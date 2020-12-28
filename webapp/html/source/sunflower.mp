beginfig(1)
phisq = (0.5*(1+sqrt(5)))**2;
for n = 1 upto 1000:
  r := 3*sqrt(n);
  theta := 360*((n/phisq) mod 1);
  filldraw fullcircle scaled 3bp shifted (r*cosd(theta),r*sind(theta));
endfor;
endfig
