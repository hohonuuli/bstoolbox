function sdn = xl2sdn(xl)
% XL2SDN    - Convert Excel time to matlab's date format
%
% Use as: sdn = xl2sdn(xl);

% Brian Schlining
% 17 Apr 2000

sdn = xl + 693960;
