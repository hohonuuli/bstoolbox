function chl = calcofi_3(Rrs490, Rrs510, Rrs555)
% CALCOFI_3 - CalCOFI three band chlorphyll alogrithmn
%
% Use as: chl = calcofi_3(Rrs490, Rrs510, Rrs555)

% Brian Schlining
% 02 Jun 2000

a   = [1.025 -1.622 -1.238];
R1  = log10(Rrs490./Rrs555);
R2  = log10(Rrs510./Rrs555);
chl = exp(a(1) + a(2).*R1 + a(3).*R2);