function outS = leadzero(inS,n)
% LEADZERO  - Add a leading zero to a string if it is not long enough
% Very useful when date forms of 01/03/98 are needed
%
% Use as: outS = leadzero(inS,n)
% Inputs: inS  = The String of numerical data (ex. '7')
%         n    = desired length (ex. 3)
% output: outS = inS padded to length n with leading zeros
%
% example: leadzero('7',3)
%          ans = '007'

[r c] = size(inS);
X     = abs(inS);

d = n - c;
if d > 0
   X    = [ones(r,d)*48 X];
   outS = setstr(X);
else
   outS = inS;
end
