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
%          : u	- data vector containing gaps (column vector)
%          : s	- time vector corresponding to u containing gaps (column vector)
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
% -------------------------------------------------------------------------------------
% The u and s vector are input wirh NaN and gapfill_ will remove them. Any index in
% in either the u or s vector with NaN's will be removed from both u and s. Even if
% only one of the two vectors has a NaN.
%
% Use As: [y,t,x,p,q,dt] = gapFill_(u,s,Ts,M,tc)
%  Inputs:  u  	- data vector containing gaps (column vector)                      With NaN's
%           s	  - time vector corresponding to u containing gaps (column vector)   With NaN's
%           Ts	- sampling period (time interval between to adjacent  observations)
%           M	  - order of AR model for gap filling - usually ~ 3-4
%           tc  - switch 'time-to-completion' or 'none'
%           Navg  - Number of projections averaged for each gap
%**************************************************************************

function [y,t,x,p,q,dt] = gapFill_(u,s,Ts,M,tc,Navg)

y = [];
t = [];
x = [];
p = [];
q = [];
dt = [];

samplingPeriod = 1;	% sampling period
threshold = 2;		% threshold for accepting gap fill ensembles 
modelOrder = 100;	% order of AR innovations model
modelData = 1000;	% length of data vector for computing AR model

if nargin < 5
  tc = 'none'; 
end;
if nargin < 4 
  M = modelOrder; 
end;
if nargin < 3, 
  Ts = samplingPeriod; 
end;
if nargin < 6, 
  Navg = 10; 
end;
if nargin < 2 
  error('Error: too few arguments in function gapFill'); 
end;
if length(u) ~= length(s)
  error('Error: time and data vectors must be of equal length');
end

% Transpose the input time and data vector if needed, all the data should be columns
[mm,nn] = size(u);
if nn ~= 1
  u = u';
end
[mm,nn] = size(s);
if nn ~= 1
  s = s';
end

% ------------------------------------------------------------------------------------------------------------------
% SECTION 1 - Project in the forward direction
% ------------------------------------------------------------------------------------------------------------------
N = modelData;
Fs = 1/Ts;
T = threshold;

% Determine beginning and ending of contiguous data segments
% This section will create a time vector in which there is no NaN's
% in the time (t) variable put there are NaN's in the data (x and y)
% variables.
%
% Example: 
%  s =       1          3         5         7        13        15        17        19    missing 9 and 11 time
%  u =   0.0125    0.3009    0.9651    0.1021    0.7173    0.8589    0.1856    0.4624
%
% If Ts == 2 which is the spacing of the time in the s vector
%  The time vector is now filled in and there are NaN in the data vector
%  t =        1         3        5         7          9        11        13        15        17        19
%  y =   0.0125    0.3009    0.9651    0.1021       NaN       NaN    0.7173    0.8589    0.1856    0.4624
%
% If Ts == 1 which is less than the spacing of the time in the s vector
% This will create the "missing" times and put NaN's in the data vector
%  t =        1         2         3         4         5         6         7         8         9        10        11        12        13       14         15       16        17         19
%  y =   0.0125       NaN    0.3009       NaN    0.9651       NaN    0.1021       NaN       NaN       NaN       NaN       NaN    0.7173       NaN    0.8589       NaN    0.1856    0.4624

t = s;
x = u;  

% Remove all the NaN's from both the s and u vectors
indx = find(sum(isnan([t x])') == 0);                   % Finds all NaN's in either U or S
t = t(indx);
x = x(indx);

k = 1;
i = 2;
p(k) = k;
q(k) = length(t);
l = length(t);
while i < l
  if t(i) - t(i-1) > Ts
    dt(k) = t(i) - t(i-1);
    tBegin = t(i);
    q(k) = i - 1;                                               % index which is 1 before the NaN
    k = k + 1;
    x = [ x(1:i-1); NaN*(t(i-1)+Ts:Ts:t(i)-Ts)'; x(i:end) ];
    t = [ t(1:i-1);     (t(i-1)+Ts:Ts:t(i)-Ts)'; t(i:end) ];
    p(k) = find(t == tBegin);
    l = length(t);
  end
  i = i + 1;
end
q(k) = length(t);                                             % Add the length of the time variable to the end
y = x;

% Print time-to-completion scale
if ~strcmp(lower(tc),'none')
  fprintf('['); 
  for n=1:k-1; 
    fprintf(' '); 
  end; 
  fprintf(']\n '); 
  %for j=1:n+1; fprintf('\b'); end;
end


WEIGTHS = repmat(0.5,length(t),1);                              % Create a wieght variable
% Fill in each gap with modelled process
for i=1:k-1
  % Compute AR innovations model of data segment
  if q(i) > N
    n = q(i) - N; 
  else  
    n = 1; 
  end;
  
  [a,g] = lpc(y(n:q(i)),M);
  b = 1;
  
  % Run emsembles of innovations model until last sample is `close'
  % to first sample in next segment; this creates a `probable'
  % fill emsemble given the actual segment value.
  ALLvs = [];
  d = nanstd(y(n:q(i)));
  for XX = 1:Navg
    % Compute innovations model output for ith data gap
    z = filtic(b,a,fliplr(y(n:q(i))));
    v = filter(b,a,d*randn(1,p(i+1)-q(i)),z)';
   
    ALLvs(:,XX) = real(v);
  end
  
  if Navg == 1
    y([q(i)+1:p(i+1)-1]) = ALLvs(1:end-1,:);
  else
    y([q(i)+1:p(i+1)-1]) = mean(ALLvs(1:end-1,:)')';
  end

  NUM = length(mean(ALLvs(1:end-1,:)')');
  WEIGTHS([q(i)+1:p(i+1)-1]) = linspace(0,1,length(WEIGTHS([q(i)+1:p(i+1)-1])));

  if ~strcmp(tc,'none'), 
    fprintf('.'); 
  end;

  ALLvs = [];
end

DATA1 = real(y.*WEIGTHS);

if ~strcmp(tc,'none')
  disp(']'); 
end; 

clear x y t WEIGTHS q p dt k i

% ------------------------------------------------------------------------------------------------------------------
% SECTION 2 - Project in the backwards direction
% ------------------------------------------------------------------------------------------------------------------
% Remove all the NaN's from both the s and u vectors
s = [1:Ts:length(s).*Ts]';
u = flipud(u);

% Remove all the NaN's from both the s and u vectors
indx = find(sum(isnan([s u])') == 0);                   % Finds all NaN's in either U or S
s = s(indx);
u = u(indx);

N = modelData;
Fs = 1/Ts;
T = threshold;

% Determine beginning and ending of contiguous data segments
% This section will create a time vector in which there is no NaN's
% in the time (t) variable put there are NaN's in the data (x and y)
% variables.

t = s;
x = u;  
k = 1;
i = 2;
p(k) = k;
q(k) = length(t);
l = length(t);
while i < l
  if t(i) - t(i-1) > Ts
    dt(k) = t(i) - t(i-1);
    tBegin = t(i);
    q(k) = i - 1;                                               % index which is 1 before the NaN
    k = k + 1;
    x = [ x(1:i-1); NaN*(t(i-1)+Ts:Ts:t(i)-Ts)'; x(i:end) ];
    t = [ t(1:i-1);     (t(i-1)+Ts:Ts:t(i)-Ts)'; t(i:end) ];
    p(k) = find(t == tBegin);
    l = length(t);
  end
  i = i + 1;
end
q(k) = length(t);                                             % Add the length of the time variable to the end
y = x;

% Print time-to-completion scale
if ~strcmp(lower(tc),'none')
  fprintf('['); 
  for n=1:k-1; 
    fprintf(' '); 
  end; 
  fprintf(']\n '); 
  %for j=1:n+1; fprintf('\b'); end;
end

WEIGTHS = repmat(0.5,length(t),1);                              % Create a wieght variable
% Fill in each gap with modelled process
for i=1:k-1
  % Compute AR innovations model of data segment
  if q(i) > N
    n = q(i) - N; 
  else  
    n = 1; 
  end;
  
  [a,g] = lpc(y(n:q(i)),M);
  b = 1;
  
  % Run emsembles of innovations model until last sample is `close'
  % to first sample in next segment; this creates a `probable'
  % fill emsemble given the actual segment value.
  ALLvs = [];
  d = nanstd(y(n:q(i)));
  for XX = 1:Navg
    % Compute innovations model output for ith data gap
    z = filtic(b,a,fliplr(y(n:q(i))));
    v = filter(b,a,d*randn(1,p(i+1)-q(i)),z)';
   
    ALLvs(:,XX) = real(v);
  end

  if Navg == 1
    y([q(i)+1:p(i+1)-1]) = ALLvs(1:end-1,:);
  else
    y([q(i)+1:p(i+1)-1]) = mean(ALLvs(1:end-1,:)')';
  end

  NUM = length(mean(ALLvs(1:end-1,:)')');
  WEIGTHS([q(i)+1:p(i+1)-1]) = linspace(0,1,length(WEIGTHS([q(i)+1:p(i+1)-1])));


  if ~strcmp(tc,'none'), 
    fprintf('.'); 
  end;

  ALLvs = [];
end

DATA2 = real(flipud(y.*WEIGTHS));
y = DATA1+DATA2;

if ~strcmp(tc,'none')
  disp(']'); 
end; 


