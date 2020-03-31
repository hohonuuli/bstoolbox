function f_used = fun_used(PRGname)

% FUN_USED - Find which MLDBASE programs use a particular program
%
% FUN_USED will return the names of the MLDBASE and OCEAN 
% that used a specific program. The program names are
% returned as output and listed to the screen.
%
% Use As: fun_used(PRGname)
% Inputs: PRGname = Program name
% Output: f_used  = List of program names that use
%                   PRGname. 
%    
% Also See: FUN_REQ

if nargin == 0
  help fun_used
  return
end

if ~isstr(PRGname)
  disp('  FUN_USED Error (PRGname must a filename)')
  return
end

pind = findstr(PRGname,'.');
if ~isempty(pind)
  PRGname = PRGname(1:pind-1);                  % Remove the extension
end
PRGname = upper(PRGname);                       % Upper case

disp('  ')
disp('  PROGRAMS TO SEARCH IN ....')

olddir = pwd;

% Get list of MLDBASE and OCEAN files
[s,fm,d] = dirlist_('c:\matlab\toolbox\local\mldbase\','*.m');
[Mm Nm] = size(fm);
[s,fo,d] = dirlist_('c:\matlab\toolbox\local\ocean\','*.m');
f = [fm; fo];
[Mf Nf] = size(f);

dirm = 'c:\matlab\toolbox\local\mldbase\';
diro = 'c:\matlab\toolbox\local\ocean\';
I = [];

disp(['  FUN_USED is searching for ' PRGname ' in ' num2str(Mf) ' files'])
% Look for the program in other programs
for i = 1:Mf 
  % Change to correct dir
  if i == 1
    disp(' ')
    disp(['    Current search dir = ' dirm])
    fprintf('\n    ')
    eval(['cd ' dirm(1:length(dirm)-1)]);
  elseif i == Mm+1
    disp(' ')
    disp(' ')
    disp(['    Current search dir = ' diro])
    fprintf('\n    ')
    eval(['cd ' diro(1:length(diro)-1)]);
  end
  fid = fopen(f(i,:),'rt');
  if fid < 0
    disp(['  FUN_USED (' f(i,:) ' does not exist)'])
    if rem(i,10) == 0
      fprintf('%i',i)
      if rem(i,50) == 0
        fprintf('\n    ')
      end
    else
      fprintf('x')
    end
  else
    num = fread(fid,inf);                       % Read in entire file
    fclose(fid);                                % Close the file
    str = upper(setstr(num'));                  % Convert numeric values to strings

    ind = findstr(str,PRGname);                   % If found 
    pind = findstr(f(i,:),'.');                 % Find extension
    % If the name was found in the program and it is
    % not it's own name
    if ~isempty(ind) & ~strcmp(upper(f(i,1:pind-1)),upper(PRGname))
      incomment = [];
      for k = 1:length(ind)
        % Now remove programs found in comments
        retb = find(abs(str(1:ind(k))) == 10);
        reta = find(abs(str(ind(k):length(str))) == 10);
        lineS = str(retb(length(retb)):reta(1)+ind(k)-1);
        perind = findstr(lineS,'%');
        PRGind = findstr(upper(lineS),upper(PRGname));
        if ~isempty(perind)
          if (perind(1) < PRGind(1)) 
            incomment = 1;
          else
            incomment = 0;
            break
          end
        else
          incomment = 0;
          break
        end
      end
      % Only add to list if the PRGname was not found in a comment
      if incomment == 0
        I = [I i];
      end
    end
    if rem(i,10) == 0
      fprintf('%i',i)
      if rem(i,50) == 0
        fprintf('\n    ')
      end
    elseif ~isempty(ind)
      fprintf('*')
    else
      fprintf('.')
    end
  end
end
eval(['cd ' olddir]);

disp('  ')
disp('  ')
disp(['  ' num2str(length(I)) ' Programs found that use ' PRGname])
disp(['  -----------------------------------------'])
disp([32*ones(length(I),3) f(I,:)]);
f_used = f(I,:);                        % Return list of files








