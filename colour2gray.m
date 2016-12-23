rgb=imread('Sunrise.png');
alpha = 10;
theta = pi / 4;

cform = makecform('srgb2lab');
Lab = applycform(rgb, cform);
[h, w, ~] = size(Lab);
L = reshape(Lab(:,:,1), 1, w*h);
A = reshape(Lab(:,:,2), 1, w*h);
B = reshape(Lab(:,:,3), 1, w*h);
% LL = reshape(L, h, w);
% imshow(LL);

delta = zeros(h*w, h*w);
for i = 1 : h*w
    for j = 1 : h*w
        if (i > j) 
            delta(i,j) = get_delta(L, A, B, i, j, alpha, theta);
            delta(j,i) = -delta(i,j);
        end;
    end;
end;

G = L;

for iter = 1 : 20 
    fprintf('iter:(%d)\n',iter);
    min_want = zeros(N,1);
    % Touch every pixel once, changing it a little
    % For now assume want to encode signed differences
    if (STOP_CONSTRAINT == 0)
        
        %%%%%%%%%%%%%%%% Main Loop  %%%%%%%%%%%%%%%%%%%%%%%%%
        for i=1:N
            Tvector(:)=delta(i,:);
            
            
            % dG  = G(i) - G;
            %  dGPlus   = dG + (little*dG);
            %  dGNeg = dG - (little*dG);
            %  dGZero = dG;
            dGZero = G(i) - G;
            dGPlus = dGZero  +little; 
            dGNeg = dGZero-little ;
            
            %More continuous changes
            tmpD = (dGPlus - Tvector);
            want0_p = mean(tmpD.*tmpD);
            tmpD = (dGZero - Tvector);
            want0_0 = mean(tmpD.*tmpD);
            tmpD = (dGNeg - Tvector);
            want0_n = mean(tmpD .* tmpD);
            
            
            %if I add a little to Gi and it make dG - T(i,j) smaller, 
            %   this is good
            % otherwise if I subtract a little to Gi and it makes dG - T(i,j)
            % smaller, 
            %    do that
            %  else   leave it alone
            min_want(i) = min(min(want0_p,want0_0),want0_n);
                if (min_want(i) == want0_p)
                    % fprintf('adding a little G(%d)\n',i);
                    updatedG(i) = G(i)+little;
                    %  fprintf(' adding  G(%d)\n',i);
                elseif (min_want(i) == want0_n)
                    % fprintf('subtracting a little G(%d)\n',i);
                    updatedG(i) = G(i) - little;
                    %  fprintf(' subtracting G(%d)\n',i);
                else 
                    if (USE_RANDOM_BUMP && mean((dGPlus - T(i,:)) .* (dGNeg - T(i,:))) >  (mean((dGPlus - T(i,:))))^2)
                        
                        updatedG(i) = G(i)+ (rand(1)-.5); 
                        
                        %    fprintf(' adding random shift G(%d)\n',i);
                        %else
                        %    fprintf('ick: doing nothing for G(%d)\n',i);
                    end;
                    %Do nothing
                end;
            end;
            
        end; %end of i, touching every pixel once & moving G[i] a little 
        %%%%%%%%%%%%%%%% END OF Main Loop  %%%%%%%%%%%%%%%%%%%%%%%%%
        
        G =updatedG;  %Double buffering
        

        
        %%%%%%%%%%%   Save out Intermediate Results  %%%%%%%%%%%%%
%         NewG = reshape(G,ImgCol,ImgRow);
%         NewG2RGBImg = LImg2RGBImg(NewG);
%         fprintf('Will try to write out image %s\n', str_grayImg);
%         imwrite(uint8(NewG2RGBImg), colormap(gray(256)), str_grayImg, 'png');
        
end;

LL = reshape(G, h, w);
imshow(LL);
