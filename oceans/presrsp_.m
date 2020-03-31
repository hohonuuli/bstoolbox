function t = presrsp_(npairs,period,Z,height) 
% PRESRSP_ - Compute the pressure transfer function for wave spectra 
%            made with pressure sensors. 
% 
% Use As:   tf = presrsp_(npairs,period,Z,height) 
% 
% Input:    npairs = number of spectral estimates power of two 
%           period = sampling interval (s) 
%           Z  = water density_ in (m) 
%           height = sensor height above bottom (m) 
% Output:   tf     = transfer function as a column vector 
% 
% Example:  tf     = presrsp_(128,.5,15.5,5.7) 
% 
% Note:     The pressure transfer function is squared when 
%           it is applied to correct the spectral estimates. 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 27 Apr 96; W. Broenkow  Results are 'close' to PC wavefun.for from which 
%                         it was copied.  PC version used REAL*4 values.  
% 16 Oct 96; W. Broenkow  fixed incorrect polynomial evaluation, now agrees with PC wavefun 
 
t = ones([npairs,1]); 
if Z == 0 
  return 
end 
     g = 9.81; 
cutoff = 10; 
     t = cutoff*t;       % set transfer function to cutoff value 
 dfreq = pi/(period*npairs); 
     c = [1, 0.66667,0.3555,0.16084,0.0632,0.02174,0.00654,0.00171,0.00039,0.00011]; 
  t(1) = 1.0; 
 for i = 2:npairs 
    freq = (i-1)*dfreq; 
       y = Z*freq*freq/g; 
     arg = polyval(fliplr(c),y);    % polyval evaluates with highest order value first 
     arg = g*Z/(y+1/arg); 
    wavn = freq/sqrt(arg); 
     rsp = cosh(wavn*Z)/cosh(wavn*height); 
     if rsp < cutoff 
       t(i,1) = rsp; 
     else 
       break              % leave remainder of values at cutoff value 
    end 
  end 
 
