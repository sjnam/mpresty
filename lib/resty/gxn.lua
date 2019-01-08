-- Copyright (C) 2018-2019, Soojin Nam


local ipairs = ipairs
local fopen = io.open
local str_gsub = string.gsub
local ngx_var = ngx.var
local ngx_say = ngx.say
local ngx_log = ngx.log
local ngx_ERR = ngx.ERR
local ngx_exit = ngx.exit
local gumbo_parse = require("gumbo").parse


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
   local f = fopen(ngx_var.document_root..ngx_var.uri, "r")
   if not f then
      ngx_exit(404)
   end

   local content = f:read("*a")
   f:close()

   for _, v in ipairs(graphics) do
      content = str_gsub(content, "(<"..v.."%s+.-src%s*=.-)/?>", "%1></"..v..">")
   end

   local doc = gumbo_parse(content)
   if not doc then
      ngx_log(ngx_ERR, "fail to parse html")
      ngx_exit(500)
   end
   for _, v in ipairs(graphics) do
      doc = self[v]:setDocument(doc):updateDocument(fn_update_node)
   end
   ngx_say(doc:serialize())
end


return _M
