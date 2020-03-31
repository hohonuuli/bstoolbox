function y = readflatfile(Filename)
% READFLATFILE - Reads flat ascii files compiled using the java program CoallateOasisFiles
% 
% Use As: x = readflatfile(Filename)
%      or x = readflatfile
%
% Inputs: Filename = name of coallated data file
%
% Output: x        = matrix of data. The first column is the Day of the year, 
%							the last column is the year. Refer to the header in <Filename>
%                    for specifics on each column of data.

% Brian Schlining
% 22 Apr 1999

%===========
% Open File
%===========
if ~nargin | isempty(Filename)
   [infile inpath] = uigetfile('*.*','Select Oasis data file',0,0);
   if infile == 0
      y = [];
      return                            % Return if CANCEL is selected
   end
   Filename = [inpath infile];
end

fid  = fopen(Filename,'rt');
if fid < 0
   error(['Unable to open file ' Filename])
end

fprintf(1, 'Reading %s...', Filename);

trashheader(fid);      % Get rid of the Header (i.e. lines that start with '#')

p    = ftell(fid);     % Get the position of the first data point
c    = 0;              % Initialize memory to speed things up, we're quessing file size here

%==================================================================================
% 1st pass is to check the number of inputs on each line and count number of lines
%==================================================================================
n    = 0;
while ~feof(fid)
   
   s = fgetl(fid);
   if isstr(s)
      v = sscanf(s,'%f');
   end
   n = n + 1;
   j = length(v);
   
   if j > c
      c = j;
   end
   
end

if c == 0
   fclose(fid);
   y = [];
   return
end



fseek(fid,p,'bof');                    % Rewind to the start of the data

%=======================================
% 2nd pass reads the data into a matrix
%=======================================
y    = ones(n,c)*NaN;
l    = n;
n    = 0;
while ~feof(fid)
   s = fgetl(fid);
   if isstr(s)
      v = sscanf(s,'%f')';
   end
   
   if length(v) == c
      n = n + 1;
      y(n,:) = v;
      if ~rem(n,1000);
         fprintf(1,'.');
      end
   end
   
end
fprintf(1,'\n');

bad = find(y == -999);
y(bad) = NaN;

y = snip(y);

fclose(fid);

%=================================
% function SNIP
% Remove rows that start with NaN
%=================================
function x = snip(x)

i = find(~isnan(x(:,1)));
x = x(i,:);

%====================================================
% function TRASHHEADER
% Remove the first block of lines beginning with '#'
%====================================================
function p = trashheader(fid)

OK = 1;
n = 0;
while OK
   p = ftell(fid);
   s = fgetl(fid);
   
   if strmatch('#',s) | strmatch('%', s)
      OK = 1;
      n = n + 1;
   else
      OK = 0;
   end
   
end
fseek(fid,p - n,'bof');
