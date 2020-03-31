function [chi, p, h] = chi2ktest(s1, s2, a)
% CHI2KTEST - Run a Chi squared test between 2 distributions
%
% Usage:
%   [chi, p, h] = chi2ktest(s1, s2)
%   [chi, p, h] = chi2ktest(s1, s2, a)
%
% Inputs: 
%   s1 = observed sample set #1
%   s2 = observed sample set #2
%   a  = alpha (default = 0.05)
%
% Outputs:
%   chi = chi^2 test statistic
%   p   = p-value or level of signifigance. The number returned is the smallest significance level 
%         at which one can reject the null hypothesis that the observed counts conform to the same 
%         distribution
%   h   = 

if nargin < 3
    a = 0.05;
end

% Apache math chokes if a category has a 0 value in both s1 and s2
good = intersect(find(s1 ~= 0), find(s2 ~= 0));
s1 = s1(good);
s2 = s2(good);

chisquaretest = org.apache.commons.math3.stat.inference.ChiSquareTest();
try
    chi = chisquaretest.chiSquareDataSetsComparison(s1, s2);
    p = chisquaretest.chiSquareTestDataSetsComparison(s1, s2);
    h = chisquaretest.chiSquareTestDataSetsComparison(s1, s2, a);
catch me
    chi = NaN;
    p = NaN;
    h = NaN;
    warning(['bstoolbox:' mfilename], me.message);
end
