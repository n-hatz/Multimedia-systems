% "Main" file για το θέμα 1 ιι)
% Ρυθμίστε τον αριθμό των frames στη γραμμή 19. 
% Επίσης, μπορείται να αλλάξετε το frame από το οποίο ξεκινάει
% η κωδικοποίηση στη γραμμή 20, καθώς το βίντεο είναι ακίνητο στην αρχή
% και οι διαφορές είναι σχεδόν μηδενικές. Για να τρέξει όλοκληρο το βίντεο
% από την αρχή κάντε comment τις γραμμές 19 και 20.

vid = VideoReader('../Videos/Untitled.mp4');

rgbframes = read(vid);
[w,h,~,frame_number] = size(rgbframes);
frames = (zeros(w,h,frame_number));
start_frame = 1;

for i=1:frame_number
    frames(:,:,i)=(rgb2gray(rgbframes(:,:,:,i)));
end

frame_number = 10; %comment these lines for the entire video
start_frame = 200; %change this to start from a different frame

[codes,dicts,coded_mvs]  = encode_video(frames(:,:,start_frame:start_frame+frame_number),frame_number,32);
[rec_frames,error_frames] = decode_video(codes,dicts,coded_mvs,32);

v = VideoWriter('errorframes.avi');
open(v);
for i=1:frame_number-1
    imshow(uint8(error_frames(:,:,i)));
    writeVideo(v,uint8(error_frames(:,:,i)));
end
close(v);

v = VideoWriter('compressedframes.avi');
open(v);
for i=1:frame_number
    imshow([uint8(frames(:,:,start_frame-1+i)) rec_frames(:,:,i)]);
    writeVideo(v,uint8(rec_frames(:,:,i)));
end
close(v);
