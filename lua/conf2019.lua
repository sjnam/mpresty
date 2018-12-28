local mgx = require "resty.mgx"

--[[
local fn_update_node_img_pre = function (self, node, uri, content)
   local img = self:createElement("img")
   img:setAttribute("src", uri)
   for _, v in ipairs(node.attributes) do
      img:setAttribute(v.name, v.value)
      node:removeAttribute(v.name)
   end

   local pre = self:createElement("pre")
   pre.textContent = content

   node.localName = "div"
   node:appendChild(img)
   node:appendChild(pre)
end


mgx.metapost:set_update_node(fn_update_node_img_pre)
mgx.tikz:set_update_node(function (self, node, uri, content)
      node.localName = "pre"
      node.textContent = content
      for _, attr in ipairs(node.attributes) do
         node:removeAttribute(attr.name)
      end
end)
--]]


mgx:render()

