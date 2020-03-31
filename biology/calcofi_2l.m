function chl = calcofi_2l(Rrs490, Rrs555)
% CALCOFI_2L - CalCOFI two band linear chlorphyll alogrythmn
%
% Use as: chl = calcofi_2l(Rrs490, Rrs555)

% Brian Schlining
% 02 Jun 2000

a = [0.444 -2.431];
chl = 10.^(a(1) + a(2)*log10(Rrs490./Rrs555));