-- Soojin Nam jsunam@gmail.com
-- Public Domain


local gumbo = require "gumbo"


local ipairs = ipairs
local setmetatable = setmetatable
local ngx_var = ngx.var
local thread_wait = ngx.thread.wait
local thread_spawn = ngx.thread.spawn
local loc_capture = ngx.location.capture
local gumbo_parse = gumbo.parse


local gxs = {
   require "gxn.mplibcode",
   require "gxn.graphviz",
   require "gxn.tikzpicture"
}


local update_document = function (gx, doc, fn_update_node)
   return gx:update_document(doc, fn_update_node)
end


local function get_document ()
   local res = loc_capture("/source/"..ngx_var.uri)
   if res.status ~= 200 then
      return nil, res.status
   end
   local doc, err = gumbo_parse(res.body)
   if not doc then
      return err, 500
   end
   return doc
end


local render = function (self, fn_update_node, doc)
   local doc, err = doc or get_document()
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
   version = "0.9.1",
   render = render
}


return setmetatable(_M, { __call = render })
