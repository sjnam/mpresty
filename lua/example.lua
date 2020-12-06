require "mpresty".render(
   function (doc, node, uri, content)
      node.localName = "p"
      node:removeAttribute("width")
      -- pre
      local pre = doc:createElement("pre")
      pre.textContent = content
      node:appendChild(pre)
      -- img
      local img = doc:createElement("img")
      img:setAttribute("src", uri)
      img:setAttribute("width", "200")
      node:appendChild(img)
      -- hr
      local hr = doc:createElement("hr")
      node:appendChild(hr)
   end
)

