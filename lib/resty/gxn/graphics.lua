-- Copyright (C) 2018-2019, Soojin Nam


local ngx_var = ngx.var
local fopen = io.open

local gxn = require("resty.gxn.base"):new {
   tag_name = "graphics",
}


local function set_property (self, g)
   local gx = require("resty.gxn")[g]
   self.cmd = gx.cmd
   self.ext = gx.ext
   self.tag_name = gx.tag_name
   self.preamble = gx.preamble
   self.postamble = gx.postamble
end


gxn.getContent = function (self, node)
   set_property(self, node:getAttribute("type"))
   local src = node:getAttribute("src");
   local f = fopen(ngx_var.document_root.."/"..src, "r");
   local content =  f:read("*a")
   f:close()
   return content
end


return gxn

