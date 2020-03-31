function map = exifdata(f)
% EXIFDATE - extract date from image's exif metadata
%
% Usage:
%   d = exifdate(f)
%
% Input:
%   f = path to an image file
%
% Output:
%   d = The date (in matlab's date format) that the image was taken

% Brian Schlining
% 2014-06-23

m = org.apache.sanselan.Sanselan.getMetadata(java.io.File(f));
map = containers.Map();
if isempty(m)
    warning(['No EXIF metadata was found in ' f]);
else
    items = m.getItems();  % java.util.ArrayList<org.apache.sanselan.formats.tiff.TiffImageMetadata$Item>
    it = items.iterator();
    while it.hasNext
       a = it.next();
       kw = char(a.getKeyword);
       txt = char(a.getText);
       map(kw) = txt;
    end
end
