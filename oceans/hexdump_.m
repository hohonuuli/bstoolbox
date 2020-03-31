function hexdump_(Option,infname,outfname,blocks)
% HEXDUMP_ - Print file contents as hex codes and ascii characters
%
% Use As:  hexdump_(Option,infile,outfile,blocks)
% Input:   Option   = 0 to print to screen
%                   = 1 to print to file
%          infname  = complete input path and file name
%          outfname = complete output path and file name
%          blocks   = range of 256-byte blocks to print
% Output:  Text file containing hexadecimal and ASCII representations of file contents
% 
% Example: hexdump_(1,'mydata.dat','mydata.hex',2:4)
%          hexdump_       use dialog box to input infile name
%          hexdump_(1)    use dialog box to input infile and outfile names
%          hexdump_(1,[],[],3:5) use dialog box to input infile and outfile names
%                                output blocks 3, 4 and 5  
% Sample Output:
% File:        C:\Matlab\toolbox\local\MS263\hexdump_.m
% File Length: 3654 bytes 15 blocks
%
% 000000: 66 75 6E 63 74 69 6F 6E 20 68 65 78 64 75 6D 70  function hexdump 000000
% 000010: 5F 28 4F 70 74 69 6F 6E 2C 69 6E 66 6E 61 6D 65  _(Option,infname 000016
%
% Note:    Long files are most quickly processed by writing them to a file

% Copyright (c) 1997 Moss Landing Marine Laboratories
% 28 Oct 1997; W. Broenkow
% 05 Nov 1997; W. Broenkow fixed bug
% 08 Nov 1997; W. Broenkow allow files < 15 bytes

blocksize = 256;                    % This may not be the size of disk records.

if nargin < 1
  Option  = 0;
end
if nargin < 2 | isempty(infname)
  [inname, inpath] = uigetfile('*.*','HEXDUMP_ Input File');
  infname = [inpath inname];
end
if  Option == 1 & nargin < 3 | Option == 1 & isempty(outfname)
  [outname outpath] = uiputfile('*.*','HEXDUMP_ Save Output File As');
  outfname = [outpath outname];
end

fid1  = fopen(infname);
if fid1 < 0
  disp(['HEXDUMP_ Error in opening input file: ' infname])
  break
end
if Option == 1
  fid2 = fopen(outfname,'wt');
  if fid2 < 0
    disp(['HEXDUMP_ Error in opening output file: 'outfname])
    break
  end
else
  fid2 = 1;                         % By default, print to printer.
end

if floor(version) == 5              % The documentation lies.  We get a double precision variable
  [x,N] = fread(fid1,'uint8');      % in Matlab version 5, rather than a uint8 variable.
else
  [x,N] = fread(fid1);              % Read the file into a single double precision variable.
end

fclose(fid1);

fprintf(fid2,'\nFile:        %s\n',infname);
fprintf(fid2,'File Length: %i bytes %i blocks\n',N,ceil(N/blocksize));

if nargin == 4                      % Display records given by blocks parameter
  a = 1 + blocksize*(min(blocks) - 1);
  z = min(N,blocksize*max(blocks));
else
  a = 1;                            % First byte of file to be written
  z = N;                            % Last byte of file to be written
end

b = min(length(x),15);              % The number of bytes to print, this may change for last line.
while a < N
  b = min(b,N-a);
  if rem(a-1,256) == 0              % Print a blank line at 256-byte block intervals
    fprintf(fid2,'\n');
  end
  fprintf(fid2,'%.6x: ',a-1);       % Print the byte count in hex
  fprintf(fid2,'%.2X ',x(a:a+b));   % Print Hex values first
  if b < 15                         % Pad the last line with spaces
    fprintf(fid2,'%s',blanks(3*(15-b)));
  end
  fprintf(fid2,' ');
  y = x(a:a+b);
  j = find(y < 32);                 % Find position of non-printable characters
  y(j) = 46;                        % Replace those with a period
  fprintf(fid2,'%c',char(y));       % Print the 16 bytes as their ASCII characters
  if b < 15                                     
    fprintf(fid2,'%s'),blanks(15-b);%Pad the last line with spaces
  end
  fprintf(fid2,' %0.6i\n',a-1);
  a = a + b + 1;                     % First byte on next line
  % b = min(b,N-a);                    % Last byte on next line 
end
if Option == 1
  fprintf(1,'Saved Hex Dump As: %s\n',outfname);
end
fclose('all');


