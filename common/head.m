function head(filename, n)
% Head      - Extract the first n lines of a file to the screen

% Brian Schlining
% 09 Nov 2000

if nargin < 2
   n = 25;
end

fid = fopen(filename, 'rt');
for i = 1:n
   if ~feof(fid)
      fprintf(1, '%s\n', fgetl(fid));
   end
end
fclose(fid);