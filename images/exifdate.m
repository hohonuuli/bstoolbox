function d = exifdate(f)
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
if isempty(m)
    warning(['No EXIF metadata was found in ' f]);
    d = NaN;
else
    fd = m.findEXIFValue(org.apache.sanselan.formats.tiff.constants.TiffConstants.EXIF_TAG_CREATE_DATE);
    if isempty(fd)
        fd = m.findEXIFValue(org.apache.sanselan.formats.tiff.constants.TiffConstants.EXIF_TAG_DATE_TIME_ORIGINAL);
    end
    if isempty(fd)
        fd = m.findEXIFValue(org.apache.sanselan.formats.tiff.constants.TiffConstants.EXIF_TAG_DATE_TIME);
    end
    
    if isempty(fd)
        warning(['No EXIF date was found in ' f]);
        d = NaN;
    else
        ds = char(fd.getValueDescription());
        ds = ds(2:end -1); % remove single quotes
        d = datenum(ds, 'yyyy:mm:dd HH:MM:SS');
    end
end

