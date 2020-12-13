-- Author:  Soojin Nam, jsunam@gmail.com
-- License: Public Domain


local gumbo = require "gumbo"

local type = type
local pairs = pairs
local open = io.open
local ipairs = ipairs
local setmetatable = setmetatable
local say = ngx.print
local log = ngx.log
local ERR = ngx.ERR
local exit = ngx.exit
local ngx_var = ngx.var
local parse = gumbo.parse
local wait = ngx.thread.wait
local ngx_shared = ngx.shared
local spawn = ngx.thread.spawn



local graphics = {
   ['metapost'] = require "mpresty.metapost",
   ['graphviz'] = require "mpresty.graphviz",
   ['tikz'] = require "mpresty.tikz"
}


local _M = {
   version = "0.11.0"
}


local mt = { __index = _M }


local function capture (path)
   local f = open(ngx_var.document_root..path, "rb")
   if not f then
      return nil
   end

   local content = f:read("*all")
   f:close()
   return content
end


function _M:render ()
   local doc = self.doc
   local fn_update_node = self.fn_update_node

   if not doc then
      local body = capture(ngx_var.uri)
      if not body then
         exit(404)
      end
      doc, err = parse(body)
      if not doc then
         log(ERR, err)
         exit(500)
      end
   end

   local update_nodes
   if type(fn_update_node) == "table" then
      update_nodes = fn_update_node
   end
   local threads = {}
   for k, g in pairs(graphics) do
      local fn = fn_update_node
      if update_nodes then
         fn = update_nodes[k]
      end
      threads[#threads+1] = spawn(g.update_document, g, doc, fn)
   end
   for i=1,#threads do
      local ok, res = wait(threads[i])
      if not ok then
         log(ERR, "fail to render html: ", res)
         exit(500)
      end
   end
   say(doc:serialize())
end


function _M.new (o)
   return setmetatable(o or {}, mt)
end


return _M

