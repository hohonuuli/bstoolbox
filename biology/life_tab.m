function [lx,dx,qx,ex] = life_tab(nx);
% LIFE_TAB  - Life History Tables based on formula from pg 175-6
%
% USE AS:  [lx,dx,qx,ex] = life_tab(nx);
%
% INPUTS:  nx = Observed number of organisms alive at each sampiling interval
%
% OUTPUTS: lx = Proportion surviving at the start of each age interval
%          dx = Number dying within each age interval
%          qx = Rate of Mortality
%          ex = Mean expectation of further life for animals at start of age
%
%          life_tab also outputs a life table directly to the screen
%
% EXAMPLE: life_tab([142,62,34,20,15.5,11,6.5,2,2,0]);
%  => This example is straight out of the text, be aware that non-integer input 
%     (i.e. 15.5) for nx will result in incorrect table formatting
 
% Brian Schlining
% 27 Jan 97

m     = length(nx);	% Find the length of the input vector
lx    = nx./nx(1);
dx    = -diff(nx);
dx(m) = NaN;		% Tack on the NaN to the end of dx so all vectors are equal length
qx    = dx./nx;


Lx    = (nx(1:m-1)+nx(2:m))/2;
Tx    = rot90(rot90(cumsum(rot90(rot90(Lx)))));
Tx(m) = NaN;		% Again, tack on the NaN
ex    = Tx./nx;


% Format printed output
fprintf(1,'\nnx = Observed number alive at each sample time\n')
fprintf(1,'lx = Proportion surviving at the start of each age interval\n')
fprintf(1,'dx = Number dying within each age interval\n')
fprintf(1,'qx = Rate of Mortality\n')
fprintf(1,'ex = Mean expectation of further life for animals at start of age\n\n')
fprintf(1,'........nx........lx..........dx........qx.........ex........\n')
for i = 1:m
   fprintf('%10i %9.3f\n',nx(i),lx(i))
   fprintf('                     ---->%6.1f %9.3f %10.2f\n',dx(i),qx(i),ex(i))
end