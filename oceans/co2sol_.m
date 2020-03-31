function yyy = co2sol_(S,T) 
% CO2S)L_ - CO2 solubility in per liter*atm. (S,T) 
% 
% UNESCO Tech Papaer Mar Sci 42 (1983), Weiss (1974), Murray & Riley (1971) 
% 
% Use As:  co2sol_(S,T) 
% 
% Input:   S = Salinity (psu) 
%          T = Temperature (deg C) 
% Output:  Carbon dioxide solubility (/liter*atm) 
% 
% Example: co2sol_(35,10) -> 0.04505  
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 23 Nov 87; M. Yuen 
% Matlabized 17 Jan 1996; W. Broenkow 
% lower case 20 Jan 1996 
 
A1    = -58.0931; 
A2    =  90.5069; 
A3    =  22.2940; 
 
B1    =   0.027766; 
B2    =  -0.025888; 
B3    =   0.0050578; 
 
TEMP1 = 273.16; 
TEMP2 = 100.0; 
 
TEMP = (T + TEMP1)/TEMP2;                % Scaled Kelvin 
 
yyy = exp(A1 + A2./TEMP + A3.*log(TEMP) + S.*(B1 + (B2 + B3.*TEMP).*TEMP)); 
 
