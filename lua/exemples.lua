local mpresty = require "mpresty"


local function my_update_node (doc, node, uri, content)
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


mpresty.go(nil, my_update_node)
