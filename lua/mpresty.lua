-- Copyright (C) 2018-2019, Soojin Nam


local ipairs = ipairs
local setmetatable = setmetatable
local ngx_var = ngx.var
local ngx_exit = ngx.exit
local loc_capture = ngx.location.capture
local gumbo_parse = require("gumbo").parse


local _M = {
   version = "0.7.2"
}


local graphics = {
   "mplibcode",
   "graphviz"
}


for _, v in ipairs(graphics) do
   _M[v] = require("mpresty."..v)
end


local render = function (self, fn_update_node, doc)
   local err
   if not doc then
      local res = loc_capture("/source/"..ngx_var.uri)
      if res.status ~= 200 then
         ngx_exit(res.status)
      end
      doc, err = gumbo_parse(res.body)
      if not doc then
         return err, 500
      end
   end
   for _, v in ipairs(graphics) do
      doc, err = self[v]:update_document(doc, fn_update_node)
      if not doc then
         return err, 500
      end
   end
   return doc:serialize()
end


_M.render = render


return setmetatable(_M, { __call = render })
