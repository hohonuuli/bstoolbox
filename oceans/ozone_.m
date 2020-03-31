function O3 = ozone_(Lat,Lon,Day) 
% OZONE_ - Atmospheric ozone_ concentration in Dobsons  
% Use As:  OZ = ozone_(Lat,Lon,Day) 
% Inputs:  Lat = latitude (degrees +N, -S) 
%          Lon = longitude (degrees +W - E) 
%          Day = Day of the year 1..365 
% Output:  Integrated atmospheric ozone (Dobsons = mAtm cm of O3 NPT) 
% 
% Example: ozone_(36,122,185) ->  321.2
%
% Ref:    Van Heuklon, T.K. (1979) Estimating atmospheric ozone for solar  
%         radiation models. Solar Energy Vol 22: p63:68.        
 
% 30 April 97; W.Broenkow 
% 21 May 97; S. Flora - corrected problem with I and added annotation 
 
A = [150 100]; 
B = [1.28 1.5]; 
D = [0.9865; 0.9865]; 
C = [40 30]; 
F = [-30 152.625]; 
G = [20 20]; 
H = [3 2]; 
I = [20 -75];    % For Northern Hemisphere I(1) = 0 for negative longitude   
J = [235 235]; 
Lon = -Lon;      % All of our routines used West = + Longitude  
                 % Heuklon requires West = - Longitude 
              
if Lat > 0 
  n = 1;    % use first value in coefficient vector for northern latitudes 
else 
  n = 2;    % use second for southern 
end 
F1 = J(n);                                    % equatorial annual average value 
F2 = A(n);                                    % accounts for the Part of ozone variation attributable to Latitude  
F3 = C(n).*sin(pi*D(n).*(Day + F(n))/180);    % accounts for the Part of ozone variation attributable to Season 
 
% We must switch between 3 numbers, 75 in the Southern Hemisphere (SH) 
% and 0 and 20 in the Northern Hemisphere (NH), the code will allow I 
% to be 75 in the the SH and in the NH switch between 0 in the West 
% and 20 in the East.  code = (~(Lon<0 & Lat>0)) 
 
F4 = G(n).*sin((pi/180)*(H(n).*(Lon + I(n)*(~(Lon<0 & Lat>0))))); 
 
F5 = sin(pi*B(n).*Lat/180).^2;    % Latitudianl dependent of each variation 
 
% F1 the equatorial annual average value 
% F2*F5 is Van Heuklon's Loz and is the latitudinal variation in ozone amount 
% F3*F5 is Van Heuklon's Soz is the seasonal variation in ozone amount  
% F4*F5 is Van Heuklon's Moz is the longitudinal variation in ozone amount  
O3 = F1 + (F2 + F3 + F4).*F5;
