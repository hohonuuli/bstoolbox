function [chi, df] = chi2Ktable(x1, x2)
% chi2ktable - Chi-squred test for consitency in a 2xK table
%
% Use as: [chi df] = chi2Ktable(x1, x2)
% Inputs: 
%   x1 The first group
%   x2 the second group
%
% Reference: G.K Kanji. Statistical Tests. 1993. SAGE Publications Inc. p. 75-76
%
% Example:
%    n1 = [50 56 56];
%    n2 = [5 14 8];
%    [chi df] = chi2ktable([n1; n2]);
%    % chi = 4.84, df = 2

if nargin == 1
    samples = x1;
else
    [rows1 , columns1]  =  size(x1);
    [rows2 , columns2]  =  size(x2);
    
    if (rows1 ~= 1) & (columns1 ~= 1)
        error('chi2Ktable:VectorRequired','Sample X1 must be a vector.');
    end
    
    if (rows2 ~= 1) & (columns2 ~= 1)
        error('chi2Ktable:VectorRequired','Sample X2 must be a vector.');
    end
    
    samples = [x1(:) x2(:)]';
    
end



totals = sum(samples);
N = sum(samples, 2);
Nt = sum(N);
expected = [N(1) .* totals ./ (Nt); N(2) .* totals ./ (Nt)];
chi = sum(sum(((samples - expected) .^ 2) ./ expected));
df = size(samples, 2) - 1;