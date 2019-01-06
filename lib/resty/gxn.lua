-- Copyright (C) 2018-2019, Soojin Nam


local ipairs = ipairs
local fopen = io.open
local str_gsub = string.gsub
local ngx_var = ngx.var
local ngx_print = ngx.print
local gumbo_parse = require("gumbo").parse


local _M = {
   _VERSION = '0.3.6',
}


local GXS = {
   "mplibcode",
   "tikzpicture",
   "digraph",
   "neatograph",
}


for _, v in ipairs(GXS) do
   _M[v] = require("resty.gxn."..v)
end


function _M:render (fn_update_node)
   local f = fopen(ngx_var.document_root..ngx_var.uri, "r")
   local content = f:read("*a")
   f:close()

   for _, v in ipairs(GXS) do
      content = str_gsub(content, "(<"..v.."%s+.-src%s*=.-)/?>", "%1></"..v..">")
   end

   local doc = gumbo_parse(content)
   if not doc then
      ngx.exit(404)
   end
   for _, v in ipairs(GXS) do
      doc = self[v]:setDocument(doc):updateDocument(fn_update_node)
   end
   ngx_print(doc:serialize())
end


return _M

