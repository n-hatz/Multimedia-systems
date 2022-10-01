function [dx, dy, min] = min_cost_mb(costs,k)
%MIN_COST_MB return dx and dy of best matching block relative to center of
%search area

[row, col] = size(costs);

%costs is (2k+1)x(2k+1) since this function is used after exhaustive search

min = 99999;

for i = 1:row
    for j = 1:col
        if (costs(i,j) < min)
            min = costs(i,j);
            dx = j-k-1; %remove search radius to be relative to search center
            dy = i-k-1; %remove search radius to be relative to search center
        end
    end
end

end