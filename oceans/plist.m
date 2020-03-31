function plist(infile,NOLINE)
% plist.m
% Program listing with line numbers to screen, file or printer.
%
%    Use as:   plist               to print file with line numbers
%              plist('filename')   to print file with line numbers
%              plist('filename',1) to print file without line numbers              
%              Menu selects screen, file or printer
%              Dialog box sets input and output files

% This version uses variable format strings for different devices.
% Input and Output file names are handled with uiputfile & uigetfile.
% Uses fgetl as in READMLML.M
% 22 Oct 1995
% W. Broenkow
% rev 24 Oct 95:
%     default mode prints lines numbers
%     corrected: pagenumber & lineprinter escape codes
%     simplified by use variable format strings
% 10 Jun 96; WWB replaced fmttime_ with now(6); 

if nargin > 1
  NO_LINE = 1;
else
  NO_LINE = 0;   % list with line numbers
end
pagelength = 75;
pagenumber =  1;

%  3 Mar 96; added hour
% 30 May 96; pass filename through function call
% 15 Jun 96; added no line numbers option

% device = menu('PLIST: Output Device','Screen','Disk File','LPT1 Printer','LPT3 Printer','Exit');
device = 3;   % I'm getting tired of that menu

if device == 5
  break
end;

if nargin == 0
[infile, inpath] = uigetfile('*.m', 'ENTER Input File Name', 0, 0);
 fid1 = fopen([inpath infile],'r');
  fnl = length(inpath)+length(infile); % filename length for printing
else
  fid1 = fopen([infile],'r');
  inpath = [pwd '\'];
  infile = upper(infile);
  fnl = length(inpath)+length(infile); % filename length for printing
end

% Set-up formats for devices that use carriage returns and those that don't
if device == 1 | device == 3 | device == 4
  fmt1S = '%4i: %s\r\n';
  fmt2S = '%s\r\n';
  fmt3S = '%s%s%s  page%3i \r\n\n';
elseif device == 2      % no carriage return for files
  fmt1S = '%4i: %s\n';
  fmt2S = '%s\n';
  fmt3S = '%s%s%s  page%3i \n\n';
end

if device == 1
  fid2 = 1;
elseif device == 2  
  [outfile, outpath] = uiputfile([strtok(infile,'.') '.lst'], 'PLIST: Save Listing File As');
  fid2 = fopen([outpath outfile],'wt');
elseif device == 3
  % Set printer to lineprinter font. and small margins
  fid2 = fopen('LPT1','wt');
  fprintf(fid2,'\033E');        % \033 is octal for char 27 = escape
  fprintf(fid2,'\033&l0O');     % print in portrait mode note zero and oh
  fprintf(fid2,'\033(0U');      % use the US ASCII character set
  fprintf(fid2,'\033(sp16.67h8.5vb0T'); % 16.6 cpi, pitch 8.5 pts, upright, medium, line printer type
  fprintf(fid2,'\033&l88F');    % 88 lines per page
  fprintf(fid2,'\033&l8D');     % 'ell not one' 8 lines per inch
  fprintf(fid2,'\033&l4E');     % set top margin to 4 lines
  fprintf(fid2,'\033&l1L');     % 'ell one ELL' skip over perforation
  fprintf(fid2,'\033&a15L');    % 'twelve L' set left margin to 15 char 
  fprintf(fid2,'\033&a120M');   % set right margin to 120 char
  fprintf(fid2,'\033&s1C');     % end of line wrap-around set to off
elseif device == 4
  fid2 = fopen('lpt3','wt');
else
  break
end

datestr = date;
hrstr   = now(6);
datestr = [hrstr(1,1:5) ' ' datestr];
if fid1 < 0 | fid2 < 0
  disp('ERROR.. file not found')
  return
end

if device == 1 | device == 2
  spaces = blanks(80 - fnl - 26);    % spaces are used to space fileheader 
elseif device == 3 | device == 4
  spaces = blanks(17*6 - fnl - 20);
end

% Print the header: path\filename ... time date page number
fprintf(fid2,fmt3S,[inpath infile],spaces,datestr,pagenumber);

OK = 1;
linecount = 0;

% Body of the program file is printed here:
while OK
  strbuf = fgetl(fid1);
  if ~isstr(strbuf), 
    break
  end
  linecount = linecount + 1;

  if NO_LINE == 0        % reversed meaning of PRT_LINE 24 Oct 95
    fprintf(fid2,fmt1S,linecount,strbuf);
  else
    fprintf(fid2,fmt2S,strbuf);
  end
  if device == 3 | device == 4
    if rem(linecount,pagelength) == 0 & device == 3
      fprintf(fid2,'\f');
      pagenumber = pagenumber + 1;
      fprintf(fid2,fmt3S,[inpath infile],spaces,datestr,pagenumber);
    end
  end
end

if device == 3 | device == 4
  fprintf(fid2,'\f');
end
fclose('all');
