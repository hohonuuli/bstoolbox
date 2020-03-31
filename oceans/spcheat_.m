function yyy = spcheat_(S,T,P,Units) 
% SPCHEAT_ - Computes the specific heat of seawater  
% 
% Use As:  spcheat_(S,T,P,Units) 
% 
% Input:   S     = Salinity (practical salinity) 
%          T     = Temperature (Celsius) 
%          P     = Pressure (dbar)
%          Units:  Set output units
%                  0 (default) use Joules/kg C
%                  1 use cal/g C
% 
% Output:  Specific Heat (Joules/kg C) or (cal/g C)
% 
% Example: spcheat_(35,10,1000)    -> 3959.9 
%          spcheat_(40,40,0)       -> 3980.051 UNESCO 44 p 34
%          spcheat_(35,10,1000,1)  -> 0.9462   scalar values only
%
% Ref: UNESCO Tech Paper Mar Sci 44 (1983) 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% from UNESCO_83.FOR 
% Matlabized 17 Jan 1996; W. Broenkow 

if nargin < 3
  disp('SPCHEAT_  Error: 3 inputs are required')
  help spcheat_
  return
end
if nargin < 4
  Units = 0;
end
if Units > 0
  Units = 1;
else
  Units = 0;
end
  
A00 = -7.643575;          % coefficients for pure water 
A01 =  0.1072763; 
A02 = -1.38385E-3; 
 
B00 =  0.1770383;         % pressure independent salinity terms
 
B01 = -4.07718E-3; 
B02 =  5.148E-5; 
 
C00 =  4217.4; 
C01 = -3.720283; 
C02 =  0.1412855; 
C03 = -2.654387E-3; 
C04 =  2.093236E-5; 
 
A0  = -4.9592E-1;         % terms for pressure correction 
A1  =  1.45747E-2; 
A2  = -3.13885E-4; 
A3  =  2.0357E-6; 
A4  =  1.7168E-8; 
 
B0  =  2.4931E-4; 
B1  = -1.08645E-5; 
B2  =  2.87533E-7; 
B3  = -4.0027E-9; 
B4  =  2.2956E-11; 
 
C0  = -5.422E-8; 
C1  =  2.6380E-9; 
C2  = -6.5637E-11; 
C3  =  6.136E-13; 
 
D0  =  4.9247E-3; 
D1  = -1.28315E-4; 
D2  =  9.802E-7; 
D3  =  2.5941E-8; 
D4  = -2.9179E-10; 
 
E0  = -1.2331E-4; 
E1  = -1.517E-6; 
E2  =  3.122E-8; 
 
F0  = -2.9558E-6; 
F1  =  1.17054E-7; 
F2  = -2.3905E-9; 
F3  =  1.8448E-11; 
 
G0  =  9.971E-8; 
 
H0  =  5.540E-10; 
H1  = -1.7682E-11; 
H2  =  3.513E-13; 
J1  = -1.4300E-12; 
 
if nargin == 2 
 P = zeros(size(S)); 
end 
 
 CP1 = 0.0; 
 CP2 = 0.0; 
ROOT = sqrt(S); 
  P2 = P/10;                     % use pressure in bars 
   A = A00 + (A01 + A02.*T).*T; 
   B = B00 + (B01 + B02.*T).*T; 
   C = C00 + (C01 + (C02 + (C03 + C04.*T).*T).*T).*T; 
 CP0 = C + A.*S + B.*S.*ROOT;                        % spc heat @ S=0, P=0 
 
 % pressure correction 
    A = A0 + (A1 + (A2 + (A3 + A4.*T).*T).*T).*T; 
    B = B0 + (B1 + (B2 + (B3 + B4.*T).*T).*T).*T; 
    C = C0 + (C1 + (C2 + C3.*T).*T).*T; 
  CP1 = (A + (B + C.*P2).*P2).*P2;                     % del spc heat @ S=0, P>0 
 
  % salinity correction  
   A = D0 + (D1 + (D2 + (D3 + D4.*T).*T).*T).*T; 
   B = E0 + (E1 + E2.*T).*T; 
   A = (A + B.*ROOT).*S; 
   B = F0 + (F1 + (F2 + F3.*T).*T).*T; 
   B = (B + G0.*ROOT).*S; 
   C = H0 + (H1 + H2.*T).*T; 
   C = (C + J1.*T.*ROOT).*S; 
 CP2 = (A + (B + C.*P2).*P2).*P2;   % del spc heat @ S>0, P>0 
     
 yyy = CP0 + CP1 + CP2; 
 
 if Units > 0
   yyy = yyy/4185;
 end
