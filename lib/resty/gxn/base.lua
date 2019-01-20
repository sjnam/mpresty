-- Copyright (C) 2018-2019, Soojin Nam


local gumbo = require "gumbo"
local lrucache = require "resty.lrucache"
local resty_requests = require "resty.requests"

local fopen = io.open
local ipairs = ipairs
local gsub = string.gsub
local format = string.format
local setmetatable = setmetatable
local hash = ngx.crc32_long
local ngx_var = ngx.var
local re_find = ngx.re.find
local ngx_shared = ngx.shared
local ngx_config = ngx.config
local pipe_spwan = io.popen
local gumbo_parse = gumbo.parse
local http_get = resty_requests.get

local gxn_script = "util/gxn.sh"
local cache_dir = "/images"
local work_dir = ngx_var.document_root..cache_dir
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


local error_fn_update_node = function (self, node, uri)
   node.localName = "iframe"
   node:setAttribute("src", uri)
   node:setAttribute("width", "400")
   node:setAttribute("height", "400")
end


local function prepare_input_file (self, fname, content)
   local f, err = fopen(format("%s/%s.%s", work_dir, fname, self.ext), "w")
   if not f then
      return err
   end
   f:write(format("%s\n%s\n%s", self.preamble, content, self.postamble))
   f:close()
end


local function execute (self, node, fname)
   local p = pipe_spwan(table.concat({ ngx_config.prefix()..gxn_script,
                                       work_dir, self.tag_name, fname,
                                       self.outputfmt,
                                       node:getAttribute("cmd") or self.cmd
                                     }, " "))
   if not p then
      return nil, true
   end
   --p:read("*all") -- acts as wait function
   p:close()
   local uri = format("%s/%s.%s", cache_dir, fname, self.outputfmt)
   local f = fopen(format("%s%s", ngx_var.document_root, uri), "r")
   if not f then
      return format("%s/%s.log", cache_dir, fname), true
   end
   f:close()
   return uri
end


function _M:update_document (fn_update_node)
   local doc = self.doc
   for _, node in ipairs(doc:getElementsByTagName(self.tag_name)) do
      local update_node = fn_update_node or
         (self.cur_update_node or self.fn_update_node)
      local content, err = self:get_content(node)
      if not content then
         return nil, err
      end
      local uri
      local fname = hash(content)
      local doCache = node:getAttribute("cache") ~= "no"
      if doCache then
         uri = gxn_cache:get(self.tag_name..fname)
      end
      if not uri then
         local err = prepare_input_file(self, fname, content)
         if err then
            return nil, err
         end
         uri, err = execute(self, node, fname)
         if err then
            update_node = error_fn_update_node
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
   local f, err = fopen(ngx_var.document_root..ngx_var.uri, "r")
   if not f then
      return err, ngx.HTTP_NOT_FOUND
   end
   local name = self.tag_name
   local content = gsub(f:read("*a"),
                        "(<"..name.."%s+.-src%s*=.-)/>", "%1></"..name..">")
   f:close()
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
