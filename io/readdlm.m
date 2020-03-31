function X = readdlm(filename, token)
% READDLM    - Read a token delimited file. 
%
%    READDLM reads a token delimited fiel containing only ascii numerical data. It
% expects the first row to contain column headers
%
% Use as: X = readdlm(filename, token)
%      or X = readdlm(filename)
%
% Inputs: filename = name of delimited file
%         token = the token that delits the data (default = space)
%
% Output: X = structure of data with the following fields
%           fields = cell array of column names
%           data   = matrix of the data

% Brian Schlining
% 07 May 2001

%===========
% Open File
%===========
if ~nargin | isempty(filename)
   [infile inpath] = uigetfile('*.*','Select delimited data file');
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

s = fgetl(fid); % Get the row containing the column headers
fclose(fid);
warning off

[filePath filename_ ext] = fileparts(filename);
X.filename = [filename_ ext];

n = 0;
while 1
    n = n + 1;
    buf = stringtokenizer(s, n, token);
    if isempty(buf)
        break;
    end
    X.field{n} = buf;
end
warning on 

X.data = dlmread(filename, token, 1, 0); % Skip the first line but read all the data in the file
