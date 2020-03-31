function rho = fresnel_(theta,n) 
 
% FRESNEL_ - Fresnell reflectance. 
% 
% Use As:   rho     = fresnel_(theta,n) 
% Input :   theta_  = angle to surface normal (deg) 
%           n       = refractive index 
%                   if no value entered, set to 1.34 for seawater 
% Output:   rho    = fresnel_ reflectance  
%
% Example:  fresnel_(0) > 0.0211 
%           fresnel_(0,2.5) > 0.1837 
 
% W. Broenkow 25 Apr 1993 for MS-262 
% 10 Sep 96; S. Flora - corrected the calculation of rho by dividing p2 by 2. 
 
if ( ~(exist('n')) )
  n = 1.34;
end;                           % refractive index of seawater 
if (theta == 0), 
 rho   = ((n-1)/(n+1)).^2; 
else, 
  p1   = theta.*pi/180;         % Convert to radians 
  p4   = sin(p1);               % Calc. the sin 
  p3   = asin(p4/n);            % p3 = the theta_water         
  p5   = sin(p1-p3); p6 = sin(p1+p3); 
  p2   = (p5./p6).^2;          % rho_normal 
  p7   = tan(p1-p3); p8 = tan(p1+p3); 
  p9   = (p7./p8).^2;           % rho_parallel 
 rho   = p2/2 + p9/2;            
end; 
