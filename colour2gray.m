rgb=imread('test4.png');
alpha = 8;
theta = pi;

Lab = RGB2Lab(rgb);
[h, w, ~] = size(Lab);
n = h * w;
L = reshape(Lab(:,:,1), 1, n);
A = reshape(Lab(:,:,2), 1, n);
B = reshape(Lab(:,:,3), 1, n);
tmp = zeros(h, w, 3);
tmp(:, :, 1) = reshape(L, h, w);
figure(1);
tmp = Lab2RGB(uint8(tmp));
imshow(tmp);
% figure(2);
% gray = RGB2gray(rgb);
% imshow(gray);

% delta = zeros(h*w, h*w);
% for i = 1 : h*w
%     if mod(i, 100) == 0
%         fprintf('i:(%d)\n',i);
%     end;
%     for j = 1 : h*w
%         if (i > j) 
%             delta(i,j) = get_delta(L, A, B, i, j, alpha, theta);
%             delta(j,i) = -delta(i,j);
%         end;
%     end;
% end;

load delta4

L = double(L);
newL = L;
dL = 1;
maxIter = 20;
for iter = 1 : maxIter
    fprintf('iter:(%d)\n',iter);
    for i = 1 : n
    	di = delta(i,:);
        Li = L(i) - L;
        diff1 = mean((Li + dL - di) .^ 2);
        diff2 = mean((Li - di) .^ 2);
        diff3 = mean((Li - dL - di) .^ 2);
        diff = min(min(diff1, diff2), diff3);
        if (diff == diff1)
            newL(i) = L(i) + dL;
        elseif (diff == diff3)
            newL(i) = L(i) - dL;
%         else
%             if (mean((dGPlus - delta(i,:)) .* (dGNeg - delta(i,:))) >  (mean((dGPlus - delta(i,:))))^2)
%                 newL(i) = L(i)+ (rand(1)-.5); 
%             end;
        end;
    end;
    L = newL;
end;

L = reshape(L, h, w);
tmp2 = zeros(h, w, 3);
tmp2(:, :, 1) = L;
newRGB = Lab2RGB(uint8(tmp2));
figure(3);
imshow(newRGB);
