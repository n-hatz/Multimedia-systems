function rec_frame = compensateFrame(f,rf, mvs, mbSize)
%compensateFrame
% f - current frame
% rf - reference frame
% mvs - motion vector
% mbSize - macroblock size

[row,col] = size(rf);


mbCount = 1;
for i = 1:mbSize:row-mbSize+1
    for j = 1:mbSize:col-mbSize+1
        dy = mvs(1,mbCount);
        dx = mvs(2,mbCount);
        if dy~=0 || dx~=0 %if non zero mvs, replace with background (rf) block
            rec_frame(i:i+mbSize-1,j:j+mbSize-1) = rf(i:i+mbSize-1,j:j+mbSize-1); 
        else
            rec_frame(i:i+mbSize-1,j:j+mbSize-1) = f(i:i+mbSize-1,j:j+mbSize-1); %else keep the same mb
        end
        mbCount = mbCount + 1;
    end
end

end
