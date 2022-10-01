% "Main" file για το θέμα 2. Ρυθμίστε τον αριθμό από frames στην γραμμή
% 17 για μείωση του χρόνου της διαδικασίας, ή κάντε την comment για να
% τρέξει σε ολόκληρο το βίντεο

vid = VideoReader('../Videos/GreenTiger.mp4');

frames = read(vid);

rgbframes = read(vid);
[w,h,~,frame_number] = size(rgbframes);
frames = (zeros(w,h,frame_number));

for i=1:frame_number
    frames(:,:,i)=(rgb2gray(rgbframes(:,:,:,i)));   %convert video to grayscale
    imshow(uint8(frames(:,:,i)));   %show original video
end

frame_number = 100; %change or comment for different number of frames

rf = frames(:,:,1); %reference frame is frame with only the background
rem_frames = (zeros(w,h,frame_number)); %frames with removed motion
rem_frames(:,:,1) = rf; %
for i=1:frame_number
    mvs = computeMotionVector(frames(:,:,i),rf,32,16);  %compute motion vectors
    rem_frame = compensateFrame(frames(:,:,i),rf,mvs,32);   %remove motion
    rem_frames(:,:,i) = rem_frame;  %store frame with removed motion
    rf = rem_frame;
end

v=VideoWriter('RemovedTiger');
open(v);
for i=1:frame_number  %show frames with removed moving object
    imshow(uint8(rem_frames(:,:,i)));
    writeVideo(v,uint8(rem_frames(:,:,i)));
end
close(v);