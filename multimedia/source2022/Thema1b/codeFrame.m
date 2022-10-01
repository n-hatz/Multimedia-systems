function [codes,dicts] = codeFrame(frame,mbSize)
%CODEFRAME Pipeline to encode an image.
%   For each 8x8 block perform DCT, Quantization,
%   run length encoding on zigzag scan and huffman encoding.


[width,height] = size(frame);
frame = double(frame);
macroblocks = mat2cell(frame,mbSize*ones(1,width/mbSize),mbSize*ones(1,height/mbSize));
[macroblocksX,macroblocksY] = size(macroblocks);

quant_matrix = [16    11    10    16    24    40    51    61
                12    12    14    19    26    58    60    55
                14    13    16    24    40    57    69    56
                14    17    22    29    51    87    80    62
                18    22    37    56    68   109   103    77
                24    35    55    64    81   104   113    92
                49    64    78    87   103   121   120   101
                72    92    95    98   112   100   103    99];

quant = @(block_struct) ceil(block_struct.data ./ quant_matrix); %quantization

T = dctmtx(8);  %dct matrix
dct = @(block_struct) T * block_struct.data * T';   %apparently faster than dct2

mask = [1   1   1   1   0   0   0   0
       1   1   1   0   0   0   0   0
       1   1   0   0   0   0   0   0
       1   0   0   0   0   0   0   0
       0   0   0   0   0   0   0   0
       0   0   0   0   0   0   0   0
       0   0   0   0   0   0   0   0
       0   0   0   0   0   0   0   0];

codes = cell(macroblocksX,macroblocksY,(mbSize/8),(mbSize/8)); %12x15x4x4
dicts = cell(macroblocksX,macroblocksY,(mbSize/8),(mbSize/8));

for i=1:macroblocksX
    for j=1:macroblocksY
        
        macroblocks{i,j} = blockproc(macroblocks{i,j},[8 8], dct);  %dct for each 8x8 block in the macroblock
        macroblocks{i,j} = blockproc(macroblocks{i,j},[8 8],@(block_struct) mask .* block_struct.data); %keep upper left coefficients
        macroblocks{i,j} = blockproc(macroblocks{i,j},[8 8],quant); %quantization
        
        blocks = mat2cell(macroblocks{i,j},8*ones(1,mbSize/8),8*ones(1,mbSize/8));  %split mb to blocks
        [blocksX,blocksY] = size(blocks);
        
        %for each 8x8 block in the macroblock
        for m=1:blocksX
            for n=1:blocksY
               rl = runlengthenc(zigzag(blocks{m,n})); %zigzag scan then run length encode
               
               %[symbols,p] = symbolsprob(rl);
               
               [p,symbols]=hist(rl,unique(rl)); %prepare huffman
               p=p/sum(p);
               [dict,~] = huffmandict(symbols,p); %huffman encode
               code = huffmanenco(rl,dict);
               
               codes{i,j,m,n} = code;   %save code
               dicts{i,j,m,n} = dict;   %save dictionary
            end
        end
        
    end
end


end

