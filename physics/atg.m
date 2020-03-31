function yyy = atg(S,T,P) 
% ATG - Adiabatic temperature gradient (S,T,P) 
% 
% UNESCO Tech Paper Mar Sci 44 (1983) 
% 
% Use As:    atg(S,T,P) 
% 
% Input:     S   = Salinity   (psu) 
%            T   = Temperatue (C) 
%            P   = Pressure   (dbar) 
% Output:    atg_ = Adiabatic temperature gradient (C/dbar) 
% 
% Example:   atg(35,10,4000)  -> 1.612567e-004
%            atg(40,40,10000) -> 3.255976e-004
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% Adapted from UNESCO_83.FOR 14 Mar 1987 W. Broenkow and R. Reaves 
% Matlabized 17 Jan 1996 
% lower case 20 Feb 1996 
 
A0 =   3.5803E-5; 
A1 =   8.5258E-6; 
A2 =  -6.8360E-8; 
A3 =   6.6228E-10; 
B0 =   1.8932E-6; 
B1 =  -4.2393E-8; 
C0 =   1.8741E-8; 
C1 =  -6.7795E-10; 
C2 =   8.7330E-12; 
C3 =  -5.4481E-14; 
D0 =  -1.1351E-10; 
D1 =   2.7759E-12; 
E0 =  -4.6206E-13; 
E1 =   1.8676E-14; 
E2 =  -2.1687E-16; 
 
yyy = A0 + (A1 + (A2 + A3.*T).*T).*T  ...  
    + (B0 + B1.*T).*(S - (35))        ... 
    + (C0 + (C1 + (C2 + C3.*T).*T).*T ... 
    + (D0 + D1.*T).*(S - (35))).*P    ... 
    + ((E0 + (E1 + E2.*T).*T)).*P.*P; 
 
