local ngx_var = ngx.var
local ngx_print = ngx.print
local gumbo_parse = require("gumbo").parseFile


local graphics = { "metapost", "tikz", "graphviz" }


local _M = {}


for i=1,#graphics do
   local v = graphics[i]
   _M[v] = require("resty.mgx."..v)
end


function _M:render (update_node)
   local doc = gumbo_parse(ngx_var.document_root..ngx_var.uri)
   if not doc then
      ngx.exit(ngx.HTTP_NOT_FOUND)
   end
   for i=1,#graphics do
      local mgx = self[graphics[i]]
      mgx.doc = doc
      doc = mgx:update_document(update_node)
   end
   ngx_print(doc:serialize())
end


return _M

