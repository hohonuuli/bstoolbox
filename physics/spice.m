function Pi_ = spice(S,Theta,P)
% SPICE     - 'Spiciness', an oceanographic variable for characterization 
%              of intrusions and water masses
%
% Spiceness is orthogonal to isopycnals of potential density
%
% Use as: Pi = spice(S,Theta,P)
%
% Inputs: S     = Salinity (psu)
%         Theta = Potential temperature (C)
%         P     = Pressure (dbar)
%
% Output: Tau   = spiciness
%
% Requires: OCEANS toolbox

% Brian Schlining
% 07 Oct 1997
% Algorithmn from P. Flament, Subduction and finestructure associated
% with upwelling filaments. Ph. D. Dissertation. University of 
% California, San Diego. Vol 32. No.10. pp.1195 to 1207. 1985

%=====================================================================
% Table of Coefficients b(i,j) of polynomial expression for spiciness
%=====================================================================
a =  3.1171e-1 - 2.1029e-6*P - 2.7917e-9*(P.^2);
b = -1.0925e-2 + 7.5657e-7*P + 4.9133e-11*(P.^2);
c = -7.3732e-2 - 4.8778e-6*P + 1.0850e-9*(P.^2);

S0 = 35;

Pi_ = (density_(S0, 0, P)-1)*1000 - (density_((S0 - (1 + c).*(S - S0)), (Theta + (S - S0).*(a + b .* Theta)), P)-1)*1000 ;
   
