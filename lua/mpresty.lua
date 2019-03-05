-- Copyright (C) 2018-2019, Soojin Nam


local setmetatable = setmetatable
local ngx_var = ngx.var
local ngx_exit = ngx.exit
local thread_wait = ngx.thread.wait
local thread_spawn = ngx.thread.spawn
local loc_capture = ngx.location.capture
local gumbo_parse = require("gumbo").parse


local _M = {
   version = "0.7.2"
}


local grx = {
   "mplibcode",
   "graphviz",
   "tikzpicture"
}


for i=1,#grx do
   local v = grx[i]
   _M[v] = require("mpresty."..v)
end


local update_document = function (mpx, doc, fn_update_node)
   return mpx:update_document(doc, fn_update_node)
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
   local threads = {}
   for i=1,#grx do
      threads[#threads+1] = thread_spawn(update_document, self[grx[i]],
                                         doc, fn_update_node)
   end
   for i=1,#threads do
      local doc, err = thread_wait(threads[i])
      if not doc then
         return err, 500
      end
   end
   return doc:serialize()
end


_M.render = render


return setmetatable(_M, { __call = render })
