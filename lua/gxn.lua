-- Author:  Soojin Nam, jsunam@gmail.com
-- License: Public Domain


local gumbo = require "gumbo"


local ipairs = ipairs
local io_open = io.open
local say = ngx.say
local log = ngx.log
local ERR = ngx.ERR
local WARN = ngx.WARN
local exit = ngx.exit
local ngx_var = ngx.var
local ngx_shared = ngx.shared
local wait = ngx.thread.wait
local spawn = ngx.thread.spawn
local parse = gumbo.parse
local HTTP_NOT_FOUND = ngx.HTTP_NOT_FOUND
local HTTP_INTERNAL_SERVER_ERROR = ngx.HTTP_INTERNAL_SERVER_ERROR


local gxs = {
    require "gxn.mplibcode",
    require "gxn.graphviz",
    require "gxn.tikzpicture"
}


local _M = {
    version = "0.9.4"
}


local DIR_PLAYGROUND = "/webapps/playground"


local function update_document (gx, doc, fn_update_node)
    return gx:update_document(doc, fn_update_node)
end


local function capture (path)
    local f = io_open(DIR_PLAYGROUND..path, "rb")
    if not f then
       return nil
    end

    local content = f:read("*all")
    f:close()
    return content
end


local function render (fn_update_node, doc)
    if not ngx_shared.gxn_cache then
        log(WARN, "Declare a shared memory zone, \"gxn_cache\" in a file 'nginx.conf.'")
    end

    local ok, res, err
    if not doc then
        local body = capture(ngx_var.uri)
        if not body then
            exit(ngx.HTTP_NOT_FOUND)
        end
        doc, err = parse(body)
        if not doc then
            log(ERR, err)
            exit(HTTP_INTERNAL_SERVER_ERROR)
        end
    end

    local threads = {}
    for _, gx in ipairs(gxs) do
        threads[#threads + 1] = spawn(update_document, gx, doc, fn_update_node)
    end

    for _, th in ipairs(threads) do
        ok, res, err = wait(th)
        if not ok then
            log(ERR, "fail to render html: ", err)
            exit(HTTP_INTERNAL_SERVER_ERROR)
        end
    end
    say(doc:serialize())
end


function _M.preview (html)
    render(nil, parse(html))
end


_M.render = render


return _M
