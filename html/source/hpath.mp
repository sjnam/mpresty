beginfig(139)
  pair P[], Q[], R[], S[];
  u:=.5cm;
  for i=0 upto 4:
    P[i] = u* down rotated (i*360/5);
  endfor;
  P[5] = P[0];
  for i=0 upto 4:
    Q[i] = 3*( 1/2[ P[i], P[i+1] ] );
  endfor;
  Q[5] = Q[0];
  for i=0 upto 4:
    R[i] = 1/3( Q[i] + Q[i+1] + P[i+1] );
  endfor;
  R[5] = R[0];
  for i=0 upto 5:
    S[i] = 1.5*Q[i];
  endfor;
  for i=0 upto 4:
    draw P[i]   -- P[i+1];
    draw P[i+1] -- R[i];
    draw Q[i]   -- R[i];
    draw R[i]   -- Q[i+1];
    draw Q[i]   -- S[i];
    draw S[i]   -- S[i+1];
  endfor;
  draw P[2] -- P[3] -- P[4] -- P[0] -- P[1] --
       R[0] -- Q[0] -- R[4] -- Q[4] -- R[3]
            -- Q[3] -- R[2] -- Q[2] --
       S[2] -- S[3] -- S[4] -- S[0] -- S[1] --
       Q[1] -- R[1] -- cycle
       withpen pencircle scaled 2bp;
endfig;
