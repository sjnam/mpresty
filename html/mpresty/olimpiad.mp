beginfig(3);                                            % olimpiad
  numeric u;
  u=1in;
  path squr, arcir, vert, horiz, area;
  squr = unitsquare scaled u;
  arcir = halfcircle scaled 2u;
  vert = (origin--up) scaled u shifted (u/2,0);
  horiz = (origin--right) scaled u shifted (0,u/2);\
    area = buildcycle( vert, arcir, horiz );
  fill area withcolor 0.5white;
  draw area withpen pencircle scaled 1pt;
  draw squr;
  draw arcir cutafter squr;
  draw vert;
  draw horiz;
endfig;
