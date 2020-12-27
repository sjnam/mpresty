beginfig(1);
  numeric scf, #, t[];
  3.2scf = 2.4in;
  path fun;
  # = .1; % Keep the function single-valued
  fun = ((0,-1#)..(1,.5#){right}..(1.9,.2#){right}..{curl .1}(3.2,2#))
    yscaled(1/#) scaled scf;
  x1 = 2.5scf;
  for i=1 upto 2:
    (t[i],whatever) =
      fun intersectiontimes ((x[i],-infinity)--(x[i],infinity));
    z[i] = point t[i] of fun;
    z[i]-(x[i+1],0) = whatever*direction t[i] of fun;
    draw (x[i],0)--z[i]--(x[i+1],0);
    fill fullcircle scaled 3bp shifted z[i];
  endfor
  label.bot(btex $x_1$ etex, (x1,0));
  label.bot(btex $x_2$ etex, (x2,0));
  label.bot(btex $x_3$ etex, (x3,0));
  draw (0,0)--(3.2scf,0);
  pickup pencircle scaled 1pt;
  draw fun;
endfig
