function fun_req(PRGname)

% FUN_REQ - Search a Matlab function for MLDBASE programs required
%
% FUN_REQ will return a list of MLDBASE and OCEAN programs
% used in a specific program. The list contains the MLDBASE 
% and OCEAN programs required. The program names, line number
% and line are listed to the screen. 
% 
% Use As: fun_req(PRGname)
% Inputs: PRGname = PRGname name 
%                   (with directory if needed)
% Output: Output is to the screen
%    
% Also See: FUN_USED

if nargin == 0
  help fun_req
  return
end

if ~isstr(PRGname)
  disp('  FUN_REQ Error (PRGname must a filename)')
  return
end

fid = fopen(PRGname,'rt');
if fid == -1
  disp(['  FUN_REQ Error (Could not open ' PRGname ')'])
  return
end

disp('  ')
disp('  PROGRAMS TO SEARCH FOR ....')

% Get list of MLDBASE and OCEAN files
[s,fm,d] = dirlist_('c:\matlab\toolbox\local\mldbase\','*.m');
[s,fo,d] = dirlist_('c:\matlab\toolbox\local\ocean\','*.m');
f = [fm; fo];
[Mf Nf] = size(f);

% Read in the entire file
F = fread(fid);
fclose(fid);

% Convert numeric values to strings
s = setstr([10 F']);

ret = find(abs(s) == 10);                       % Find the returns
len = max(diff(ret))+1;                         % Maximum string length

disp('  ')
disp(['  PROGRAM:       LN#    LINE'])
disp(['  -------------------------------------------------------------------------------------------------------'])
prgname = [];
% Look for the programs
for i = 1:Mf 
  fprnted = 0;
  program = f(i,:);                              % File to search for
  pind = findstr(program,'.');                   % Find the extention
  ind = findstr(s,program(1:pind-1));            % Find the program
  if ~isempty(ind)
    for j = 1:length(ind)                     % Loop through all the instances of the program found
      % Only save the filename once  
      if fprnted == 1
        program = blanks(Nf);
      end

      r1ind = find(ret <= ind(j));                           % Find the beginning of the line
      if isempty(r1ind)
        r1ind = 1
      end

      r2ind = r1ind(length(r1ind))+1;                        % Find the end of the line
      if r2ind > length(ret)
        r2ind = length(ret);
      end

      line = s(ret(r1ind(length(r1ind)))+1:ret(r2ind)-1);    % Extract the line where the program name was found

      nbind = find(abs(line) ~= 32);                         % Find non-blanks
      line = line(nbind(1):length(line));                    % Remove beginning blanks

      % Remove the lines were the program was found in the comments
      perind = findstr(line,'%');                            % Find %
      prgind = findstr(line,f(i,1:pind-1));                  % Find the program
      if ~isempty(prgind) & ~isempty(perind)
        if prgind(1) > perind(1)                             % Make sure the program found is to the left of the first %
          line = '';                                         % Empty line so that it is not printed                                  
        end
      end

      % Don't print if line is empty (ie a comment)
      if ~isempty(line)
        if isempty(deblank(program))
          nblks = 5;                                         % Spacing for blank program names
        elseif ~isempty(deblank(program))
          nblks = Nf-length(deblank(program))+5;             % Spacing for program not blanked
          fprnted = 1;                                       % program name has been printed once
        end

        fprintf('  %s',program)                                              % Print program found
        fstr = ['%' num2str(nblks)  's'];                                    % Create format string
        fprintf(fstr,blanks(nblks))                                          % Print blanks
        fstr = ['%0' num2str(length(num2str(length(ret))))  '.0f'];          % Create format string
        fprintf(fstr',r1ind(length(r1ind)))                                  % Print the line number
        fprintf('    %s\n',line)                                             % Print the string
      end
    end
  end
end








