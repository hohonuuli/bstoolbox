function A = alongshore(U,V)
% ALONGSHORE - Convert U and V components to alongshore central CA
%
% Use As: a = alongshore(u,v)
% Inputs: U = North-south component
%         V = East-west component
% Output: a = alongshore (330-150 degrees) component

% Brian Schlining
% 23 Feb 1999

Theta = atan2(V,U);
Rho   = sqrt(U.^2 + V.^2);
Phi   = Theta - 125*pi/180;
A     = Rho.*cos(Phi);