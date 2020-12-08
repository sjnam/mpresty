-- Author:  Soojin Nam, jsunam@gmail.com
-- License: Public Domain


local gumbo = require "gumbo"


local type = type
local open = io.open
local pairs = pairs
local ipairs = ipairs
local say = ngx.say
local log = ngx.log
local ERR = ngx.ERR
local WARN = ngx.WARN
local exit = ngx.exit
local ngx_var = ngx.var
local ngx_shared = ngx.shared
local wait = ngx.thread.wait
local spawn = ngx.thread.spawn
local parse = gumbo.parse
local HTTP_NOT_FOUND = ngx.HTTP_NOT_FOUND
local HTTP_INTERNAL_SERVER_ERROR = ngx.HTTP_INTERNAL_SERVER_ERROR


local gxs = {
   ['metapost'] = require "mpresty.mplibcode",
   ['graphviz'] = require "mpresty.graphviz",
   ['tikz'] = require "mpresty.tikzpicture"
}


local _M = {
   version = "0.10.5"
}


local function update_document (gx, doc, fn_update_node)
   return gx:update_document(doc, fn_update_node)
end


local function capture (path)
   local f = open(ngx_var.document_root..path, "rb")
   if not f then
      return nil
   end

   local content = f:read("*all")
   f:close()
   return content
end


local function render (fn_update_node, doc)
   if not ngx_shared.mpresty_cache then
      log(WARN, "Declare a shared memory zone, \"mpresty_cache\" in a file 'nginx.conf.'")
   end

   local ok, res, err
   if not doc then
      local body = capture(ngx_var.uri)
      if not body then
         exit(ngx.HTTP_NOT_FOUND)
      end
      doc, err = parse(body)
      if not doc then
         log(ERR, err)
         exit(HTTP_INTERNAL_SERVER_ERROR)
      end
   end

   local threads = {}
   for key, gx in pairs(gxs) do
      local fn = fn_update_node
      if type(fn_update_node) == "table" then
         fn = fn_update_node[key]
      end
      threads[#threads + 1] = spawn(update_document, gx, doc, fn)
   end

   for _, th in ipairs(threads) do
      ok, res, err = wait(th)
      if not ok then
         log(ERR, "fail to render html: ", err)
         exit(HTTP_INTERNAL_SERVER_ERROR)
      end
   end
   say(doc:serialize())
end


function _M.preview (str)
   render(nil, gumbo.parse(str))
end


_M.render = render


return _M

