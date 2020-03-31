function lH = plotfill(X,Y,fcolor)

% PLOTFILL will plot the data input on the MAP and fill 
% each polygon with the specified color. X and Y must be 
% vectors the same length with NaN's separating the polygons.
%
% Use As: plotfill(X,Y,fcolor)
% Inputs: X      = vector of X data 
%         Y      = vector of Y data 
%         fcolor = color to fill polygons
% Output: Plot of data with polygons filled
%
% Also See: PLOT and FILL

% 22 Jun 98; S. Flora - Rewritten and Works in Matlab 5.2

if any(size(X) ~= size(Y))
  disp('  PLOTFILL Error (X and Y must be the same dimensions)')
  return
end

if ~any(size(X) == 1) | ~any(size(Y) == 1)
  disp('  PLOTFILL Error (X and Y must be vectors)')
  return
end

if nargin < 3
  fcolor = 'b';
end

[Mx Nx] = size(X);
if Mx == 1
  X = [NaN X NaN];
  Y = [NaN Y NaN];
elseif Nx == 1
  X = [NaN; X; NaN];
  Y = [NaN; Y; NaN];
end
ind = find(isnan(X) == 1);      % find the number of NaN's separating polygons

% remove duplicate NaN's
dind = find(diff(ind) == 1);
if ~isempty(dind)
  X(ind(dind)) = [];
  Y(ind(dind)) = [];
end
ind = find(isnan(X) == 1);      % find the number of NaN's separating polygons

for f = 1:length(ind)-1
  hold on
  xind = find(isnan(X([ind(f)+1:ind(f+1)-1])) == 1);
  yind = find(isnan(Y([ind(f)+1:ind(f+1)-1])) == 1);
  if ~isempty(xind) | ~isempty(yind)
    disp(' PLOTFILL Error')
    return
  end
  lH(f) = fillm(X([ind(f)+1:ind(f+1)-1]),Y([ind(f)+1:ind(f+1)-1]),'FaceColor',fcolor);
%  fill(X([ind(f)+1:ind(f+1)-1]),Y([ind(f)+1:ind(f+1)-1]),'g');
  hold on
end






