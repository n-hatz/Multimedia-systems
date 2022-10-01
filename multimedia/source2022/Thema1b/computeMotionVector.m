function [mvs,mins] = computeMotionVector(f, rf, mbSize, k)
%computeMotionVector find motion vectors via Exhaustive search
% f - current frame
% rf - reference frame
% mbSize - macroblock size
% k - search radius

[row col] = size(rf);

mvs = zeros(2,row*col/mbSize^2);
costs = ones(2*k + 1, 2*k +1) * 65536;

mins=[];


mbCount = 1;
%loop through macroblocks
for i = 1 : mbSize : row-mbSize+1
    for j = 1 : mbSize : col-mbSize+1
        

        
        %exhaustive search in search radius
        for m = -k : k        
            for n = -k : k
                row_coor = i + m;   % row coordinate for searched block
                col_coor = j + n;   % col coordinate for searched block
                if ( row_coor < 1 || row_coor+mbSize-1 > row  || col_coor < 1 || col_coor+mbSize-1 > col) %edge case, move to next loop
                    continue;
                end
                costs(m+k+1,n+k+1) = MAD(f(i:i+mbSize-1, j:j+mbSize-1), rf(row_coor:row_coor+mbSize-1, col_coor:col_coor+mbSize-1));
                %mad between frame mb and rf searched block               
            end
        end
        
        [dx, dy, min] = min_cost_mb(costs,k); % return dx dy of block with minimum MAD cost
        mins=[mins min];
        mvs(1,mbCount) = dy;    % row coordinate for mv
        mvs(2,mbCount) = dx;    % col coordinate for mv
        mbCount = mbCount + 1;
        costs = ones(2*k + 1, 2*k +1) * 99999; %reset for next loop
    end
end

end
