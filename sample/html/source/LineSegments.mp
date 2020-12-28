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
  
  % Line Segment
  draw (.7u, 4u)--(5u, 6.5u);
  
  % Arrow
  drawarrow (6.4u, 6u)--(9.5u, 4.8u);
  
  pickup pencircle scaled 2;            % default: 
                                        % 0.5 (= 0.5bp = 0.5 PostScript Points)

  % Polyline  
  draw (u, 5u)--(0, 4u)--(u, 3u)--(2u, 4u)--(3u, 3u)--(u,u)--(2u, 0)--(3u, u);

  % Polyarrow  
  drawarrow (5u, 5u)--(4u, 3u)--(5u, 4u)--(4u, 2u)--(6u, 3u)--(5u, u);
  
  % Polygon
  fill (7.7u, .3u)--(9.6u, 1.5u)--(9.3u, 3.6u)--(7.2u, 3.8u)
                  --(6.4u, 2.5u)--(7.3u, 1.9u)--cycle withcolor .9white;  
  pickup pencircle scaled .5;
  draw (7.7u, .3u)--(9.6u, 1.5u)--(9.3u, 3.6u)--(7.2u, 3.8u)
       --(6.4u, 2.5u)--(7.3u, 1.9u)--cycle;    
endfig;
