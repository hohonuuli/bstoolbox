function [status,fileS,dirS] = dirlist(directory,search)

% DIRLIST - Returns a list of filenames from the specified directory
%
% DIRLIST will return a list of files and subdirectories in the
% specified directory with the specified search extension. 
%
% Use As: [status,files,directories] = dirlist(directory,search)
%
% Inputs: directory   = A string containing a directory
%         search      = A string containing the extention 
%
% Output: status      = Status of DIRLIST_
%         files       = List of all files found
%         directories = List of all directories found
%
% Examples: [s,f,d] = dirlist([pwd '\'],'*.*') or
%           [s,f,d] = dirlist([pwd '\'],'*.m')

% Copyright (c) 1996 by Moss Landing Marine Laboratories
% 31 Jul 96; S. Flora - added alphabetizing the files list
%  9 Aug 96; W. Broenkow changed name, put in \OCEAN
%  6 Jun 97; W. Broenkow test 

status = 1;

if nargin == 0
  status = 0;
  help dirlist
  return
end

if nargin == 1
  search = '*.*';
end

if strcmp(computer,'MAC2')
 DIRS = ':';
elseif strcmp(computer,'PCWIN')
 DIRS = '\';
end

% Remove ending '\' or ':'
if strcmp(directory(length(directory)),DIRS)
  directory = directory(1:length(directory)-1);
end

% Make sure it's a directory
if ~isdir(directory)
  status = 0;
  disp(' DIRLIST_ Error (NOT a Valid Directory)');
  return
elseif isdir(directory)
  directory = deblank(directory);
  if ~strcmp(directory(length(directory)),DIRS)
    directory = [directory DIRS];
  end
end
 
if exist('dir.lis') == 2
  eval(['delete ' directory 'dir.lis']);
end

if strcmp(computer,'MAC2')
  pathS = [directory 'dir.lis'];diary (pathS)
  pathS = [deblank(directory) deblank(search) ';']; dir (pathS)
end

if strcmp(computer,'PCWIN')
  eval(['diary ' directory 'dir.lis;']);                        % include here the searchs of all files 
  eval(['dir ' deblank(directory) deblank(search) ';']); 
end
diary off 

filename = [directory 'dir.lis'];
fid = fopen(filename,'r');
files = fread(fid,inf,'char');
fclose(fid);

% Replace all carriage returns and line feeds with white spaces
ind = find(files ==13 | files == 10);
files(ind) = 32*ones(length(ind),1);

% Convert ASCII numbers to strings
if version == 4.2
  files = setstr(files)';
end
if version == 5.0
  files = char(files)';
end

% Indexes to convert a row of files to a column
i = find(abs(files==32));         % location of all white spaces
j = diff(i);                      % j will be 1 at duplicated spaces
k = find(j ~= 1);                 % k gives index in i of space before valid character
a = i(k) + 1;                     % a is the position of first character in file name
b = i(k) + j(k)-1;                % b is the ending position of valid file name 

% Create a column of FILES
FILES = [];
files = files';
for N = 1:length(k)
  % fprintf('N %4.0f a(N) %4.0f b(N) %4.0f %s\n',N,a(N),b(N),files(1,a(N):b(N)))
  FILES(N,1:b(N)-a(N)+1) = files(1,a(N):b(N));
end

% Sort Alphabetically
[AM AN] = size(FILES);
for k = 1:AN
  [i,j] = sort(abs(FILES(:,k)));
  FILES = FILES(j,:);
end

% Remove . and ..
[AM AN] = size(FILES);
npp = 0;
for k = 1:AM
  ppind = findstr(FILES(k,1),'.');
  if isempty(ppind)
    npp = [npp k];
  end
end
npp = npp(find(npp>0));
FILES = FILES(npp,:);

% Remove directories
[AM AN] = size(FILES);
dpp = 0;
npp = 0;
for k = 1:AM
  ppind = findstr(FILES(k,: ),'.');
  if isempty(ppind)
    dpp = [dpp k];       % create an index of directories
  elseif ~isempty(ppind)
    npp = [npp k];       % create an index of files
  end
end
dpp = dpp(find(dpp>0));
npp = npp(find(npp>0));

if version == 5
  dirS  = char(FILES(dpp,:));
  fileS = char(FILES(npp,:));
end
if version == 4.2
  dirS  = setstr(FILES(dpp,:));
  fileS = setstr(FILES(npp,:));
end

% Alphabetize... We note that Matlab 5.0 has a function called SORTROWS
%                Stephanie was a step ahead of them.
[m n] = size(fileS);
for i = n:-1:1
  f = fileS(:,i)
  [sn,ind] = sort(abs(f));
  files = fileS(ind,:);
end

