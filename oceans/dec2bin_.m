function s = dec2bin_(x,n) 
% DEC2BIN_ - Use repeated division to convert a decimal fraction to binary
% Use As: s = dec2bin_(x,n) 
%         x = decimal fractional value to convert to binary fraction   
%         n = number of frctional binary digits to return 
% Example dec2bin_(4321.1234) 
%      ans = 1000011100001.000111111001 
     
% Copyright (c) 1996 by Moss Landing Marine Laboratories 
% 30 Sep 1995; W. Broenkow
% 23 Nov 1995 added integer part 
 
k = nargin; 
if k == 1, n = 12; end; % default number of binary digits 
 
x = abs(x);     % no negative numbers, thank you 
z = floor(x);   % integer part of number 
x = x - z;      % fractional part of number 
 
s = ''; 
if z>0 
  p1 = floor(log(z)/log(2)); 
  for p = p1:-1:0 
    y = rem(z,2^p); 
    if (z == y) 
      s = [s,'0'];     % concatenate binary digits into output string 
    else 
      s = [s,'1']; 
      z = y; 
    end 
  end 
end 
if ~exist('s') 
  s = '.'; 
else 
  s = [s,'.']; 
end 
for p = 1:n 
  y = rem(x,1/2^p); 
  if (x == y) 
    s = [s,'0']; 
  else 
    s = [s,'1']; 
    x = y; 
  end 
end      
