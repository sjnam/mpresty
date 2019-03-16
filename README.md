TeX graphics in all browsers
=======
A web application for TeX graphics(metapost, TikZ, Graphviz) that works
in all browsers.

No more setup for readers. It just works.

[Sample page](http://ktug.org/~sjnam/gxn/all.html)

Synopsis
---------

````html
<html>
<body>

<h3>Metapost</h3>
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

<h3>Graphviz</h3>
<graphviz src="http://ktug.org/~sjnam/source/fsm.gv" cmd="dot" width="150"></graphviz>
<graphviz src="https://graphviz.gitlab.io/_pages/Gallery/undirected/philo.gv.txt" cmd="neato" width="150"></graphviz>

<h3>TikZ</h3>
<tikzpicture src="http://ktug.org/~sjnam/source/sine.tex" width="150"></tikzpicture>
<tikzpicture src="http://ktug.org/~sjnam/source/func.tex" width="150"></tikzpicture>

</body>
</html>
````

Installation
------------
- Prerequisites
  
  - [TeX Live](https://www.tug.org/texlive/), An easy way to get up and running with the TeX document production system
  - [OpenResty 1.15.8.1](https://openresty.org/en/ann-1015008001rc1.html), A dynamic web platform based on NGINX and LuaJIT
  - [lua-gumbo](https://craigbarnes.gitlab.io/lua-gumbo/), A HTML5 parser and DOM library for Lua
  - [lua-resty-requests](https://github.com/tokers/lua-resty-requests), Yet Another HTTP Library for OpenResty

```bash
$ git clone https://github.com/sjnam/tex-graphics.git
$ cd tex-graphics
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
Soojin Nam, jsunam@gmail.com

License
-------
Public Domain

