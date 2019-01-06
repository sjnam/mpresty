local gxn = require "resty.gxn"

--[[
local fn_update_node_img_pre = function (self, node, uri, content)
   local img = self:createElement("img")
   img:setAttribute("src", uri)
   for _, v in ipairs(node.attributes) do
      img:setAttribute(v.name, v.value)
      node:removeAttribute(v.name)
   end
   if not img:getAttribute("width") then
      img:setAttribute("width", "250")
   end

   local pre = self:createElement("pre")
   pre.textContent = content

   node.localName = "div"
   node:appendChild(img)
   node:appendChild(pre)
end

gxn.mplibcode:setCurrentUpdateNode(fn_update_node_img_pre)
gxn.tikzpicture:setCurrentUpdateNode(function (self, node, uri, content)
      node.localName = "pre"
      node.textContent = content
      for _, attr in ipairs(node.attributes) do
         node:removeAttribute(attr.name)
      end
end)
--]]

gxn:render()

