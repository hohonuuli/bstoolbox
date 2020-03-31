function asc2txt(FileName)
% ASC2TXT   - Convert ASC files to columns of data
%
% This one's for you Atma
%
% Use As: asc2txt(FileName)
%     or  asc2txt
%
% Inputs: FileName is the path and name of the file to be converted
%
% Output: Writes the converted file with the name FileName.txt
%         ex. asc2txt(abs123.asc) => abs123.txt

% Brian Schlining
% 16 Mar 1999

%===========
% Open File
%===========
if ~nargin
   [infile inpath] = uigetfile('*.asc','Select Ascii file',0,0);
   if infile == 0
      return                            % Return if CANCEL is selected
   end
   FileName = [inpath infile];
end


fid    = fopen(FileName,'r');				 % Open File

[FilePath, FileName, FileExt] = fileparts(FileName); % Get the path and the name w/o extension

%isheader = 1;
OK = 1;
%while isheader 
%   S  = fgetl(fid);
%   x = findstr('Trace', S)
%   if isempty(x)
%      isheader = 1;
%   end
%end

for i = 1:12
   S = fgetl(fid);
end


n = 0;
while OK
   S = fgetl(fid);
   x = findstr('Trace',S);
   if ~isempty(x)
      break
   end
   i = findstr(S,',');
   if ~isempty(i)
      i = [0 i];
      for j = 1:(length(i)-1)
         buf = sscanf(S(i(j)+1:i(j+1)),'%f');
         n = n + 1;
         if isempty(buf)
            O2(n,1) = NaN;
         else
            O2(n,1) = buf;
         end
      end
   end
end
n = 0;

while ~feof(fid)
   S = fgetl(fid);
   i = findstr(S,',');
   if ~isempty(i)
      i = [0 i];
      for j = 1:(length(i)-1)
         buf = sscanf(S(i(j)+1:i(j+1)),'%f');
         n = n + 1;
         if isempty(buf)
            T(n,1) = NaN;
         else
            T(n,1) = buf;
         end
      end
   end
end

fclose(fid);

y = [O2 T];

fname = [FilePath filesep FileName '.txt'];

fid = fopen(fname,'w');
fprintf(fid,'%7.4f %5.2f\n',y');
fclose(fid);
disp([fname ' created'])

