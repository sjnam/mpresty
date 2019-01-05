-- Copyright (C) 2018-2019, Soojin Nam


local str_find = string.find
local ngx_var = ngx.var
local fopen = io.open

local gxn = require("resty.gxn.base"):new {
   tag_name = "gxn",
}

local graphics = {
   mp = "mplibcode",
   tikz = "tikzpicture",
   dot = "digraph",
   neato = "neatograph"
}


local function set_graphics (self, src, cmd)
   local _, _, ext = str_find(src, "%.(%a+)$")
   local gx = require("resty.gxn")[graphics[cmd or ext]]
   self.cmd = gx.cmd
   self.ext = gx.ext
   self.tag_name = gx.tag_name
   self.preamble = gx.preamble
   self.postamble = gx.postamble
end


gxn.getContent = function (self, node)
   local src = node:getAttribute("src");
   set_graphics(self, src, node:getAttribute("cmd"))
   local f = fopen(ngx_var.document_root.."/"..src, "r");
   local content =  f:read("*a")
   f:close()
   return content
end


return gxn

