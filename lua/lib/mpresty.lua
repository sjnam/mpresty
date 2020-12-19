-- Author:  Soojin Nam, jsunam@gmail.com
-- License: Public Domain


local gumbo = require "gumbo"

local type = type
local pairs = pairs
local open = io.open
local ipairs = ipairs
local say = ngx.say
local log = ngx.log
local ERR = ngx.ERR
local exit = ngx.exit
local ngx_var = ngx.var
local parse = gumbo.parse
local wait = ngx.thread.wait
local ngx_config = ngx.config
local re_match = ngx.re.match
local ngx_shared = ngx.shared
local spawn = ngx.thread.spawn
local setmetatable = setmetatable


local gxs = {}
for _, v in ipairs{ "img", "metapost", "graphviz", "tikz" } do
   gxs[v] = require("mpresty."..v)
end


local _M = {
   version = "0.12.1"
}


local mt = { __index = _M }


local function get_document (doc)
   if doc then
      return doc
   end
   local f = open(ngx_var.document_root..ngx_var.uri, "rb")
   if not f then
      return nil, 404
   end
   local body = f:read("*all")
   f:close()
   local doc, err = parse(body)
   if not doc then
      log(ERR, "fail to parse html: ", err)
      return nil, 505
   end
   return doc
end


function _M:render ()
   local fn_update_node = self.fn_update_node
   local doc, err = get_document(self.doc)
   if not doc then
      exit(err)
   end

   local update_nodes
   if type(fn_update_node) == "table" then
      update_nodes = fn_update_node
   end

   local threads = {}
   for k, g in pairs(gxs) do
      local fn = fn_update_node
      if update_nodes then
         fn = update_nodes[k]
      end
      if k == "img" and not fn then
         fn = fn_update_node
      end
      threads[#threads+1] = spawn(g.update_document, g, doc, fn)
   end
   for _, th in ipairs(threads) do
      local ok, res = wait(th)
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

