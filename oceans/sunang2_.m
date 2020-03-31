function [zen,azm,dec,eqt,gha,lha] = sunang2_(jday,gmt,lat,long)
 
% SUNANG2_ - Determine solar zenith and azimuth angles from latitude,  
%            longitude position using low precision algorithm. 
% 
% Use As:  [zen,azm,dec,eqt,GHA,LHA]=sunang2(jday,gmt,lat,long)
 
% 
% Input:    jday  = Julian Day of the year (1-365) 
%           gmt   = GMT        (hours) 
%           lat   = Latitude   (decimal degrees +N/-S) 
%           long  = Longitude  (decimal degrees +W/-E) 
% Output:   zen   = Solar zenith  (degrees) 
%           azm   = Solar azimuth (degrees) 
%           dec   = Declination  (degrees) 
%           eqt   = Equation of time (degrees) 
%           GHA   = Greenwich Hour Angle (degrees) 
%           LHA   = Local Hour Angle (degrees) 
%  
% Example:  [a,b,c,d,e,f] = sunang2_([1 100],20,36,121) 
%           a =   59.08    28.37   zenith  
%           b =  178.15   177.06   azimuth 
%           c =  -23.06     7.65   declination 
%           d =    0.726    0.407  equation of time 
%           e =  119.27   119.59   greenwich hour angle 
%           f =  358.27   358.59   local hour angle 
% 
% See Also: SUNRISE_, SUNSET_, NOON_, ALTAZM_, SUNALT_, ALMANAC_ 
% Note:     This algorithm is accurate only to a few tenths of a degree 
%           in altitude and azimuth. It is still useful for remote sensing 
%           atmospheric corrections, and may be more desireable for that  
%           purpose due to its speed. 
% Ref:      Howard Gordon, University of Miami (1977) This version was taken from PLOTczcs. 
%           Wayne Wilson (1980) Scripps Visibility Labs Ref: 80-13 
 
% Copyright (c) 1996 by Moss LandingMarine Laboratories 
% W. Broenkow, 15 April 1995 
% 28 Mar 96; W. Broenkow vectorized 
% 29 May 96; W. Broenkow fixed equation of time error added GHA
% 20 Jun 96; wwb changed degrad to deg2rad 
% 22 Jul 97; W. Broenkow changed variable names; changed azmiuth to Wilson's more robust method 
 
latR = deg2rad_(lat); 
lonR = deg2rad_(long); 
yrR  = 2*pi.*(jday - 1)./365; 
 
% declination 
dec  = .396372 - 22.91327.*cos(yrR) + 4.02543.*sin(yrR) - .387205.*cos(2.*yrR); 
dec  = dec + .051967.*sin(2.*yrR) - .154527.*cos(3.*yrR) + .084798.*sin(3.*yrR);   % decl degrees 
decR = deg2rad_(dec);                      % declination in radians 
 
% equation of time 
eqt  = .004297 + .107029.*cos(yrR) - 1.837877.*sin(yrR) - .837378.*cos(2*yrR); 
eqt  = eqt - 2.340475.*sin(2.*yrR);        % eq time degrees 
eqtR = deg2rad_(eqt);                      % eq time in radians

% hour angle 
lhaR = (gmt - 12).*15.*pi./180 - lonR; 
lhaR = lhaR + eqtR;                         % hour angle in radians 
 
% solar zenith angle   theta_-0 
zenR = acos(sin(latR).*sin(decR) + cos(latR).*cos(decR).*cos(lhaR)); 
 
% solar azimuth angle  Phi-0 Now: wilson_ (1980) Algorithm 
azmR  = acos((-sin(latR).*cos(lhaR).*cos(decR) + sin(decR).*cos(latR))./sin(zenR)); 
sign1 = sign(-cos(decR).*sin(lhaR)./sin(zenR)); 
sign2 = sign(sin(azmR)); 
indx = find(sign1 ~= sign2); 
if exist('indx') 
  azmR(indx) = 2*pi - azmR(indx); 
end 
zen =  rad2deg_(zenR); 
azm =  rad2deg_(azmR); 
dec =  rad2deg_(decR); 
eqt = -rad2deg_(eqtR);                      % corrected sign 29 May 96 
gha = rem(rad2deg_(lhaR) + long + 360,360); % greenwich hour angle degrees 
lha = rem(rad2deg_(lhaR) + 360,360);        % local hour angle degrees 
 
