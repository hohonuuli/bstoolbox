function D = readascii(Filename)
% READASCII - Read a delimited ascii file
%
% READASCII is used to read tab or space delimited files. It
% ignores lines that start with '#' or '%'. It also assumes that
% every line has the same number of data points. 
%
% Use as: D = readascii(Filename)
%
% Inputs: Filename  = The name fo the file to read
%
% Output: D = matrix of data containied in the input file

% Brian Schlining
% 04 Aug 1999

%===========
% Open File
%===========
if ~nargin
   [infile inpath] = uigetfile('*.*','Select data file',0,0);
   if infile == 0
      y = [];
      return                            % Return if CANCEL is selected
   end
   Filename = [inpath infile];
end

if nargin < 2
   dlm = '\t';
end

fid  = fopen(Filename,'rt');
if fid < 0
   error(['Unable to open file ' Filename])
end


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

   if strmatch('#',s)
      OK = 1;
      n = n + 1;
   elseif strmatch('%',s)
      OK = 1;
      n = n + 1;
   else
      OK = 0;
   end
   
end
fseek(fid,p - n,'bof');