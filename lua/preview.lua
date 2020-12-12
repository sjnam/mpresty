local gumbo = require "gumbo"
local mpresty = require "mpresty"


ngx.req.read_body()

local args = ngx.req.get_post_args()

local html = table.concat {
   "<", args.gx, " cmd='", args.cmd, "'",
   " cache='no', width='400'>", args.code, "</", args.gx, ">"
}

local gx = mpresty.new { doc = gumbo.parse(html) }
gx:render()
