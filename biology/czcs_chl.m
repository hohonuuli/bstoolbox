function chl = czcs_chl(Lw550, Lw443)
% CZCS_CHL  - Calculate Chl using CZCS algorythmn
%
% Use as: chl = czcs_chl(Lw443, Lw550)
%
% Inputs: Lw443 = Water leaving radiance at 443nm
%         Lw550 = Water leaving radiance at 550nm
%
% Output: chl = Chlorophyll concentration (ug/l)

% Brian Schlining
% 01 Feb 2000

% CZCS Chl: log10(C) = 0.053 + 1.71*log10(Lw550/Lw443)
chl = 10.^(0.053 + 1.71*log10(Lw550./Lw443));