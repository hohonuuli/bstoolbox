function t = readurl(u, tb)
% READURL - Read from a URL
%
% Usage:
%   t = readurl(u)
%   t = readurl(u, tb)
%
% Inputs:
%   u = The URL to read from
%   tb = Flag to indicate whether to read the data from the URL as text or
%        binary. Optios are 't' for Text (ASCII) or 'b' for Binary. The
%        default is 't'
%
% Output:
%   t = if tb is 't' then a 1 x n char array is returned (line feeds are no
%       filtered out). If tb is 'b' then a n x 1 array is returned of the
%       bytes.

% Brian Schlining
% 2012-06-27

if nargin == 1
    tb = 't';
end


try
    url = java.net.URL(u);
catch me
    m = MException([mfilename ':BadURL'], '%s is not a valid URL. Cause: %s', u, me.message);
    throw(m);
end


urlStream = url.openStream();
if tb == 't'
    % Read as text
    t = java.util.Scanner(urlStream).useDelimiter('\\Z').next();
else
    % Read as binary
    
    in = java.io.BufferedInputStream(urlStream);
    bos = java.io.ByteArrayOutputStream();
    n = in.read();
    while n > -1
       bos.write(n);
       n = in.read();
    end
    bos.flush();
    t = bos.toByteArray();
    bos.close();
end
urlStream.close();

