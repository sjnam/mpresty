beginfig(208)
  vardef pave(expr t, A, B, C, n) =
    save D, E, d;
    pair D,E;
    numeric d[];
    d[0] := 1;
    d[1] := sqrt( 2*(1+cosd(72)) );
    d[2] := sqrt( 2*(1-cosd(36)) );
    if n>0:
      if t=1:
        D := (d0/(d0+d2)) [A,C];
        pave(1,B,C,D,n-1);
        pave(4,B,D,A,n-1);
      elseif t=2:
        D := (d0/(d0+d2)) [A,B];
        pave(2,C,D,B,n-1);
        pave(3,C,A,D,n-1);
      elseif t=3:
        D := (d1/(d0+d1)) [A,B];
        E := (d0/(d0+d2)) [A,C];
        pave(1,D,C,E,n-1);
        pave(3,B,C,D,n-1);
        pave(4,D,E,A,n-1);
      elseif t=4:
        D := (d1/(d0+d1)) [A,C];
        E := (d0/(d0+d2)) [A,B];
        pave(2,D,E,B,n-1);
        pave(3,D,A,E,n-1);
        pave(4,C,D,B,n-1);
      fi;
    else:
      draw A--B--C--cycle;
      if t=1:
        fill A--B--C--cycle withcolor green + blue;
        draw A--C withpen pencircle scaled 1bp;
        draw A--B withpen pencircle scaled 1bp;
      elseif t=2:
        fill A--B--C--cycle withcolor green + blue;
        draw A--B withpen pencircle scaled 1bp;
        draw A--B withpen pencircle scaled 1bp;
      elseif t=3:
        fill A--B--C--cycle withcolor green + red;
        draw A--C withpen pencircle scaled 1bp;
        draw C--B withpen pencircle scaled 1bp;
      elseif t=4:
        fill A--B--C--cycle withcolor green + red;
        draw B--C withpen pencircle scaled 1bp;
        draw A--B withpen pencircle scaled 1bp;
      fi;
    fi;
  enddef;
  numeric M;
  M := 6;
  pair A,B,C,D;
  u := 3cm;
  A := (0,0);
  B := (u,0);
  D := B rotated 72;
  C := (u,0) + D;
  pave(3,A,C,D,M);
  pave(4,A,B,C,M);
endfig;
