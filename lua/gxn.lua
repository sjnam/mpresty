-- Author:  Soojin Nam, jsunam@gmail.com
-- License: Public Domain


local gumbo = require "gumbo"
local ipairs = ipairs
local say = ngx.say
local log = ngx.log
local ERR = ngx.ERR
local WARN = ngx.WARN
local exit = ngx.exit
local ngx_var = ngx.var
local ngx_shared = ngx.shared
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


local function render (fn_update_node, doc)
   if not ngx_shared.gxn_cache then
      log(WARN, "Declare a shared memory zone, \"gxn_cache\" !!!")
   end

   local ok, res, err
   if not doc then
      res = loc_capture("/source"..ngx_var.uri)
      if res.status ~= 200 then
         exit(res.status)
      end
      doc, err = gumbo_parse(res.body)
      if not doc then
         log(ERR, err)
         exit(500)
      end
   end

   local threads = {}
   for _, gx in ipairs(gxs) do
      threads[#threads+1] = thread_spawn(update_document,
                                         gx, doc, fn_update_node)
   end

   for _, th in ipairs(threads) do
      ok, res, err = thread_wait(th)
      if not ok then
         log(ERR, "fail to render html: ", err)
         exit(500)
      end
   end
   say(doc:serialize())
end


function _M.preview (html)
   render(nil, gumbo_parse(html))
end


_M.render = render


return _M
