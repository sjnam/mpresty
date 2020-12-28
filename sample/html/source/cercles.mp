beginfig(1)
def iteration(expr a,b,ra,rb,n) =
if n = 0 :
else :
begingroup
save t,m,r ;
numeric t,r ;
pair m ;
t := sqrt(ra) + sqrt(rb) ;
r := ra * rb / (t * t) ;
m := (sqrt(ra)/t)[a,b] ;
draw fullcircle scaled (r * 2u) shifted (m + (0,r*u)) ;
iteration(a,m,ra,r,n-1) ;
iteration(m,b,r,rb,n-1) ;
endgroup
fi
enddef ;
u = 10cm ;
z0 = (0,0) ; z1 = (u,0) ;
drawarrow (0,0)--(0,6cm) ; label.rt("y",(0,6cm)) ;
drawarrow (0,0)--(11cm,0) ; label.bot("x",(11cm,0)) ;
dotlabel.bot("1",z1) ; dotlabel.lrt("0",z0) ;
draw fullcircle scaled u shifted (0,u/2) ;
draw fullcircle scaled u shifted (u,u/2) ;
pickup pencircle scaled 0.1bp ;
iteration(z0,z1,1/2,1/2,6) ;
clip currentpicture to (-1cm,-1cm)--(12cm,-1cm)--(12cm,7cm)--(-1cm,7cm)--cycle ;
endfig;
