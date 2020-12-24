local mpresty = require "mpresty"


local function mp_update_node (doc, node, uri, content)
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

local function tikz_update_node (doc, node, uri, content)
   node.localName = "img"
   node:setAttribute("src", uri)
   node:setAttribute("width", "200")
   node:setAttribute("style", "border:5px solid black")
   node:setAttribute("alt", content)
end


local fn_update_node = {
   ['metapost'] = mp_update_node,
   ['tikz'] = tikz_update_node,
}

mpresty.go(nil, fn_update_node)
