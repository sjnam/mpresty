GraphicsNode
=======
Just as [MathJax](https://www.mathjax.org/) makes it easier to use the tex math equations on a web page, `GraphicsNode` makes it easy to get the corresponding graphics with scripts such as `metapost`, `graphviz` or `tikz` on a web page.

Installation
------------
- Prerequisites:
  
  - [TeX Live](https://www.tug.org/texlive/), An easy way to get up and running with the TeX document production system
  - [Graphviz](https://www.graphviz.org/), Graph visualization is a way of representing structural information as diagrams of abstract graphs and networks.
  - [OpenResty](http://openresty.org/en/), A full-fledged web platform that integrates the standard Nginx core, LuaJIT
  - [lua-gumbo](https://craigbarnes.gitlab.io/lua-gumbo/), A HTML5 parser and DOM library for Lua

Getting Started
---------------
- GraphicsVode webapps

```bash
$ git clone https://github.com/sjnam/GraphicsNode.git ./www
$ cd ~/www
$ mkdir -p logs
$ ./openrestyctl start
```

- Visit sample page,  http://localhost:2019/demo/sunflower.html

Copyright (C) 2018-2019 Soojin Nam
