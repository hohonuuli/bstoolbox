function status = isbtset_(XX,Y,Z) 
 
% ISBTSET_- Tests whether a binary value is included in a test value. 
% 
% Use As:  status = isbtset_(X,Y) 
% Input:        X = the value or vector to be tested 
%               Y = the binary value sought 
%               Z = (optional) Can be set to look for binary numbers  
%                   greater than 2^20 = 1048576, the default 
%                   maximum size 
% Output:  status = result of the bit test 
%                   1 = binary value Y is found in X 
%                   0 = the binary value Y is not found in X 
% Example:  isbtset_(37,4) -> 1   because 37 = 32 + 4 + 1 
%           isbtset_(37,8) -> 0 
% 
% NOTE: Numbers which are not powers of two will always return a 0 
 
% 08 Jul 96; W. Broenkow 
% 10 Jul 96; S. Flora - added loop so work on vector inputs 
% 22 Jun 98; S. Flora - Rewritten and Works in Matlab 5.2
 
if nargin <3 
  Z = 20;          % this value is used to form a binary string
 
end                % larger than the largest number to be bit tested 
 
if nargin == 0 
  help isbitset 
  return 
end 
 
if nargin < 2 
  disp('  ISBTSET_ Error (Function requires 2 inputs)') 
  return 
end 
%*************************************************************** 
 
XX = abs(XX); 
for b = 1:length(XX) 
  X = XX(b); 
  bits = 2.^abs(findstr(dec2bn2_(X + 2^Z ),'1') -(Z+1)); 
 
  F = find(bits==Y); 
  if F > 0 
    status(b) = 1; 
  else 
    status(b) = 0; 
  end 
end 
