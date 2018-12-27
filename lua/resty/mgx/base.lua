local resty_exec = require "resty.exec"

local fopen = io.open
local ipairs = ipairs
local ngx_md5 = ngx.md5
local ngx_var = ngx.var
local str_format = string.format
local setmetatable = setmetatable

local EXEC_SOCK = "/tmp/exec.sock"
local CACHE_DIR = "/images"
local MGX_SCRIPT = "util/mgx"

local mgx_cache = ngx.shared.mgx_cache
local cache_dir = (ngx_var.cache_dir or CACHE_DIR).."/"
local work_dir = ngx_var.document_root..cache_dir


local _M = {
   _VERSION = '0.23',
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


function _M:update_node (node, uri, content)
   node.localName = "img"
   node:setAttribute("src", uri)
end


function _M:set_update_node (update_node)
   self.cur_update_node = update_node
end


function _M:update_document (update_node)
   local doc = self.doc
   local update_node = update_node or (self.cur_update_node or self.update_node)

   for _, node in ipairs(doc:getElementsByTagName(self.tag_name)) do
      local content = node.textContent
      local fname = ngx_md5(content)
      local uri = mgx_cache:get(fname)
      if not uri then
         -- make input file
         local f = fopen(str_format("%s%s.%s", work_dir, fname, self.ext), "w")
         f:write(self.preamble)
         f:write(content)
         f:write(self.postamble)
         f:close()
         -- run command
         local prog = resty_exec.new(ngx_var.exec_sock or EXEC_SOCK)
         local res, err = prog(ngx.config.prefix()..(ngx_var.mgx_script or MGX_SCRIPT),
                               work_dir,
                               self.tag_name,
                               fname,
                               self.outputfmt,
                               node:getAttribute("cmd") or self.cmd)
         if err then
            ngx.log(ngx.ERR, "fail to exec: ", err)
            ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
         end
         uri = str_format("%s.%s", fname, self.outputfmt)
         mgx_cache:set(fname, uri)
      end
      node:removeAttribute("cmd")
      node:removeChild(node.childNodes[1])
      update_node(self, node, cache_dir..uri, content)
   end

   self.cur_update_node = nil
   return doc
end


return _M

