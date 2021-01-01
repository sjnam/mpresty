-- Author:  Soojin Nam, jsunam@gmail.com
-- License: Public Domain


local gumbo = require "gumbo"

local type = type
local pairs = pairs
local ipairs = ipairs
local fopen = io.open
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


local tags = {}
for _, v in ipairs{ "img", "metapost", "graphviz", "tikz" } do
   tags[v] = require("mpresty."..v)
end


local _M = {}


local function capture ()
   local f, err = fopen(ngx_var.document_root..ngx_var.uri, "rb")
   if not f then
      log(ERR, "error: ", err)
      return nil, 404
   end
   local body = f:read("*all")
   f:close()
   return body
end


local function get_document (html)
   local html = html
   if not html then
      local body, err = capture()
      if not body then
         return nil, err
      end
      html = body
      if not re_find(ngx_var.uri, "\\.html?$") then
         return body, 200
      end
   end
   local doc, err = parse(html)
   if not doc then
      return nil, 500
   end
   return doc
end


function _M.go (html, fn_update_node)
   local doc, err = get_document(html)
   if not doc then
      log(ERR, "error: get_document ", err)
      exit(err)
   elseif err == 200 then
      say(doc)
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

