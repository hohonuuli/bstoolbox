function p = urlpath(a,b,c)
%URLPATH Get and set the URL path.
%
%  URLPATH  with no arguments will pretty print the 
%  current URL path.
%
%  URLPATH(P) changes the URL path to P, P is a 
%  string or cell array of strings for multiple entries.
%
%  URLPATH(P1,P2) changes the url path to the 
%  concatenation of the two paths P1 and P2. Input should
%  be a string or cell array of strings for multiple entries.
%
%  URPATH(...,'-refresh') refreshes cache so that all files on the 
%  URL path are downloaded again. 
%
%  P = URLPATH  returns the URL path.
%
%  NOTES
%  This function will implicitly download the file to the user's 
%  profile directory as defined by PREFDIR. This local directory 
%  is then added to the m-path to simulate the effect of adding 
%  the URL file to the m-path. URL directories are not supported 
%  by this function, only files. A URL to a zip file will automatically
%  unzip.
%
%  Example:
%
%  urlpath({'ftp://ftp.mathworks.com/matlab/contrib/v4/math/mandel.m'})
%  mandel % run m-file
%
%  urlpath % output the current URL path
%
%  See also URLADDPATH.

% Copyright 2004 Joe Conti

errmsg = 'Invalid input';

% pretty-print
if nargin == 0  

    if nargout == 0
      local_urlpath('-print')
    else 
      p = local_urlpath('-get');
    end

% urlpath(p)
elseif nargin == 1   
     
      if ischar(a) && strcmp(a,'-clear')
          local_clear; 
          return;
      elseif ischar(a) && strcmp(a,'-refresh')
         local_urlpath('-set',urlpath,'-download');
      elseif ~ischar(a) & ~iscell(a)
          error(errmsg)
      else
          local_urlpath('-set',a);
      end
      
% urlpath(a,b)
elseif nargin == 2 
   if strcmp(b,'-download')
       local_urlpath('-set',b,'-download');
   else
       newpath = local_remove_pair_redundancies(a,b);
       % Update new path
       local_urlpath('-set',newpath);
   end

% urlpath(a,b,'-download')   
elseif nargin == 3
       newpath = local_remove_pair_redundancies(a,b);
       % Update new path
       local_urlpath('-set',newpath,'-download');    
end

% return urlpath
if nargout
    p = getappdata(0,'URLPATH');
end

%-------------------------------------------------------%
function local_clear

% % remove urlpaths from m-path
% pathout = getappdata(0,'URLPATH');
% for n = 1:length(pathout)
%   rmpath(pathout{n})    
% end

% % remove cached files
% CACHEDIR = 'urlpath';
% [ok,err,id] = rmdir(fullfile(prefdir,CACHEDIR),'s');
% delete(fullfile(prefdir,CACHEDIR))
% if(~ok)
%    error(err);
% end

%-------------------------------------------------------%
function [pathout] = local_urlpath(varargin)
    
if nargin<3
    forcedownload = false;
else
    forcedownload = true;
end

CACHEDIR = 'urlpath';

% Make local cache directory
[ok,msg] = mkdir(prefdir,CACHEDIR);
if(~ok)
    error('Could not make cache directory')
end
cachedir = fullfile(prefdir,CACHEDIR);

arg1 = varargin{1};

% pretty print url path
if strcmp(arg1,'-print')
    
    % Emulate PATH command format  
    disp(sprintf('\n\t\tMATLAB URLPATH\n'))             
    url_path = local_urlpath('-get');
    if length(url_path)>0  
       local_pretty_print_path(url_path);
    else
       disp(sprintf('\t\t<empty>'));
    end
   
% return url path
elseif strcmp(arg1,'-get')
    pathout = getappdata(0,'URLPATH');
    if isempty(pathout) 
        pathout = {};
        setappdata(0,'URLPATH',pathout);
    end

% set the url path    
elseif strcmp(arg1,'-set')
    pathin = varargin{2};
    [pathin,err] = local_validate_url_path(pathin);
    if ~err
       local_create_url_path(pathin,cachedir,forcedownload);
    end
    setappdata(0,'URLPATH',pathin);
end

%-------------------------------------------------------%
function local_create_url_path(url_path,cachedir,forcedownload)

% Loop through URL's
for n = 1:length(url_path)
    url_str = url_path{n};
    url = java.net.URL(url_str);
    
    % Convert host: www.example.com to www_example_com
    url_host_str = char(url.getHost);
    url_host_str = strrep(url_host_str,'.','_');

    % Create directory mapping to host 
    % Example: C:/MyProfile/Application Data\MathWorks\MATLAB\R14\urlpath\
    url_dir = url_host_str;
    if (exist(fullfile(cachedir,url_dir))==0)
       [ok,msg,id] = mkdir(cachedir,url_dir);
       if(~ok), error(id,msg); end
    end
   
    % Create directory mapping to host directory
    url_file = fullfile(url_dir,char(url.getFile));
    [new_path,file_name,file_ext] = fileparts(url_file);
    if (exist(fullfile(cachedir,new_path))==0)
       [ok,msg,id] = mkdir(cachedir,new_path);
       if(~ok), error(id,msg); end
    end
   
    if(exist(fullfile(cachedir,url_file))==0)
       doDownload = true;
    else 
       doDownload = false;
    end
    
    % Download file from internet
    if doDownload || forcedownload
       local_download(url_str,url_file,cachedir,file_name,file_ext,new_path);
    end
    
    % Add the local directory to the m-path
    addpath(fullfile(cachedir,new_path),'-end');
end

%-------------------------------------------------------%
function local_download(url_str,url_file,cachedir,file_name,file_ext,new_path)
        
import com.mathworks.mlwidgets.io.InterruptibleStreamCopier;

% This code is similar to urlread.m
url = java.net.URL(url_str);
urlConnection = url.openConnection;
inputStream = urlConnection.getInputStream;
byteArrayOutputStream = java.io.ByteArrayOutputStream;
isc = InterruptibleStreamCopier.getInterruptibleStreamCopier;
isc.copyStream(inputStream,byteArrayOutputStream);
inputStream.close; 
byteArrayOutputStream.close;

% Unlike urlread.m, don't convert to string        
s = byteArrayOutputStream.toByteArray;

fid = fopen(fullfile(cachedir,url_file),'w','b');
if(fid==0)
    error(['Could not write: ' + url_file]);
end
fwrite(fid,s);
fclose(fid);
       
% Unzip file into directory
if strcmp(file_ext,'.zip')
   unzip(fullfile(cachedir,url_file),fullfile(cachedir,new_path));
end

%-------------------------------------------------------%
function [newpath] = local_remove_pair_redundancies(pa, pb)        
% Compare two cell arrays and remove any redundancies from input arg cell 
% array string "pa"

casesen = isunix; 

% wrap char arrays into cell arrays
if ischar(pa), pa = {pa};end
if ischar(pb), pb = {pb};end

% remove any redundancies in pa from pb
for(i=1:length(pa))
   aa = pa{i};
   j = 1;
   while(j<=length(pb)) %for j=1:length(pb)
      bb = pb{j};
      if ~casesen, aa = lower(aa); end
      if ~casesen, bb = lower(bb); end
      if strcmp(aa,bb)
         pb = {pb{1:j-1},pb{j+1:end}};
      end
      j = j+1;
   end
end

p = {pa{:},pb{:}};

newpath = p;

%-------------------------------------------------------%
function [url_path,err] = local_validate_url_path(url_path)        
% Validate url path for correctness:
%   -Valid url
%   -No duplicate entries within url path

err = false;

% Check each url path entry for correctness 
n = length(url_path);
while (n>0)  
  flag = logical(0);
  
  % Candidate url path entry
  url_entry = url_path{n};
  
  % Remove if invalid
  if ~local_url_exist(url_entry)
    warning(['Invalid url: ',url_entry]);
    flag = logical(1);
    err = true;
  
  % Remove if duplicate
  elseif sum(strcmp(url_entry,url_path))>1
    warning(['Duplicate entry: ',url_entry]);
    flag = logical(1);
  end
  
  % Remove entry if flagged
  if(flag), url_path = {url_path{1:n-1},url_path{n+1:end}}; end 
  
  % Go to next entry
  n = n-1;
end

%-------------------------------------------------------%
function bool = local_url_exist(url_name)

bool = true;
try
  url = java.net.URL(url_name);
  urlConnection = url.openConnection;
  urlConnection.getInputStream;
catch
    bool = false;
end

%-------------------------------------------------------%
function local_pretty_print_path(p)
% input is cell array of strings

ch= strvcat(p);
tabspace = ones(size(ch,1),1);
tabspace(:) = sprintf('\t');
s = [tabspace, ch];
disp(s)


