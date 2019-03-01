Metapost in all browsers
=======
A web application for metapost that works in all browsers.

No more setup for readers. It just works.

[mpresty sample page](http://ktug.org/~sjnam/mpresty/all.html)

Synopsis
---------

````html
<html>
<body>
<h1>Examples</h1>

<mplibcode width="300">
beginfig(1)
  pair A,B,C; u:=3cm;
  A=u*dir(-30); B=u*dir(90); C=u*dir(210);

  transform T;
  A transformed T = 1/6[A,B];
  B transformed T = 1/6[B,C];
  C transformed T = 1/6[C,A];

  path p; p = A--B--C--cycle;
  for i=0 upto 20:
    draw p; p:= p transformed T;
  endfor;
endfig
</mplibcode>

</body>
</html>
````

Installation
------------
- Prerequisites
  
  - [TeX Live](https://www.tug.org/texlive/), An easy way to get up and running with the TeX document production system
  - [OpenResty](http://openresty.org/en/) v1.15.8, A dynamic web platform based on NGINX and LuaJIT
  - [lua-gumbo](https://craigbarnes.gitlab.io/lua-gumbo/), A HTML5 parser and DOM library for Lua

```bash
$ git clone https://github.com/sjnam/mp-resty.git /path/to/mpresty
$ cd /path/to/mpresty
$ mkdir -p html/images logs
$ ./ngxctl start
```

Examples
--------
- http://localhost:8080/demo/sunflower.html
- http://localhost:8080/preview.html
- http://localhost:8080/demo/all.html

Copyright (C) 2018-2019 Soojin Nam
