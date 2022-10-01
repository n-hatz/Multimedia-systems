function [mad] = MAD(mb,rmb)
%MAD Computes mean absolute difference (MAD) between 2 blocks 
%   Detailed explanation goes here
mad = 0;
[n,~] = size(mb);
for i = 1:n
    for j = 1:n
        mad = mad + abs((mb(i,j) - rmb(i,j))); %abs difference of pixels
        
    end
end
mad = mad/(n^2);    %mean

end

