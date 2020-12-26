beginfig(117)
  u:=2cm;
  pair A, B, C, D, E;
  path p, q, r;

  A = u*up;
  p := (-.2)[ A, A rotated 72 ] -- (1.2)[ A, A rotated 72 ];
  for i=0 upto 5:
    draw p rotated 72i;
  endfor;
  B := 1/2[ A, A rotated 72 ];
  C := .8*B;

  p := B --- C .. (C rotated (2*72)){right};
  % On allonge le chemin p
  p := ( (point 0 of p) - 4mm*unitvector(direction 0 of p))
       --
       (point 0 of p)
       & p &
       (point 2 of p)
       --
       ( (point 2 of p) + 4mm*unitvector(direction 2 of p));

  E = p intersectionpoint (p rotated 72);
  q := p cutbefore fullcircle scaled -2mm shifted E;
  r := p cutafter fullcircle scaled  2mm shifted E;

  for i=0 upto 4:
    draw q rotated 72i;
    draw r rotated 72i;
    draw A rotated 72i withpen pencircle scaled 4bp;
    draw B rotated 72i withpen pencircle scaled 4bp;
    draw C rotated 72i withpen pencircle scaled 4bp;
  endfor;
endfig
