local mpresty = require "mpresty"

mpresty.render(
   function (node, uri, content)
      -- img
      local img = node:cloneNode()
      img.localName = "img"
      img:setAttribute("src", uri)
      if not node:hasAttribute("width") then
         img:setAttribute("width", "300")
      end
      if node:hasAttribute("code") then
         img:setAttribute("alt", content)
         img:removeAttribute("code")
      end
      
      -- pre
      local pre = node:cloneNode()
      pre.localName = "pre"
      pre.textContent = content

      -- div
      node.localName = "div"
      node:appendChild(pre)
      node:appendChild(img)
   end
)

