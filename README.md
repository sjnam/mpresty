TeX graphics in all browsers
=======
A web application for TeX graphics (Metapost, TikZ, Graphviz) that works
in all browsers.

No more setup for readers. It just works.

A [sample page](http://ktug.org/~sjnam/gxn/all.html) redered by this web application, tex-graphics

Synopsis
---------

````html
<html>
<body>

<H1>Metapost</H1>

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

<mplibcode src="http://ktug.org/~sjnam/source/tree.mp" cache="no"></mplibcode>

<H1>Graphviz</H1>

<graphviz>
digraph G {
    main -> parse -> execute;
    main -> init;
    main -> cleanup;
    execute -> make_string;
    execute -> printf
    init -> make_string;
    main -> printf;
    execute -> compare;
}
</graphviz>

<graphviz src="https://graphviz.gitlab.io/_pages/Gallery/undirected/philo.gv.txt"
          cmd="neato"></graphviz>

<H1>TikZ</H1>

<tikzpicture>
\begin{tikzpicture}[scale=3]
  \draw[step=.5cm, gray, very thin] (-1.2,-1.2) grid (1.2,1.2); 
  \filldraw[fill=green!20,draw=green!50!black] (0,0) -- (3mm,0mm) arc (0:30:3mm) -- cycle; 
  \draw[->] (-1.25,0) -- (1.25,0) coordinate (x axis);
  \draw[->] (0,-1.25) -- (0,1.25) coordinate (y axis);
  \draw (0,0) circle (1cm);
  \draw[very thick,red] (30:1cm) -- node[left,fill=white] {$\sin \alpha$} (30:1cm |- x axis);
  \draw[very thick,blue] (30:1cm |- x axis) -- node[below=2pt,fill=white] {$\cos \alpha$} (0,0);
  \draw (0,0) -- (30:1cm);
  \foreach \x/\xtext in {-1, -0.5/-\frac{1}{2}, 1} 
    \draw (\x cm,1pt) -- (\x cm,-1pt) node[anchor=north,fill=white] {$\xtext$};
  \foreach \y/\ytext in {-1, -0.5/-\frac{1}{2}, 0.5/\frac{1}{2}, 1} 
    \draw (1pt,\y cm) -- (-1pt,\y cm) node[anchor=east,fill=white] {$\ytext$};
\end{tikzpicture}
</tikzpicture>

<tikzpicture src="http://ktug.org/~sjnam/source/func.tex"></tikzpicture>

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
- http://localhost:8080/sample/small.html
- http://localhost:8080/sample/all.html
- http://localhost:8080/preview.html

Author
------
Soojin Nam, jsunam@gmail.com

License
-------
Public Domain

