beginfig(111)
  u := 7mm;
  path a,b,c;
  a = fullcircle scaled 2u shifted (.5u,0);
  b = a rotated (360/3);
  c = b rotated (360/3);
  fill a withcolor red;
  fill b withcolor green;
  fill c withcolor blue;
  fill buildcycle(a,b) withcolor red + green;
  fill buildcycle(b,c) withcolor green + blue;
  fill buildcycle(c,a) withcolor blue + red;
  fill buildcycle(a,b,c) withcolor white;
  draw a; draw b; draw c;
endfig
