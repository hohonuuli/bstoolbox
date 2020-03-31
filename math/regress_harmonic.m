function [Y, a, r2, p] = regress_harmonic(t, y, T)
% REGRESS_HARMONIC  - fits data to sin Wt cos Wt + C 
%
% Use as: [Y, a, r, p] = regress_harmonic(t, y)
%         [Y, a, r, p] = regress_harmonic(t, y, T)
%
% Inputs: t = vector of times of each sample 
%         y = vector of measurements at times t
%         T = period to fit curve to. The units must be in the 
%             same units as t. Default is T = 31536000 seconds (1 year)
%
% Output: Y = fitted values at times in t
%         a = coefficients
%         r = r^2 correlation coefficient
%         p = p-value

% Brian Schlining
% 11 May 1998
% 27 May 1998; a is now a row vector, not a column vector

% Convert row vectors to columns
[rt ct] = size(t);
if (rt > 1 & ct > 1)
   error('REGRESS_HARMONIC only accepts vectors as inputs')
elseif (ct > 1 & rt == 1)
   t = t';
end

% Convert row vectors to column
[ry cy] = size(y);
if (ry > 1 & cy > 1)
   error('REGRESS_HARMONIC only accepts vectors as inputs')
elseif (cy > 1 & ry == 1)
   FLAG = 'on';            % Flag for vectors that have been transposed
   y = y';
else
   FLAG = 'off';
end

% Make sure vectors are the same length
if length(t) ~= length(y)
   error('Vectors t and y must be the same length');
end

if nargin == 2
   T = 365*24*60*60;       % Period of a year in seconds; d/y * h/d * m/h * s/m
end

Omega = 2*pi/T;            % Angular Frequency for period T

% X = sin(Omega*T) + cos(Omega*t) + C
X = [sin(Omega*t) cos(Omega*t) ones(size(t))];  % Create matrix
a = (X\y)';                                        % matrix math; matlab uses Gaussian elimination

% Calculate the resulting curve at times equal to t
Y = a(1)*sin(Omega*t) + a(2)*cos(Omega*t) + a(3);

% get the correlation coefficient, matlab returns a triangularly symmetrical matrix
% with the diagonal equal to 1.
r = corrcoef(y,Y);
r2 = r(2)*r(2);

%==================================================================
% Calculate Statistics - analysis of variance
% From Pollard, J. H., Numerical and Statistical Techniques, 
% Cambridge University Press, Cambridge, pg 281, 1977
%==================================================================
n = length(t);    % length of input vector
v = length(a);    % lenght of coefficeint vector

total_SS = y'*y - n*mean(y).^2;
total_DF = n - 1;

regression_SS = a*X'*y - n*mean(y).^2;        % Sum of squares
regression_DF = v - 1;                       % Degrees of Freedom
regression_MS = regression_SS/regression_DF; % Mean Square

residual_SS = total_DF - regression_DF;
residual_DF = n - v;
residual_MS = residual_SS/residual_DF;

% Get F(alpha,V1,V2) where: alpha = confidence interval, V1 = regression_DF,
% and V2 = residual_DF
if (residual_SS ~=0 )
   F = regression_MS./residual_MS;
   p = fcdf(F,regression_DF,residual_DF);     % Probability of F given equal means.
elseif (regression_SS==0)       % Constant Matrix case.
   F = 0;
   p = 1;
else                            % Perfect fit case.
   F = Inf;
   p = 0;
end
%=====================================================================

% If the flag is on transpose Y to the same orientation is the input y
if strcmp(FLAG,'on')
   Y = Y';
end

% Print out the goodies
fprintf(1,'\n  y = %3.4f*sin Wt + %3.4f*cos Wt + %3.4f\nr^2 = %3.4f\n', a(1), a(2), a(3), r2)
fprintf(1,'  p = %3.4f\n',p)
fprintf(1,'                         SS      DF      MS          F\r')
%fprintf(1,'__________________________________________________________________\n')
fprintf(1,'Total                  %3.4f   %4i              %3.6f \n',total_SS,total_DF,F)
fprintf(1,'  Harmonic regression  %3.4f   %4i   %3.4f\n',regression_SS,regression_DF,regression_MS)
fprintf(1,'  Residual             %3.4f   %4i   %3.4f\n\n',residual_SS,residual_DF,residual_MS)

