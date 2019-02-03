verbatimtex
%&latex
\documentclass{article}
\everymath{\displaystyle}
\begin{document}
etex
input courbes;
vardef fx(expr t) = t enddef;
vardef fy(expr t) = (t-5)*sin(t)-cos(t)+2 enddef;
beginfig(1);
numeric a,b,n,h;
a = 1; b = 7; n = 6; h = (b-a)/n;
color aubergine; aubergine = (37/256,2/256,29/256);
repere(10cm,10cm,2cm,3cm,1cm,1cm);
fill ((a,0)--ftrace(a,b,200)--(b,0)--cycle) en_place withcolor 0.7red;
for i=1 upto n:
path cc;
aa := a + (i-1) * h;
bb := aa + h;
ff := fy(aa + h/2);
cc := rpoint(aa,0)--rpoint(aa,ff)--rpoint(bb,ff)--rpoint(bb,0);
fill cc--cycle withcolor 0.8white;
draw cc;
endfor;
trace.axes(0.5pt);
trace.courbe(a,b,200,2pt,aubergine);
decoupe.repere;
etiquette.axes;
label.bot(btex $x_{i-1}$ etex, rpoint(a+n/2*h,0));
label.bot(btex $x_{0}$ etex, rpoint(a,0));
label.bot(btex $x_{n}$ etex, rpoint(b,0));
label.ulft(btex $\mathbf{a}$ etex, rpoint(a,0));
label.urt(btex $\mathbf{b}$ etex, rpoint(b,0));
label.top(btex $\mathbf{y=f(x)}$ etex, f(b) en_place);
label.bot(btex $x_{i}$ etex, rpoint(a+n/2*h+h,0));
projection.axes(f(a+(n+1)/2*h),0.5pt,2);
label.lft(btex $f(\xi_i)$ etex, rpoint(0,fy(a+(n+1)/2*h)));
label.bot(btex $\xi_i$ etex,rpoint(a+(n+1)/2*h,-0.4));
drawarrow rpoint(a+(n+1)/2*h,-0.4)--rpoint(a+(n+1)/2*h,-0.1);
label(btex \textit{Riemann Sum} etex scaled 2,rpoint(4,5));
label(btex $S = \sum_{i=1}^n f(\xi_i)(x_i - x_{i-1})$ etex
scaled 1.5,rpoint(5,-2));
endfig;
