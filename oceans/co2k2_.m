function [yy1, yy2] = co2k2_(S,T,P) 
% CO2K2_ - Second apparent dissociation constant for CO2 (S,T,P)
% 
% UNESCO Tech Paper Mar Sci 42 (1983), (and PLOT52), Mehrbach (1983) 
%  
% Use As:   [K2,pK2] = co2k2_(S,T,P) 
%       
% Input:    S   = Salinity  (psu) 
%           T   = Temperature (deg C) 
%           P   = Pressure (dbar) 
% Output:   K2  = Second apparent dissociation constant for CO2 
%           pK2 = -log10(K2) 
% 
% Example:  [K2,pK2] = co2k2_(35,10,1000) 
%              -> K2 = 5.314e-010
%                pK2 = 9.274 
% 
% See Also: CO2K1_, CO2SOL_ 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 24 Nov 87; M. Yuen 
% Matlabized added pK2 17 Jan 1996; W. Broenkow 
% lower case 20 Feb 1996 
 
    A =    207.6548; 
    B = -11843.79; 
    C =    -33.6485; 
   A0 =      0.9805; 
   A1 =    -92.65; 
   A2 =      0.0; 
   B0 =     -0.03294; 
  A00 =     15.82; 
  A10 =     -0.321; 
  A20 =      0.0219; 
  A30 =      0.0; 
  B00 =     -1.13; 
  B10 =      0.314; 
  B20 =      0.1475; 
 
  if nargin == 2 
    P = zeros(size(S)); 
  end 
 
    R =     82.057;       % Gas constant 
   S1 =     34.8; 
TEMP1 =    273.16;        % corrected 18 Dec 91 
 
PRESS =  P/10.13;         % Pressure in atm. 
 TEMP =  T + TEMP1;       % Scaled Kelvin 
   KT =  A + B./TEMP + C.*log(TEMP);                       % ln(K[T]) 
 
 KTS  = (A0 + A1./TEMP + A2.*log(TEMP)).*sqrt(S) + B0.*S;  % ln(K[TS] - ln(K[T]) 
DEL_V = A00 + A10.*(S - S1) + (A20 + A30.*TEMP).*TEMP;     % -del V 
DEL_K = B00 + B10.*(S - S1) + B20.*TEMP;                   % -10^3 del K 
 KPTS = ((DEL_V - 0.5.*DEL_K.*PRESS./1000).*PRESS)./(TEMP.*R); % ln(K[PTS]/K[0TS]) 
 
yy1 = exp(KT + KTS + KPTS);   %  K2 
yy2 = -log(yy1)/log(10);      % pK2 
 
