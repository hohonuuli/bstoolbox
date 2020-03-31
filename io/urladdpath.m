function urladdpath(p)
%URLADDPATH(MYURLFILE) Add a URL file to the MATLAB path.
%  URLADDPATH gets a URL file from the internet onto the MATLAB path 
%  so that the file can be used by MATLAB. If the URL points to a 
%  zip file, the file will automatically unzip.
%
%  Use URLPATH with no arguments to display current path.
%
%  Use URLPATH -refresh to refresh a download. See urlpath m-help 
%  for more details.
%
%  Examples:
%
%  % Get an m-file
%  urladdpath ftp://ftp.mathworks.com/matlab/contrib/v4/math/mandel.m
%  mandel % run m-file 
%
%  % Get an application from MATLAB Central 
%  urladdpath http://www.mathworks.com/matlabcentral/files/705/viking.zip
%  vikingplot % run m-file 
%
%  urlpath % output the current URL path
%
%  See also URLPATH.

% Copyright 2004 Joe Conti

urlpath(urlpath,p);
