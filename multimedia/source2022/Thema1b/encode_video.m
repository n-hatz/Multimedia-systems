function [codes,dicts,coded_mvs] = encode_video(frames,frame_number,mbSize)
%ENCODE_VIDEO Video encoder with motion compensation.
%   Based on pseudocode of page 265.

[width,height] = size(frames(:,:,1));
codes = cell(1,frame_number);
dicts = cell(1,frame_number);
coded_mvs = cell(2,frame_number);

for i=1:frame_number
    if i==1 %first frame is I frame
        [c,d] = codeFrame(frames(:,:,i),mbSize);   %code using JPEG pipeline
        
        %dumpToStream(codedFrame);
        codes{i}=c; %save codes and dicts
        dicts{i}=d;
        
        reconstructedFrame = decodeFrame(c,d,mbSize);   %reconstruct frame
        referenceFrame = reconstructedFrame;
    else

        %mVs = computeMotionVector(frames(:,:,i),referenceFrame,mbSize,16);  %exhaustive
        mVs = computeMotionVectorHS(frames(:,:,i),referenceFrame,mbSize,16); %hierarchical  
        
        predictedFrame = compensateFrame(referenceFrame,mVs,mbSize);    %predict frame
        
        errorFrame = frames(:,:,i)-predictedFrame;  %compute error frame
            
        [c,d] = codeFrame(errorFrame,mbSize);   %encode frame
        cMvs = codeMotionVectors(mVs);  %encode mv's
            
        %referenceFrame = predictedFrame;
        %dumpToStream(codedFrame);
        codes{i}=c; %save codes and dicts
        dicts{i}=d;
        %dumpToStream(codedMvs);
        coded_mvs{i,1} = cMvs{1};   %save mv's
        coded_mvs{i,2} = cMvs{2};
        
        
    end
end



end

