u:=50;                    % 50 = 50bp = 50 PostScript points = 50/72 in
wi:=5;                    % width  in units u   
he:=4;                    % height in units u
hoehe:=he*u;              % height
breite:=wi*u;             % width

beginfig(1)
  % --- Grid ---
  for i=0 upto he:
    draw (0, i*u)--(breite, i*u) withcolor .7white;
  endfor
  for j=0 upto wi:
    draw (j*u, 0)--(j*u, hoehe) withcolor .7white;
  endfor
  % --- End Grid ---
  
  draw (0, 0)--(breite, 0)--(breite, hoehe)--(0, hoehe)--cycle;
  
  z1=(0,    sqrt 0);
  z2=(1,    sqrt 1);
  z3=(2,    sqrt 2);
  z4=(3,    sqrt 3);
  
  drawarrow ((0,0)--(3.5, 0)) scaled u shifted (u, u);      % x-Achse
  drawarrow ((0,0)--(0,2.5)) scaled u shifted (u, u);       % y-Achse
  
  pickup pencircle scaled 4;
  draw (z1..z2..z3..z4) scaled u shifted (u, u) withcolor 0.8white;
  
  pickup pencircle scaled 8;
  for i=1 upto 4:
    draw z[i] scaled u shifted (u,u) withcolor .8white;
  endfor
  
  pickup pencircle scaled 2;
  draw (z1{up}..z2..z3..z4) scaled u shifted (u, u);  
endfig;
