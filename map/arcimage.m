function arcimage(filename, fignum)
% ARCIMAGE  - Create an image data source for arcview from a figure
%
% Use as: arcimage(filename)
%         or arcimage(filename, fignum)
%
% Inputs: filename = the name of the ouput files to create. 2 files will
%           be produces a JPG image and a JGW world file
%         fignum = the handle or number of the figure to use
%

% Brian Schlining
% 15 Aug 2000
% Copyright MBARI 2000


H = findobj('Type','figure');
if isempty(H)
  disp('  ARCIMAGE Error (A figure must exist)')
  return
end

if nargin < 2
  fignum = gcf;
end

aH = findobj(fignum, 'Type', 'axes');

if length(aH) > 1
   disp(' ARCIMAGE warning (Multiple axes are present in the figure)');
   aH = min(aH);
end

%=========================
% Set the units to normal
%=========================
fUnits = get(fignum, 'Units');
PaperUnits = get(fignum, 'PaperUnits');
aUnits = get(aH, 'Units');
set(fignum, 'Units', 'normal', 'PaperUnits', 'normalized');
set(aH, 'Units', 'normal');

%=============================================
% Geolocate the top left corner of the figure
%=============================================
XLim = get(aH, 'XLim');
YLim = get(aH, 'YLim');
Position = get(aH, 'Position');

dX = diff(XLim); % Width of the axes in plotted units
dY = diff(YLim); % Height of the axes in plotted units

X = dX*Position(1)/Position(3);  % Distance betwen axes and left edge of figure
Y = dY*(1 - (Position(4) + Position(2)))./Position(4); % disance between axes and top of figure

Xtlc = XLim(1) - X;  % X Coordinate of top left corner in the same units as the plotted data
Ytlc = YLim(2) + Y;  % Y Coordinate of top left corner in the same units as the plotted data

%===================================================
% Get the dimensions of the figure in plotted units
%===================================================
width = dX/Position(3);  % Width of figure in plotted axes units
height = dY/Position(4); % Height of figure in plotted axes units

%============================================
% Return the units to there original settings
%============================================
set(fignum, 'Units', fUnits, 'PaperUnits', PaperUnits);
set(aH, 'Units', aUnits);

%=======================================================
% Create JPG file name (a file format Matlab can create)
%=======================================================
[p f e] = fileparts(filename);
if isempty(e)
  e = '.jpg';
end

if isempty(p)
   jpg = [f e];
   jgw = [f '.jgw'];
else
   jpg = [p filesep f e];
   jgw = [p filesep f '.jgw'];
end

print('-djpeg', jpg);

%==========================================================
% Get the number of pixels in the image and calc dx and dy
%==========================================================
A = imread(jpg,'jpg');
[nYPixels, nXPixels, col] = size(A);

dx = width/nXPixels;
dy = height/nYPixels;

%=====================
% Create the JGW file
%=====================
fid = fopen(jgw, 'wt');
fprintf(fid, '%16.14f\n', dx);
fprintf(fid, '%16.14f\n', 0);
fprintf(fid, '%16.14f\n', 0);
fprintf(fid, '%16.14f\n', dy*-1);
fprintf(fid, '%16.14f\n', Xtlc);
fprintf(fid, '%16.14f\n', Ytlc);
fclose(fid);