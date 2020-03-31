function [chi p h] = chi2kbootstrp(expected, observed, aph, n)
% CHI2KBOOTSTRP - Runa chi2k contingency table test bootstraped.
%
% Usage: 
%   [chi p h] = chi2kboostrp(expected, observed, aph, n)
%   [chi p h] = chi2kboostrp(expected, observed, aph)
%
% Inputs:
%   expected - Expected samples
%   observed - Observed samples
%   aph - Alpha level
%   n - Number of bootstrap iterations (default = 100)

if nargin < 4
    n = 100;
end

chi = ones(n, 1) * NaN;
h = chi;
kE = length(expected);
kO = length(observed);
count = 0;
for i = 1:n
    randIdx = randperm(kE);                 % random index into observed pixels
    gExpected = expected(randIdx(1:kO));    % grab the first k pixels (should be same length as nObserved)
    nExpected = histc(gExpected, bins);     % hist with sample number equal to observed
    nExpected = nExpected(1:end - 1);

    try
        [chi(i) p h(i)] = chi2ktest(nExpected, nObserved, aph);
        count = count + 1;
    catch me
        chi(i) = NaN;
        h(i) = NaN;
    end

end
fprintf(1, '\nContingency Table (%s vs %s) ...\n', eName, oName);
fprintf(1, 'Mean chi = %8.4f\n', nanmean(chi));
fprintf(1, 'Median chi = %8.4f\n', nanmedian(chi));
fprintf(1, 'Maximum chi = %8.4f\n', nanmax(chi));
fprintf(1, 'Minimum chi = %8.4f\n', nanmin(chi));
fprintf(1, 'H0 was rejected %i times of %i\n', nansum(h), count);

