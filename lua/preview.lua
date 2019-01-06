local gumbo_parse = require("gumbo").parse

ngx.req.read_body()

local args = ngx.req.get_post_args()
local args_gx = args.gx or "mplibcode"
local gx = require("resty.gxn")[args_gx]
local msg = string.format("<%s width='300'>%s</%s>", args_gx, args.msg, args_gx)

ngx.say(gx:setDocument(gumbo_parse(msg)):updateDocument():serialize())

