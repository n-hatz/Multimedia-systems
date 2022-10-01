function [mvs,mins] = check8NewPositions(f,rf,mbSize,k,old_min)
%CHECK8NEWPOSITIONS Check 8 new possible blocks in Hierarchical Search
%   f = current frame
%   rf = reference frame
%   mbSize = maroblock size
%   k = search radius
%   old_min = mad cost of middle position

[width,height] = size(f);

mvs = zeros(2,width*height/mbSize^2);
costs = ones(3,3)*99999; %costs is now 3x3, 8 new positions + middle position

costs(2,2) = old_min(1);

mins = [];
ci=1;
cj=1;

mbCount = 1;
for i=1:mbSize:width-mbSize+1
    for j=1:mbSize:height-mbSize+1
        
        for m=-k:k:k %search step is now k since this is HS
            for n=-k:k:k
                row_coord = i + m;   % row coordinate for searched block
                col_coord = j + n;   % col coordinate for searched block
                if ((n==0 && m==0) || row_coord < 1 || row_coord+mbSize-1 > width  || col_coord < 1 || col_coord+mbSize-1 > height) %edge case, move to next loop
                    cj=cj+1; %cost j index
                    continue;
                end
                costs(ci,cj) = MAD(f(i:i+mbSize-1, j:j+mbSize-1), rf(row_coord:row_coord+mbSize-1, col_coord:col_coord+mbSize-1));
                cj=cj+1;
            end
            ci=ci+1;    %costs i index
            cj=1;
        end
        
        
        [dx, dy, min] = min_cost_mb_2(costs,k); %motion vector x and y for HS
        mins=[mins min];
        mvs(1,mbCount) = dy;    % row coordinate of mv
        mvs(2,mbCount) = dx;    % col coordinate of mv
        costs = ones(3,3)*99999;
        
        if mbCount<180  %reset for next macroblock
            mbCount = mbCount+1;
            costs(2,2) = old_min(mbCount);
        end
        
        ci=1;
        cj=1;
        
    end
    
end

end

