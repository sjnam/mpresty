local function update_node_img_pre (self, node, uri, content)
   local doc = self.doc
   local img = doc:createElement("img")
   img:setAttribute("src", uri)
   for _, v in ipairs(node.attributes) do
      img:setAttribute(v.name, v.value)
      node:removeAttribute(v.name)
   end
   if not img:getAttribute("width") then
      img:setAttribute("width", "300")
   end

   local pre = doc:createElement("pre")
   pre.textContent = content

   node.localName = "div"
   node:appendChild(img)
   node:appendChild(pre)
end

-- main
local html, err = (require "gxn"):render()
if err then
   ngx.log(ngx.ERR, "fail to render html: ", html)
   ngx.exit(err)
end

ngx.say(html)
