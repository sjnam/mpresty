require "mpresty".render(
   function (node, uri, content)
      -- img
      local img = node:cloneNode()
      img.localName = "img"
      img:setAttribute("src", uri)
      -- pre
      local pre = node:cloneNode()
      pre.localName = "pre"
      pre.textContent = content
      -- hr
      local hr = node:cloneNode()
      hr.localName = "hr"
      hr:setAttribute("width", "100%")

      node.localName = "p"
      node:appendChild(pre)
      node:appendChild(img)
      node:appendChild(hr)
   end
)

