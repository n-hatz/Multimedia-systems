function [mad] = MAD(mb,rmb)
%MAD Summary of this function goes here
%   Detailed explanation goes here
mad = 0;


[n,~] = size(mb);
for i = 1:n
    for j = 1:n
        mad = mad + abs((mb(i,j) - rmb(i,j)));  %abs difference of pixels
        
    end
end
mad = mad/(n^2);    %mean

end

