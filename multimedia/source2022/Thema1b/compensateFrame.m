function rec_frame = compensateFrame(rf, mvs, mbSize)
%compensateFrame replace each mb with reference frame mb depending on
%motion vectors
%   rf = reference frame
%   mvs = motion vectors
%   mbSize = macroblock size

[row col] = size(rf);

mbCount = 1;
for i = 1:mbSize:row-mbSize+1
    for j = 1:mbSize:col-mbSize+1
        
        dy = mvs(1,mbCount);
        dx = mvs(2,mbCount);
        row_coor = i + dy;
        col_coor = j + dx;
        rec_frame(i:i+mbSize-1,j:j+mbSize-1) = rf(row_coor:row_coor+mbSize-1, col_coor:col_coor+mbSize-1);
    
        mbCount = mbCount + 1;
    end
end

end
