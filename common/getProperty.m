function S = getProperty(X, property)
% getProperty - Return a property from a properties structure
%
% Use as: S = getProperty(X, property)
%
% Inputs: X = Data structure from readProperties
%         property = Name of property to be returned
%
% Output: S = value corresponding to the named property
%
% See also: readProperties

% Brian Schlining
% 20 Jul 2000

i = strmatch(property, X.name); % Find the property by name

if isempty(i)
   warning(['Property ''' property ''' was not found']);
   S = [];
   return
end

S = X.value{max(i)}; % Return the last entry of that property in the file
