function fun_copy(contfile,drivename)
% FUN_COPY - Copy M-files to floppy disk for distribution based on CONTENTS.M
% Use As:   fun_copy([pwd '\contents.m'])
% Inputs:   full path and contents.m file name
% Output:   disk files containing the files listed in contents.m

% Copyright (c) 1996 by Moss Landing Marine Laboratories
% 6 May 1997: W. Broenkow
% 7 May 1997; S. Flora - added checking size copied to a drive
% 1 Jul 1997; W. Broenkow added drive name

disp('FUN_COPY.M')
if nargin < 2
  drivename = 'a:';
end

disp('Copies files in a CONTENTS.M file')
fid = fopen(contfile);
if fid < 0
  disp('ERROR.. file not found')
  return
end

fprintf(1,'Reading Data \n');

disksize = 0;
while 1

  inline = fgetl(fid);
  if ~isstr(inline)
    break
  end
  p1 = 0;
  p2 = 0;
  p1 = findstr('% ',inline);
  p2 = findstr(' -',inline);
  if p1 > 0 & p2 > p1
    filename = [inline(p1+2:p2-1) '.M'];
    filename = filename(find(abs(filename) ~= 32));     % Remove all the blanks

    % Use this to make sure we are not writting to many files to the a: drive
    fid2 = fopen(lower(filename),'rt');
    if fid2 ~= -1
      str = fread(fid2);
      fclose(fid2);
      [Ms Ns] = size(str);
      disksize = Ms*Ns + disksize;
    else
       filename
    end

    disp([strpad_(['Copying ' filename],25) '- ' num2str(Ms*Ns) ' bytes']);
    eval(['!copy ' filename ' ' drivename]);
    
    % If you have written 1.3MB then pause and ask for a new BLANK disk
    if disksize > 1300000
       fprintf('\nDONE copying %i bytes\n',disksize);
       disp(' ')
       disp(['  COPYFILE: Please insert another blank disk in drive ' drivename])
       disp('            Then Press Return')
       pause
       disksize = 0;
    end
  end
end
fprintf('\nDONE copying %i bytes\n',disksize);
 
