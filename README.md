mpresty
=======
A web application for TeX graphics such as metapost or tikz

No more setup for readers. It just works.

Synopsis
---------

````html
<html>
<body>
<h1>mpresty examples</h1>

<mplibcode>
beginfig(1)
  draw (0,0) withpen pencircle scaled 4bp;
  draw fullcircle scaled 1cm;
endfig
</mplibcode>

<hr>

<tikzpicture width="400">
\begin{tikzpicture}
  \draw [blue] (0,0) rectangle (1.5,1);
  \draw [red, ultra thick] (3,0.5) circle [radius=0.5];;
  \draw [gray] (6,0) arc [radius=1, start angle=45, end angle= 120];
\end{tikzpicture}
</tikzpicture>

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
- Sample pages

  - http://localhost:8080/demo/sunflower.html
  - http://localhost:8080/demo/riemann.html

- Preview page, http://localhost:8080/preview.html

Copyright (C) 2018-2019 Soojin Nam

