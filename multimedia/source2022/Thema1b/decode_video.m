function [rec_frames,error_frames] = decode_video(codes,dicts,coded_mvs,mbSize)
%DECODE_VIDEO Video decoder.
%   Based on pseudocode of page 266.
[~,s] = size(codes);
[w,h,~,~] = size(codes{1});
w = mbSize*w;
h = mbSize*h;

rec_frames = uint8(zeros(w,h,s));
error_frames= uint8(zeros(w,h,s-1));

for i=1:s
    
    currentCodes = codes{i}; %huffman coded sequences of current frame
    currentDicts = dicts{i}; %huffman dictionaries of current grame
    
    currentCodedMvs = cell(1,2);
    currentCodedMvs{1,1} = coded_mvs{i,1}; %current motion vector dx and dy
    currentCodedMvs{1,2} = coded_mvs{i,2};
    
    if i==1 %first frame is a regular frame
        frame = decodeFrame(currentCodes,currentDicts,mbSize);
        referenceFrame = frame;
        rec_frames(:,:,i) = uint8(frame);
        %error_frames(:,:,i) = frame;
    else %rest are error frames
        errorFrame = decodeFrame(currentCodes,currentDicts,mbSize); %decode error frame
        
        error_frames(:,:,i-1) = errorFrame;    %store error frame
        
        mVs = decodeMotionVectors(currentCodedMvs); %decode motion vectors
        predictedFrame = compensateFrame(referenceFrame,mVs,mbSize);    %predict frame
        frame = predictedFrame + errorFrame;
        %imshow(uint8(frame));
        rec_frames(:,:,i) = uint8(frame);   %store predicted frame
        %referenceFrame = frame;
    end
end

