function [ class ] = cvpr_fetchclass( img, filename )
%   Helper function to fetch image class from filename.

seperatorlc = strfind(filename,'_');
class = str2num(filename(1:seperatorlc-1));

end

