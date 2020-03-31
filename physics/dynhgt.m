function D = dynhgt(S,T,P)
% DYNHGT    - Calculate dynamic height 
%
% Use As: D = dynhgt(S,T,P)
%
% Inputs: S = Salinity (psu)
%         T = Temperature (C)
%         P = Pressure (dbar)
%
% Output: D = Dynamic Height
%
% Requires: DENSITY from oceans toolbox

% B. Schlining
% 16 Jul 1997

alpha = 1./density(S,T,P);
D     = trapz(P,alpha);