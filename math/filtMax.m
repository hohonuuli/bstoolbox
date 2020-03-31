function Af = filtMax(A,fsize);
% filtMedian - Max filter for 2-D arrays
%
% Use as: Af = filtMedian(A, fSize)
%
% Inputs: A = 2-D matrix
%         fSize = the size of the filterbox centerd on around each pixel
% To median filter images without distortion around edges and coastlines
%	fsize is the size of the 2-D box to be used.
%  	Assumes that land is masked as NaN (no value output to these).
%	Will change zero to NaN;

idx    = find(A==0);
A(idx) = NaN*idx;

Af     = A;
[R C]  = size(A);
buffer = floor(fsize/2);

for r = 1+buffer:R-buffer;
   for c = 1+buffer:C-buffer;
      if ~isnan(A(r,c));
         a = A([r-buffer:r+buffer],[c-buffer:c+buffer]);
         a([isnan(a) | a == 0]) = [];
         if ~isempty(a);
            Af(r,c) = max(a(:));
         end
      end
   end
end


