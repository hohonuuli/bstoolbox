function s = dec2bn2_(x,n) 
% DEC2BN2_ - Convert decimal integer to binary string 
% 
% Use As:  s = dec2bn2_(x,n) 
% 
% Input:   x = decimal integer to convert to binary 
%          n = number of binary digits to return 
% Output:  s = string containing the binary digits 
% 
% Example: s = dec2bn2_(4321) -> 1000011100001 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories     
% W. Broenkow; 30 Sep 1995 
% 16 Jun 96;  reduced dec2bin_.m to dec2bn2_.m integer part 
%             This function works only on scalar values 
% 31 Aug 96; added number of digits to return 
% 16 Nov 96; S. Flora - Fixed problem of returning ones to many digits 
% 11 Dec 96; S. Flora - Fixed problem I created when I fixed the digit problem 
% 19 Dec 96; S. Flora - Now returns a string if x = 0. 
 
k = nargin; 
if k == 1, n = 12; end; % default number of binary digits 
 
z = floor(abs(x));   % negative or integer part of number 
 
s = ''; 
if z > 0 
  p1 = floor(log(z)/log(2)); 
  if n > p1 
    p1 = n-1;    
  end 
  for p = (p1):-1:0 
    y = rem(z,2^p); 
    if (z == y) 
      s = [s,'0'];      % concatenate binary digits to output string 
    else 
      s = [s,'1']; 
      z = y; 
    end 
  end 
elseif z == 0 
  % Returns correct number of zeros if z = 0 
  s = setstr(48*ones(1,n)); 
end 
