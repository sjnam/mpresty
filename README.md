GraphicsNode
=======
Just as MathJax makes it easier to use the tex math equations on a web page, GraphicsNode makes it easy to get the corresponding graphics with scripts such as `metapost`, `tikz`, or `graphviz` on a web page.

Status
------
Experimental.

Installation
------------
- Prerequisites:
  
  - [texlive](https://www.tug.org/texlive/), An easy way to get up and running with the TeX document production system.
  - [nginx](http://nginx.org), An HTTP and reverse proxy server
  - [lua-nginx-module](https://github.com/openresty/lua-nginx-module), Embed the power of Lua into Nginx HTTP Servers
  - [lua-gumbo](https://craigbarnes.gitlab.io/lua-gumbo/), A HTML5 parser and DOM library for Lua
  - [sockexec](https://github.com/jprjr/sockexec), A small server for executing local processes.
  - [netstring.lua](https://github.com/jprjr/netstring.lua), An implementation of DJB's netstring encoding format for Lua/LuaJIT.
  - [lua-resty-exec](https://github.com/jprjr/lua-resty-exec), Run external programs in OpenResty without spawning a shell or blocking

- Place `lua/resty` to your lua library path.

Getting Started
---------------
```bash
$ PATH=/usr/local/nginx/sbin:$PATH
$ export PATH
$ git clone https://github.com/sjnam/GraphicsNode.git /path/to/www
$ cd /path/to/www
$ mkdir -p logs html/images
$ sockexec /tmp/exec.sock
$ nginx -p `pwd`/ -c conf/nginx.conf
```

- html/sample.html
```html
<html>
<body>
<mplibcode width="200px">
beginfig(1)
  pair A, B, C;
  A:=(0,0); B:=(1cm,0); C:=(0,1cm);
  draw A--B--C;
endfig;
</mplibcode>
<hr>
<tikzpicture width="200px">
\begin{tikzpicture}
  \draw (-1.5,0) -- (1.5,0);
  \draw (0,-1.5) -- (0,1.5);
\end{tikzpicture}.
</tikzpicture>
</body>
</html>
```

- conf/nginx.conf
```
server {
    listen 8080;
    location = /sample.html {
        content_by_lua_block {
            require("resty.gxn"):render()
        }
    }
}
```

