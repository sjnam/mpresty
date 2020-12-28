beginfig(1)
  u := 1/2cm;
  defaultscale := 10pt/fontsize(defaultfont);
  path sqr; sqr := unitsquare scaled u;
  for i=0 upto 10:
    label.bot(decimal(i/10), ((i+1/2)*u,0));
    label.lft(decimal(i/10), (0,(i+1/2)*u));
    for j=0 upto 10:
      fill sqr shifted (i*u,j*u) withcolor (i*0.1, j*0.1,0);
      draw sqr shifted (i*u,j*u); % draw grid
    endfor;
  endfor;
  label.bot("r",(6u,-2/3u));
  label.lft("g",(-u,6u));
  label.top("RGB(r,g,0)", (6u,11u));
endfig
