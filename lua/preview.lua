local gumbo = require "gumbo"
local mpresty = require "mpresty"

ngx.req.read_body()

local args = ngx.req.get_post_args()
local str = table.concat {
   "<", args.gx, " cmd='", args.cmd, "'", " width='400'>",
   args.code,
   "</", args.gx, ">"
}
local doc = gumbo.parse(str)

mpresty.render(nil, doc)

