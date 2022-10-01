function [mv] = computeMotionVectorHS(f,rf,mbSize,k)
%UNTITLED compute motion vectors via hierarchical search 
%   f = current frame
%   rf = reference frame
%   mbSize = macroblock size
%   k = search radius

for i=4:-1:1
    ds_f = f(1:2^(i-1):end,1:2^(i-1):end);  %downsample target frame
    ds_rf = rf(1:2^(i-1):end,1:2^(i-1):end);    %downsample reference frame
    if i~=4 && i~=1
        mv = mv.*2;
    end
    if i==4
        [mv,min_mads] = computeMotionVector(ds_f,ds_rf,mbSize/2^(i-1),k/2^(i-1));   %exhaustive search for topmost level
        
    else
        [mv,min_mads] = check8NewPositions(ds_f,ds_rf,mbSize/2^(i-1),k/2^(i-1),min_mads);    %8 new possible positions
    end
end

end

