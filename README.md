mpresty
=======
A web application for TeX graphics such as metapost, tikz or graphviz

No more setup for readers. It just works.

Synopsis
---------

````html
<html>
<body>
<h1>mpresty examples</h1>
<mplibcode>
beginfig(1)
  pair A, B, C;
  A:=(0,0); B:=(1cm,0); C:=(0,1cm);
  draw A--B--C;
endfig
</mplibcode>
</body>
</html>
````

Installation
------------
- Prerequisites
  
  - [TeX Live](https://www.tug.org/texlive/), An easy way to get up and running with the TeX document production system
  - [OpenResty](http://openresty.org/en/) v1.15.8, A full-fledged web platform that integrates the standard Nginx core, LuaJIT
  - [lua-gumbo](https://craigbarnes.gitlab.io/lua-gumbo/), A HTML5 parser and DOM library for Lua

- Webapps

```bash
$ git clone https://github.com/sjnam/mp-resty.git ./www
$ cd ~/www
$ mkdir -p html/images logs
$ ./openrestyctl start
```

Examples
--------
- Sample pages

  - http://localhost:8080/demo/sunflower.html
  - http://localhost:8080/demo/escher.html

- Preview page, http://localhost:8080/preview.html

Copyright (C) 2018-2019 Soojin Nam
