function yyy = svel_(S,T,P) 
% SVEL_  - Sound velocity in seawater (S,T,P) 
% 
% Use As:   svel_(S,T,P) 
% 
% Input:    S = Salinity (psu) 
%           T = Temperature (Celsius) 
%           P = Pressure (dbar) 
% Output:   Speed of Sound in Seawater (m/s) 
% 
% Example:  svel_(35,10,2000) -> 1522.96
%           svel_(40,40,10000)-> 1731.995  UNESCO 44 p48
% 
% See Also: WILSON_  
% Ref:      UNESCO Tech Paper Mar Sci 44 (1983) 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% Matlabized 17 Jan 1996; W. Broenkow 
% renamed to svel_ 20 Feb 1996 
 
A00 =  1.389; 
A01 = -1.262E-2; 
A02 =  7.164E-5; 
A03 =  2.006E-6; 
A04 = -3.210E-8; 
A10 =  9.4742E-5; 
A11 = -1.2580E-5; 
A12 = -6.4885E-8; 
A13 =  1.0507E-8; 
A14 = -2.0122E-10; 
 
A20 = -3.9064E-7; 
A21 =  9.1041E-9; 
A22 = -1.6002E-10; 
A23 =  7.9880E-12; 
 
A30 =  1.100E-10; 
A31 =  6.649E-12; 
A32 = -3.389E-13; 
 
B00 = -1.922E-2; 
B01 = -4.42E-5; 
 
B10 =  7.3637E-5; 
B11 =  1.7945E-7; 
 
C00 = 1402.388; 
C01 =  5.03711; 
C02 = -5.80852E-2; 
C03 =  3.3420E-4; 
C04 = -1.4780E-6; 
C05 =  3.1464E-9; 
 
C10 =  0.153563; 
C11 =  6.8982E-4; 
C12 = -8.1788E-6; 
C13 =  1.3621E-7; 
C14 = -6.1185E-10; 
 
C20 =  3.1260E-5; 
C21 = -1.7107E-6; 
C22 =  2.5974E-8; 
C23 = -2.5335E-10; 
C24 =  1.0405E-12; 
 
C30 = -9.7729E-9; 
C31 =  3.8504E-10; 
C32 = -2.3643E-12; 
 
D00 =  1.727E-3; 
D10 = -7.9836E-6; 
 
P2 = P./10;   % use pressure in bars 
 
CW = C00 + (C01 + (C02 + (C03 + (C04 + C05.*T).*T).*T).*T).*T ... 
      + ((C10 + (C11 + (C12 + (C13 + C14.*T).*T).*T).*T)     ... 
      + ((C20 + (C21 + (C22 + (C23 + C24.*T).*T).*T).*T)     ... 
      + (C30 + (C31 + C32*T).*T).*P2).*P2).*P2; 
 
A  = A00 + (A01 + (A02 + (A03 + A04.*T).*T).*T).*T      ... 
     + ((A10 + (A11 + (A12 + (A13 + A14.*T).*T).*T).*T) ... 
     + ((A20 + (A21 + (A22 + A23.*T).*T).*T)           ... 
     + (A30 + (A31 + A32.*T).*T).*P2).*P2).*P2; 
 
B  = B00 + B01*T + (B10 + B11*T).*P2; 
D  = D00 + D10*P2; 
 
yyy = CW + (A + B.*sqrt(S) + D.*S).*S;
