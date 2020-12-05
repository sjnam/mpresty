mpresty
=======
An openresty web application for TeX graphics (`metapost`, `graphviz`) that works
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
  u:=1.3cm; transform T; z1=(0,2u); n:=5;
  for i=1 upto n-1: z[i+1]=z1 rotated (360*i/n);
  endfor;
  z1 transformed T=0.1[z1,z2];
  z2 transformed T=0.1[z2,z3];
  z3 transformed T=0.1[z3,z4];
  path p;
  p = for i=1 upto n: z[i]--endfor cycle;
  for i=0 upto 100:
    fill p withcolor 0.2*white; p:=p transformed T;
    fill p withcolor white;     p:=p transformed T;
  endfor;
endfig
</mplibcode>

<mplibcode src="/source/tree.mp" cache="no"></mplibcode>

<mplibcode src="http://ktug.org/~sjnam/source/rgb.mp" width="300"></mplibcode>

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

<graphviz src="http://ktug.org/~sjnam/source/neato.gv" cmd="neato" width="300"></graphviz>

</body>
</html>
````

Run
---
```bash
% git clone https://github.com/sjnam/mpresty.git
% cd mpresty
% docker run -d -p 8080:80 \
-v $(pwd)/lua:/usr/local/openresty/nginx/lua \
-v $(pwd)/playground:/playground \
-v $(pwd)/conf.d:/etc/nginx/conf.d \
sjnam/mpresty
```

Try to visit the following pages
- http://localhost:8080/sample/sunflower.html
- http://localhost:8080/sample/all.html
- http://localhost:8080/preview.html

Create a `fun.html` file with the above [Synopsis](#Synopsis) and put it in the `$(pwd)/playground/mpresty/sample` directory and visit the page http://localhost:8080/sample/fun.html

Author
------
Soojin Nam, jsunam@gmail.com

License
-------
Public Domain
