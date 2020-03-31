[status,files,directories] = dirlist_(pwd,'*.*');

[M N] = size(files);
if ~isempty(files)
  for i = 1:M
    plist(files(i,:))
  end
end
