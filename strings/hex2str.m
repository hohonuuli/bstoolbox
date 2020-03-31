function str = hex2str(hex)
% HEX2STR - Utility for converting an array of hex characters to ascii
%
% Use as: s = hex2str(h)
% 
% Inputs: h = hex string (ex. '53454e44')
% Output: s = ascii output (ex. 'SEND')

% Brian Schlining
% 11 Sep 2000

if ~isstr(hex)
   error('HEX2STR error: input is not a string');
end

n = length(hex);  % Get the number of characters (i.e number of 4-bit words)

if rem(n, 2)      % If length is odd then there's an extra charater...ignore it
   warning('HEX2STR warning: string has an extra word (i.e 4 bits). Last character of input string is being ignored.');
   n = n - 1;
   hex = hex(1:n);
end

dec = ones(1, n/2); % Initalize intermediate (decimal ascii) memory

for i = 1:n/2
   a = i*2 - 1;
   b = a + 1;
   dec(i) = hex2dec(hex(a:b));
end

str = setstr(dec);
   
   

