% GAPFILL   - Fills in gaps in data record using AR innovations model
%**************************************************************************
% Copyright 1999 MBARI
%**************************************************************************
% Summary  : Fills in gaps in data record using AR innovations model
% Filename : gapFill.m
% Author   : Michael B. Matthews
% Project  : P1
% Version  : 1.00
% Created  : 17.2.99
% Modified : 
% Notes    : Version 1.0 is a simple innovations filling algorithm.
%          : It detects contiguous segments of data and fills in the
%          : gaps with the output of an innovations model created
%          : from the data of the previous segment and initialized
%          : from the previous segment. This method is clearly
%          : suboptimal since it leaves a `probability hole' at the
%          : beginning of the next segment. To address this, we
%          : run many ensembles for each gap until the last sample
%          : in the gap is `close' to the first sample in the next segment.
%          :
%          : Inputs: 
%          : u	- data vector containing gaps
%          : s	- time vector corresponding to u containing gaps 
%          : Ts	- sampling period
%          : M	- order of AR model for gap filling
%          : tc - switch 'time-to-completion' or 'none'
%          :
%          : Outputs:
%          : y	- contiguous data vector
%          : t	- contiguous time vector corresponding to y
%          : p	- segment beginning index vector
%          : q	- segment ending index vector
%          : dt	- gap width vector
%          :
%**************************************************************************

function [y,t,x,p,q,dt] = gapFill(	...
                                  u,    ...     % data vector
                                  s,    ...    	% time vector
                                  Ts,	...	% sampling period
                                  M, 	...	% model order
                                  tc	...	% time-to-completion scale
                                  )

samplingPeriod = 1;	% sampling period
threshold = 2;		% threshold for accepting gap fill ensembles 
modelOrder = 100;	% order of AR innovations model
modelData = 1000;	% length of data vector for computing AR model

if nargin < 5, tc = 'none'; end;
if nargin < 4, M = modelOrder; end;
if nargin < 3, Ts = samplingPeriod; end;
if nargin < 2, error('Error: too few arguments in function gapFill'); end;
if length(u) ~= length(s)
  error('Error: time and data vectors must be of equal length');
end

N = modelData;
Fs = 1/Ts;
T = threshold;

% Determine beginning and ending of contiguous data segments
t = s; x = u; 
k = 1; i = 2;
p(k) = k;
q(k) = length(t);
l = length(t);
while i < l
  if t(i) - t(i-1) > Ts
    dt(k) = t(i) - t(i-1);
    tBegin = t(i);
    q(k) = i - 1;
    k = k + 1;
    x = [ x(1:i-1); NaN*(t(i-1)+Ts:Ts:t(i)-Ts)'; x(i:end) ];
    t = [ t(1:i-1);     (t(i-1)+Ts:Ts:t(i)-Ts)'; t(i:end) ];
    p(k) = find(t == tBegin);
    l = length(t);
  end
  i = i + 1;
end
q(k) = length(t);
y = x;

% Print time-to-completion scale
if ~strcmp(tc,'none')
  fprintf('['); for n=1:k-1; fprintf(' '); end; fprintf(']\n '); 
  %for j=1:n+1; fprintf('\b'); end;
end

% Fill in each gap with modelled process
for i=1:k-1
  % Compute AR innovations model of data segment
  if q(i) > N, n = q(i) - N; else n = 1; end;
  [a,g] = lpc(y(n:q(i)),M);
  b = 1;

  % Compute innovations model output for ith data gap
  z = filtic(b,a,fliplr(y(n:q(i))));
  v = filter(b,a,randn(1,p(i+1)-q(i)),z)';

  % Run emsembles of innovations model until last sample is `close'
  % to first sample in next segment; this creates a `probable'
  % fill emsemble given the actual segment value.
  d = 0.1;
  while abs(v(end) - x(p(i+1))) >= T 
    z = filtic(b,a,fliplr(y(n:q(i))));
    v = filter(b,a,d*randn(1,p(i+1)-q(i)),z)';
    d = d + 0.01;
  end

  % Fill in gap in data record with synthetic data
  y([q(i)+1:p(i+1)-1]) = v(1:end-1);

  if ~strcmp(tc,'none'), fprintf('.'); end;
end

if ~strcmp(tc,'none'), disp(']'); end; 
