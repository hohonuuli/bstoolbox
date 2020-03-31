function Lw = calc_lw(Lu,K,Z)
% CALC_LW    - Calculate water leaving radiance
%
% Use as: Lw = calc_lw(Lu, K, Z)
% 
% Inputs: Lu = Upwelled radiance at depth Z
%         K  = Diffuse attenuation coefficeint (1/m)
%         Z  = Depth of Ed sensor (m) (Value may be + or -, It's assumed that its below the water)
%      
% Output: Lw = Water Leaving Radiance (in same units as Lu)

% Brian Schlining
% 09 Dec 1999
% Edited to reflect new Simbios protocols Rev3-Vol2 equation 13.16
%.543 changed to .529

Lw = 0.529*Lu./exp(K.*(-abs(Z)));


