-- Copyright (C) 2018-2019, Soojin Nam


local ipairs = ipairs
local fopen = io.open
local ngx_var = ngx.var
local str_gsub = string.gsub
local setmetatable = setmetatable
local gumbo_parse = require("gumbo").parse


local _M = {
   _VERSION = '0.3.6',
}


local graphics = {
   "mplibcode",
   "tikzpicture",
   "digraph",
   "neatograph",
}


for _, v in ipairs(graphics) do
   _M[v] = require("resty.gxn."..v)
end


return setmetatable(
   _M,
   { __call = function (self, fn_update_node)
        local f, err = fopen(ngx_var.document_root..ngx_var.uri, "r")
        if not f then
           return err, ngx.HTTP_NOT_FOUND
        end
        local content = f:read("*a")
        f:close()
        for _, v in ipairs(graphics) do
           content = str_gsub(content, "(<"..v.."%s+.-src%s*=.-)/?>", "%1></"..v..">")
        end
        local doc, err = gumbo_parse(content)
        if not doc then
           return err, ngx.HTTP_INTERNAL_SERVER_ERROR
        end
        for _, v in ipairs(graphics) do
           doc, err = self[v]:setDocument(doc):updateDocument(fn_update_node)
           if not doc then
              return err, ngx.HTTP_INTERNAL_SERVER_ERROR
           end
        end
        return doc:serialize()
   end }
)
