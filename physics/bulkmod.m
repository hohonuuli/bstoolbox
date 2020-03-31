function yyy = bulkmod(S,T,P) 
% BULKMOD - Seawater bulk modulus (S,T,P)  
% 
% UNESCO Tech Paper Mar Sci 44 (1983) 
%  
% Use As:  bulkmod_(S,T,P) 
% 
% Input:   S = salinity (psu) 
%          T = temperature (C) 
%          P = pressure (dbar) 
% Output:  Bulk Modulus in BARS   !! not dbar 
% 
% Example: bulkmod(35,10,4000) -> 24,046.04869
%          bulkmod(35,25,10000)-> 27,108.94504   UNESCO 36 p19
%                    
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% Separated out from DENSITY_83 
% 15 February 1992;  W. Broenkow 
% Matlabized 17 Jan 1996; W. Broenkow 
 
% use constant names exactly as in UNESCO 1983 
 
 E0 =   19652.21; 
 E1 =   148.4206; 
 E2 =  -2.327105; 
 E3 =   1.360477E-2; 
 E4 =  -5.155288E-5; 
 
 F0 =  54.6746; 
 F1 =  -0.603459; 
 F2 =   1.09987E-2; 
 F3 =  -6.1670E-5; 
 
 G0 =   7.944E-2; 
 G1 =   1.6483E-2; 
 G2 =  -5.3009E-4; 
 
 H0 =   3.239908; 
 H1 =   1.43713E-3; 
 H2 =   1.16092E-4; 
 H3 =  -5.77905E-7; 
 
 I0 =   2.2838E-3; 
 I1 =  -1.0981E-5; 
 I2 =  -1.6078E-6; 
 
 J0 =   1.91075E-4;        % ADDED LAST DIGIT 18 FEB 88 WWB 
 
 K0 =   8.50935E-5; 
 K1 =  -6.12293E-6; 
 K2 =   5.2787E-8; 
 
 M0 =  -9.9348E-7; 
 M1 =   2.0816E-8; 
 M2 =   9.1697E-10; 
 
 PRESS = P/10;        % do not change input values; use P in bars 
 KW   = E0 + (E1 + (E2 + (E3 + E4.*T).*T).*T).*T;       % eq 19
 
 AW   = H0 + (H1 + (H2 + H3.*T).*T).*T; 
 BW   = K0 + (K1 + K2.*T).*T; 
 A    = AW + (I0 + (I1 + I2.*T).*T).*S + J0.*S.*sqrt(S); % eq 17 
 B    = BW + (M0 + (M1 + M2.*T).*T).*S;                  % eq 18 
 F    = (F0 + (F1 + (F2 + F3.*T).*T).*T).*S; 
 G    = (G0 + (G1 + G2.*T).*T).*S.*sqrt(S); 
 
 KST0 = KW + F + G;                                      % eq 16 
 yyy = KST0 + (A + B.*PRESS).*PRESS;                     % eq 15 
 
 
% The following does not work when PRESS is an array,  
% because you cannot compare a vector with a scalar. 
% if (PRESS > 0) 
%   yyy = KST0 + (A + B.*PRESS).*PRESS 
% else 
%   yyy = KST0; 
% end 
 
