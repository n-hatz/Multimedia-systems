function [codes,dicts] = codeFrame(frame,mbSize)
%CODEFRAME Encode an image without loss.
%   For each 8x8 block perform run length encoding and huffman encoding

[width,height] = size(frame);
frame = double(frame);
macroblocks = mat2cell(frame,mbSize*ones(1,width/mbSize),mbSize*ones(1,height/mbSize));
[macroblocksX,macroblocksY] = size(macroblocks);

codes = cell(macroblocksX,macroblocksY,(mbSize/8),(mbSize/8));
dicts = cell(macroblocksX,macroblocksY,(mbSize/8),(mbSize/8));

% for each macroblock
for i=1:macroblocksX
    for j=1:macroblocksY
        
        blocks = mat2cell(macroblocks{i,j},8*ones(1,mbSize/8),8*ones(1,mbSize/8));
        [blocksX,blocksY] = size(blocks);
        
        %for each 8x8 block in the macroblock
        for m=1:blocksX
            for n=1:blocksY
               b = blocks{m,n};
               rl = runlengthenc(b(:)); %zigzag scan then run length encode
               
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

