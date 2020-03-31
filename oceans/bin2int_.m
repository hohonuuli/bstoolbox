function y = bin2int_(x,option) 
% BIN2INT_ - Convert binary value to integer.   
%           This function is useful to store flags, contents of status 
%           registers and other binary data. 
% 
% Use As:  y = bin2int_(x) 
% 
% Input:   x      = integer array of bit positions [0 .. N] 
%                   or string containing '0' and '1' 
%                   or numeric value containing 0s & 1s 
%          option = flag to indicate conversion of bit values 
%                   if option == 0 use numeric or value containing only 0s & 1s 
%                                  with LSD towards the RIGHT 
%                   if option == 1 use array containing bit positions of 1s 
%                   if option == 2 use array containing numeric values;  
%                                  positive non-zero values are interpreted as 1s 
%                                  negative and zero values are interpreted as 0s 
%                                  with LSD as the FIRST or LEFT-MOST element in the array 
% 
% Output:  y      = integer formed from vector of set bit positions or binary string 
% 
% Examples  y = bin2int_(111000011111110,0)  -> 28926   
%           y = bin2int_([1:7 12:14],1)      -> 28926 
%           y = bin2int_([1 0 2 0 3 -1 1],2) -> 85 
%           s = dec2bn2_(28926)              -> 111000011111110 
% 
% NOTE:  The integers are stored as double precision numbers. The 
%        limit of bit values that can be stored is 2^54 which allows 
%        the binary array to be 54 bits long. 
% 
% See Also:  DEC2BIN_, DEC2BN2_, ISBTSET_ 
 
% Copyright (c) 1996 by Moss Landing Marine Laboratories     
% 31 Aug 1996; W. Broenkow 
 
if nargin == 1 
  option = 0;    % string or numeric value of 0s and 1s 
end 
if option > 2 
  disp('BIN2INT Error: Range of valid options is 0, 1 or 2') 
  return 
end 
[m,n] = size(x); 
 
if option == 1 
  if max(x)> 54 
    disp('BIN2INT Error: Maximum input value is 54') 
    return 
  end 
  if min(m,n)>1 
    disp('BIN2INT Error: Input array must be single dimensioned vector') 
    return 
  end 
  if min(x) < 0 
    disp('BIN2INT Error: Positive integers only in input array') 
    return; 
  end 
  frcx = x - floor(x); 
  index = find(frcx ~= 0); 
  if any(index) 
    disp('BIN2INT Error: Integers only in input array') 
    return; 
  end 
  y     = sum(2.^x); 
  return 
end 
 
if option == 0 
  if ~isstr(x)                % then convert to string 
    if max(m,n) > 1 
      disp('BIN2INT Error: Input must be a scalar') 
      return;     
    end 
    sx = num2str(x,16); 
  else 
    sx = x;     
  end 
  L = length(sx); 
  for i = 1:L 
    if sx(1,i) ~= '0' & sx(1,i) ~= '1' 
      disp('BIN2INT Error: Input must contain only binary digits 0 & 1'); 
    return; 
    end 
  end 
  y = 0;                     % this method is not very clever 
  for i = 1:L                % should be vectorizeable  
    p = L - i; 
    if (sx(1,i) == '1') 
      y = y + 2^p; 
    end 
  end 
  return 
end 
 
if option == 2 
  L = max(m,n); 
  if m > 1 & n > 1 
    disp('BIN2INT Error: Input vector must be 1-dimensional') 
    return 
  end 
  if m > n 
    x = x' 
  end 
  y = 0; 
  for p = 1:L 
    if (x(1,p) > 0)          % positive and non-zero values are  
      y = y + 2^(p-1);       % interpreted as 1s 
    end 
  end 
end   
   
