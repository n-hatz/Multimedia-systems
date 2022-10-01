function [dec_diffs] = decode(codes,dicts,mbSize,w,h)
%DECODE Summary of this function goes here
%   Detailed explanation goes here

[~,frame_number] = size(codes);
dec_diffs = zeros(w,h,frame_number);

for i=1:frame_number
    currentCodes = codes{i}; %get encoded sequence and huffman dict 
    currentDicts = dicts{i}; %for current frame
    dec_diffs(:,:,i) = decodeFrame(currentCodes,currentDicts,mbSize);   %decode frame
end


end

