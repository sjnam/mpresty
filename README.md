lua-resty-graphics-node
=======
Just as [MathJax](https://www.mathjax.org/) makes it easier to use the tex math equations on a web page, `lua-resty-graphics-node` makes it easy to get the corresponding graphics with scripts such as `metapost` and `graphviz` on a web page.

Status
------
Experimental.

Installation
------------
- Prerequisites:
  
  - [TeX Live](https://www.tug.org/texlive/), An easy way to get up and running with the TeX document production system
  - [Graphviz](https://www.graphviz.org/), Graph visualization is a way of representing structural information as diagrams of abstract graphs and networks.
  - [OpenResty](http://openresty.org/en/), A full-fledged web platform that integrates the standard Nginx core, LuaJIT
  - [lua-gumbo](https://craigbarnes.gitlab.io/lua-gumbo/), A HTML5 parser and DOM library for Lua
  - [lua-resty-http](https://github.com/ledgetech/lua-resty-http), Lua HTTP client cosocket driver for OpenResty
- Place `lib/resty` to your lua library path.

Getting Started
---------------
```bash
$ export PATH=/usr/local/openresty/nginx/sbin:$PATH
$ mkdir ~/www
$ cd ~/www
$ mkdir -p conf logs util html/images
$ nginx -p `pwd`/ -c conf/nginx.conf
```

- html/sample.html
```html
<html>
<body>

<hr>
<mplibcode src="http://ktug.org/~sjnam/examples/newton.mp" width="250"/>

<hr>
<mplibcode width="250">
beginfig(1)
  pair A, B, C;
  A:=(0,0); B:=(1cm,0); C:=(0,1cm);
  draw A--B--C;
endfig;
</mplibcode>

<hr>
<digraph width="250">
digraph G {
  main -> init;
  main -> cleanup;
}
</digraph>

</body>
</html>
```

- conf/nginx.conf
```
worker_processes  1;
error_log logs/error.log;
events {
    worker_connections 1024;
}
http {
    server {
        listen 8080;
        include mime.types;
        location /sample {
            default_type text/html;
            content_by_lua_block {
                require("resty.gxn"):render()
            }
        }
    }
}
```

- util/gxn.sh
```bash
#!/bin/bash

cd $1

ERROR=0

case $2 in
    mplibcode)
        $5 $3
        ERROR=$?
        ;;
    digraph)
        $5 -Tsvg $3.gv -o $3.$4
        ERROR=$?
        ;;
    *)
        echo 'NOT SUPPORTED'
esac

rm -rf *.mp *.mpx *.gv

exit $ERROR
```

Copyright (C) 2018-2019 Soojin Nam

