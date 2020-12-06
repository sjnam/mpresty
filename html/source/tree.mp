beginfig(1)
  u:=1cm; branchrotation := 60;
  offset := 180-branchrotation;
  thinning := 0.7;
  shortening := 0.8;
  def drawit(expr p, linethickness) =
    draw p withpen pencircle scaled linethickness;
  enddef;
  vardef tree(expr A,B,n,size) =
    save C,D,thickness; pair C,D;
    thickness := size;
    C := shortening[B, A rotatedaround(B,
        offset+uniformdeviate(branchrotation))];
    D := shortening[B, A rotatedaround(B,
        -offset-uniformdeviate(branchrotation))];
    if n>0:
      drawit(A--B, thickness);
      thickness := thinning*thickness;
      tree(B, C, n-1, thickness);
      tree(B, D, n-1, thickness);
    else:
      drawit(A--B,thickness);
      thickness := thinning*thickness;
      drawit(B--C, thickness);
      drawit(B--D, thickness);
    fi;
  enddef;
  tree((0,0), (0,u), 10, 2mm);
endfig
