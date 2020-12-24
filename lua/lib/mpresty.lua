-- Author:  Soojin Nam, jsunam@gmail.com
-- License: Public Domain


local gumbo = require "gumbo"

local type = type
local pairs = pairs
local open = io.open
local ipairs = ipairs
local log = ngx.log
local ERR = ngx.ERR
local exit = ngx.exit
local say = ngx.print
local ngx_var = ngx.var
local ngx_req = ngx.req
local parse = gumbo.parse
local re_find = ngx.re.find
local wait = ngx.thread.wait
local spawn = ngx.thread.spawn


local gxs = {}
for _, v in ipairs{ "img", "metapost", "graphviz", "tikz" } do
   gxs[v] = require("mpresty."..v)
end


local _M = {}


local function get_document (doc)
   if doc then
      return doc
   end
   local uri = ngx_var.uri
   local f, err = open(ngx_var.document_root..uri, "rb")
   if not f then
      log(ERR, "error: ", err)
      return nil, 404
   end
   local body = f:read("*all")
   f:close()
   if not re_find(uri, [[\.html?$]]) then
      return body, 200
   end
   local doc, err = parse(body)
   if not doc then
      log(ERR, "error: ", err)
      return nil, 505
   end
   return doc
end


function _M.go (doc, fn_update_node)
   local doc, err = get_document(doc)
   if not doc then
      exit(err)
   elseif err == 200 then
      say(doc)
      exit(200)
   end

   local args = ngx_req.get_uri_args()
   local use_cache = not args.debug

   local update_nodes
   if type(fn_update_node) == "table" then
      update_nodes = fn_update_node
   end

   local threads = {}
   for k, g in pairs(gxs) do
      g.use_cache = use_cache
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
         log(ERR, "error: ", res)
         exit(500)
      end
   end

   say(doc:serialize())
end


return _M
