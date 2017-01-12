function [ d ] = get_delta( L, A, B, i, j, alpha, theta )
%DELTA 此处显示有关此函数的摘要
%   此处显示详细说明
    if (i == j)
        d = 0;
    else
        dL = L(i) - L(j);
        dA = A(i) - A(j);
        dB = B(i) - B(j);
        dC = sqrt(double(dA*dA + dB*dB));
        sign = 1;
        if (dA * cos(theta) + dB * sin(theta) < 0)
            sign = -1;
        end;
        crunchC = crunch(dC * sign, alpha);
        if (abs(dL) > abs(crunchC))
            d = dL;
        else
            d = crunchC;
        end;
    end;
end

