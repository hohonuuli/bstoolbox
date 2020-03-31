function ID = inddisp(X)
% INDDISP   - Calculate index of dispersion
%
% Use As: ID = inddisp(X)
% Inputs: X  = matrix of column grouped data
% Output: ID = index of dispersion
%
% Requires STATISTICAL toolbox, see also GREENIND, INDCLUMP

% B. Schlining
% 18 May 1997

VAR  = nanstd(X);	% std is the sqrt fo the var
VAR  = VAR.*VAR;
MEAN = nanmean(X);
ID   = VAR./MEAN;