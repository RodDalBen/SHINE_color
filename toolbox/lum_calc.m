%
% lum_calc, January 2019
% (c) Rodrigo Dal Ben (dalbenwork@gmail.com)
%
% Adapted to be integrated with SHINE_color toolbox on February 2019 
%
% Calculates the luminance mean and standard deviation from the original 
% (INPUT) and the modified rgb images (OUTPUT). 
% The calculations are performed on Value channel of hsv color space.
%
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
% Please send suggestions or corrections to dalbenwork@gmail.com
% ------------------------------------------------------------------------
% SHINE_color toolbox, September 2021, version 0.0.3
% (c) Rodrigo Dal Ben
%
% - Fix formula for pooled SD;
% - Add calculations based on colorspaces: 
%   - channel 3 for hsv;
%   - channel 1 for cielab;
% - Add pre and pos luminance summary on a single file, saved in the new 
% DIAGNOSTICS subfolder;
% - Update progress msg;
% - Update input for 'lum2scale' function
% ------------------------------------------------------------------------
% SHINE_color toolbox, October 2021, version 0.0.4
% (c) Rodrigo Dal Ben
%
% - Calculations are now done directly on the manipulated channels (pre and
% post). Previous versions re-read & transformed rgb images;
% - Luminace is calculated and reported in greyscale (0-255).
% ------------------------------------------------------------------------


function lum_calc (images_orig, images, imname, cs, rgb_channel)
% Set output folder
output_folder_diagnostics = fullfile(pwd,'SHINE_color_OUTPUT', 'DIAGNOSTICS');

% Set number of im
numim = length(images_orig);

% Set tag based on color space
if cs == 1 % hsv
    cs_tag = 'hsv_'; % colorspace tag
elseif cs == 2 % lab
    cs_tag = 'cielab_';
elseif cs == 3 % lab
    cs_tag = strcat('rgb_',rgb_channel,'_');
end

% Open output .txt
statistics_pre_post = fopen([output_folder_diagnostics filesep strcat(cs_tag, 'img_stats_pre_post.txt')], 'wt');

% Setting data structure
fprintf(statistics_pre_post, 'Img_pre\tMean_pre\tSD_pre\tImg_post\tMean_post\tSD_post\n');

% Setting initial mean and standard deviation
M_pre = 0;
Sd_pre = 0;

M_post = 0;
Sd_post = 0;

for i = 1:numim
  
   % Recording individual means and sds
   m1 = mean2(images_orig{i});
   m2 = mean2(images{i});
   
   sd1 = std2(images_orig{i});
   sd2 = std2(images{i});
   
   % Saving img name
   img1 = imname{i};
   img2 = strcat(cs_tag, imname{i});
   
   % Saving luminance values
   fprintf(statistics_pre_post, '%s\t%.4f\t%.4f\t%s\t%.4f\t%.4f\n', img1, m1, sd1, img2, m2, sd2);
   
   M_pre = M_pre + m1; % sum the mean of each iteration
   M_post = M_post + m2;
   
   Sd_pre = Sd_pre + sd1^2; % sum & square the sd of each iteration
   Sd_post = Sd_post + sd2^2;
      
end
      
% Pooled mean and sd
M_pre = M_pre/numim; 
M_post = M_post/numim; 

% Pooled sd: sqrt(sum(SD1^2 + SD2^2 ...)/N;
Sd_pre = sqrt(Sd_pre/numim); 
Sd_post = sqrt(Sd_post/numim); 

% Img name
img1 = 'Pooled';
img2 = 'Pooled';

% Save the overall mean and sd
fprintf(statistics_pre_post, '%s\t%.4f\t%.4f\t%s\t%.4f\t%.4f', img1, M_pre, Sd_pre, img2, M_post, Sd_post);

% Close all open .txt
fclose('all'); 

% Display progress msg on Command window
disp('Progress: lum_calc sucessful') 
disp('Progress: summary stats are in OUTPUT/DIAGNOSTICS');

end