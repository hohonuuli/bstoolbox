function stripcr
% STRIPCR

eval(['cd ' pwd])
f = getfname('*.m')
[r c] = size(f);
for i = 1:r
   FileName = deblank(f(i,:))
   fidR = fopen(FileName,'rt')
   fidW = fopen(['tmp' filesep FileName],'wt');
   while ~feof(fidR)
      s   = fgetl(fidR);
      c = strfindb(s,'Copyright (c)');
      r = strfindb(s,'$Revision:');
      if isempty(c) & isempty(r)
         fprintf(fidW,'%s\n',s);
      end
   end
   fclose(fidR);
   fclose(fidW);
end
