-- Author:  Soojin Nam, jsunam@gmail.com
-- License: Public Domain


local gumbo = require "gumbo"
local ipairs = ipairs
local setmetatable = setmetatable
local say = ngx.say
local log = ngx.log
local ERR = ngx.ERR
local exit = ngx.exit
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


local _M = {
   version = "0.9.4"
}


local function update_document (gx, doc, fn_update_node)
   return gx:update_document(doc, fn_update_node)
end


local function get_document ()
   local res = loc_capture("/source/"..ngx_var.uri)
   if res.status ~= 200 then
      return "not found", res.status
   end
   local doc, err = gumbo_parse(res.body)
   if not doc then
      return err, 500
   end
   return doc
end


local function render (self, fn_update_node, doc)
   local doc, err = doc or get_document()
   if err then
      log(ERR, "fail to get document: ", doc)
      exit(err)
   end
   local threads = {}
   for _, gx in ipairs(gxs) do
      threads[#threads+1] = thread_spawn(update_document,
                                         gx, doc, fn_update_node)
   end
   for _, th in ipairs(threads) do
      local ok, doc, err = thread_wait(th)
      if not ok then
         log(ERR, "fail to render html: ", err)
         exit(500)
      end
   end
   say(doc:serialize())
end


function _M:preview (html)
   render(self, nil, gumbo_parse(html))
end


_M.render = render


return setmetatable(_M, { __call = render })
