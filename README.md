mpresty
==================
An openresty web application for metapost

Getting started
---------------
You can write the `metapost` or `tikz` or `graphviz` script of the image you
want to draw in the html file, and the _mpresty_ converts the script into the
image.

The graphics scripts are inserted into the html in codes or they are stored in
a file and inserted into uri format of `img`'`src` attribute.

````html
<html>
<body>
<H1>Metapost</H1>
<metapost width="200">
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
endfig;
</metapost>
<img src="/source/tree.mp" width="200">
<img src="http://ktug.org/~sjnam/source/rgb.mp" width="200">
</body>
</html>
````

Run
---
```bash
% git clone https://github.com/sjnam/mpresty.git
% cd mpresty
% docker run -d -p 8080:8080 \
-v $(pwd)/lua:/usr/local/openresty/nginx/lua \
-v $(pwd)/conf.d:/etc/nginx/conf.d \
--name mpresty sjnam/mpresty
```

Try to visit the following pages
- http://localhost:8080/benchmark.gxn
- http://localhost:8080/tutorial.gxn
([Original](http://www.ursoswald.ch/metapost/tutorial.html))
- http://localhost:8080/sunflower.gxn
- http://localhost:8080/all.gxn
- http://localhost:8080/preview.html

Create a `fun.html` file with the above [Getting started](#getting-started) and
put it in the `$(pwd)/html` directory and visit http://localhost:8080/fun.gxn

Advanced Usage
--------------
### update-node customization
See [exemples.lua](https://github.com/sjnam/mpresty/blob/master/lua/exemples.lua)
- http://localhost:8080/exemples.gxn ([Original](https://tex.loria.fr/prod-graph/zoonekynd/metapost/metapost.html))

See [upnode.lua](https://github.com/sjnam/mpresty/blob/master/lua/upnode.lua)
- http://localhost:8080/updatenode.gxn

Author
------
Soojin Nam, jsunam at gmail.com
