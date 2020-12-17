u:=25;                    % 25 = 25bp = 25 PostScript points = 30/72 in
wi:=10;                   % width  in units u   
he:=10;                   % height in units u
hoehe:=he*u;              % height
breite:=wi*u;             % width
string s[];
s1:="06.09.2002";
s2:="StringLabels.png";

beginfig(1)
  % --- Grid ---
  for i=0 upto he:
    draw (0, i*u)--(breite, i*u) withcolor .7white;
  endfor
  for j=0 upto wi:
    draw (j*u, 0)--(j*u, hoehe) withcolor .7white;
  endfor
  % --- End Grid ---
  
  for i=1 upto 9:
    z[i]=(1+.9i, 1+.2i+.01i*i) scaled u;
    z[10+i]=z[i] rotatedaround((5u,5u), 160) scaled .8 yscaled 1.3;
  endfor
  
  % frame 
  draw (0, 0)--(breite, 0)--(breite, hoehe)--(0, hoehe)--cycle;
    
  for i=1 upto 9:
    draw (z[i]--z[10+i]);                         % connections
  endfor

  for i=1 upto 9:
    dotlabel.bot("z"&decimal i, z[i]);            % bot: bottom
    dotlabel.top("z"&decimal (10+i), z[10+i]);    % &:   catenation of strings
  endfor
  
  label.urt("Urs Oswald", (0, 0));                % urt:  upper right
  label.ulft(s[1],        (breite, 0));           % ulft: upper left
  label.lrt(s[2],         (0, hoehe));            % lrt:  lower right   
endfig;
