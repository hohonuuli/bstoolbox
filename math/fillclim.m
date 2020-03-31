function yFilled = fillclim(t, y)
% fillclim - Fill climatology. Fills gaps in data with 'statistically
%            neutral' data. Useful for pluging those annoying holes so 
% 	     that spectral analysis can be run.
%    
% Use as: yi = fillclim(t, y);
% Inputs: t = time. for this function the sample period should be monthly.
%             If you are not using monthly samples then you'll need to modify
%             the code. T should be regularly spaced!!
%	  y = samples. Use Nan For missing values. Use NaN for missing values.
% Output: yi = y with gaps filled in with comparible data.

% Brian Schlining
% 16 Mar 2000

Ts = 365.25/12;		% sampling period. Here it's monthly
Fs = 1/Ts;		% sampling frequency
nfft = 1024;		% length of FFT segment
modelOrder = 100;	% order of AR model in gap fill

good = find(~isnan(y));
y = y(good);
t = t(good);

[yFilled,t,x,iBegin,iEnd,tGap] = gapFill(y,t,Ts,modelOrder,'time-to-completion');
