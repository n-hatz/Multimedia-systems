function [recFrame] = decodeFrame(codes,dicts,mbSize)
%DECODEFRAME Decode frame
%   Decode huffman, run length, inverse zigzag scan, inverse quantization
%   and inverse DCT2
[mbX,mbY,bX,bY] = size(codes);

mbs = cell(mbX,mbY);

quant_matrix = [16    11    10    16    24    40    51    61
                12    12    14    19    26    58    60    55
                14    13    16    24    40    57    69    56
                14    17    22    29    51    87    80    62
                18    22    37    56    68   109   103    77
                24    35    55    64    81   104   113    92
                49    64    78    87   103   121   120   101
                72    92    95    98   112   100   103    99];  %JPEG quant matrix

T = dctmtx(8);  %dct matrix
invdct = @(block_struct) T' * block_struct.data * T;    %faster than idct2
iquant = @(block_struct) block_struct.data .* quant_matrix; %inverse quantization

for i=1:mbX     %for each macroblock
    for j=1:mbY
        
        blocks = cell(mbSize/8,mbSize/8);
        
        for m=1:bX  %for each 8x8 block in the macroblock
            for n=1:bY
                sig = huffmandeco(codes{i,j,m,n},dicts{i,j,m,n});   %huffman decoding
                blocks{m,n} = izigzag(runlengthdec(sig),8,8);   %RL-decoding and inverse zig zag
            end
        end
        
        mbs{i,j} = cell2mat(blocks);    %reconstruct macroblock from 8x8 blocks
        mbs{i,j} = blockproc(mbs{i,j},[8 8],iquant);    %inverse quantization
        mbs{i,j} = blockproc(mbs{i,j},[8 8],invdct);    %inverse dct
        
    end
end

recFrame = cell2mat(mbs);   %reconstruct frame from macroblocks

end

