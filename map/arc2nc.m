function arc2nc(infile, outfile)
% ARC2NC    - Convert ArcView ascii raster data to netcdf format
%
% Use as: arc2nc(infile, outfile)
%
% Inputs: infile = filename of the arc raster data to read
%         outfile = filename of the netcdf file to create

% Brian Schlining
% 03 May 2001

[x y z] = readArcRaster(infile);
%load arc2nc_test

ncfile = netcdf(outfile, 'clobber');

% Define global attributes
ncfile.conventions = 'COARDS';
d = java.util.Date;
ds = char(d.toString)
ncfile.creationDate = ds
ncfile.lastModified = ds
ncfile.description = ['Grid of geolocated data created from ' infile ' using arc2nc.m.'];

% Define dimensions
ncfile('latitude') = length(y);
ncfile('longitude') = length(x);

% Define Co-ordinate variables
ncfile{'latitude'} = ncfloat('latitude'); %% 1 element.
ncfile{'latitude'}.long_name = ncchar('Latitude');
ncfile{'latitude'}.units = ncchar('degrees_north (+N/-S)');

ncfile{'longitude'} = ncfloat('longitude'); %% 1 element.
ncfile{'longitude'}.long_name = ncchar('Longitude');
ncfile{'longitude'}.units = ncchar('degrees_east (+E/-W)');

ncfile{'depth'} = ncfloat('longitude', 'latitude');
ncfile{'depth'}.long_name = ncchar('Depth');
ncfile{'depth'}.units = ncchar('meters');
ncfile{'depth'}.missing_value = ncfloat(NaN);
ncfile{'depth'}.positive = ncchar('up');

% Write the data
ncfile{'latitude'}(:) = y;
ncfile{'longitude'}(:) = x;
ncfile{'depth'}(:) = z;

ncquit(ncfile)