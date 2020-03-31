function A = getvcomp(U,V,OffsetAngle)
% GETVCOMP  - Get a vector component for any direction
%
% GETVCOMP is useful for getting crosshore and longshore components from U and 
% V directional components.
%
% Use As: a = getvcomp(U,V,OffsetAngle)
% Inputs: U = Component along the x-direction (east-west)
%         V = Component along the y-direction (North-South)
%         OffsetAngle = Degree from north of the new component axis
%         (Example: 
% convert adcp angle to true North
% Not wokring yet
Theta = atan2(V,U);
Rho   = sqrt(U.^2 + V.^2);
Phi   = Theta - OffsetAngle*pi/180;

A     = Rho.*cos(Phi);