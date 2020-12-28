u:=25;                    % 25 = 25bp = 25 PostScript points = 25/72 in
wi:=10;                   % width  in units u   
he:=7;                    % height in units u
hoehe:=he*u;              % height
breite:=wi*u;             % width

path p[];
  p0:=fullcircle scaled  3u shifted (2.3u, hoehe-2.1u);
  p1:=fullcircle xscaled 3u yscaled u rotated 225 shifted (2.3u, 1.6u);
  p2:=fullcircle xscaled 4u yscaled 2u shifted (7.25u, hoehe/2);
  p3:=fullcircle xscaled 5u yscaled 6.5u shifted (7.25u, hoehe/2);

def draw_point(expr P, colInt, colPer) =
  fill fullcircle scaled 1.5mm shifted P withcolor colInt;
  draw fullcircle scaled 1.5mm shifted P withcolor colPer;
enddef;

beginfig(1)
  % --- Draw frame ---
  draw (0, 0)--(breite, 0)--(breite, hoehe)--(0, hoehe)--cycle;

  draw p0;                                        % Draw p0
  pickup pencircle scaled 1.5;
  draw subpath (0, 4) of p0 withcolor red;
  pickup pencircle scaled 0.5;
  for t=0 upto 7:
    z[t]=point t of p0;
    draw_point(z[t], white, red);
    if (t<2) or (t=7): 
      label.rt("t = "&decimal t, z[t]);
    elseif t=2:      
      label.top("point "&decimal t&" of p0", z[t]);
    elseif (t=3) or (t=5): 
      label.lft("t = "&decimal t, z[t]);          
    elseif t=4: 
      label.lft(decimal t, z[t]);          
    else: 
      label.ulft(decimal t, z[t]); 
    fi
  endfor
  label("p0", center p0 + (0, .25u));
  label("length(p0)="&decimal length(p0), center p0 - (0, .25u));
  
  draw p1;                                        % Draw p1
  pickup pencircle scaled 1.5;
  draw subpath (0, 4) of p1 withcolor red;
  pickup pencircle scaled 0.5;
  for t=0 upto 7:
    z[10+t]=point t of p1;
    draw_point(z[10+t], white, red);
    if t=0: 
      label.llft("t = "&decimal t, z[10+t]);
    elseif t=1: 
      label.lrt("t = "&decimal t&" - point "&decimal t&" of p1", z[10+t]);
    elseif t<4: 
      label.lrt ("t = "&decimal t, z[10+t]);
    elseif t=4: 
      label.urt ("t = "&decimal t, z[10+t]);
    else: 
      label.ulft("t = "&decimal t, z[10+t]); 
    fi
  endfor
  label("p1", center p1);
  
  draw p2;                                        % Draw p2
  pickup pencircle scaled 1.5;
  draw subpath (0, 4) of p2 withcolor red;
  pickup pencircle scaled 0.5;  
  label("subpath (0, 4) of p2", center p2 + (0, .25u));
  label("subpath (4, 8) of p2", center p2 - (0, .25u));
  
  draw p3 dashed evenly;                          % Draw p3  
  label.llft("p3", point 1.4 of p3);
  
  for t=0 upto 7:                                 % Draw blue arrows    
    p99:=(point t of p3)--center p3;
    pickup pencircle scaled 1.5;
    if t<4:
      drawarrow p99 cutafter subpath (0, 4) of p2 withcolor blue;
    else:
      drawarrow p99 cutafter subpath (4, 8) of p2 withcolor blue;
    fi
  endfor
endfig;
