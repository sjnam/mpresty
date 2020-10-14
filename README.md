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

<graphviz src="https://graphviz.org/Gallery/directed/Linux_kernel_diagram.gv.txt"
          cmd="dot"></graphviz>

</body>
</html>
````

Installation
------------
```bash
% git clone https://github.com/sjnam/tex-graphics.git
% cd tex-graphics
% mkdir -p /path/to
% cp -r playground /path/to
% docker build -t mpresty .
% docker run -d -p 8080:8080 \
  -v /path/to/playground:/webapps/playground \
  --name gxn \
  mpresty
% docker start gxn
```

Examples
--------
- http://localhost:8080/gxn/sunflower.html
- http://localhost:8080/gxn/test.html
- http://localhost:8080/preview.html

Create a `sample.html` file with the above [Synopsis](#Synopsis) and put it in the `/path/to/playground/gxn` directory and run the following.
- http://localhost:8080/gxn/sample.html

Author
------
Soojin Nam, jsunam@gmail.com

License
-------
Public Domain
