u:=40mm/68;
breite:=150u;
hoehe:=110u;

path p;

beginfig(1) 
  z0=(.5breite, .3hoehe);               

  z1=(7,28)*u;
  z2=(51,98)*u;
  z3=(55,100)*u;
  z4=(54,93)*u;
  z5=(22,24)*u;
  z6=(25,12)*u;
  z7=(36,18)*u;
  z8=(89,94)*u;
  z9=(87,95)*u;
  z10=(49,20)*u;  
  z11=(59,11)*u;
  z12=(87,23)*u;
  
  p:=z1{2,5}..
     z2{10,9}..
     z3{right}..tension 1.3..
     z4{-4,-9}..tension 1.1..
     z5{-17,-62}..
     z6{right}..
     z7..tension 1.8..
     z8{27,58}..
     z9{-55,-52}..tension 2..
     z10{down}..
     z11{right}..
     z12{50,31};         
  
  draw (0,0)--(breite,0)--(breite,hoehe)--(0,hoehe)--cycle;
    
  draw p;                                    % original curve   
  for i=1 upto 12:                           % labels 1 to 12
    if (i=2) or (i=3) or (i=9) or (i=12):
      label.top(decimal(i), z[i]);
    elseif (i=4) or (i=8):
      label.rt(decimal(i), z[i]);
    elseif (i=6) or (i=11):      
      label.bot(decimal(i), z[i]);
    elseif (i=7):      
      label.ulft(decimal(i), z[i]);
    else:      
      label.lft(decimal(i), z[i]);
    fi
  endfor
  
  pickup pencircle scaled 4;                 % dot labels
  for i=1 upto 12:
    draw z[i];
  endfor
  
                                             % transform original curve  
  pickup pencircle scaled .5;                
  draw p rotated   0 shifted (.5breite, 0) scaled 1/16 shifted z0;
  pickup pencircle scaled 1;
  draw p rotated  10 shifted (.5breite, 0) scaled 1/8 shifted z0;
  pickup pencircle scaled 1.5;
  draw p rotated  20 shifted (.5breite, 0) scaled 1/4 shifted z0;
  pickup pencircle scaled 2;
  draw p rotated  30 shifted (.5breite, 0) scaled 1/2 shifted z0;
  
endfig;
