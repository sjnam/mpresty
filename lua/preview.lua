local mpresty = require "mpresty"


local ngx_req = ngx.req
local concat = table.concat


ngx_req.read_body()

local args = ngx_req.get_post_args()

mpresty.preview(
   concat{
      "<", args.gx, " cmd='", args.cmd, "'", " width='400'>",
      args.code,
      "</", args.gx, ">"
})

