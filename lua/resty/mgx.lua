local ngx_var = ngx.var
local ngx_print = ngx.print
local gumbo_parse = require("gumbo").parseFile


local graphics = { "metapost", "tikz", "graphviz" }


local _M = {}


for i=1,#graphics do
   local v = graphics[i]
   _M[v] = require("resty.mgx."..v)
end


function _M:render (fn_update_node)
   local doc = gumbo_parse(ngx_var.document_root..ngx_var.uri)
   if not doc then
      ngx.exit(404)
   end
   for i=1,#graphics do
      local gx = self[graphics[i]]
      gx.doc = doc
      doc = gx:update_document(fn_update_node)
   end
   ngx_print(doc:serialize())
end


return _M

