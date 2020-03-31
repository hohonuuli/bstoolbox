function [yy1,yy2] = bo4k1_(S,T,P) 
% BO4K1_ - First apparent dissociation constant for boric acid 
% 
% UNESCO Tech Paper Mar Sci 42 (1983) and Lyman (1957). 
% 
% Use As:  [K1,pK1] = bo4k1_(S,T,P) 
% 
% Input:   S   = Salinity (psu) 
%          T   = Temperature (deg C) 
%          P   = Pressure (dbar) 
%                {optional if not entered, 0 is assumed} 
% Output:  K1  = First apparent dissociation constant for Boric Acid 
%          pK1 = -log10(K1) 
% 
% Example: [K1,pK1] = bo4k1_(25*1.80655,10,0) -> K1 = 1.835e-009 pK1 = 8.736 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 18 Dec 91; E. Armstrong 
% K. Johnson says to use Lyman, because he used phosphate buffers 
% whereas Hansson used borate buffers 
% Matlabized 17 Jan 1996; W. Broenkow 
% lower case 20 Feb 1996 
 
 A   =    148.0248; 
 B   =  -8966.90; 
 C   =    -24.4344; 
 
 A0  =  0.0473;     % Based on Lyman (1957) 
 A1  = 49.10; 
 A2  =  0.0; 
 B0  =  0.0; 
 
A00 = 29.48; 
A10 = -0.295; 
A20 = -0.1622; 
A30 =  0.002608; 
B00 =  2.84; 
B10 = -0.354; 
B20 =  0.0; 
 
if nargin == 2 
  P = zeros(size(S)); 
end 
 
    R =  82.057;         % Gas constant 
   S1 =  34.8; 
TEMP1 = 273.16; 
PRESS = P/10.13;         % Pressure in atm.  
TEMP  = T + TEMP1;       % Scaled Kelvin 
 
   KT = A + B./TEMP + C.*log(TEMP);                           % ln(K[T]) 
  KTS = (A0 + A1./TEMP + A2.*log(TEMP)).*sqrt(S) + B0*S;     % ln(K[TS] - ln(K[T]) 
DEL_V = A00 + A10.*(S - S1) + (A20 + A30.*T).*T;             % -del V 
DEL_K = B00 + B10.*(S - S1) + B20.*TEMP;                     % -10^3 del K 
 KPTS = ((DEL_V - 0.5.*DEL_K.*PRESS./1000).*PRESS)./(TEMP.*R);  % ln(K[PTS]/K[0TS]) 
  yy1 = exp(KT + KTS + KPTS);  % K1 Boric Acid 
  yy2 = -log(yy1)/log(10);     % pK Boric Acid 
 
