-- Copyright (C) 2018-2019, Soojin Nam


local resty_http = require "resty.http"
local str_find = string.find
local str_format = string.format
local ngx_var = ngx.var
local gxn_cache = ngx.shared.gxn_cache


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
   local _, _, key = str_find(src, "%.(%a+)$")
   local gx = require("resty.gxn")[graphics[cmd or key]]
   self.cmd = gx.cmd
   self.ext = gx.ext
   self.tag_name = gx.tag_name
   self.preamble = gx.preamble
   self.postamble = gx.postamble
end


gxn.getContent = function (self, node)
   local uri = node:getAttribute("src");
   set_graphics(self, uri, node:getAttribute("cmd"))

   local http = resty_http.new()
   local scheme = http:parse_uri(uri)
   if not scheme then
      uri = str_format("http://%s:%s/%s",
                       ngx_var.server_addr, ngx_var.server_port, uri)
   end

   local content = gxn_cache and gxn_cache:get(uri)
   if not content then
      local res, err = http:request_uri(uri)
      if not res then
         ngx.log(ngx.ERR, "fail to fetch uri: ", err)
         ngx.exit(500)
      end
      content = res.body
      if gxn_cache then
         gxn_cache:set(uri, content)
      end
   end
   return content
end


return gxn
