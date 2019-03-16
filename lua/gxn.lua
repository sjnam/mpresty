-- Soojin Nam jsunam@gmail.com
-- Public Domain


local base = require "gxn.base"


local ipairs = ipairs
local setmetatable = setmetatable
local thread_wait = ngx.thread.wait
local thread_spawn = ngx.thread.spawn
local gumbo_parse = require("gumbo").parse


local gxs = {
   require "gxn.mplibcode",
   require "gxn.graphviz",
   require "gxn.tikzpicture"
}


local update_document = function (gx, doc, fn_update_node)
   return gx:update_document(doc, fn_update_node)
end


local render = function (self, fn_update_node, doc)
   local doc, err = doc or base.get_document()
   if err then
      return nil, err
   end
   local threads = {}
   for _, gx in ipairs(gxs) do
      threads[#threads+1] = thread_spawn(update_document,
                                         gx, doc, fn_update_node)
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
