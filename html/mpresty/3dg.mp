beginfig(154)
  vardef project(expr x,y,z) =
    x*(-1,-1) + y*(1,0) + z*(0,1)
  enddef;
  vardef f(expr x,y) = sind(x/u*180)*sind(y/u*180)*u enddef;
  numeric m,M,inc,couleur;
  u:=1cm;
  m:=-2u; M:=2u; inc:=.1u;
  for i=m step inc until M:
    for j=m step inc until M:
      path p;
      p = project(i,j,f(i,j)) --
          project(i,j+inc,f(i,j+inc)) --
          project(i+inc,j+inc,f(i+inc,j+inc)) --
          project(i+inc,j,f(i+inc,j)) --
          cycle;
      dfdx := (f(i,j) - f(i+inc,j))/inc;
      dfdy := (f(i,j) - f(i,j+inc))/inc;
      couleur := 1/sqrt( dfdx**2 + dfdy**2 + 1);
      fill p withcolor couleur*(red+green);
    endfor
  endfor;
endfig;
