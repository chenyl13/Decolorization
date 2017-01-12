function Lab= RGB2Lab(RGB)
%input:uint8 vector RGB
%output:double vector Lab

RGB = double(RGB);
[h, w, ~] = size(RGB);
n = h * w; 
R = reshape(RGB(:,:,1) / 255, 1, n);
G = reshape(RGB(:,:,2) / 255, 1, n);
B = reshape(RGB(:,:,3) / 255, 1, n);
RGB = [reshape(R,1,n); reshape(G,1,n); reshape(B,1,n)];
M = [0.4124,0.3576,0.1805; 0.2126,0.7152,0.0722; 0.0193,0.1192,0.9505];
XYZ = M * RGB;

X = XYZ(1, :) / 0.95047;
Y = XYZ(2, :);
Z =  XYZ(3, :) / 1.08883;
threshold = (6 / 29) ^ 3;
fX = (X > threshold) .* X .^ (1/3) + (X <= threshold) .* (X * 29 * 29 / 108 + 4 / 29);
fY = (Y > threshold) .* Y .^ (1/3) + (Y <= threshold) .* (Y * 29 * 29 / 108 + 4 / 29);
fZ = (Z > threshold) .* Z .^ (1/3) + (Z <= threshold) .* (Z * 29 * 29 / 108 + 4 / 29);
L = 116 * fY - 16;
a = 500 * (fX - fY);
b = 200 * (fY - fZ);

L = reshape(L, h, w); 
a = reshape(a, h, w); 
b = reshape(b, h, w); 
Lab = cat(3, L, a, b);
Lab = round(Lab);
end
