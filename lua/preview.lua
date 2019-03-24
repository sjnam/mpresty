local gxn = require "gxn"
local ngx_req = ngx.req

ngx_req.read_body()

local args = ngx_req.get_post_args()

gxn.preview("<"..args.gx.." cmd='"..args.cmd.."'".." width='400'>"
            ..args.code.."</"..args.gx..">")

