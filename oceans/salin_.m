function yyy = salin_(R,T,P) 
% SALIN_ -  Conversion of conductivity ratio to practical salinity 
% 
% Use As:   S = salin_(R,T,P) 
% 
% Input:    R = Conductivity Ratio 
%           T = Temperature (C) 
%           P = Pressure (db)  
% Output:   S = Practical Salinity (psu or ~ g/kg) 
% 
% Example:  salin_(.87654,12.345,1234) -> 31.9077 
%           salin_(0.65,5,1500)        -> 27.9953479 UNESCO 44 p9
% 
% See Also: LABSAL_
% Ref: UNESCO Tech Paper Mar Sci 44 (1983) 

% Copyright (c) 1996 by Moss Landing Marine Laboratories  
% W. Broenkow 28 June 1994 from 
% MLLIB SOURCE NAME:  UNESCO_83.FOR 
% B. Schlining 30 Aug 2000; Bug fix: a zero or negative anywhere in R will screw up
%  all salinities. Workaround is to find zeros at the start and replace 
%  with NaN's

bad = find(R <= 0 | isinf(R) | isnan(R));
R(bad) = 1;
 
if nargin == 2 
  P = zeros(size(R)); 
end 
 
a = [0.0080, -0.1692, 25.3851, 14.0941, -7.0261, 2.7081]; 
b = [0.0005, -0.0056, -0.0066, -0.0375, 0.0636, -0.0144]; 
c = [0.6766097, 2.00564E-2, 1.104259E-4, -6.9698E-7, 1.0031E-9]; 
d = [3.426E-2, 4.464E-4, 4.215E-1, -3.107E-3]; 
e = [2.070E-5, -6.370E-10, 3.989E-15]; 
k = [0.0162]; 
 
rt   = c(1)+(c(2)+(c(3)+(c(4)+c(5).*T).*T).*T).*T;   % eq 3 
D    = 1+(d(1)+d(2).*T).*T+(d(3)+d(4).*T).*R ; 
E    = (e(1)+(e(2)+e(3).*P).*P).*P; 
Rp   = 1+E./D;                                    % eq 4 
% if (R./(Rp.*rt) > 0) 
%   RRt = sqrt(R./(Rp.*rt));                        % use root Rt
%  
% else 
%   RRt = 0; 
% end 
RRt = ones(size(rt));
i = find(R./(Rp.*rt) > 0);
RRt(i) = sqrt(R(i)./(Rp(i).*rt(i)));                        % use root Rt
i = find(R./(Rp.*rt) < 0);
RRt(i) = 0;

B    = b(1)+(b(2)+(b(3)+(b(4)+(b(5)+b(6).*RRt).*RRt).*RRt).*RRt).*RRt; 
delS = (T-15).*B./(1+k.*(T-15));                    % eq 2 
 
yyy = a(1)+(a(2)+(a(3)+(a(4)+(a(5)+a(6).*RRt).*RRt).*RRt).*RRt).*RRt+delS;  % eq 1 
 
if (yyy < 0.0)  
  yyy = 0.0; 
end 

yyy(bad) = NaN;
