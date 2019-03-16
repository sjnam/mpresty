local gxn = require "gxn"

ngx.req.read_body()
local args = ngx.req.get_post_args()
local html = string.format("<%s cmd='%s' width='400' cache='no'>%s</%s>",
                           args.gx, args.cmd or "", args.code, args.gx)
gxn:preview(html)
