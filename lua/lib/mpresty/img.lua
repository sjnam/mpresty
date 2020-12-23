-- Author:  Soojin Nam, jsunam@gmail.com
-- License: Public Domain


local tikz = require "mpresty.tikz"
local graphviz = require "mpresty.graphviz"
local metapost = require "mpresty.metapost"

local type = type
local ipairs = ipairs
local log = ngx.log
local ERR = ngx.ERR
local re_find = ngx.re.find
local wait = ngx.thread.wait
local spawn = ngx.thread.spawn


local _M = {}


function _M:update_document (doc, fn_update_node)
   local update_nodes
   if type(fn_update_node) == "table" then
      update_nodes = fn_update_node
   end
   local threads = {}
   for _, node in ipairs(doc.images) do
      local gx
      local uri = node:getAttribute("src")
      if re_find(uri, "\\."..metapost.ext.."$") then
         gx = metapost
      elseif re_find(uri, "\\."..tikz.ext.."$") then
         gx = tikz
      elseif re_find(uri, "\\."..graphviz.ext.."(\\.txt)?$") then
         gx = graphviz
      else
         goto continue
      end
      gx.doc = doc
      local fn = fn_update_node
      if update_nodes then
         fn = update_nodes[gx.tag_name]
      end
      threads[#threads+1] = spawn(gx.update_doc, gx, node, fn)
      ::continue::
   end
   for i=1,#threads do
      local ok, res = wait(threads[i])
      if not ok then
         log(ERR, "error: ", res)
         return nil, res
      end
   end
   return doc
end


return _M

