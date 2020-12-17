u:=25;                    % 25 = 25bp = 25 PostScript points = 30/72 in
wi:=10;                   % width  in units u   
he:=7;                    % height in units u
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

  %%%              %%%
  %%%  fullcircle  %%%
  %%%  halfcircle  %%%
  %%%              %%%            
  draw fullcircle scaled 3u shifted (5u, 5.2u);
  draw fullcircle xscaled 3u yscaled 1.2u shifted (5u, 2.2u);
  draw fullcircle xscaled 1.2u yscaled 3u shifted (8u, 5.2u);
  fill fullcircle xscaled 3u yscaled 1.2u rotated 45 shifted (8u, 2.2u) withcolor .9white;
  draw fullcircle xscaled 3u yscaled 1.2u rotated 45 shifted (8u, 2.2u);
  
  draw halfcircle scaled 2u shifted (1.5u, 5u);
  pickup pencircle scaled 1.5;
  draw halfcircle scaled 2u rotated 90 shifted (1.5u, 4u) withcolor red;
  draw halfcircle scaled 2u rotated -90 shifted (1.5u, 3u) withcolor blue;  
endfig;

end
