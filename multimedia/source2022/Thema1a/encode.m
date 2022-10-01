function [codes,dicts] = encode(diffs,mbSize)
%ENCODE Summary of this function goes here
%   Detailed explanation goes here

[~,~,frame_number] = size(diffs);
codes = cell(1,frame_number);
dicts = cell(1,frame_number);

for i=1:frame_number
    [c,d] = codeFrame(diffs(:,:,i),mbSize); %encode frame
    codes{i}=c; %save huffman encoded sequence
    dicts{i}=d; %save huffman dictionary
end

end

