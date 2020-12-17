u:=25;                    % 25 = 25bp = 25 PostScript points = 25/72 in
wi:=10;                   % width  in units u   
he:=7;                    % height in units u
hoehe:=he*u;              % height
breite:=wi*u;             % width
path p[];
pair P;

def draw_point(expr P, colI, colP) =
  fill fullcircle scaled 3 shifted P withcolor colI;
  draw fullcircle scaled 3 shifted P withcolor colP;
enddef;

beginfig(1)
  z0=(1, .5)*u;
  z1=(.5, 2)*u;
  z2=(4, 2.1)*u;
  z3=(9, 6)*u;
  
  p0:=z0..z1..z2..z3;
  p1:=p0 slanted .2 
           xscaled .7 
	     rotatedabout(.5(breite, hoehe), -55)
	       shifted (.7u, 0)
	         rotatedaround((.5(breite, hoehe)), 180)
		   shifted (-.3u, 0);
  
  % --- Draw Frame ---
  draw (0, 0)--(breite, 0)--(breite, hoehe)--(0, hoehe)--cycle;
  %
  % --- Draw p0 withcolor black ---
  %
  pickup pencircle scaled 1;
  draw p0;
  pickup pencircle scaled .5;  
  for i=0 upto 30:
    t2:=.1i;
    draw ((-3, 0)--(3, 0))rotated (90+angle direction t2 of p0) 
      shifted point t2 of p0;
  endfor
  label.ulft("p0", point 2.8 of p0);  
  %
  % --- Draw p1 withcolor red ---
  %
  pickup pencircle scaled 1;
  draw p1 withcolor red;
  pickup pencircle scaled .5;  
  for i=0 upto 30:
    t2:=.1i;
    draw ((-3, 0)--(3, 0))rotated (90+angle direction t2 of p1) 
      shifted point t2 of p1 withcolor red;
  endfor  
  label.top("p1", point 2.8 of p1);  
  %
  % --- Calculate and draw point of intersection and tangents
  %
  (t0, t1)=p0 intersectiontimes p1;
  P:=p0 intersectionpoint p1;  
  draw ((-75, 0)--(75, 0)) rotated angle direction t0 of p0 shifted P;
  draw ((-50, 0)--(85, 0)) rotated angle direction t1 of p1 shifted P withcolor red;  
  label.ulft("t0="&decimal t0, P-(.1u, 0));
  label.lrt("t1="&decimal t1, P+(.1u, 0));  
  draw_point(P, white, blue);
  %
  % --- Draw points with integer parameter values ---
  %  
  for i=0 upto 3:
    draw_point(point i of p0, white, black);
    if i<>2:
      label.rt("t="&decimal i, point i of p0);
    else:
      label.bot("t="&decimal i, point i of p0);
    fi
  endfor 
  for i=0 upto 3:
    draw_point(point i of p1, white, red);
    if (i=1) or (i=3):
      label.bot("t="&decimal i, point i of p1);
    else:
      label.rt("t="&decimal i, point i of p1);
    fi
  endfor 
  
  label.rt("(t0, t1)=p0 intersectiontimes p1" ,(.5u, hoehe-.75u));

endfig;
