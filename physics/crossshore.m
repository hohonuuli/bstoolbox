function A = crossshore(U,V)
% CROSSSHORE - Convert U and V components to alongshore central CA
%
% Use As: x = crossshore(u,v)
% Inputs: U = North-south component
%         V = East-west component
% Output: x = crossshore (240-60 degrees) component

% Brian Schlining
% 23 Feb 1999

Theta = atan2(V,U);
Rho   = sqrt(U.^2 + V.^2);
Phi   = Theta - 125*pi/180;
A     = Rho.*sin(Phi);