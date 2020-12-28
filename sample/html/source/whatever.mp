verbatimtex
%&latex                   % necessary for \,
\documentclass{article}
\begin{document}
etex

u:=25;                    % 25 = 25bp = 25 PostScript points = 25/72 in
wi:=10;                   % width  in units u   
he:=7;                    % height in units u
hoehe:=he*u;              % height
breite:=wi*u;             % width

beginfig(1)
  z1=(.5, 1)*u;
  z2=(5.5, 2)*u;
  z3=(4.3, 3.5)*u;
  z4=(1.5, 4)*u;
  
  z5=(z1--z3) intersectionpoint (z2--z4);    % "intersectionpoint" requires
                                             % two paths which  d o  intersect 
					     
  z6=f[z1, z2]=g[z3, z4];                    % Here the points of intersection may
  z7=whatever[z1, z4]=whatever[z2, z3];      % lie on the prolongations of the
                                             % line segments

  z10=z1 intersectionpoint z1;               % z1 is a path of length zero  
  z1=z1 intersectionpoint z1;                % is a consistent equation
  
  % -----------------------------------------------------------------------------------------
  
  z8=z7 shifted (u, -.65u);
  z9=z6 shifted (-.5u, -1.7u);   
  draw (0, 0)--(breite, 0)--(breite, hoehe)--(0, hoehe)--cycle;  
  draw z1--z3 withcolor red;
  draw z2--z4 withcolor red; 
   
  draw z1--z6 withcolor blue;
  draw z4--z6 withcolor blue;    
  draw z1--z7 withcolor .7green;
  draw z2--z7 withcolor .7green;
  
  pickup pencircle scaled 1.5;
  draw z1--z2 withcolor blue;
  draw z4--z3 withcolor blue;    
  draw z1--z4 withcolor .7green;
  draw z2--z3 withcolor .7green;
  pickup pencircle scaled 0.5;  
  
  for i=2 upto 6:
    if i=4:
      dotlabel.ulft("z"&decimal i, z[i]);
    elseif (i=3) or (i=6):
      dotlabel.urt("z"&decimal i, z[i]);
    elseif (i=1) or (i=2) or (i=5):
      dotlabel.bot("z"&decimal i, z[i]);
    else:
       dotlabel.top("z"&decimal i, z[i]);         
    fi
  endfor  
  dotlabel.lrt("", z1);
  label.lrt("z1 = z10", z1-(.3u, .05u));
  label.lrt("z10 = z1 intersectionpoint z1", z1-(.3u, .4u));  
  dotlabel.urt(btex z7=whatever[z1, z4]=whatever[z2, z3] etex, z7);   % `]' gets lost
  draw z5--z8-(.1u, u)--z8-(.1u, .1u)--z8;                            % without btex ... etex
  label.rt(btex z5=(z1-\,-z3)intersectionpoint(z2-\,-z4) etex, z8);   % \, is a LaTeX command
  draw z9--z9+(.1u, 0)--z6-(0, u)--z6;
  label.lft(btex z6=f[z1, z2]=g[z3, z4] etex, z9);
endfig;
