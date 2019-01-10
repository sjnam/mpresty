-- Copyright (C) 2018-2019, Soojin Nam


local resty_http = require "resty.http"
local resty_exec = require "resty.exec"
local lrucache = require "resty.lrucache"

local fopen = io.open
local ipairs = ipairs
local str_format = string.format
local setmetatable = setmetatable
local crc32 = ngx.crc32_long
local ngx_var = ngx.var
local ngx_shared = ngx.shared
local ngx_config = ngx.config

local EXEC_SOCK = "/tmp/exec.sock"
local CACHE_DIR = "/images"
local GXN_SCRIPT = "util/gxn.sh"


local gxn_cache = ngx_shared.gxn_cache or lrucache.new(128)
local cache_dir = (ngx_var.cache_dir or CACHE_DIR).."/"
local work_dir = ngx_var.document_root..cache_dir


local _M = {
   outputfmt = "svg",
   preamble = "",
   postamble = "",
   fn_update_node = function (self, node, uri, content)
      node.localName = "img"
      node:setAttribute("src", uri)
      if not node:hasAttribute("width") then
         node:setAttribute("width", "250")
      end
      if not node:hasAttribute("alt", content) then
         node:setAttribute("alt", content)
      end
   end
}


function _M:new (o)
   return setmetatable(o or {}, { __index = _M })
end


function _M:createElement (name)
   return self.doc:createElement(name)
end


function _M:setUpdateNode (fn_update_node)
   self.cur_update_node = fn_update_node
end


function _M:setDocument (doc)
   self.doc = doc
   return self
end


function _M:getContent (node)
   local uri = node:getAttribute("src");
   if not uri then
      return node.textContent, nil
   end
   local content = gxn_cache:get(uri)
   if not content then
      local http = resty_http.new()
      if not http:parse_uri(uri) then
         uri = str_format("http://%s:%s/%s",
                          ngx_var.server_addr, ngx_var.server_port, uri)
      end
      local res, err = http:request_uri(uri)
      if not res then
         return nil, err
      end
      content = res.body
      gxn_cache:set(uri, content)
   end
   return content, nil
end


local function prepareInputFile (self, fname, content)
   local f, err = fopen(str_format("%s%s.%s", work_dir, fname, self.ext), "w")
   if not f then
      return err
   end
   f:write(str_format("%s\n%s\n%s", self.preamble, content, self.postamble))
   f:close()
   return nil
end


local function execute (self, cmd, fname)
   local prog = resty_exec.new(ngx_var.exec_sock or EXEC_SOCK)
   local res = prog(ngx_config.prefix()
                       ..(ngx_var.gxn_script or GXN_SCRIPT),
                    work_dir, self.tag_name, fname, self.outputfmt,
                    cmd or self.cmd)
   return str_format("%s%s.%s", cache_dir, fname, self.outputfmt), res
end


local function execFailed (uri)
   local f = fopen(str_format("%s%s", ngx_var.document_root, uri), "r")
   if not f then
      return true
   end
   f:close()
   return false
end


function _M:updateDocument (fn_update_node)
   local doc = self.doc
   for _, node in ipairs(doc:getElementsByTagName(self.tag_name)) do
      local fn_update_node = fn_update_node or
         (self.cur_update_node or self.fn_update_node)
      local content, err = self:getContent(node)
      if not content then
         return nil, err
      end
      local fname = crc32(content)
      local doCache = node:getAttribute("cache") ~= "no"
      local uri
      if doCache then
         uri = gxn_cache:get(self.tag_name..fname)
      end
      if not uri then
         local res
         local err = prepareInputFile(self, fname, content)
         if err then
            return nil, err
         end
         uri, res = execute(self, node:getAttribute("cmd"), fname)
         if execFailed(uri) then
            content = res.stdout
            uri = str_format("%s%s.log", cache_dir, fname)
            fn_update_node = function (self, node, uri)
               node.localName = "iframe"
               node:setAttribute("src", uri)
               node:setAttribute("width", "400")
               node:setAttribute("height", "400")
            end
         else
            if doCache then gxn_cache:set(self.tag_name..fname, uri) end
         end
      end
      node:removeAttribute("src")
      node:removeAttribute("cmd")
      if node.childNodes[1] then
         node:removeChild(node.childNodes[1])
      end
      fn_update_node(self, node, uri, content)
      fn_update_node = nil
   end
   self.cur_update_node = nil
   return doc, nil
end


return _M
