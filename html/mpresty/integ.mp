beginfig(1);
  numeric xmin, xmax, ymin, ymax;
  xmin := 1/4; xmax := 6; ymax := 1/xmin; u := 1cm;
% compute the graph of the function
  vardef f(expr x) = 1/x enddef;
  xinc := 0.1;
  path pts_f;
  pts_f := (xmin,f(xmin))*u
    for x=xmin+xinc step xinc until xmax:
    .. (x,f(x))*u
  endfor;
  path hline[], vline[];
  hline0 = (0,0)*u -- (xmax,0)*u;
  vline0 = (0,0)*u -- (0,ymax)*u;
  vline0.5 = (0.5,0)*u -- (0.5,ymax)*u;
  vline4 = (4,0)*u -- (4,ymax)*u;
  fill buildcycle(hline0, vline0.5, pts_f, vline4)
    withcolor 0.8[blue,white];
  draw hline0; draw vline0; % draw axes
  draw (0.5,0)*u -- vline0.5 intersectionpoint pts_f;
  draw (4,0)*u -- vline4 intersectionpoint pts_f;
  draw pts_f withpen pencircle scaled 2;
  label.bot(btex $x$ etex, (0.9xmax,0)*u);
  label.lft(btex $y$ etex, (0,0.9ymax)*u);
  label.urt(btex $f(x)$ etex, (0.5,f(0.5))*u);
endfig;
