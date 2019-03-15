Metapost in all browsers
=======
A web application for metapost, tikz and graphviz that works in all browsers.

No more setup for readers. It just works.

[gxn sample page](http://ktug.org/~sjnam/mpresty/all.html)

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

<mplibcode src="http://ktug.org/~sjnam/source/tree.mp"></mplibcode>

</body>
</html>
````

Installation
------------
- Prerequisites
  
  - [TeX Live](https://www.tug.org/texlive/), An easy way to get up and running with the TeX document production system
  - [OpenResty](https://openresty.org/en/ann-1015008001rc1.html) v1.15.8.1, A dynamic web platform based on NGINX and LuaJIT
  - [lua-gumbo](https://craigbarnes.gitlab.io/lua-gumbo/), A HTML5 parser and DOM library for Lua
  - [lua-resty-requests](https://github.com/tokers/lua-resty-requests), Yet Another HTTP Library for OpenResty

```bash
$ git clone https://github.com/sjnam/mp-resty.git /path/to/mpresty
$ cd /path/to/mpresty
$ mkdir -p html/images logs
$ ./ngxctl start
```

Examples
--------
- http://localhost:8080/sample/sunflower.html
- http://localhost:8080/sample/all.html
- http://localhost:8080/preview.html

Author
------
Soojin Nam jsunam@gmail.com

License
-------
Public Domain

