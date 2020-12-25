-- Author:  Soojin Nam, jsunam@gmail.com
-- License: Public Domain


local type = type
local ipairs = ipairs
local log = ngx.log
local ERR = ngx.ERR
local wait = ngx.thread.wait
local spawn = ngx.thread.spawn


local _M = {}


local gxs = {
   ['mp'] = require "mpresty.metapost",
   ['tex'] = require "mpresty.tikz",
   ['gv'] = require "mpresty.graphviz",
}


function _M:update_document (doc, fn_update_node)
   local update_nodes
   if type(fn_update_node) == "table" then
      update_nodes = fn_update_node
   end
   local threads = {}
   for _, node in ipairs(doc.images) do
      local gx = gxs[node:getAttribute("src"):match("%.(%a+)$")]
      if gx then
         gx.doc = doc
         local fn = fn_update_node
         if update_nodes then
            fn = update_nodes[gx.tag_name]
         end
         threads[#threads+1] = spawn(gx.update_doc, gx, node, fn)
      end
   end
   for _, th in ipairs(threads) do
      local ok, res = wait(th)
      if not ok then
         log(ERR, "error: ", res)
         return nil, res
      end
   end
   return doc
end


return _M
