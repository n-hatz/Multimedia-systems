function [recFrame] = decodeFrame(codes,dicts,mbSize)
%DECODEFRAME Decode frame
%   Decode huffman, run length
[mbX,mbY,bX,bY] = size(codes);

mbs = cell(mbX,mbY);

for i=1:mbX     %for each macroblock
    for j=1:mbY
        
        blocks = cell(mbSize/8,mbSize/8);
        
        for m=1:bX  %for each 8x8 block in the macroblock
            for n=1:bY
                sig = huffmandeco(codes{i,j,m,n},dicts{i,j,m,n});   %huffman decode
                sig = runlengthdec(sig);    %run length decode
                blocks{m,n} = reshape(sig,[8 8]);   %reshape 1d sequence to 8x8 block
            end
        end
        
        mbs{i,j} = cell2mat(blocks);    %reconstruct mb from blocks
        
    end
end

recFrame = cell2mat(mbs);   %reconstruct frame from macroblocks

end

