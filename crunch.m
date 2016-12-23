function [ output ] = crunch( x, alpha )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
if (alpha == 0)
    output = 0;
else
    output = alpha * tanh(x / alpha);
end;
end

