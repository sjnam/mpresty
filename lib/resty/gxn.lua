-- Copyright (C) 2018-2019, Soojin Nam

local io = require("ngx.io") or io

local fopen = io.open
local ngx_var = ngx.var
local ngx_print = ngx.print
local gumbo_parse = require("gumbo").parse


local GXS = { "metapost", "graphviz", "tikz" }


local _M = {
   _VERSION = '0.3.1',
}


for i=1,#GXS do
   _M[GXS[i]] = require("resty.gxn."..GXS[i])
end


function _M:render (fn_update_node)
   local f = fopen(ngx_var.document_root..ngx_var.uri, "r")
   if not f then
      ngx.exit(404)
   end
   local doc = gumbo_parse(f:read("*a"))
   if not doc then
      f:close()
      ngx.exit(404)
   end
   f:close()
   for i=1,#GXS do
      doc = self[GXS[i]]:set_docucmet(doc):update_document(fn_update_node)
   end
   ngx_print(doc:serialize())
end


return _M

