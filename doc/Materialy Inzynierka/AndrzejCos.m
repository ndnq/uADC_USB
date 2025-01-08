syms t dot dnt w

eq = sin(w*(dnt-dot)) == 0
solve(eq,dnt)

%%same for dot+-2
%w*dot == pi
%dot == pi/w