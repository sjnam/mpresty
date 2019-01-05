-- Copyright (C) 2018-2019, Soojin Nam


local resty_exec = require "resty.exec"
local fopen = io.open
local ipairs = ipairs
local ngx_md5 = ngx.md5
local ngx_var = ngx.var
local str_format = string.format
local setmetatable = setmetatable


local EXEC_SOCK = "/tmp/exec.sock"
local CACHE_DIR = "/images"
local GXN_SCRIPT = "util/gxn.sh"


local gxn_cache = ngx.shared.gxn_cache
local cache_dir = (ngx_var.cache_dir or CACHE_DIR).."/"
local work_dir = ngx_var.document_root..cache_dir


local _M = {
   outputfmt = "svg",
   preamble = "",
   postamble = ""
}


function _M:new (o)
   return setmetatable(o or {}, { __index = _M })
end


function _M:createElement (name)
   return self.doc:createElement(name)
end


function _M:fn_update_node (node, uri, content)
   node.localName = "img"
   node:setAttribute("src", uri)
   node:setAttribute("alt", content)
end


function _M:set_update_node (fn_update_node)
   self.cur_update_node = fn_update_node
end


function _M:set_docucmet(doc)
   self.doc = doc
   return self
end


function _M:getContent(node)
   return node.textContent
end


local function hasError (uri)
   local f = fopen(str_format("%s%s", ngx_var.document_root, uri), "r")
   if not f then
      return true
   end
   f:close()
   return false
end


function _M:update_document (fn_update_node)
   local doc = self.doc
   local fn_update_node = fn_update_node or
      (self.cur_update_node or self.fn_update_node)

   for _, node in ipairs(doc:getElementsByTagName(self.tag_name)) do
      local content = self:getContent(node)
      local fname = ngx_md5(content)
      local uri = gxn_cache and gxn_cache:get(fname) or nil
      if not uri then
         -- prepare input file
         local f = fopen(str_format("%s%s.%s", work_dir, fname, self.ext), "w")
         if not f then
            ngx.log(ngx.ERR, "fail to prepare input file")
            ngx.exit(500)
         end
         f:write(self.preamble)
         f:write(content)
         f:write(self.postamble)
         f:close()
         -- run command
         local prog = resty_exec.new(ngx_var.exec_sock or EXEC_SOCK)
         local res, err = prog(ngx.config.prefix()
                                  ..(ngx_var.gxn_script or GXN_SCRIPT),
                               work_dir,
                               self.tag_name,
                               fname,
                               self.outputfmt,
                               node:getAttribute("cmd") or self.cmd)
         uri = str_format("%s%s.%s", cache_dir, fname, self.outputfmt)
         if hasError(uri) then
            content = res.stdout
            ngx.log(ngx.ERR, content)
            uri = str_format("%s%s.log", cache_dir, fname)
            fn_update_node = function (self, node, uri)
               node.localName = "iframe"
               node:setAttribute("src", uri)
               node:setAttribute("width", "400")
               node:setAttribute("height", "400")
            end
         else
            if gxn_cache then
               gxn_cache:set(fname, uri)
            end
         end
      end
      node:removeAttribute("src")
      node:removeAttribute("cmd")
      if node.childNodes[1] then
         node:removeChild(node.childNodes[1])
      end
      fn_update_node(self, node, uri, content)
   end

   self.cur_update_node = nil
   return doc
end


return _M
