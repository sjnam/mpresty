-- Copyright (C) 2018-2019, Soojin Nam


local ipairs = ipairs
local fopen = io.open
local ngx_var = ngx.var
local gumbo_parse = require("gumbo").parse

local HTTP_OK = ngx.HTTP_OK
local HTTP_NOT_FOUND = ngx.HTTP_NOT_FOUND
local HTTP_INTERNAL_SERVER_ERROR = ngx.HTTP_INTERNAL_SERVER_ERROR


local _M = {
   _VERSION = '0.3.6',
}


local graphics = {
   "mplibcode",
   "tikzpicture",
   "digraph",
   "neatograph",
}


for _, v in ipairs(graphics) do
   _M[v] = require("resty.gxn."..v)
end


function _M:render (fn_update_node)
   local f, err = fopen(ngx_var.document_root..ngx_var.uri, "r")
   if not f then
      return HTTP_NOT_FOUND, err
   end
   local doc, err = gumbo_parse(f:read("*a"))
   f:close()
   if not doc then
      return HTTP_INTERNAL_SERVER_ERROR, err
   end
   for _, v in ipairs(graphics) do
      doc, err = self[v]:setDocument(doc):updateDocument(fn_update_node)
      if not doc then
         return HTTP_INTERNAL_SERVER_ERROR, err
      end
   end
   return HTTP_OK, doc:serialize()
end


return _M
