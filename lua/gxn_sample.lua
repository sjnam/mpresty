--[[
local function update_node_img_pre (self, node, uri, content)
   local img = self:create_element("img")
   img:setAttribute("src", uri)
   for _, v in ipairs(node.attributes) do
      img:setAttribute(v.name, v.value)
      node:removeAttribute(v.name)
   end
   if not img:getAttribute("width") then
      img:setAttribute("width", "300")
   end

   local pre = self:create_element("pre")
   pre.textContent = content

   node.localName = "div"
   node:appendChild(img)
   node:appendChild(pre)
end
--]]

local body, err = (require "gxn"):render()
if err then
   ngx.log(ngx.ERR, "fail to render html: ", body)
   ngx.exit(err)
end

ngx.say(body)
