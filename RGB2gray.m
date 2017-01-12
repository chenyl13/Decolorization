function [ gray ] = RGB2gray( origin )
%togray: change rgb image to gray
%   此处显示详细说明
origin = double(origin);
gray = 0.299 * origin(:,:,1) + 0.587 * origin(:,:,2) + 0.114 * origin(:,:,3);
gray = uint8(round(gray));

end

