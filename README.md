TeX graphics in all browsers
=======
An openresty web application for TeX graphics (Metapost, Graphviz) that works
in all browsers.

No more setup for readers. It just works.

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

</body>
</html>
````

Installation
------------
- Docker
```bash
% docker build -t mpresty .
% docker run -d -p 80:80 --name gxn mpresty
```

Examples
--------
- http://localhost/sample/sunflower.html
- http://localhost/sample/all.html
- http://localhost/preview.html

Author
------
Soojin Nam, jsunam@gmail.com

License
-------
Public Domain
