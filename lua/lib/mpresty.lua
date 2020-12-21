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
local ngx_req = ngx.req
local parse = gumbo.parse
local wait = ngx.thread.wait
local ngx_config = ngx.config
local re_find = ngx.re.find
local ngx_shared = ngx.shared
local spawn = ngx.thread.spawn
local setmetatable = setmetatable


local gxs = {}
for _, v in ipairs{ "img", "metapost", "graphviz", "tikz" } do
   gxs[v] = require("mpresty."..v)
end


local _M = {
   version = "0.12.1",
   cache = true,
}


local mt = { __index = _M }


local function get_document (doc)
   if doc then
      return doc
   end
   local uri = ngx_var.uri
   local f = open(ngx_var.document_root..uri, "rb")
   if not f then
      return nil, 404
   end
   local body = f:read("*all")
   f:close()
   if not re_find(uri, [[\.html?$]]) then
      return body, 200
   end
   local doc, err = parse(body)
   if not doc then
      log(ERR, "fail to parse html: ", err)
      return nil, 505
   end
   return doc
end


function _M:go ()
   local fn_update_node = self.fn_update_node
   local doc, err = get_document(self.doc)
   if not doc then
      exit(err)
   end

   if err == 200 then
      say(doc)
      exit(200)
   end

   local args = ngx_req.get_uri_args()
   local cache = not args.debug

   local update_nodes
   if type(fn_update_node) == "table" then
      update_nodes = fn_update_node
   end

   local threads = {}
   for k, g in pairs(gxs) do
      g.cache = cache
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

