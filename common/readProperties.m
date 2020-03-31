function X = readProperties(filename)
% readProperties - Read a properties file
%
% A properties file is a file containing name values pairs.
% An example file might look like:
%
%    # Some comment
%    first.name=firstValue
%    secondName=second.value
%    some.other.name=yetAnotherValue
%
% It is not recommended that the names or values contain spaces.
% Also, it's best if property names are case insensitive
% This program can also read java properties files
%
% Use as: X = readProperties(filename)
%
% Inputs: filename = string name of the property file to read
%
% Output: X = Data structure with the following fields
%             filename = name of the properties file
%             name = Cell array of property names
%             value = cell array of properties values corresponding to each name
%                     If a value is missing
%
% Example: X = readProperties('SomeFile.properties'); % Reading the example file above
%          getProperty(X, 'first.name')               % Get the value of the first.name property
%         
%          ans = 'firstValue'
%          
%
% See also: getProperty
%
% Requires: STRINGTOKENIZER

% Brian Schlining
% 20 Jul 2000

%===========
% Open File
%===========
if ~nargin | isempty(filename)
   [infile inpath] = uigetfile('*.*','Select Oasis data file',0,0);
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

[p f e] = fileparts(filename);
X.filename = [f e];

n = 0;
while ~feof(fid)
   S = fgetl(fid);
   if strmatch('#', S)
      % Do nothing if a comment   
   else
      warning('off')
      name = stringtokenizer(S, 1, '=');
      if ~isempty(name)
         n = n + 1;
         X.name{n}  = stringtokenizer(S, 1, '=');
         X.value{n} = stringtokenizer(S, 2, '=');
      end
      warning('on')
      
   end
   
end



