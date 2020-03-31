function [yy1,yy2] = co2k1_(S,T,P) 
% CO2K1_ - First apparent dissociation constant for CO2 (S,T,P) 
% 
% UNESCO Tech Paper Mar Sci 42 (1983), (and PLOT52), Mehrbach (1983) 
% 
% Use As:   [K1,pK1] = co2k1_(S,T,P) 
% 
% Input:    S   = Salinity (psu)  
%           T   = Temperature (deg C) 
%           P   = Pressure (dbar) 
% Output:   K1  = First apparent dissociation constant for CO2 
%           pK1 = -log10(K1) 
% 
% Example:  [K1,pK1] = co2k1_(35,10,1000) -> K1 = 8.868e-007 pK1 = 6.052 
% 
% See Also: CO2K2_, CO2SOL_
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 24 Nov 87; M. Yuen 
% Matlabized added pK output 17 Jan 1996 W. Broenkow 
% lower case 20 Feb 1996 
 
  A   =    290.9097; 
  B   = -14554.21; 
  C   =    -45.0575; 
 
  A0  =  0.0221; 
  A1  = 34.02; 
  A2  =  0.0; 
  B0  =  0.0; 
 
  A00 = 25.50; 
  A10 =  0.151; 
  A20 = -0.1271; 
  A30 =  0.0; 
  B00 =  3.08; 
  B10 =  0.578; 
  B20 = -0.0877; 
 
  if nargin == 2 
    P = zeros(size(S)); 
  end 
 
  R     =   82.057;                 % Gas constant 
  S1    =   34.8; 
  TEMP1 =  273.16;                  % corrected 18 Dec 91 E. Armstrong 
  PRESS = P./10.13;                 % Pressure in atm. 
  TEMP  = T + TEMP1;                % Scaled Kelvin 
  KT    = A + B./TEMP + C.*log(TEMP);    % ln(K[T]) 
  KTS   = (A0 + A1./TEMP + A2.*log(TEMP)).*sqrt(S) + B0.*S;  % ln(K[TS] - ln(K[T]); 
  DEL_V = A00 + A10.*(S - S1) + (A20 + A30.*T).*T;           % -del V 
  DEL_K = B00 + B10.*(S - S1) + B20.*TEMP;                   % -10^3 del K 
  KPTS  = ((DEL_V - (0.5).*DEL_K.*PRESS./(1000)).*PRESS)./(TEMP*R);% ln(K[PTS]/K[0TS]) 
 
  yy1 = exp(KT + KTS + KPTS); 
  yy2 = -log(yy1)/log(10);  
