beginfig(5) ;
z0 = (0,0) ; z1 = (5cm,0) ; z2 = (5cm,5cm) ; z3 = (0,5cm) ;
transform T ;
z0 transformed T = 1/4[z0,z1] ;
z1 transformed T = 1/4[z1,z2] ;
z2 transformed T = 1/4[z2,z3] ;
path carre ;
carre = z0--z1--z2--z3--cycle ;
fill carre withcolor 0.8white ;
fill carre transformed T withcolor white ;
draw carre ; draw carre transformed T ;
picture dessin ;
dessin = currentpicture ;
for i = 1 upto 8:
dessin := dessin transformed T transformed T ;
draw dessin ;
endfor
endfig;
