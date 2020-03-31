function taur = tauray2_(lambda) 
% TAURAY2_ - Rayleigh optical thickness f(wavelength); Reaves & Broenkow (1989) 
% 
% Use As:  taur   = tauray2_(lambda)
%   
% Inputs:  lambda = wavelength (nm)  
% Outputs: taur   = Rayleigh scattering optical thickness 
%
% Example: tauray2_(443) ->  0.2392
% 
% Ref:  Broenkow and Reaves 17 Aug 89, TAU_R_OZ.MLDAT 
%       via linear regression from H.Gordon CZCS data 
% Note: This algorithm is included for reference to the CZCS era
%       atmospheric correction scheme.
%
% See Also: TAURAY_ TAURAY1_ 
 
% 05 Feb 97; M. Feinholz  
% 22 May 97; S. Flora - Added help  
 
% Original H.Gordon data [lambda tau] 
% [400 .365;450 .225;500 .145;550 .098;600 .069;650 .050;700 .037] 
 
taur = 10.^(10.205 - 4.0909.*log10(lambda)); 
