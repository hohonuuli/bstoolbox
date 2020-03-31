function chl = oc2v2(LU_490,LU_555)
% OC2V2     - Modified ocean chlorphyll 2 algorithm 
%
% OC2V2 calculates ocean chlorphyll from in water upwelled radiance (Lu).
% The algorithm is from Stephane Maritorena <stephane@calval.gfsc.nasa.gov>
%
% It's modified in that the original algotithm uses:
%        R = log(Rrs_490/Rrs_555) where Rrs is the remote reflectance ratio
%
% Be aware:
%        R = log(Lu_490/Lu_555) as an approximation gives values that are closer to 
%        morel's algorythmn (at least for equatorial data).
%
% Use as: c = oc2v2(LU_490, LU_555)
%
% Inputs: LU_490 = Upwelled radiance at 490 nm
%         LU_555 = Upwelled radiance at 555 nm
%         Note: the units of LU490 and LU_555 are not important.
%         however they must be the same for both inputs
%
% Output: chl = Chlorophyll (ug/L)

% Brian Schlining
% 15 jan 1999


% Calculate chlorophyll
a      = [0.2974 -2.2429 0.8358 -0.0077 -0.0929];
R      = log10(LU_490./LU_555);
chl    = 10.^(a(1) + a(2).*R + a(3).*R.^2 + a(4).*R.^3) + a(5);

% Remove the complex numbers
%i      = find(chl < 0);
%chl(i) = real(chl(i));