-- Copyright (C) 2018, Soojin Nam


local ngx_var = ngx.var
local ngx_print = ngx.print
local gumbo_parse = require("gumbo").parseFile


local GXS = { "metapost", "graphviz", "tikz" }


local _M = {
   _VERSION = '0.3.0',
}


for i=1,#GXS do
   _M[GXS[i]] = require("resty.gxn."..GXS[i])
end


function _M:render (fn_update_node)
   local doc = gumbo_parse(ngx_var.document_root..ngx_var.uri)
   if not doc then
      ngx.exit(404)
   end
   for i=1,#GXS do
      doc = self[GXS[i]]:set_docucmet(doc):update_document(fn_update_node)
   end
   ngx_print(doc:serialize())
end


return _M

