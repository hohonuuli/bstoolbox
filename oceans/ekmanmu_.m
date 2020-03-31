function mu = ekmanmu_(S,T,P) 
% EKMANMU_ - Ekman (1908) Seawater compressibility (S,T,P) 
%  
% Use As:  ekmanmu_(S,T,P) 
% 
% Input:   S = Salinity (psu) 
%          T = Temperature (C) 
%          P = Pressure (dbar) 
% Output:  Seawater compressibility 
% 
% Example: ekmanmu_(34,10,1000) -> 4.36557e-006 
% See Also: KSIGMAT_, BULKMOD_
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% Written without nested polynomials exactly in order shown in handout 
% William Broenkow 
% 28 Sept 1987, revised 11 Sept 88 
% Matlab-ized 18 Jan 1996 adapted from kednsty_.m 
 
A1  =  4886.0;  
A2  =     1.83E-5;  
A3  =   227.0;  
A4  =    28.33;  
A5  =     0.551;  
A6  =     0.004;  
A7  =   105.5;  
A8  =     9.50;  
A9  =     0.158;  
A10 =     1.5E-8;  
A11 =   147.3;  
A12 =     2.72;  
A13 =     0.04;  
A14 =    32.4;  
A15 =     0.87;  
A16 =     0.02;  
A17 =     4.5;  
A18 =     0.1;  
A19 =     1.8; 
A20 =     0.06;  
A21 =    28.0; 
                                                     
SIGMA_ZERO =  ksigmat_(S,0.0); 
 
P2 =  A1./(1.0 + A2.*P) - ( A3 + A4.*T - A5.*T.*T + A6.*T.*T.*T); 
P3 =  1E-4.*P.*(A7 + A8.*T - A9.*T.*T) - A10.*T.*P.*P; 
P4 =  A11 - A12.*T + A13.*T.*T - 1E-4.*P.*(A14 - A15.*T + A16.*T.*T); 
P5 =  A17 - A18.*T - 1E-4.*P.*(A19 - A20.*T); 
P6 =  1E-1.*(SIGMA_ZERO - A21); 
mu =  (P2 + P3 - P6.*P4 + P5.*P6.*P6)*1.0E-9;   % compressibility 
