function [DECL, GHA, DIST, EQ_TIME] = almanac_(YEAR,MONTH,DAY,HOUR) 
% ALMANAC_ - Moderate precision solar ephemeris computes declination, GHA 
%            distance and equation of time. 
% 
% Use As:   [DECL,GHA,DIST,EQ_TIME] = almanac_(y,mo,d,h) 
% 
% Input:    y         = year, as 1996 
%           mo        = month of the year (1-12) 
%           d         = GMT Day of the month (1-31)  
%           h         = GMT decimal hour of the day (0-24) 
% Output:   DECL      = Apparent Declination      (deg) 
%           GHA       = Greenwich Hour Angle      (deg) 
%           DIST      = Earth-Sun Distance        (AU) 
%           EQ_TIME   = Equation of Time          (deg) 
% 
% Example:  [a,b,c,d] = almanac_(1996,6,12,16.1) 
%                   a =  23.19; b = 61.52; c = 1.0156; d = -0.0287 
% 
% Note:     This algorithm is accurate to about 30 arc seconds.
 
%           The following internal values may be of interest  
%           CENT_1900 = Fractional century from 1.5 Jan 1900 
%           DAYS_2000 = Days from               1.5 Jan 2000   
 
%           GMST      = Greenwich Mean Siderial Time (hours) 
%           MEAN_RA   = Mean Right Ascension         (deg)                             
%           RA        = Apparent Right Ascension     (deg) 
%           SUN_LON   = Apparent Sun Longitude       (deg) 
%           SHA       = Siderial Hour Angle          (deg) 
%           GHA_ARIES = Greenwich Hour Angle Aries   (deg) 
% 
% See Also: SUNANG2_, DEG2DMS_, EPHEMS_, ALTAZM_, SUNALT_, SUNRISE_, SUNSET_, NOON_ 
% Ref:  Van Flanderen and Pulkkinen (1979) Low Precision Formulae for Planetary 
%       Positions. Astrophysical Journal Supplement Series, 41:391-411. 
 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% Richard Reaves & William Broenkow 
% 21 March 1988 
% 28 May 96; W. Broenkow converted from NEWSUN.FOR           
% Adapted from PLOTephem.HPL and 
% 20 Jun 96; wwb changed degrad to deg2rad 
%  Internal parameter names (P10-P20) are identical to those in the  
%  HPL program, PLOTephem, from which this was extracted. 
 
% [CENT_1900,DAYS_2000,GMST] = EPHEMPAR(YEAR,MONTH,DAY,HOUR); 
% Do not use the needless function 
% This program agrees with Wilson (1980) and Duffet-Smith (1997) 
% W. Broenkow 21 Jul 1997 
 
JUL_HR    = juldate_(YEAR,MONTH,DAY) + HOUR/24.0;  % Julian date + hours 
DAYS_2000 = JUL_HR - 2451545.0; 
CENT_1900 = 1.0 + DAYS_2000/36525.0; 
GMST      = 6.6460656 + 2400.051262*CENT_1900 + 0.0000258*CENT_1900.^2; 
GMST      = rem(GMST,24); 
                         
P10 = 2*pi*(0.827362 + 0.03386319198*DAYS_2000); % originally FRAC360*() 
P11 = 2*pi*(0.347343 - 0.00014709391*DAYS_2000); % just convert to 2*pi radians 
P12 = 2*pi*(0.779072 + 0.00273790931*DAYS_2000); % and make angle positive 
P13 = 2*pi*(0.993126 + 0.00273777850*DAYS_2000); % Even without making angles 
P14 = 2*pi*(0.140023 + 0.00445036173*DAYS_2000); % the answer should be correct. 
P15 = 2*pi*(0.053856 + 0.00145561327*DAYS_2000); 
P16 = 2*pi*(0.056531 + 0.00023080893*DAYS_2000); 
 
P17 = (6910.0 - 17.0*CENT_1900).*sin(P13);       % all trig arguments are radians 
P17 =  P17  + 72.0.*sin(2.0*P13); 
P17 =  P17  -  7.0.*cos(P13 - P16); 
P17 =  P17  +  6.0.*sin(P10);          
P17 =  P17  +  5.0.*sin(4.0*P13 - 8.0*P15 + 3.0*P16); 
P17 =  P17  -  5.0.*cos(2.0*P13 - 2.0*P14);  
P17 =  P17  -  4.0.*sin(P13 - P14); 
P17 =  P17  +  4.0.*cos(4.0*P13 - 8.0*P15 + 3.0*P16); 
P17 =  P17  +  3.0.*sin(2.0*P13 - 2.0*P14);  
P17 =  P17  -  3.0.*sin(P16);              
P17 =  P17  -  3.0.*sin(2.0*P13 - 2.0*P16); 
                                            
P18 = (0.39785 - 0.00021*CENT_1900).*sin(P12); 
P18 =  P18 + (0.00003.*CENT_1900 - 0.01).*sin(P12-P13); 
P18 =  P18 +  0.00333.*sin(P12 + P13); 
P18 =  P18 +  0.00004.*sin(P12 + 2.0*P13); 
P18 =  P18 -  0.00004.*cos(P12); 
P18 =  P18 -  0.00004.*sin(P11 - P12); 
 
P19 = (-3349.0 + 8.0.*CENT_1900).*cos(P13); 
P19 = P19 - 14.0.*cos(2.0*P13); 
P19 = P19 -  3.0.*sin(P13 - P16); 
P19 = 1.0 + P19./1e5; 
 
P20 = (-0.04129 + 0.00005*CENT_1900).*sin(2*P12); 
P20 = P20 + (0.03211 - 0.00008*CENT_1900).*sin(P13); 
P20 = P20 + 0.00104.*sin(2*P12 - P13); 
P20 = P20 - 0.00035.*sin(2*P12 + P13) - 0.0001; 
P20 = P20 - 0.00008.*sin(P11); 
P20 = P20 + 0.00007.*sin(2*P13); 
P20 = P20 + 0.00003.*sin(P10); 
P20 = P20 - 0.00002.*cos(P13 - P16); 
P20 = P20 + 0.00002.*sin(4.0.*P13 - 8.0.*P15 + 3.0.*P16); 
P20 = P20 - 0.00002.*sin(P13 - P14); 
P20 = P20 - 0.00002.*cos(2.0.*P13 - 2.0.*P14); 
 
%  I went to some trouble to discover all of this... 
%  so keep the commented lines as a tutorial. 
 
REQ_TIME   = asin(P20./sqrt(P19 - P18.*P18)); % Equation of Time (radians) 
EQ_TIME    = rad2deg_(REQ_TIME);              % Equation of Time (degrees) 
DIST       = 1.00021.*sqrt(P19);              % Earth-Sun Distance (A.U.) 
RDECL      = asin(P18./sqrt(P19));            % Declination (radians) 
DECL       = rad2deg_(RDECL);                 % Declination (degrees) 
RMEAN_RA   = P12;                             % Mean Right Ascension (radians) 
MEAN_RA    = rad2deg_(P12);                   % Mean Right Ascension (degrees) 
RRA        = RMEAN_RA + REQ_TIME;             % Right Ascension (radians) 
RA         = rad2deg_(RRA);                   % Right Ascension (degrees) 
GHA_ARIES  = 15*(GMST + HOUR);                % Greenwich Hour Angle Aries (degrees) 
GHA        = GHA_ARIES - RA;                  % Greenwich Hour Angle Sun (degrees) 
GHA        = rem(GHA,360); 
SHA        = 360 + RA;                        % Siderial  Hour Angle Sun (degrees) 
SUN_LONG   = MEAN_RA + P17./3600;             % Sun Longitude 
 
if EQ_TIME > 180 
  EQ_TIME =  EQ_TIME - 360; 
end 
 
% The following four quantities are returned: 
% print *, 'Equation of Time  ', eq_time 
% print *, 'Declination       ', decl 
% print *, 'Earth-Sun Dist    ', dist 
% print *, 'GHA               ', gha 
 
% The following tutorial quantities are not returned in this subroutine: 
% print *, 'Mean Right Ascen  ', mean_ra 
% print *, 'Right Ascension   ', dmod(ra,circle) 
% print *, 'GHA Aries         ', dmod(gha_aries,circle) 
% print *, 'Sun Longitude     ', dmod(sun_long,circle) 
% print *, 'Siderial Hr Angle ', dmod(sha,circle)
