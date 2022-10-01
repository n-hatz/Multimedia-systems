function [dx,dy,min] = min_cost_mb_2(costs,k)
%MIN_COST_MB_2 find best match macroblock after hierarchical search
%   Detailed explanation goes here

[row, col] = size(costs);

min = 99999;

for i = 1:row
    for j = 1:col
        if (costs(i,j) < min)
            min = costs(i,j);
            %the 8 positions are not consecutive
            dx = (j-1)*k+1-k-1; %remove search radius to be relative to search center
            dy = (i-1)*k+1-k-1; %remove search radius to be relative to search center
        end
    end
end
%costs
end

