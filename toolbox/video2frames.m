%
% video2frames
%
% Extracts all frames from a video file and save them as .png images.
% ------------------------------------------------------------------------
% SHINE_color toolbox, February 2019, version 0.0.1
% (c) Rodrigo Dal Ben
% ------------------------------------------------------------------------
% Permission to use, copy, or modify this software and its documentation
% for educational and research purposes only and without fee is hereby
% granted, provided that this copyright notice and the original authors'
% names appear on all copies and supporting documentation. This program
% shall not be used, rewritten, or adapted as the basis of a commercial
% software or hardware product without first obtaining permission of the
% authors. The authors make no representations about the suitability of
% this software for any purpose. It is provided "as is" without express
% or implied warranty.
%
% Kindly report any suggestions or corrections dalbenwork@gmail.com
% ------------------------------------------------------------------------

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
