function [ output ] = crunch( x, alpha )
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
if (alpha == 0)
    output = 0;
else
    output = alpha * tanh(x / alpha);
end;
end

