-- Copyright (C) 2018-2019, Soojin Nam


local fopen = io.open
local str_gsub = string.gsub
local ngx_var = ngx.var
local ngx_print = ngx.print
local gumbo_parse = require("gumbo").parse


local GXS = { "gxn", "mplibcode", "tikzpicture", "digraph", "neatograph" }


local _M = {
   _VERSION = '0.3.6',
}


for i=1,#GXS do
   _M[GXS[i]] = require("resty.gxn."..GXS[i])
end


function _M:render (fn_update_node)
   local f = fopen(ngx_var.document_root..ngx_var.uri, "r")
   local content = f:read("*a")
   f:close()
   content = str_gsub(content, "(<gxn%s+.-)/?>", "%1></gxn>")
   local doc = gumbo_parse(content)
   if not doc then
      ngx.exit(404)
   end
   for i=1,#GXS do
      doc = self[GXS[i]]:set_docucmet(doc):update_document(fn_update_node)
   end
   ngx_print(doc:serialize())
end


return _M

