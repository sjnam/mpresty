local resty_exec = require "resty.exec"

local fopen = io.open
local ipairs = ipairs
local ngx_md5 = ngx.md5
local ngx_var = ngx.var
local str_format = string.format
local setmetatable = setmetatable

local EXEC_SOCK = "/tmp/exec.sock"
local CACHE_DIR = "/images"
local GXN_SCRIPT = "util/gxn"

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
end


function _M:set_update_node (fn_update_node)
   self.cur_update_node = fn_update_node
end


function _M:update_document (fn_update_node)
   local doc = self.doc
   local fn_update_node = fn_update_node or
      (self.cur_update_node or self.fn_update_node)

   for _, node in ipairs(doc:getElementsByTagName(self.tag_name)) do
      local content = node.textContent
      local fname = ngx_md5(content)
      local uri = gxn_cache:get(fname)
      if not uri then
         -- make input file
         local f = fopen(str_format("%s%s.%s", work_dir, fname, self.ext), "w")
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
         if res.exitcode ~= 0 then
            ngx.log(ngx.ERR, res.stderr)
            ngx.log(ngx.ERR, res.stdout)
         end
         uri = str_format("%s.%s", fname, self.outputfmt)
         gxn_cache:set(fname, uri)
      end
      node:removeAttribute("cmd")
      node:removeChild(node.childNodes[1])
      fn_update_node(self, node, cache_dir..uri, content)
   end

   self.cur_update_node = nil
   return doc
end


return _M

