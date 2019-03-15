-- Soojin Nam jsunam@gmail.com
-- Public Domain


local base = require "gxn.base"


local setmetatable = setmetatable
local thread_wait = ngx.thread.wait
local thread_spawn = ngx.thread.spawn
local gumbo_parse = require("gumbo").parse


local gx = {
   "mplibcode",
   "graphviz",
   "tikzpicture"
}


local update_document = function (mpx, doc, fn_update_node)
   return mpx:update_document(doc, fn_update_node)
end


local render = function (self, fn_update_node, doc)
   local doc, err = doc or base.get_document()
   if err then
      return nil, err
   end
   local threads = {}
   for i=1,#gx do
      threads[#threads+1] = thread_spawn(update_document,
                                         require("gxn."..gx[i]),
                                         doc, fn_update_node)
   end
   for i=1,#threads do
      local ok, err = thread_wait(threads[i])
      if not ok then
         return err, 500
      end
   end
   return doc:serialize()
end


local _M = {
   version = base.version,
   render = render
}


return setmetatable(_M, { __call = render })
