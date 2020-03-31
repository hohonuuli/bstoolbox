function [alt,az,dist] = ephems_(yr,mo,dy,hms,lat,lon,debug) 
 
% EPHEMS - Moderate precision solar ephemeris from Wilson (1980) 
% Used As: [alt,az,dist] = ephems_(yr,mo,dy,hms,lat,lon,debug) 
% Input:    yr = year  (1997) 
%           mo = month (1..12) 
%           dy = day of month (1..31) 
%          hms = GMT time (as HH.MMSS)
%          lat = latitude  (+/- N/S degrees)
%          lon = longitude (+/- W/E degrees) 
%        debug = 0 to suppress detailed printout 
%              = 1 to display complete ephemeris results 
%                  as given in Wilson (1980) 
% Output:  alt = solar altitude (decimal degrees) 
%           az = solar azimuth angle (decimal degrees) 
%         dist = earth-sun distance (AU)   
% 
% Example: [alt,az,dist] = ephems_(1980,3,6,20,32,120) 
%                    alt =  52.5410 deg 
%                     az = 175.4319 deg 
%                   dist =   0.9924 AU 
% See Also:  ALMANAC_, SUNANG2_, SUNALT_, SUNRISE_, SUNSET_, NOON_ 
% Note:  This solar ephemeris has the highest accuracy (about 15 arc 
%        seconds) of the three contained in this library. The code 
%        in this function is well annotated and may be useful 
%        to obtain other astronomical parameters.  
% Ref:   Wilson_, W. 1980. Solar Ephemeris Algorithm. Visibility
%        Laboratory, Scripps Institution of Oceanography 
%        SIO Ref. 80-13. 
 
% Copyright (c) Moss Landing Marine Laboratories 1997 
% 18 Jul 1997; W. Broenkow adapted from Wilson's HPL code 
% 22 Jul 1997; fully debugged 
 
% Use Wilson's variable names, but use scratch 
% variables a,b,c,d,e instead of p11,p12,p13,P14,p15 
 
% Supply data to use with Wilson's test output page 5-8 
% These test data agree exactly with Wilson's results  
% EXCEPT for p34 and p35 
% Wilson gives    p34 =  -0.00089 ... I get  -0.00148 
% Wilson gives    p35 =  -0.00074 ... I get  -0.00124 
% However  
% Wilson gives    p75 =  23.26233 ... I get  23.26233 
% Wilson gives    p41 = 346.24208 ... I get 346.24208  
% The mistake is only in the printed test data. If we  
% take deg2dms_(-.00089)  we get my result -.00148 
% take deg2dms_(-.00074)  we get my result -.00123 
% The code that generated his test results did not include tohms function 
% dy = 6; mo = 3; yr = 1980; hms = 12.00;lat = 32; lon = 120; 
 
if nargin < 7 
  debug = 0; 
end 
if nargin < 6 
  help ephems 
end 
 
p16 = dy; 
p17 = mo; 
p18 = yr; 
p19 = lat;   
p20 = lon; 
hr  = dms2deg_(hms); 
 
% ET - UT: difference between Ephemeris and Universal Time 
p57 = 0; 
 
% convert HH.MMSS to h.hh 
p21 = dms2deg_(hms,1); 
 
% zone longitude 
p53 = 15*floor((7.5 + abs(p20))/15)*sign(p20); 
 
% GMT degrees 
% p51 = 15*hr + p53; 
% when using GMT time input replace above with 
p51 = 15*hr;   % i.e. do not add the zone longitude 
 
% Day from 0 Jan 1900 
p11 = mo + 1; 
p12 = yr; 
if p11 <= 3 
  p11 = p11 + 12; 
  p12 = p12 - 1; 
end 
p13 = floor(365.25*p12) + floor(30.6*p11) + dy; 
p22 = p13 - 694038.5; 
p11 = p18 + mo/100 + dy/10000; 
if p11 < 1900.0228  
  p22 = p22 + 1; 
end 
if p11 < 1800.0228 
  p22 = p22 + 1; 
end 
p23 = (p51/360 + p22 + p57)/36525; 
 
% fraction of the century 
p22 = p23*36525; 
 
% Mean longitude 
a = 279.69668; 
b = .9856473354; 
c = 3.03e-4; 
p24 = a + rem(b*p22,360) + c*p23^2; 
p24 = rem(p24,360); 
Mean_Long = p24; 
 
% Mean anomaly 
a = 358.47583; 
b = .985600267; 
c = -1.5e-4; 
d = -3e-6; 
p25 = a + rem(b*p22,360) + c*p23^2 + d*p23^3; 
p25 = rem(p25,360); 
Mean_Anom = p25; 
 
% Eccentricity 
a = .01675104; 
b = -4.18e-5; 
c = -1.26e-7; 
p26 = a + b*p23 + c*p23^2;  
Eccent = p26; 
 
% Eccentric anomaly 
p11 = deg2rad_(p25); 
p12 = p11; 
p13 = p12; 
p12 = p11 + p26*sin(p13); 
while abs((p12 - p13)/p12) > 1e-8  
  p13 = p12; 
  p12 = p11 + p26*sin(p13); 
end 
 
% True anomaly 
p13 = rad2deg_(p12); 
EccAnomR = p13; 
p27 = 2*atan(sqrt((1+p26)/(1-p26))*tan(deg2rad_(p13/2))); 
if sign(p27) ~= sign(sin(deg2rad_(p13))) 
  p27 = p27 + pi; 
end 
p27 = rad2deg_(p27); 
if p27 < 0 
  p27 = p27 + 360; 
end 
 
% Radius vector 
R = 1 - p26*cos(deg2rad_(p13)); 
 
% Aberration 
p29 = -20.47/R/3600; 
 
% Mean obliquity 
a = 23.452294; 
b = -.0130125; 
c = -1.64e-6; 
d = 5.03e-7; 
p43 = a + b*p23 + c*p23^2 + d*p23^3; 
 
% Mean ascension 
a = 279.6909832; 
b = .98564734; 
c = 3.8708e-4; 
p45 = a + rem(b*p22,360) + c*p23^2; 
p45 = rem(p45,360); 
 
% Moon's mean anomaly 
a = 296.104608; 
b = 1325*360; 
c = 198.8491083; 
d = .00919167; 
e = 1.4388e-5; 
p28 = a + rem(b*p23,360) + c*p23 + d*p23^2 + e*p23^3; 
p28 = rem(p28,360); 
 
% Mean elongation of moon 
a = 350.737486; 
b = 1236*360; 
c = 307.1142167; 
d = 1.436e-3; 
p30 = a + rem(b*p23,360) + c*p23 + d*p23^2; 
p30 = rem(p30,360); 
 
% Moon longitude of ascending node 
a = 259.183275; 
b = -5*360; 
c = -134.142008; 
d = 2.0778e-3; 
p31 = a + rem(b*p23,360) + c*p23 + d*p23^2; 
p31 = rem(p31,360); 
 
% Mean longitude of moon 
a = 270.434164; 
b = 1336*360; 
c = 307.8831417; 
d = -1.1333e-3; 
p32 = a + rem(b*p23,360) + c*p23 + d*p23^2; 
p32 = rem(p32,360); 
 
% Moon perturbation of sun longitude 
p33 =        6.454*sin(deg2rad_(p30)); 
p33 = p33 + .013*sin(deg2rad_(3*p30)); 
p33 = p33 + .177*sin(deg2rad_(p30 + p28)); 
p33 = p33 - .424*sin(deg2rad_(p30 - p28)); 
p33 = p33 + .039*sin(deg2rad_(3*p30 - p28)); 
p33 = p33 - .064*sin(deg2rad_(p30+p25)); 
p33 = p33 + .172*sin(deg2rad_(p30 - p25)); 
p33 = p33/3600;  
p74 = p33;    
 
% Nutation of longitude 
p34 = -(17.234-.017*p23)*sin(deg2rad_(1*p31)); 
p34 = p34 +  .209*sin(deg2rad_(2*p31)); 
p34 = p34 -  .204*sin(deg2rad_(2*p32)); 
p34 = p34 - 1.257*sin(deg2rad_(2*p24)); 
p34 = p34 +  .127*sin(deg2rad_(p28)); 
p34 = p34/3600; 
 
% Nutation in Obliquity 
p35 =       9.214*cos(deg2rad_(1*p31)); 
p35 = p35 +  .546*cos(deg2rad_(2*p24)); 
p35 = p35 -  .090*cos(deg2rad_(2*p31)); 
p35 = p35 +  .088*cos(deg2rad_(2*p32)); 
p35 = p35/3600; 
 
% Inequalities of long period 
p36 =       .266*sin(deg2rad_(31.8 + 119*p23)); 
p36 = p36 + (1.882-.016*p23)*sin(deg2rad_(57.24 + 150.27*p23)); 
p36 = p36 + .202*sin(deg2rad_(315.6 + 893.3*p23)); 
p36 = p36 + 1.089*p23^2 + 6.4*sin(deg2rad_(231.19 + 20.2*p23)); 
p36 = p36/3600; 
 
% Moon mean argument of latitude 
a = 11.250889; 
b = 1342*360; 
c = 82.02515; 
d = .003211; 
p63 = a + rem(b*p23,360) + c*p23 + d*p23^2; 
p63 = rem(p63,360); 
 
% Mean Anomaly of Venus 
a = 212.603222; 
b = 162*360; 
c = 197.803875; 
d = 1.286e-3; 
p37 = a + rem(b*p23,360) + c*p23 + d*p23^2; 
p70 =       4.838*cos(deg2rad_(299.171  + 1*p37 - 1*p25)); 
p70 = p70 + 5.526*cos(deg2rad_(148.5259 + 2*p37 - 2*p25)); 
p70 = p70 + 2.497*cos(deg2rad_(316.5759 + 2*p37 - 3*p25)); 
p70 = p70 + 0.666*cos(deg2rad_(177.71   + 3*p37 - 3*p25)); 
p70 = p70 + 1.559*cos(deg2rad_(345.4559 + 3*p37 - 4*p25)); 
p70 = p70 + 1.024*cos(deg2rad_(318.15   + 3*p37 - 5*p25)); 
p33 = p33 + p70/3600; 
 
% Perturbation of solar latitude by Venus 
p61 =        .21*cos(deg2rad_(151.8 + 3*p37 - 4*p25)); 
p61 = p61 + .092*cos(deg2rad_( 93.7 + 1*p37 - 2*p25)); 
p61 = p61 + .067*cos(deg2rad_(123   + 2*p37 - 3*p25)); 
 
% Mean Anomaly of Mars 
a = 319.529022; 
b = 53*360; 
c = 59.8592194; 
d = 1.8083e-4; 
p38 = a + rem(b*p23,360) + c*p23 + d*p23^2; 
p38 = rem(p38,360); 
p71 =       0.273*cos(deg2rad_(217.7    - 1*p38 + 1*p25)); 
p71 = p71 + 2.043*cos(deg2rad_(344.4898 - 2*p38 + 2*p25)); 
p71 = p71 + 1.770*cos(deg2rad_(200.6713 - 2*p38 + 1*p25)); 
p71 = p71 + 0.425*cos(deg2rad_(338.88   - 3*p38 + 2*p25)); 
p71 = p71 + 0.500*cos(deg2rad_(105.18   - 4*p38 + 3*p25)); 
p71 = p71 + 0.585*cos(deg2rad_(334.06   - 4*p38 + 2*p25)); 
p33 = p33 + p71/3600; 
 
% Mean Anomaly of Jupiter 
a = 225.3225; 
b = 8*360; 
c = 154.583; 
p39 = a + rem(b*p23,360) + c*p23; 
p39 = rem(p39,360); 
p72 =       7.208*cos(deg2rad_(179.888  - 1*p39 + 1*p25)); 
p72 = p72 + 2.600*cos(deg2rad_(263.3685 - 1*p39 + 0*p25)); 
p72 = p72 + 2.731*cos(deg2rad_( 87.2472 - 2*p39 + 2*p25)); 
p72 = p72 + 1.610*cos(deg2rad_(109.8259 - 2*p39 + 1*p25)); 
p72 = p72 + 0.556*cos(deg2rad_( 82.65   - 3*p39 + 2*p25)); 
p33 = p33 + p72/3600; 
 
% Perturbation of Solar Latitude by Jupiter 
p62 = .166*cos(deg2rad_(265.5 - 2*p39 + p25)); 
 
% Mean Anomaly of Saturn 
a = 175.613; 
b = 3*360; 
c = 141.794; 
p40 = a + rem(b*p23,360) + c*p23; 
p40 = rem(p40,360); 
p73 =       0.419*cos(deg2rad_(100.58   - 1*p40 + 1*p25)); 
p73 = p73 + 0.320*cos(deg2rad_(269.46   - 1*p40 + 0*p25)); 
p33 = p33 + p73/3600; 
 
% Precession 
p42 = (50.2564 + .0222*(p18-1900)/100)*(p23 - (p18-1900)/100)*100/3600; 
 
% Apparent Longitude 
p41 = p27 - p25 + p24 + p29 + p33 + p36 + p34; 
 
% Solar Latitude 
p60 = (.576*sin(deg2rad_(p63)) + p61 + p62)/3600; 
 
% Obliquity 
p75 = p35 + p43; 
 
% Apparent Right Ascension 
p44 = rad2deg_(atan(tan(deg2rad_(p41))*cos(deg2rad_(p75)))); 
if sign(p44) ~= sign(sin(deg2rad_(p41))) 
  p44 = p44 + 180; 
end 
if p44 < 0 
  p44 = p44 + 360; 
end 
 
% Equation of Time 
p46 = p45 - p44; 
if p46 > 180 
  p46 = p46 - 360; 
end 
 
% Greenwich Hour Angle 
p48 = p51 + p46 - 180; 
 
% Local Hour Angle 
p49 = p48 - p20; 
p49 = rem(p49 + 360,360); 
 
% Declination 
a = deg2rad_(p41); 
b = deg2rad_(p75); 
c = deg2rad_(p60); 
p47 = rad2deg_(asin(sin(a)*sin(b)*cos(c) + sin(c)*cos(b))); 
 
% Zenith Angle 
a = deg2rad_(p19); 
b = deg2rad_(p47); 
c = deg2rad_(p49); 
Z = rad2deg_(acos(sin(a)*sin(b) + cos(a)*cos(b)*cos(c))); 
 
% Azimuth Angle 
a = deg2rad_(p19); 
b = deg2rad_(p47); 
c = deg2rad_(p49); 
d = deg2rad_(Z); 
e = (-sin(a)*cos(c)*cos(b) + sin(b)*cos(a))/sin(d); 
if abs(e) > 1; 
  e = sign(e); 
end 
A = rad2deg_(acos(e)); 
if sign(-cos(b)*sin(c)/sin(d)) ~= sign(sin(deg2rad_(A))) 
  A = 360 - A; 
end 
 
if debug 
  fprintf('p22 Days Since   0 Jan 1900    %11.1f \n',p22) 
  fprintf('p23 Fractional Century 1900    %11.6f \n',p23) 
  fprintf('p24 Mean Longitude             %11.5f \n',deg2dms_(p24,1)) 
  fprintf('p25 Mean Anomaly               %11.5f \n',deg2dms_(p25,1)) 
  fprintf('p26 Eccentricity               %11.5f \n',p26)     
  fprintf('p27 p25 Equation of Center     %11.5f \n',deg2dms_(p27-p25,1)) 
  fprintf('R   Radius Vector              %11.5f \n',R) 
  fprintf('p29 Abberation                 %11.5f \n',deg2dms_(p29,1)) 
  fprintf('p43 Mean Obliquity             %11.5f \n',deg2dms_(p43,1)) 
  fprintf('p45 Mean Ascension             %11.5f \n\n',deg2dms_(24*p45/360,1)) 
 
  fprintf('p74 Perturb by Moon            %11.5f \n',deg2dms_(p74,1)) 
  fprintf('p70 Perturb by Venus           %11.5f \n',deg2dms_(p70/3600,1)) 
  fprintf('p61 Perturb Latitude by Venus  %11.5f \n',deg2dms_(p61/3600,1)) 
  fprintf('p71 Perturb by Mars            %11.5f \n',deg2dms_(p71/3600,1)) 
  fprintf('p72 Perturb by Jupiter         %11.5f \n',deg2dms_(p72/3600,1)) 
  fprintf('p62 Perturb Latitude by Jupiter%11.5f \n',deg2dms_(p62/3600,1)) 
  fprintf('p73 Perturb by Saturn          %11.5f \n',deg2dms_(p73/3600,1)) 
  fprintf('p33 Total Perturbs of Sun Long %11.5f \n\n',deg2dms_(p33,1)) 
 
  fprintf('p28 Moon Mean Anomaly          %11.5f \n',deg2dms_(p28,1)) 
  fprintf('p30 Moon Mean Elongation       %11.5f \n',deg2dms_(p30,1)) 
  fprintf('p31 Moon Long Ascend Node      %11.5f \n',deg2dms_(p31,1)) 
  fprintf('p32 Mean Longitude of Moon     %11.5f \n',deg2dms_(p32,1)) 
  fprintf('p63 Moon Mean Arg of Latitude  %11.5f \n',p63)   
  fprintf('p36 Long Period Inequalities   %11.5f \n',deg2dms_(p36,1))   
  fprintf('p34 Nutation of Longitude      %11.5f \n',deg2dms_(p34))   
  fprintf('p35 Nutation in Obliquity      %11.5f \n\n',deg2dms_(p35))   
 
  fprintf('p42 Precession                 %11.5f \n',deg2dms_(p42,1)) 
  fprintf('p41 Apparent Longitude         %11.5f \n',deg2dms_(p41,1)) 
  fprintf('p60 Solar Latitude             %11.5f \n',deg2dms_(p60,1)) 
  fprintf('p75 Obliquity                  %11.5f \n',deg2dms_(p75,1)) 
  fprintf('p44 Apparent Ascension         %11.5f \n',deg2dms_(24*p44/360,1)) 
  fprintf('p46 Equation of Time           %11.5f \n',deg2dms_(24*p46/360,1)) 
  fprintf('p48 Greenwich Hour Angle       %11.5f \n',deg2dms_(p48,1)) 
  fprintf('p49 Local Hour Angle           %11.5f \n',deg2dms_(p49,1)) 
  fprintf('p47 Declination                %11.5f \n\n',deg2dms_(p47,1)) 
  fprintf('A   Solar Azimuth              %11.5f \n',deg2dms_(A,1)) 
  fprintf('Z   Solar Zenith Angle         %11.5f \n',deg2dms_(Z,1)) 
end 
alt  = 90 - Z; 
 az  = A; 
dist = R; 
 
