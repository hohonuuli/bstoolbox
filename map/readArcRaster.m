function [X, Y, Z] = readArcRaster(filename)
% readArcRaster - create an arcview ASCII raster file from gridded data
% (UTM grids only)
%
% Use as: [X, Y, Z] = readArcRaster(filename);
%         [X, Y, Z] = readArcRaster; % Opens selection dialog
%
% Inputs: filename = name of the file to read
%
% Output:   x = lon vector
%           y = lat vector
%           z = value grid


% Brian Schlining
% 03 May 2001

%===========
% Open File
%===========
if ~nargin | isempty(filename)
   [infile inpath] = uigetfile('*.*','Select ASCII Grid file');
   if infile == 0
      y = [];
      return                            % Return if CANCEL is selected
   end
   filename = [inpath infile];
end

fid  = fopen(filename,'rt');
if fid < 0
   error(['Unable to open file ' filename])
end

fprintf(1, 'Reading %s...\n', filename);

fid = fopen(filename, 'rt');
buf = fgetl(fid);
ncols = sscanf(stringtokenizer(buf, 2), '%f');
buf = fgetl(fid);
nrows = sscanf(stringtokenizer(buf, 2), '%f');
buf = fgetl(fid);
xllcorner = sscanf(stringtokenizer(buf, 2), '%f');
buf = fgetl(fid);
yllcorner = sscanf(stringtokenizer(buf, 2), '%f');
buf = fgetl(fid);
cellsize = sscanf(stringtokenizer(buf, 2), '%f');
buf = fgetl(fid);
nodatavalue = sscanf(stringtokenizer(buf, 2), '%f');

%X = xllcorner:cellsize:xllcorner + (cellsize * (ncols - 1));
X = linspace(xllcorner, xllcorner + (cellsize * ncols), ncols);
%Y = [yllcorner:cellsize:yllcorner + (cellsize * (nrows - 1))]';
%Y = flipud(linspace(yllcorner, yllcorner + (cellsize * nrows), nrows)');
Y = linspace(yllcorner, yllcorner + (cellsize * nrows), nrows)';

Z = fscanf(fid, '%f');
Z = reshape(Z, ncols, nrows)';
Z(Z == nodatavalue) = NaN;
Z = flipud(Z);