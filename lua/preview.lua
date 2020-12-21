local gumbo = require "gumbo"
local mpresty = require "mpresty"

local ngx_req = ngx.req
local parse = gumbo.parse
local tconcat = table.concat


ngx_req.read_body()

local args = ngx_req.get_post_args()
local cmd, args_cmd = "", args.cmd
if args_cmd and args_cmd ~= '' then
   cmd = " cmd='" .. args_cmd .. "'"
end

local html = tconcat {"<", args.gx, cmd, " cache='no' width='400'>\n",
                      args.code, "\n</", args.gx, ">" }
mpresty.go(parse(html))

