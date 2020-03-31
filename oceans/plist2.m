function plist2(infile,NOLINE,LR,device,printer,pagelength)
% plist2.m
% Program listing with line numbers to LPT printer, screen or file 
%
%  Use As:   plist2('filename',NOLINE,LR,device,printer,pagelength)
%  Inputs:   filename = Name of text file including extension
%            NOLINE   = Flag to suppress printing of line numbers
%                       0 = print line numbers (default)
%                       1 = suppress line numbers 
%            LR       = Range of line numbers to print 
%                       0 = print all lines (default
%                       range [50:75] prints only those lines 
%            device:    0 = LPT1 printer (default)
%                       1 = Screen
%                       2 = Disk File
%            printer:   0 = LaserJet 2 or compatible for line printer font
%                       1 = DeskJet 800 for Letter Gothic font
%            pagelength 0 = default 75 lines/page
%                       L <= 79  with lineprinter 79 lines maximum
 
%  When used with no inputs,  dialog box prompts for filename

% This version uses variable format strings for different devices.
% Input and Output file names are handled with uiputfile & uigetfile.
% Uses fgetl as in READMLML.M
% 22 Oct 1995
% W. Broenkow
% 10 Jun 96; WWB replaced fmttime_ with now(6); 
%  3 Mar 96; added hour
% 30 May 96; pass filename through function call
% 15 Jun 96; added no line numbers option
% 29 Aug 96; added line range option;
% 20 Nov 96; added lines/page option;   NOT FOOLPROOF YET

if nargin > 1
  NO_LINE = 1;
else
  NO_LINE = 0;   % list with line numbers
end
if nargin <3
  LR = 0;        % print all lines in the file
end
if nargin < 4
  device = 0;    % print to LPT1 the parallel port
end
if nargin < 5
  printer = 1;
end
if printer >= 1
  printer = 1;   % printer 0 is LaserJet with LinePrinter font
end              % printer 1 is DeskJet with small letter gothic font
if nargin < 6
  pagelength = 75;
end
if pagelength > 79
  pagelength = 79;
end
pagenumber =  1;

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
if device == 0 | device == 1
  fmt1S = '%4i: %s \n';
  fmt2S = '%s \n';
  fmt3S = '%s %s %s  ''page''%3i \n\n';
elseif device == 2      % no carriage return for files
  fmt1S = '%4i: %s \n';
  fmt2S = '%s \n';
  fmt3S = '%s %s %s  page%3i \n\n';
end

if device == 1           % screen
  fid2 = 1;
elseif device == 3       % file
  [outfile, outpath] = uiputfile([strtok(infile,'.') '.lst'], 'PLIST: Save Listing File As');
  fid2 = fopen([outpath outfile],'wt');
elseif device == 0       % HP LaserJet Printer
  % Set printer to lineprinter font and small margins
  fid2 = fopen('lpt1','wt');
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
  if printer == 1
      fprintf(fid2,'\033(sp16.67h9.5v3b6T'); % 16.6 cpi, pitch 9.5 pts, upright, medium, gothic type
  end
else
  break
end

datestr = date;
% hrstr   = now(6);    % CONFLICTS with Matlab's new now.m
% datestr = [hrstr(1,1:5) ' ' datestr];
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
fprintf(fid2,'\n');

OK = 1;
linecount  = 0;
linenumber = 0;

% Body of the program file is printed here:
while OK
  strbuf = fgetl(fid1);
  if ~isstr(strbuf), 
    break
  end
  linenumber = linenumber + 1;
  if sum(LR)>0 
    index = find(LR==linenumber);  % only print if linenumber is within LR
    if any(index)
      PRTOK = 1;
    else
      PRTOK = 0;
    end
  else
    PRTOK = 1;
  end
  if PRTOK > 0
    if NOLINE == 0              % reversed meaning of PRT_LINE 24 Oct 95
      fprintf(fid2,fmt1S,linenumber,strbuf);
      linecount = linecount + 1;
    else
      fprintf(fid2,fmt2S,strbuf);
      linecount = linecount + 1;
    end
    if device == 0 | device == 1
      if rem(linecount,pagelength) == 0
        if device == 0
          fprintf(fid2,'\f');  % formfeed only for printer
        end
        pagenumber = pagenumber + 1;
        fprintf(fid2,fmt3S,[inpath infile],spaces,datestr,pagenumber);
        fprintf(fid2,'\n');
      end
    end
  end
end

if device == 0
  fprintf(fid2,'\f');    % form feed for last page
end
fclose('all');
