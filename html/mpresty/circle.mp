beginfig(1)
u := 1.25cm;
color gray; gray := 0.6white;
pair p[];
p0 = (0,0); p1 = (2u,3u); p2 = (3u,2u);
def drawpoint(expr z, c) = draw z
  withpen pencircle scaled 3 withcolor c;
enddef;  

path q; q := p0..p1..p2..cycle;
for i=0 upto length(q):
  drawpoint(point i of q, black);
  p3 := precontrol i of q;
  p4 := postcontrol i of q;
  draw p3--p4 withcolor gray;
  drawpoint(p3, gray);
  drawpoint(p4, gray);
endfor;
draw q;
endfig;
