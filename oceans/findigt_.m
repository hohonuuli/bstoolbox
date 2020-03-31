function P = findigt_(STR) 
% FINDIGT_- Return position or all digits 0..9 in the input string
% 
% Use As:  position = findigt_(str) 
% Input:        str = character string 
% Output:  position = array of indicies to the string where digits are found 
%
% Example:  findigt_('abcd ; 2 4 6?') -> [8 10 12]    
 
%  9 Jul 96 W. Broenkow; 
 
N = abs(STR); 
P = find(N>47 & N<58);     
 
