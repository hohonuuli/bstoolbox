function [m, n] = strfindb(StructName, SearchS)
% STRFINDB  - Locate indices of a string in a text matrix
%
% Use As: [m n] = strfindb(String, SearchS)
% Inputs: String      = A string or char matrix
%	  SearchS     = string of characters that will be searched for
% Output: m	      = index of rows of String containing the SearchS
%	  n	      = inbdex of column of each row in m that SearchS is found
% Example: [m n] = strfind(strvcat['cat','dog','bobcat'],'cat')
%           m = [1 2]; n = [1 4]

% B. Schlining
%  5 Jun 1997 
% 11 Jun 1997; changed name from sqlsflt to strfind
% 20 Jun 1997; Modified so empty indices are returned in no hits occur
% 28 Jul 1997; Removed 'working...' prompt

[MaxRow n] = size(StructName);	% Find Size of the structure
i          = 0;			% index used to assign data in m and n
m          = [];                % return empty index if no hits occur
n          = [];                % return empty index if no hits occur

for Row = 1:MaxRow
   Col = findstr(StructName(Row,:), SearchS);
   if ~isempty(Col)		% Only assign data that is not empty
      i      = i+1;		% increment index
      m(i,1) = Row;
      n(i,1) = Col(1,1);	% Careful: findstr can return multiple hits per row
   end
end
