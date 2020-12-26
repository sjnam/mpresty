beginfig(150)
  for i=0 step 1 until 360:
    pair P;
    P = 2cm* (sind(2*i), cosd(3*i));
    fill fullcircle scaled 4mm shifted P withcolor white;
    draw fullcircle scaled 4mm shifted P;
  endfor;
endfig;
