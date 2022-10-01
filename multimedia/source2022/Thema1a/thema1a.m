% "Main" file για το θέμα 1 ι)
% Επειδή η διαδικασία είναι αργή, προτείνουμε να τρέξετε το πρόγραμμα
% για χαμηλό αριθμό από frames και όχι για ολόκληρο το βίντεο, ειδικά
% εάν το μηχάνημα σας δεν έχει αρκετή υπολογιστική ισχύ.
% Ρυθμίστε τον αριθμό των frames στη γραμμή 23. 
% Επίσης, μπορείται να αλλάξετε το frame από το οποίο ξεκινάει
% η κωδικοποίηση στη γραμμή 24, καθώς το βίντεο είναι ακίνητο στην αρχή
% και οι διαφορές είναι σχεδόν μηδενικές. Για να τρέξει όλοκληρο το βίντεο
% από την αρχή κάντε comment τις γραμμές 23 και 24.

vid = VideoReader('../Videos/Untitled.mp4');

rgb_frames = read(vid);

[w,h,~,frame_number] = size(rgb_frames);
frames = zeros(w,h,frame_number);
start_frame=1;

%convert frames to grayscale
for i=1:frame_number
    frames(:,:,i) = rgb2gray(rgb_frames(:,:,:,i));  
end

frame_number = 10;  %comment these lines for the entire video
start_frame = 200; %change this to start from a different frame or comment

diffs = zeros(w,h,frame_number-1);
for i=1:frame_number
    dif = frames(:,:,start_frame+i)-frames(:,:,start_frame+i-1);    %difference of consecutive frames
    diffs(:,:,i) = dif; %save difference frame
    imshow(uint8(dif));
end



[codes,dicts] = encode(diffs,32);   %encode difference frames
dec_diffs = decode(codes,dicts,32,w,h); %decode and reconstruct difference frames


for i=1:frame_number %show original and recreated diff frames
    imshow(uint8([diffs(:,:,i) dec_diffs(:,:,i)]))
    title("Original vs encoded-decoded difference frames")
end


cf = frames(:,:,start_frame);   %start from start_frame
for i=1:frame_number
    rf = cf + dec_diffs(:,:,i); %recreate next frame by adding diff frame
    imshow(uint8([frames(:,:,start_frame+i) rf]));
    title("Original vs encoded-decoded video")
    cf = rf;
end




