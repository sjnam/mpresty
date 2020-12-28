u:=100;                   % 100 = 100bp = 100 PostScript points = 100/72 in
hoehe:=2.5u;              % height
breite:=2.5*u;            % width
path h, r[];

beginfig(1)
  z0=(.25u, .25u);
  
  for i=4 upto 16:
    z[i]=(i/8, 8/i);
    r[i]:=(0,0)--(x[i], 0)--z[i]--(0, y[i])--cycle;
  endfor
  
  h:=(.5, 2) for i=5 upto 16: ..z[i] endfor ;
    
  % Frame    
  draw (0,0)--(breite,0)--(breite, hoehe)--(0, hoehe)--cycle;
  % Grid
  for i=1,2:
    draw ((0,i)--(2,i)) scaled u shifted z0 withcolor .7white;
    draw ((i,0)--(i,2)) scaled u shifted z0 withcolor .7white;
  endfor
  % Axes
  drawarrow ((0, 0)--(2.1, 0)) scaled u shifted z0; 
  drawarrow ((0, 0)--(0, 2.1)) scaled u shifted z0; 
  
  % Curve (hyperbola)
  pickup pencircle scaled 2;
  draw h scaled u shifted z0;
  
  fill r[5]  scaled u shifted z0 withcolor .7white;
  fill r[15] scaled u shifted z0 withcolor .9white;
  fill r[8]  scaled u shifted z0 withcolor .8white;
  
  pickup pencircle scaled .5;      % 0.5: default pencircle
  for i=5 upto 15:
    draw r[i] scaled u shifted z0;
  endfor
  
endfig;
