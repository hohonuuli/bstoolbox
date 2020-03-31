function [y,c] = savgol(x,nl,nr,order)
%
% SAVGOL  Compute and apply Savitzky-Golay smoothing filter.
%
% [Y,C]=SAVGOL(X,NL,NR,ORDER) computes and applies a S-G smoothing 
% filter to the data vector X, where NL and NR are the left and 
% right span in the convolution, respectively, and ORDER is the 
% order of the filter <=> statistical moment to be preserved in
% the filtered output. 
% Returns filtered data in vector Y and the filter coefficients
% in vector C.
%
% Savitzky-Golay Smoothing filters
% Numerical Recipes in 'Computers in Physics', NOV/DEC 1990

% Rogerio Chumbinho, July 1994
% Mike Cook - NPS Oceanography Dept., OCT 94; added some
% documentation and error checking.

if nargin < 4
   error(' You MUST supply 4 input arguements')
end

[m,n] = size(x);

if m < 2  &  n < 2
   error(' Input vector MUST have more than 1 element')
end

if m < n; x=x'; end;      % Make a column vector

xwork = [ones(nl,1)*x(1);x;ones(nr,1)*x(length(x))];

A = zeros(nl+nr+1,order+1);
for i = -nl:nr
   for j = 0:order
      A(i+1+nl,j+1) = i^j;
   end;
end;

a1 = inv(A'*A); a1 = a1(1,:);
for k = -nl:nr
   for m = 0:order
      aux(m+1) = k^m;
   end
   c(k+nl+1) = a1 * aux';
end;
y = conv(xwork,c);
m = length(y);
y = y((nl+nr):(m-(nl+nr+1)));

return;
