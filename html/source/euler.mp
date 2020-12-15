beginfig(1)
  path c;
  c = (0,0){dir 0} .. (150,100);
  draw c;

  t := 0.4;
  pair P[];
  P1 = point t of c;

  dx := 60;
  (dx, dy) = whatever * direction t of c;

  P4 = P1 + (dx, 0);
  P3 = P4 + (0, dy);
  P2 = c intersectionpoint (P4 -- P4+(0,100));

  draw P1--P4--P2;
  draw P1--P3;
  dotlabel.ulft(btex $P_1$ etex, P1);
  dotlabel.ulft(btex $P_2$ etex, P2);
  dotlabel.rt(btex $P_3$ etex, P3);
  label.bot(btex $\Delta x$ etex, 0.5[P1,P4]);
  label.rt(btex $\Delta y$ etex, 0.5[P4,P3]);
  label.rt(btex $e$ etex, 0.5[P3,P2]);
endfig;
