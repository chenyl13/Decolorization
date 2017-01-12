function RGB = Lab2RGB(Lab) 
Lab = double(Lab);
[h, w, ~] = size(Lab); 
n = h * w; 
L = reshape((Lab(:,:,1) + 16) / 116, 1, n);  
a = reshape(Lab(:,:,2) / 500, 1, n);  
b = reshape(Lab(:,:,3) / 200, 1, n);

threshold = 6/29;

X = L + a;
Y = L;
Z = L - b;

X = ((X > threshold) .* X .^ 3 + (X <= threshold) .* ((X - 4/29) / 29 / 29 * 108));
Y = (Y > threshold) .* Y .^ 3 + (Y <= threshold) .* ((X - 4/29) / 29 / 29 * 108);
Z = (Z > threshold) .* Z .^ 3 + (Z <= threshold) .* ((X - 4/29) / 29 / 29 * 108);

XYZ = [X; Y; Z];
M = [3.0799327, -1.537150, -0.542782; -0.921235, 1.875992, 0.0452442; 0.0528909, -0.204043, 1.1511515];
RGB = M * XYZ;

R = reshape(RGB(1,:), h, w) * 255;
G = reshape(RGB(2,:), h, w) * 255;
B = reshape(RGB(3,:), h, w) * 255;
RGB = cat(3, R, G, B);
RGB = uint8(RGB); 
