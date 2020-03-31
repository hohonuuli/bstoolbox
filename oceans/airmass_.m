function AM = airmass_(angl) 
% airmass_ - Atmospheric thickness for all constituents; Gordon (ca 1977) 
% 
% Given the solar azimuth angle, return the dimensionless airmass. 
% This algorithm corrects for atmospheric refraction at large solar 
% zenith angles. 
% 
% Use As:   airmass_(angl) 
% 
% Input:    angl = solar zenith angle (deg) 
% Output:   airmass 
% 
% Example:  airmass_([45 85]) ->  1.4135 11.0521
%
% Ref:      Howard Gordon, University of Miami 1977 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% Taken from PLOTephem, and intermediate variable names are from this source code 
% 12 May 93: W. Broenkow 
% 20 Feb 95; W. Broenkow handle arrays 
% 26 Jun 96; D. Peters changed name of input variable from theta to angl
%  2 Oct 97; W. Broenkow revised other variable names

anglr = angl*pi/180;    % change input values to radians 
 
if (angl < 75) 
  X  = 1./cos(anglr) - 1; 
  AM = 1 + X -1.867e-3.*X - 2.875e-3.*X.^2 - 8.083e-4.*X.^3; 
else                      
  X = 0;                 % the following iteration is Kasten's formula    
  for i=1:4              % careful... X is degrees here 
    Y = angl - X; 
    X = 10.^(-116.94+4.41925.*Y-.056623.*Y.^2+.00024364.*Y.^3); 
  end
  X  = angl - X;         % careful X is degrees here too 
  AM = 1./(cos(pi.*X/180) + 0.15.*(180 - X + 3.855).^(-1.235));  
end 
