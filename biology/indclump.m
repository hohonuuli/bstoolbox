function IC = indclump(X)
% INDCLUMP  - Calculate the index of clumping
% Index of clumping = Variance/mean - 1
%
% Use As: IC = indclump(X)
% Inputs: X  =  Column oriented data matrix
%
% See also INDDISP

% B. Schlining
% 18 May 1997

IC = inddisp(X)-1;