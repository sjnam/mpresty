u:=25;                        % 25 = 25bp = 25 PostScript points = 30/72 in
wi:=10;                       % width  in units u   
he:=9;                        % height in units u
hoehe:=he*u;                  % height
breite:=wi*u;                 % width
transform t, Txy;
pair P[];
path p[];
color wuerfel[], versch;      % 3D vectors: MetaPost type ``color''

rotX:=45;                     % angle of rotation around the x axis                        
rotY:=45;                     % angle of rotation around the y axis             
rotZ:=45;                     % angle of rotation around the z axis            
versch:=(1.6, 1, 2.7);        % translation (in mathematical units)

P0=(3.2, 2.2)*u;              % origin in MetaPost coordinates (bp)
P1=(-.6, -.4)/1.5;            % x axis in mathematical coordinates

t:=identity                                            %   t: maps mathematical 2D coordinates 
     scaled u                                          %      onto MetaPost coordinates (bp)
       shifted P0;

Txy:=identity                                          % Txy: maps 3D coordinates x,y onto 
       reflectedabout((0,0), (1,1))                    %      MetaPost coordinates     
         yscaled ypart P1               
	   slanted (xpart P1/ypart P1)
	     transformed t;   
	   
vardef dreheX(expr SpaceVector, winkel) =              % rotation of 3D vector 
  pair yz;                                             % ``SpaceVector'' around
  yz:=(greenpart SpaceVector, bluepart SpaceVector);   % the x axis by the
  yz:=yz rotated winkel;                               % angle ``winkel''
  (redpart SpaceVector, xpart yz, ypart yz)
enddef;

vardef dreheY(expr SpaceVector, winkel) =              % rotation around the y axis
  pair zx;
  zx:=(bluepart SpaceVector, redpart SpaceVector);
  zx:=zx rotated winkel;
  (ypart zx, greenpart SpaceVector, xpart zx)
enddef;

vardef dreheZ(expr SpaceVector, winkel) =              % rotation around the z axis
  pair xy;
  xy:=(redpart SpaceVector, greenpart SpaceVector);
  xy:=xy rotated winkel;
  (xpart xy, ypart xy, bluepart SpaceVector)
enddef;

vardef getPixel(expr SpaceVector) =                    % returns MetaPost coordinates (bp)
  % SpaceVector: type ``color''                        % of spatial projection of
  (redpart SpaceVector, greenpart SpaceVector)         % 3D point 
    transformed Txy                                    % with coordinates ``SpaceVector''
      shifted (0, u*bluepart SpaceVector)  
enddef;

vardef Zyklus(text t) =                 % returns cyclic path formed of the 
  forsuffixes $=t: z$-- endfor          % z points with suffixes in argument t
  cycle
enddef;	                

%
%  The following construction copies the possibilities one has in Java with 
%
%  main(String[] args) {
%  k = args.length;
%
vardef Pfad(text t) =                   % returns path formed of the 
  k:=0;                                 % z points with suffixes in argument t
  forsuffixes $=t: k:=k+1; endfor       % count number of arguments first  					
  i:=1;					
  forsuffixes $=t:                      % problem: the last z must not be followed by --
    if i<k: z$-- else: z$ fi  
    hide(i:=i+1)                        % hide: to prevent ``i:=i+1'' to be written into the path 
  endfor                                % no ; after ``)'' (would be written into path)
enddef;	                

def lot(expr n) =                       % draws perpendicular line from point wuerfel[n]                    
  color SpaceVector;                    % to (x,y) plane 
  SpaceVector:=wuerfel[n];
  draw getPixel(SpaceVector)--getPixel((redpart SpaceVector,greenpart SpaceVector, 0));  
  draw_point(getPixel(SpaceVector), white, black);    
  draw_point( getPixel((redpart SpaceVector,greenpart SpaceVector, 0)), white, black);  
enddef;
	  
def draw_point(expr P, colInt, colPer) =
  fill fullcircle scaled 1mm shifted P withcolor colInt;
  draw fullcircle scaled 1mm shifted P withcolor colPer;
enddef;	  
	   
def Lote(text t) =                      % invokes lot(n) for all the suffixes in 
  forsuffixes $=t:                      % argument t
    lot($);
  endfor    
enddef;
  
wuerfel0:=(2.8, 0, 0);                       % definition of cube ``wuerfel''
wuerfel1:=(2.8, 2.8, 0);                     % (array of type color)
wuerfel2:=(0, 2.8, 0);                       % in mathematical 3D coordinates
wuerfel3:=(0, 0, 0);
wuerfel4:=(2.8, 0, 2.8);
wuerfel5:=(2.8, 2.8, 2.8);
wuerfel6:=(0, 2.8, 2.8);
wuerfel7:=(0, 0, 2.8);


beginfig(1)    
  for i=0 upto 7:                            %  z0,...,z7: MetaPost coordinates of 
    z[i]=getPixel(wuerfel[i]);               %  cube in original position
  endfor

  for i=0 upto 7:                            % rotation and translation
    wuerfel[i]:=dreheX(wuerfel[i], rotX);    % of cube
    wuerfel[i]:=dreheY(wuerfel[i], rotY);
    wuerfel[i]:=dreheZ(wuerfel[i], rotZ);
    wuerfel[i]:=wuerfel[i]+versch;
  endfor
    
  for i=0 upto 7:                            %  z100,...,z107: MetaPost coordinates of 
    z[i+100]=getPixel(wuerfel[i]);           %  cube after rotation           
  endfor
  
  % --- Grid ---
    for i=0 upto 5:    
      draw getPixel((i,0,0))--getPixel((i,5,0)) withcolor .7white;     
      draw getPixel((0,i,0))--getPixel((5,i,0)) withcolor .7white;    
      draw getPixel((0,i,0))--getPixel((0,i,5)) withcolor .7white;
      draw getPixel((0,0,i))--getPixel((0,5,i)) withcolor .7white;    
      draw getPixel((0,0,i))--getPixel((5,0,i)) withcolor .7white;
      draw getPixel((i,0,0))--getPixel((i,0,5)) withcolor .7white;
     endfor
  % --- End Grid ---
  
  % --- Frame ---
  draw (0, 0)--(breite, 0)--(breite, hoehe)--(0, hoehe)--cycle;
  
  % --- Axes ---
  drawarrow getPixel((0, 0, 0))--getPixel((6, 0, 0)); 
  label.llft(btex $x$ etex, getPixel((6, 0, 0))+(0, 1mm));  
  drawarrow getPixel((0, 0, 0))--getPixel((0, 6, 0)); 
  label.rt  (btex $y$ etex, getPixel((0, 6, 0)));  
  drawarrow getPixel((0, 0, 0))--getPixel((0, 0, 6)); 
  label.top (btex $z$ etex, getPixel((0, 0, 6)));  
  
  % --- Cube in original position ---
  fill Zyklus(0, 1, 5, 4) withcolor .7green;
  fill Zyklus(4, 5, 6, 7) withcolor .9green;
  fill Zyklus(1, 2, 6, 5) withcolor .5green;  
  draw Pfad(0, 3, 2)      dashed evenly;
  draw Pfad(3, 7)         dashed evenly;  
  draw Zyklus(1, 2, 6, 7, 4, 0) ;
  draw Pfad(4, 5, 1, 5, 6);
  
  % --- Cube after rotation ---
  fill Zyklus(104, 105, 106, 107) withcolor .9red;
  fill Zyklus(101, 102, 106, 105) withcolor .7red;
  fill Zyklus(100, 101, 105, 104) withcolor .5red;    
  draw Pfad(100, 103, 102) dashed evenly;  
  draw Pfad(103, 107)      dashed evenly;
  draw Pfad(104, 105, 101, 105, 106);      
  draw Zyklus(101, 102, 106, 107, 104, 100);  
  Lote(0, 1, 4, 5, 7);                       % suffixes of ``wuerfel''   
endfig;
