% video2frames, April 2019, version 0.1.
% Rodrigo Dal Ben (dalbenwork@gmail.com)
%
% Extracts all frames from a video file and save them as .png images.

function frame_rate = video2frames(input_folder, video_format)

videoList = dir(fullfile(input_folder, strcat('*.', video_format)));

input_video = VideoReader(fullfile(input_folder, videoList(1).name));
frame_rate = input_video.FrameRate;

disp([10 'Extracting ', num2str(input_video.NumberOfFrames), ' frames...' 10]);

for iFrame = 1:input_video.NumberOfFrames
    frame = read(input_video, iFrame);
    %imshow(b); %debug (thousands of images may appear)
    imwrite(frame,fullfile(input_folder, sprintf('%08d.png', iFrame)));
end
disp(['All frames have been saved.' 10])

end