function L = planck_(T,lmbda)
% PLANCK_ - Evaluate Planck's black-body spectral radiance function
%
% Use As:   L = planck_(T,lmbda)
% 
% Input:    T = blackbody temperature (Kelvin)
%       lmbda = wavelength (m)
% Output:   L = spectral radiance (W/m^2 m sr)
%
% Example:  L = planck_(6000,[300:5:700]*1e-9) 
%               The visible solar spectrum at 5 nm intervals. 

% 16 Feb 93; W. Broenkow
%  8 Aug 97; W. Broenkow added to ocean library

h = 6.626076e-34;  % Planck constant    (Joule sec)
k = 1.380658e-23;  % Boltzmann constant (Joule/Kelvin)
c = 2.99792458e8;  % speed of light     (m/sec)
hc = (2*h*c^2)./(lmbda.^5);
e  = h*c./(lmbda.*k*T);
y  = exp(e)-1;
L  = hc./y;

