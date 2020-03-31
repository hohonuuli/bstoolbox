function addjar(s)
% Hack the static classpath to add a jar to it
%
% Usage:
%   addjar(s)
%
% Inputs:
%   s = path or url to a jar file

% Brian Schlining
% 2012-05-09


if ischar(s)
    js = java.lang.String(s);
    if js.startsWith('http')
        s = java.net.URL(s);
    end
end

if isa(s, 'java.net.URL')
    ClassPathHacker.addURL(s);
else
    ClassPathHacker.addFile(s);
end



