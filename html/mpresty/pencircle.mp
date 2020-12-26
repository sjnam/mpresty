beginfig(1);
  pickup pencircle xscaled 2bp yscaled 0.25bp rotated 60;
  for i=10 downto 1:
    draw 5(i,0)..5(0,i)..5(-i,0)..5(0,-i+1)..5(i-1,0);
  endfor; 
endfig
