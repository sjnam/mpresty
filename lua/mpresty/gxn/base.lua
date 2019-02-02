-- Copyright (C) 2018-2019, Soojin Nam


local gumbo = require "gumbo"
local lrucache = require "resty.lrucache"
local resty_shell = require "resty.shell"
local resty_requests = require "resty.requests"

local fopen = io.open
local ipairs = ipairs
local format = string.format
local setmetatable = setmetatable
local ngx_var = ngx.var
local ngx_exit = ngx.exit
local hash = ngx.crc32_long
local re_find = ngx.re.find
local ngx_config = ngx.config
local gumbo_parse = gumbo.parse
local shell_run = resty_shell.run
local http_get = resty_requests.get
local loc_capture = ngx.location.capture

local img_dir = "/images"
local work_dir = ngx_var.document_root..img_dir
local gxn_script = ngx_config.prefix().."util/gxn.sh"
local gxn_cache = lrucache.new(128)


local _M = {
   outputfmt = "svg",
   preamble = "",
   postamble = "",
   fn_update_node = function (self, node, uri, content)
      node.localName = "img"
      node:setAttribute("src", uri)
      if not node:hasAttribute("width") then
         node:setAttribute("width", "300")
      end
      node:setAttribute("alt", content)
   end
}


function _M:new (o)
   return setmetatable(o or {}, { __index = _M })
end


function _M:set_update_node (fn_update_node)
   self.cur_update_node = fn_update_node
end


local function get_content (node)
   local uri = node:getAttribute("src")
   if not uri then
      return node.textContent, nil
   end
   local content = gxn_cache:get(uri)
   if not content then
      if not re_find(uri, "^https?://") then
         content = loc_capture(uri).body
      else
         local res, err = http_get(uri)
         if not res then
            return nil, err
         end
         content = res:body()
      end
      gxn_cache:set(uri, content)
   end
   return content
end


local function error_fn_update_node (self, node, uri, content)
   node.localName = "pre"
   node.textContent = content
   node:setAttribute("style", "color:red")
   node:removeAttribute("width")
end


local function prepare_input_file (self, fname, content)
   local f, err = fopen(format("%s/%s.%s", work_dir, fname, self.ext), "w")
   if not f then
      return err
   end
   f:write(format("%s\n%s\n%s", self.preamble, content, self.postamble))
   f:close()
end


local function figure_uri (self, node, fname)
   local cmd = node:getAttribute("cmd") or ""
   if cmd == "" then
      cmd = self.cmd
   end
   local ok, stdout = shell_run {
      gxn_script, work_dir, self.tag_name, fname,
      self.ext, self.outputfmt, cmd
   }
   if not ok then
      return nil, stdout
   end
   return format("%s/%s.%s", img_dir, fname, self.outputfmt)
end


function _M:update_document (doc, fn_update_node)
   self.doc = doc
   for _, node in ipairs(doc:getElementsByTagName(self.tag_name)) do
      local update_node = fn_update_node or
         (self.cur_update_node or self.fn_update_node)
      local content, err = get_content(node)
      if not content then
         return nil, err
      end
      local fname = hash(content)
      local doCache = node:getAttribute("cache") ~= "no"
      local key = self.tag_name..fname
      local uri = doCache and gxn_cache:get(key) or nil
      if not uri then
         local err = prepare_input_file(self, fname, content)
         if err then
            return nil, err
         end
         uri, err = figure_uri(self, node, fname)
         if err then
            update_node = error_fn_update_node
            content = err
         else
            if doCache then
               gxn_cache:set(key, uri)
            end
         end
      end
      node:removeAttribute("cmd")
      node:removeAttribute("src")
      if node:hasChildNodes() then
         node:removeChild(node.childNodes[1])
      end
      update_node(self, node, uri, content)
      update_node = nil
   end
   self.cur_update_node = nil
   return doc
end


function _M:render (fn_update_node, doc)
   local err
   if not doc then
      local res = loc_capture("/source/"..ngx_var.uri)
      if res.status ~= 200 then
         ngx_exit(res.status)
      end
      doc, err = gumbo_parse(res.body)
      if not doc then
         return err, 500
      end
   end
   doc, err = self:update_document(doc, fn_update_node)
   if not doc then
      return err, 500
   end
   return doc:serialize()
end 


return _M
