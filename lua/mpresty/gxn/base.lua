-- Copyright (C) 2018-2019, Soojin Nam


local gumbo = require "gumbo"
local lrucache = require "resty.lrucache"
local resty_shell = require "resty.shell"
local resty_requests = require "resty.requests"

local fopen = io.open
local ipairs = ipairs
local gsub = string.gsub
local format = string.format
local setmetatable = setmetatable
local ngx_var = ngx.var
local ngx_exit = ngx.exit
local hash = ngx.crc32_long
local re_find = ngx.re.find
local ngx_shared = ngx.shared
local ngx_config = ngx.config
local gumbo_parse = gumbo.parse
local shell_run = resty_shell.run
local http_get = resty_requests.get
local loc_capture = ngx.location.capture

local img_dir = "/images"
local gxn_script = "util/gxn.sh"
local work_dir = ngx_var.document_root..img_dir
local gxn_cache = ngx_shared.gxn_cache or lrucache.new(128)


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


function _M:create_element (name)
   return self.doc:createElement(name)
end


function _M:set_update_node (fn_update_node)
   self.cur_update_node = fn_update_node
end


function _M:set_document (doc)
   self.doc = doc
   return self
end


function _M:get_content (node)
   local uri = node:getAttribute("src")
   if not uri then
      return node.textContent, nil
   end
   local content = gxn_cache:get(uri)
   if not content then
      if not re_find(uri, "^https?://") then
         uri = format("http://%s:%s/%s",
                      ngx_var.server_addr, ngx_var.server_port, uri)
      end
      local res, err = http_get(uri)
      if not res then
         return nil, err
      end
      content = res:body()
      gxn_cache:set(uri, content)
   end
   return content, nil
end


local error_fn_update_node = function (self, node, uri, content)
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
   local ok, stdout = shell_run {
      ngx_config.prefix()..gxn_script, work_dir, self.tag_name, fname,
      self.ext, self.outputfmt, node:getAttribute("cmd") or self.cmd }
   if not ok then
      return nil, stdout
   end
   return format("%s/%s.%s", img_dir, fname, self.outputfmt)
end


function _M:update_document (fn_update_node)
   local doc = self.doc
   for _, node in ipairs(doc:getElementsByTagName(self.tag_name)) do
      local update_node = fn_update_node or
         (self.cur_update_node or self.fn_update_node)
      local content, err = self:get_content(node)
      if not content then return nil, err end
      local fname = hash(content)
      local doCache = node:getAttribute("cache") ~= "no"
      local uri = doCache and gxn_cache:get(self.tag_name..fname) or nil
      if not uri then
         local err = prepare_input_file(self, fname, content)
         if err then return nil, err end
         uri, err = figure_uri(self, node, fname)
         if err then
            update_node = error_fn_update_node
            content = err
         else
            if doCache then gxn_cache:set(self.tag_name..fname, uri) end
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


function _M:render (fn_update_node)
   local res = loc_capture("/source/"..ngx_var.uri)
   if res.status ~= 200 then
      ngx_exit(res.status)
   end
   local name = self.tag_name
   local content = gsub(res.body,
                        "(<"..name.."%s+.-src%s*=.-)/>", "%1></"..name..">")
   local doc, err = gumbo_parse(content)
   if not doc then
      return err, ngx.HTTP_INTERNAL_SERVER_ERROR
   end
   doc, err = self:set_document(doc):update_document(fn_update_node)
   if not doc then
      return err, ngx.HTTP_INTERNAL_SERVER_ERROR
   end
   return doc:serialize()
end 


return _M
