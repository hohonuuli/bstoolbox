function rndM = rnd_int(M,N,MinRange,MaxRange)
% RND_INT   - Random integer generator
%
% Use as: rnd_int(NumberOfRows, NumberOfColumns, MinRange, MaxRange)
%
% Outputs: Returns a matirx of randomly generated integers
%          of size(NumberOfRows, NumberOfColumns) between 
%	   MinRange and MaxRange
%
% Requires the Statistical toolbox

% Brian Schlining
% 6 Aug 96

MinRange = ones(M,N).*MinRange;
rndM = unidrnd((MaxRange-MinRange + 1),M,N) + MinRange - 1;
