% Freely adapted from Escher's drawing 87
% From: Doris Schattschneider
%       M.C. Escher
%       Visions of Symmetry
%       W.H. Freeman and Company
%       New York
%       ISBN: 0-7167-2126-0
mpgraph:=1; input mp-tool; 
beginfig(0)
  pickup pencircle scaled 1;
  pair p[], xshift, yshift, origin, offset;
  path line[], bird, drawing;
  color GREEN, WHITE, C[];
  GREEN  = (0.8,0.9,0.8);
  WHITE  = (1,1,1);
  width  = 279.4mm;
  height = 215.9mm;
  s := 0.04;
  %
  p1  = (750,8000-4950);
  p2  = (1050,8000-4950);
  p3  = (2100,8000-4800);
  p4  = (2925,8000-4650);
  p5  = (4050,8000-5100);
  p6  = (4050,8000-5550);
  p7  = (3750,8000-6075);
  p8  = (3150,8000-6900);
  p9  = (3075,8000-7500);
  p10 = (3525,8000-7950);
  p11 = (4275,8000-8775);
  p12 = (5400,8000-9300);
  p13 = (4725,8000-8550);
  p14 = (4275,8000-7725);
  p15 = (4875,8000-8325);
  p16 = (5550,8000-8700);
  p17 = (5100,8000-7950);
  p18 = (4800,8000-7125);
  p19 = (5400,8000-7725);
  p20 = (6150,8000-8100);
  p21 = (5550,8000-7275);
  p22 = (5250,8000-6375);
  p23 = (5850,8000-7050);
  p24 = (6600,8000-7500);
  p25 = (6075,8000-6675);
  p26 = (5700,8000-5775);
  p27 = (6975,8000-7125);
  p28 = (8625,8000-7950);
  p29 = (7875,8000-7350);
  p30 = (7275,8000-6750);
  p31 = (8175,8000-7200);
  p32 = (9150,8000-7425);
  p33 = (8325,8000-6975);
  p34 = (7725,8000-6375);
  p35 = (8550,8000-6750);
  p36 = (9525,8000-6825);
  p37 = (8625,8000-6450);
  p38 = (8100,8000-6000);
  p39 = (9000,8000-6300);
  p40 = (9975,8000-6300);
  p41 = (9075,8000-6000);
  p42 = (8400,8000-5550);
  p43 = (9525,8000-5925);
  p44 = (10425,8000-5925);
  p45 = (9300,8000-5550);
  p46 = (8250,8000-5100);
  p47 = (7275,8000-4875);
  p48 = (6300,8000-4800);
  p49 = (7275,8000-4500);
  p50 = (8400,8000-4500);
  p51 = (7500,8000-4050);
  p52 = (6825,8000-3900);
  p53 = (7800,8000-3825);
  p54 = (8700,8000-3975);
  p55 = (7875,8000-3375);
  p56 = (7050,8000-3075);
  p57 = (8175,8000-3150);
  p58 = (8925,8000-3450);
  p59 = (8175,8000-2775);
  p60 = (7350,8000-2400);
  p61 = (8250,8000-2475);
  p62 = (9225,8000-3000);
  p63 = (8850,8000-2100);
  p64 = (8400,8000-1650);
  p65 = (9300,8000-1200);
  p66 = (8100,8000-1875);
  p67 = (7200,8000-1575);
  p68 = (5850,8000-1500);
  p69 = (5625,8000-2025);
  p70 = (5475,8000-2400);
  p71 = (5100,8000-3000);
  p72 = (4650,8000-3750);
  p73 = (3525,8000-3450);
  p74 = (2550,8000-3075);
  p75 = (2325,8000-3375);
  p76 = (2100,8000-3600);
  p77 = (1425,8000-4050);
  p78 = (975,8000-4350);
  p79 = (525,8000-4875);
  p80 = (1840,8000-4600);
  p81 = (2375,8000-4550);
  p82 = (2475,8000-3975);
  line1  = p79..p1..p2..p3..p4..p5;
  line2  = p9..p10..p11..p12--
    p12..p13..p14--
    p14..p15..p16--
    p16..p17..p18--
    p18..p19..p20--
    p20..p21..p22--
    p22..p23..p24--
    p24..p25..p26--
    p26..p27..p28--
    p28..p29..p30--
    p30..p31..p32--
    p32..p33..p34--
    p34..p35..p36--
    p36..p37..p38--
    p38..p39..p40--
    p40..p41..p42--
    p42..p43..p44--
    p44..p45..p46--
    p46..p47..p48--
    p48..p49..p50--
    p50..p51..p52--
    p52..p53..p54--
    p54..p55..p56--
    p56..p57..p58--
    p58..p59..p60--
    p60..p61..p62--
    p62..p66..p67..p68;
  % beak
  line3  = p62..p63..p64;
  line4  = p72..p73..p74;
  % beak
  line5  = p79..p80..p81;
  line6  = p5..p6..p7..p8..p9;
  line7  = p74..p75..p76..p77..p78..p78..p79;
  line8  = p68..p69..p70..p71..p72;
  xshift = s*(p28 + p62 - p9 - p74);
  yshift = s*(p62 - p9);
  bird = line1--line6--line2--line8--line4--line7--cycle;
  fill (0,0)--(width,0)--(width,height)--(0,height)--cycle withcolor WHITE;
  for x=-1 upto 1:
    for y=-1 upto 3:
      offset := x*xshift + y*yshift;
      fill bird scaled s shifted offset withcolor GREEN;
      pickup pencircle scaled 2pt;
      for i=1 upto 5:
        draw line[i] scaled s
          shifted offset;
      endfor;
      pickup pencircle scaled 2pt;
      fill (-60s,0)..(0,60s)..(60s,0)..cycle shifted (s*p65+offset);
      draw (-150s,0)..(0,150s)..(150s,0)..cycle shifted (s*p65+offset);
      fill (-60s,0)..(0,60s)..(60s,0)..cycle shifted (s*p82+offset);
      draw (-150s,0)..(0,150s)..(150s,0)..cycle shifted (s*p82+offset);
      pickup pencircle xscaled 6pt;
      for i=6 upto 8:
        draw line[i] scaled s shifted offset;
      endfor;
    endfor;
  endfor;
  % draw line1 scaled 0.05;
  pickup pencircle scaled 1;
  draw(0,0)--(width,0)--(width,height)--(0,height)--cycle withcolor WHITE;
  drawing = unitsquare xscaled width yscaled height;
  clip currentpicture to drawing;
  draw drawing;
endfig;
