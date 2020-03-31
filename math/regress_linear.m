function [a, r] = regress_linear(X,Y)
% REGRESS_LINEAR - fits data to y = mx + b 
%
% Use as: [a r] = regress_linear(X,Y)
% Inputs: X = independant variable (ex. Time)
%         Y = dependant variable (ex. tidal height)
% Output: a = [slope
%              intercept]
%         r = r-squared

% % Copyright (c) 1998 Brian Schlining
% 12 May 1998

[rx cx] = size(X);
if (rx > 1 && cx > 1)
   error('REGRESS_LINEAR only accepts vectors as inputs')
elseif (cx > 1 && rx == 1)
   X = X';
end

   
[ry cy] = size(Y);
if (ry > 1 && cy > 1)
   error('REGRESS_LINEAR only accepts vectors as inputs')
elseif (cy > 1 && ry == 1)
   Y = Y';
end

XX = [X ones(size(X))];
a = XX\Y;
r = corrcoef(X,Y);
r = r(2)*r(2);

fprintf(1,'\ny   = %3.7f * X + %3.7f\nr^2 = %3.4f\n', a(1), a(2), r);
