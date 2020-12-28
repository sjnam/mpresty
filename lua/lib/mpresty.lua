-- Author:  Soojin Nam, jsunam@gmail.com
-- License: Public Domain


local gumbo = require "gumbo"

local type = type
local pairs = pairs
local ipairs = ipairs
local log = ngx.log
local ERR = ngx.ERR
local exit = ngx.exit
local say = ngx.print
local ngx_var = ngx.var
local ngx_req = ngx.req
local parse = gumbo.parse
local re_find = ngx.re.find
local re_gsub = ngx.re.gsub
local wait = ngx.thread.wait
local spawn = ngx.thread.spawn
local capture = ngx.location.capture


local tags = {}
for _, v in ipairs{ "img", "metapost", "graphviz", "tikz" } do
   tags[v] = require("mpresty."..v)
end


local _M = {}


local function get_document (html)
   if html then return parse(html) end
   local uri_html = re_gsub(ngx_var.uri, ".gxn", ".html", "i")
   local res = capture(uri_html)
   if res.status ~= 200 then
      log(ERR, "error: ngx.location.capture")
      return nil, res.status
   end
   local doc, err = parse(res.body)
   if not doc then
      log(ERR, "error: ", err)
      return nil, 500
   end
   return doc
end


function _M.go (html, fn_update_node)
   local doc, err = get_document(html)
   if not doc then
      exit(err)
   end

   local args = ngx_req.get_uri_args()
   local use_cache = not args.debug

   local update_nodes
   if type(fn_update_node) == "table" then
      update_nodes = fn_update_node
   end

   local threads = {}
   for tag, gx in pairs(tags) do
      gx.use_cache = use_cache
      local fn = fn_update_node
      if update_nodes then
         fn = update_nodes[tag]
      end
      if tag == "img" and not fn then
         fn = fn_update_node
      end
      threads[#threads+1] = spawn(gx.update_document, gx, doc, fn)
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

