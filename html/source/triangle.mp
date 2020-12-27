beginfig(1)
  pair A,B,C; u:=3cm;
  A=u*dir(-30); B=u*dir(90); C=u*dir(210);

  transform T;
  A transformed T = 1/6[A,B];
  B transformed T = 1/6[B,C];
  C transformed T = 1/6[C,A];

  path p; p = A--B--C--cycle;
  for i=0 upto 20:
    draw p; p:= p transformed T;
  endfor;
endfig
