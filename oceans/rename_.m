function [s,t1,t2]=rename_(olddir,newdir)
% RENAME_  - Rename functions named in old contents.m and new contents.m directories
%
% Example: [s,t1,t2]=rename_('c:\matlab\toolbox\local\ocean','c:\matlab\toolbox\local\newocean');
%
%  1) Make sure contents.m file contains all files you want to change names
%  2) Change names in contents file and save rename contents.m in new directory
%  3) This rogram reads in contents of new contents file to form string newtags
%  4) then it reads function files, replace all old function names with new function names
%     and records modified file in the new directory.
%  5) Now edit each file to make sure syntax is correct of the lines changed by this program.

% 14 Aug 1997; W. Broenkow
% 23 Aug 1997; W. Broenkow adding smarts to the replacement
% 30 Aug 1997; W. Broenkow trying to make it work

frontchar = [abs(' %+-/\*') 13];          % one of these characters must precede the function name
backchar  = [abs(' %+-/\*^.(;,') 13];     % one of these characters must follow the function name
                                   
status = 0;

oldcontents = [olddir '\contents.m']
fid1 = fopen(oldcontents,'r');
N1 = 0;
while 1
  line1 = fgetl(fid1);
  if ~isstr(line1) 
    break; 
  end                                   % in our contents files all functions 
  posa = findstr(line1,'% ');           % begin with % space
  posb = findstr(line1,' -');           % end   with space -
  if ~isempty(posa) & ~isempty(posb)    % then line is not a comment
    if posa(1,1) < posb(1,1)
      tag = line1(posa + 1: posb - 1);      
      while abs(tag(1,1)) == 32         % it's possible that someone used more than one space
        tag = tag(1,2:end);             % before the function name in the contents file
      end
      N1 = N1 + 1;
      oldtags(N1,1:length(tag)) = tag;
    end
  end
end
fclose(fid1);
T1 = oldtags;

newcontents = [newdir '\contents.m']
fid2 = fopen([newcontents],'r');
N2 = 0;
while 1
  line2 = fgetl(fid2);
  if ~isstr(line2) 
    break; 
  end
  posa = findstr(line2,'% ');
  posb = findstr(line2,' -');
  if ~isempty(posa) & ~isempty(posb)    % then line is not a comment
    if posa(1,1) < posb(1,1)
      tag = line2(posa + 1: posb - 1); 
      while abs(tag(1,1)) == 32         % it's possible that someone used more than one space
        tag = tag(1,2:end);             % before the tag name.
      end
      N2 = N2 + 1;
      newtags(N2,1:length(tag)) = tag;
    end
  end
end
fclose(fid2);
T1 = lower(oldtags);
T2 = lower(newtags);
S = 1;
for i=1:N1
  disp([T1(i,:),T2(i,:)]);
end

for N = 1:N1   % for all of the files listed in contents.m
  oldfile = [deblank([olddir '\' T1(N,:)]) '.m'];
  newfile = [deblank([newdir '\' T2(N,:)]) '.m'];
  LN = 0;
  fid3 = fopen(oldfile,'r');   % open to read  old files
  fid4 = fopen(newfile,'w');   % open to write new files 
  fprintf('\n%s',newfile)
    while 1                    % for all lines in old program
    oldline = fgetl(fid3);
    LN = LN + 1;
    if rem(LN,5)==0
      fprintf('.')             % print dots behind program name to show progress
    end        
    if ~isstr(oldline) 
      break;                         
    end 
    found = 0;
    L3 = length(oldline);                     
    for i = 1:N1   % look for all tags 
      L1  = length(deblank(T1(i,:)));
      L2  = length(deblank(T2(i,:)));
      pos = findstr(upper(oldline),upper(deblank(T1(i,:))));
      if any(pos)
        LP = length(pos);      % allow for more than 1 use of tag per line
        for p = 1:LP
          % fprintf('%s pos %4.0f %s \n',T1(i,1:8),pos(p),oldline)
          a = pos(p) - 1;
          b = pos(p) + L1;
          b = min(b,L3);       % b cannot be greater than line length
          if a > 0             % the function name can occur as first character on line
            cfront = abs(oldline(a:a));
          else 
            cfront = 32;       % in which case pretend there is a space in front  
          end
          cback  = abs(oldline(b:b));
          % replace only if the token is used in correct syntax
          find_front = find(frontchar==cfront); 
          find_back  = find(backchar==cback);
          if any(find_front) & any(find_back)
            newline = [oldline(1:a) deblank(T2(i,:)) oldline(b:end)];
            L3 = length(oldline);
            found = 1; 
          end
        end
      end
    end
    if found == 1
      fprintf(fid4,'**%s \n',newline);
    else
      fprintf(fid4,'%s \n',oldline);
    end
  end
% When end of file is reached close old and new files
  fclose(fid3);
  fclose(fid4);
end
