function a = comparedist(expected, observed, bins, aph, n, eName, oName, y_label)
% COMPAREDIST - Run statistics to compare 2 distributions.
%
% This function is used to compared 2 different distributions. for exmaple,
% if you want to see if the depth of observations is different than all the
% depth pixels in a grid.
%
% Usage:
%   a = comparedist(expected, observed, bins, alpha)
%   a = comparedist(expected, observed, bins, alpha, n)
%   a = comparedist(expected, observed, bins, alpha, n, eName, oName, y_label)
%
% Inputs:
%   expected = the larger number of measurements. e.g. The depths of all pixels
%              in a grid. These should not be binned but individual values.
%   observed = the smaller number of measurements. e.g. The depths of sightings
%              of Calyptagena. These should not be binned but individual values.
%   bins  = The edges of the bins to to use when running a contigency table
%   alpha = The alpha level to use for hypothesis testing (Default = 0.05)
%   n = The number of bootstraps to run (Default = 25)
%   eName = the name to use on plots of the expected value (Default = 'expected')
%   oName = the name to use on plots of the observered values (Default = 'observed')
%   y_label = THe ylabel to use on the axes of the plots

% Brian Schlining
% 2012-05-01

if nargin < 8
    y_label = '';
end

if nargin < 7
    oName = 'Observed';
end

if nargin < 6
    eName = 'Expected';
end

if nargin < 5
    n = 25;
end

if nargin < 4
    aph = 0.05;
end

expected = expected(:);
expected = expected(~isnan(expected));

observed = observed(:);
observed = observed(~isnan(observed));

binCenters = (bins(1:end - 1) + bins(2:end)) / 2;
dz = mean(diff(bins));

nExpected = histc(expected, bins);
nExpected = nExpected(1:end - 1);
nObserved = histc(observed, bins);
nObserved = nObserved(1:end - 1);

fExpected = nExpected ./ nansum(nExpected);
fObserved = nObserved ./ nansum(nObserved);

figure
subplot(1, 2, 1)
barh(binCenters, [fExpected fObserved], 1)
xlabel('Frequency')
legend(['Expected [' eName ']'], ['Observed [' oName ']'])
ylabel(y_label);

subplot(1, 2, 2)
barh(binCenters, [nExpected, nObserved], 1);
xlabel('Counts')
set(gcf, 'PaperPosition', [0 0 10 8]);
print('-dpng', [mfilename '_' num2str(dz) '-' eName '-vs-' oName '.png']);

[h p ksstat] = kstest2(expected, observed);
if h == 0
    ar = 'Accept H0';
else
    ar = 'Reject H0';
end
fprintf(1, '\nKSTEST2 (%s vs %s) ... \n', eName, oName);
fprintf(1, 'D = %.5f\n', ksstat);
fprintf(1, 'p = %.8f\n', p);
fprintf(1, 'df = %i\n', length(expected) + length(observed));
fprintf(1, 'H = %i (%s)\n', h, ar);

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
    %chi(i) = chi2ktable(nExpected, nObserved);
    %fprintf(1, '%i\t%8.4f\n', i, chi(i));
    try
        [chi(i) p h(i)] = chi2ktest(nExpected, nObserved, aph);
        count = count + 1;
    catch me
        chi(i) = NaN;
        h(i) = NaN;
    end
    %fprintf(1, '\tReject = %i\tp = %.5f\tchi=%8.4f\n', h, p, chi2);
end
fprintf(1, '\nContingency Table (%s vs %s) ...\n', eName, oName);
fprintf(1, 'Mean chi = %8.4f\n', nanmean(chi));
fprintf(1, 'Median chi = %8.4f\n', nanmedian(chi));
fprintf(1, 'Maximum chi = %8.4f\n', nanmax(chi));
fprintf(1, 'Minimum chi = %8.4f\n', nanmin(chi));
fprintf(1, 'H0 was rejected %i times of %i\n', nansum(h), count);


nExpected = histc(expected, bins);
[chi p h] = chi2ktest(nExpected, nObserved, aph);
fprintf('\nChi2 test of original data ...\n');
fprintf('chi = %8.4f\n', chi);
fprintf('p   = %8.4f\n', p);
fprintf('h   = %i', h);
if h == 1
    s = 'Reject H0';
    fprintf(sprintf(' (H0 is rejected - distributions are different at alpha = %f)\n', aph));
else
    s = 'Accept H0';
    fprintf(sprintf(' (H0 is accepted - distributions are the same at alpha = %f)\n', aph));
end