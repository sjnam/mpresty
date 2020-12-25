beginfig(1);
  numeric u, w, i, r, s, lim;
  u = 2in;
  w = 150;
  r = 0.5u;
  s = 1/20;
  lim = 4;
  for i=0 step s until lim:
    draw fullcircle scaled 2r shifted (u*(i,sind(i*w)));
  endfor;
  %draw origin--(u*(90/w,1));
  pair d, p;
  path slope, decli;
  d = (-90/w,3.14159/2);
  p = unitvector((-ypart d,xpart d));
  slope = ((-u*d)--(u*d)) shifted (-r*p);
  decli = reverse slope shifted (2*r*p);
  draw (slope--decli--cycle) shifted (u*180/w,0);
endfig;

end.
