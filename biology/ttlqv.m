function VAR = TTLQV(X)
% TTLQV     - Two-term local quadrant variance
% Method of species pattern analyisis with varying block sizes
%
% Use As: VAR = TTLQV(X)
% Inputs: X   = matrix of column oriented data
%	        if TTLQV is used with out arguments, it will prompt
%	        the user to select a tab delimited file
% Output: VAR = Matrix with same number of columns as X, with a number
%               of rows equal to the maximum bin size, bin size always
%		starts at 1. Maximum binsize is set equal to 10% of the 
%		total data points. (i.e. 100 data points in a column 
%		will give a max bin size of 10.) This is the two-term 
%	  	local quadrant variance

% Read in file
if nargin == 0
   [infile, inpath] = uigetfile('*.*','Choose Data FIle',0,0);
   X                = dlmread([inpath infile],'\t');
end

% Cut off the matrix wherever you find the NaN's. This is not very
% sophiticated so it may cause errors
[NaNx, NaNy] = find(isnan(X));
if ~isempty(NaNx)
   CutOff       = min(min(NaNx)) - 1;
   X            = X(1:CutOff,:);
end

% Using bins that are greater than 10% of the total data points 
% is invalid. STOP cuts off binning over 10%
[m n] = size(X);
STOP  = ceil(m/10);

% This is the guts
for BinSize = 1:STOP
   % df and wf are multipliers
   df = 1./(m - (BinSize.*2 - 1));
   wf = 1./(2.*BinSize);
   for i = 1:floor(m - BinSize*2 + 1)
      if BinSize == 1		% SUM of a vector gives a scalar
         Buf1  = ((X(i:(i+BinSize-1),:)) - ...
                 (X((i+BinSize):(i+2*BinSize-1),:))).^2;
         if i == 1
            Crap = Buf1;	% must assign Crap initially
         else
            Crap = Crap + Buf1; % Keep adding on to Crap
         end
      else
         Buf1  = (nansum(X(i:(i+BinSize-1),:)) - ...
                 nansum(X((i+BinSize):(i+2*BinSize-1),:))).^2;
         if i == 1
            Crap = Buf1;
         else
            Crap = Crap + Buf1;
         end
      end
   end
   Buf = df.*wf.*Crap;
   if BinSize == 1
      Var = Buf;
   else
      Var = [Var; Buf];
   end
end

VAR     = Var;
