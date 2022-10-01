function [mvs,mins] = computeMotionVector(f, rf, mbSize, k)
%computeMotionVector find motion vectors via Exhaustive search
% f - current frame
% rf - reference frame
% mbSize - macroblock size
% k - search radius

[row,col] = size(rf);

mvs = zeros(2,row*col/mbSize^2);
costs = ones(2*k + 1, 2*k +1) * 99999;

mins=[];


mbCount = 1;
%this shifts the search window
for i = 1 : mbSize : row-mbSize+1   %for each macroblock
    for j = 1 : mbSize : col-mbSize+1
        

        
        %exhaustive search for each x and y in the search window
        for m = -k : k        
            for n = -k : k
                row_coord = i + m;   % row coordinate for searched block
                col_coord = j + n;   % col coordinate for searched block
                if ( row_coord < 1 || row_coord+mbSize-1 > row  || col_coord < 1 || col_coord+mbSize-1 > col) %edge case, move to next loop
                    continue;
                end
                costs(m+k+1,n+k+1) = MAD(f(i:i+mbSize-1, j:j+mbSize-1), rf(row_coord:row_coord+mbSize-1, col_coord:col_coord+mbSize-1));    %MAD between current mb and searched block in reference frame
                              
            end
        end
        
        [dx, dy, min] = min_cost_mb(costs,k); % return dx and dy of block with minimum mad
        mins=[mins min];
        mvs(1,mbCount) = dy;    % row coordinate for the motion vector
        mvs(2,mbCount) = dx;    % col coordinate for the motion vector
        
%         if min>1  %ALTERNATIVE APPROACH EXPLAINED IN PDF
%            vectors(1,mbCount) = dy+100;    % add extreme value to get flagged
%            vectors(2,mbCount) = dx+100; 
%         else
%             vectors(1,mbCount) = dy;    % row coordinate for the motion vector
%             vectors(2,mbCount) = dx;    % col coordinate for the motion vector
%         end
        
        mbCount = mbCount + 1;
        costs = ones(2*k + 1, 2*k +1) * 99999; %reset costs for next loop
    end
end

end

