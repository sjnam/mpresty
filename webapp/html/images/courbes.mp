%% =====================================================================
%% COURBES.MP
%% Courbes 1 (8 octobre 2001)
%% Macros pour présenter des courbes
%% Jean-Michel Sarlat -- Mai 1997
%% =====================================================================


%% =====================================================================
%% Repère et coordonnées
%% =====================================================================
pair origine;

vardef repere(expr lx,ly,ox,oy,ux,uy) =
        % affectations
        _ox := ox ; _oy := oy ;
        _ux := ux ; _uy := uy ;
        _lx := lx ; _ly := ly ;
        origine := (_ox,_oy);
        unitex := ux;
        unitey := uy;
        unite := ux;
        r_xmin := -ox/ux;
        r_xmax := (lx-ox)/ux;
        r_ymin := -oy/uy;
        r_ymax := (ly-oy)/uy;
        _largeur_marques := 1mm;
enddef;

% Procédure de mise en place dans le repère
def en_place =
    xscaled unitex yscaled unitey shifted origine
enddef;

% Définir un point
vardef rpoint(expr x,y) =
        (x,y) en_place
enddef;

%% =====================================================================
%% Construction dans le repère
%% =====================================================================
% Axes
vardef trace.axes(expr t) =
        drawarrow (0,_oy)--(_lx,_oy) withpen pencircle scaled t;
        drawarrow (_ox,0)--(_ox,_ly) withpen pencircle scaled t;
enddef;


% Marque des unités
vardef marque.unites(expr l) =
        draw (_ox+_ux,_oy-l)--(_ox+_ux,_oy+l);
        draw (_ox-l,_oy+_uy)--(_ox+l,_oy+_uy);
        _largeur_marques := l;
enddef;

% Labels des unités
vardef etiquette.unites =
        label.bot(btex $+1$ etex,(_ox+_ux,_oy-_largeur_marques));
        label.lft(btex $+1$ etex,(_ox-_largeur_marques,_oy+_uy));
enddef;
% Grille
vardef trace.lignes.horizontales(expr d,taille,couleur) =
       numeric ni,nf;
       ni := floor(r_ymin/d);
       nf := floor(r_ymax/d);
       for i=ni upto nf:
          draw ((r_xmin,i*d)--(r_xmax,i*d)) en_place
            withpen pencircle scaled taille
            withcolor couleur;
       endfor; 
enddef;
vardef trace.lignes.verticales(expr d,taille,couleur) =
       numeric ni,nf;
       ni := floor(r_xmin/d);
       nf := floor(r_xmax/d);
       for i=ni upto nf:
          draw ((i*d,r_ymin)--(i*d,r_ymax)) en_place
            withpen pencircle scaled taille
            withcolor couleur;
       endfor; 
enddef;
vardef trace.grille(expr d,taille,couleur) =
       trace.lignes.horizontales(d,taille,couleur);
       trace.lignes.verticales(d,taille,couleur);
enddef;

% Projeter un point sur les axes
vardef projection.axes(expr a,taille,ecart) =
       draw ((0,ypart a)--a--(xpart a,0)) en_place
             dashed evenly scaled ecart
             withpen pencircle scaled taille
enddef;

% Tracé d'une droite parallèle à l'axe des y
vardef parallele.axe.y(expr x) =
       draw (_ox+x*_ux,0)--(_ox+x*_ux,_ly)
enddef;

% Tracé d'une droite parallèle à l'axe des x
vardef parallele.axe.x(expr y) =
       draw (0,_oy+y*_uy)--(_lx,_oy+y*_uy)
enddef;

% On coupe tout ce qui dépasse les limites du repère
vardef decoupe.repere =
        clip currentpicture to (0,0)--(0,_ly)--(_lx,_ly)--(_lx,0)--cycle;
enddef;

vardef etiquette.axes =       
        label.bot (btex $x$ etex,(_lx,_oy));
        label.lft(btex $y$ etex,(_ox,_ly));
enddef;

%% =====================================================================
%% Partie numérque
%% =====================================================================

numeric Pi;
numeric E;

Pi := 3.14159;
E  := 2.72828;

vardef sin(expr x) =
        sind(x/Pi*180)
enddef;

vardef cos(expr x) =
        cosd(x/Pi*180)
enddef;

vardef tan(expr x) =
        sin(x)/cos(x)
enddef;

vardef exp(expr x) =
        E**x
enddef;

vardef ch(expr x) =
        (E**x + E**(-x))/2
enddef;

vardef sh(expr x) =
        (E**x - E**(-x))/2
enddef;

vardef th(expr x) =
        (E**(2*x) - 1)/(E**(2*x) + 1)
enddef;

%% =====================================================================
%% Partie fonctions
%% Fonctions prédéfinies t -> fx(t) et y -> fy(t)
%% =====================================================================
numeric pas_derivation;

pas_derivation := 0.01;

vardef f(expr t) =
           (fx(t),fy(t))
enddef;
vardef dfx(expr t) =
       (fx(t+pas_derivation)-fx(t-pas_derivation))/2/pas_derivation
enddef;
vardef dfy(expr t) =
       (fy(t+pas_derivation)-fy(t-pas_derivation))/2/pas_derivation
enddef;
vardef vd(expr t) =
      unitvector((dfx(t),dfy(t)))
enddef;
vardef ftrace(expr ti,tf,n) =
    numeric fpas;
    fpas := (tf-ti)/n;
    f(ti)
    for i = 1 upto n:
        ..f(ti+i*fpas)
    endfor
enddef;
vardef trace.courbe(expr ti,tf,n,taille,couleur) =
    draw ftrace(ti,tf,n) en_place
         withpen pencircle scaled taille
         withcolor couleur;
enddef;
%% =====================================================================
%% Partie équations différentielles
%% Fonction prédéfinie (x,y) -> F(x,y)  <numeric>
%% =====================================================================
vardef champ.vecteurs(expr x,y,pas,dx,couleur) =
  npasxg := floor((x-r_xmin)/pas);
  npasxd := floor((r_xmax-x)/pas);
  npasyb := floor((y-r_ymin)/pas);
  npasyh := floor((r_ymax-y)/pas);
  facteur:= unite*dx;
  for i = 0 upto npasxg:
     for j = 0 upto npasyb:
       drawarrow ((0,0)--unitvector((1,F(x-i*pas,y-j*pas)))) 
                 scaled facteur
                 shifted rpoint(x-i*pas,y-j*pas)
                 withcolor couleur;
     endfor
     for j = 0 upto npasyh:
       drawarrow ((0,0)--unitvector((1,F(x-i*pas,y+j*pas))))
                 scaled facteur
                 shifted rpoint(x-i*pas,y+j*pas)
                 withcolor couleur;
     endfor
  endfor
  for i = 0 upto npasxd:
     for j = 0 upto npasyb:
       drawarrow ((0,0)--unitvector((1,F(x+i*pas,y-j*pas)))) 
                 scaled facteur
                 shifted rpoint(x+i*pas,y-j*pas)
                 withcolor couleur;
     endfor
     for j = 0 upto npasyh:
       drawarrow ((0,0)--unitvector((1,F(x+i*pas,y+j*pas)))) 
                 scaled facteur
                 shifted rpoint(x+i*pas,y+j*pas)
                 withcolor couleur;
     endfor
  endfor
enddef;

%% =====================================================================
endinput
%% =====================================================================
