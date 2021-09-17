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


function lum_calc (input_folder, output_folder, imformat, cs)
%% Initial setup
% Set input and output source and name pattern
src_input = dir(fullfile(strcat(input_folder, filesep, '*.', imformat))); 
src_output = dir(fullfile(strcat(output_folder, filesep, '*.', imformat)));
output_folder_diagnostics = fullfile(pwd,'SHINE_color_OUTPUT', 'DIAGNOSTICS');

% Set number of im
numim = length(src_input);

% Opening the output .txt
if cs == 1 % hsv
    cs_tag = 'hsv_'; % colorspace tag
elseif cs == 2 % lab
    cs_tag = 'cielab_';
end

statistics_pre_pos = fopen([output_folder_diagnostics filesep strcat(cs_tag, 'img_stats_pre_pos.txt')], 'wt');

% Setting data structure
fprintf(statistics_pre_pos, 'Img_pre\tMean_pre\tSD_pre\tImg_pos\tMean_pos\tSD_pos\n');

% Setting initial Img
img1 = [];

% Setting initital number of hsv and lab imgs
n_pre = 0;
n_pos = 0;

% Setting initial mean and standard deviation
M_pre = 0;
Sd_pre = 0;

M_pos = 0;
Sd_pos = 0;

for i = 1:numim
   % load images
   file_name1 = strcat(input_folder, filesep, src_input(i).name); 
   I1 = imread(file_name1);
       %figure,imshow(I1); % To check if imgs have been loaded properly delete the "%" mark
   
   file_name2 = strcat(output_folder, filesep, src_output(i).name); 
   I2 = imread(file_name2);
       %figure,imshow(I2); % To check if imgs have been loaded properly delete the "%" mark
   
   if cs == 1 % hsv
       % from rbg to hsv
       im_pre = rgb2hsv(I1);
       im_pos = rgb2hsv(I2);
   
       % defining channels
       lum1 = im_pre(:,:,3);  
       lum2 = im_pos(:,:,3); 
        
   elseif cs == 2 % lab
       % from rbg to cielab
       im_pre = rgb2lab(I1);
       im_pos = rgb2lab(I2);
   
       % defining channels
       lum1 = im_pre(:,:,1);  
       lum2 = im_pos(:,:,1); 
   end
  
    % Recording indiviudal means and sds
    m1 = mean2(lum1);
    m2 = mean2(lum2);
   
   sd1 = std2(lum1);
   sd2 = std2(lum2);
   
   % Updating img name
   img1 = src_input(i).name;
   img2 = src_output(i).name;
   
   % Registering hsv and lab values
   fprintf(statistics_pre_pos, '%s\t%.4f\t%.4f\t%s\t%.4f\t%.4f\n', img1, m1, sd1, img2, m2, sd2);
   
   n_pre = n_pre + 1; % updates the number of hsv files
   n_pos = n_pos + 1;
   
   M_pre = M_pre + m1; % sum of the mean of each iteration of hsv files
   M_pos = M_pos + m2;
   
   Sd_pre = Sd_pre + sd1^2; % sum of the sd of each iteration of hsv files
   Sd_pos = Sd_pos + sd2^2;
      
end
      
% pooled mean and sd
M_pre = M_pre/numim; 
M_pos = M_pos/numim; 

% pooled sd: sqrt(sum(SD1^2 + SD2^2 ...)/N) ; SDs are squared and summed in for loop
Sd_pre = sqrt(Sd_pre/numim); 
Sd_pos = sqrt(Sd_pos/numim); 

% Redifining img
img1 = 'Pooled';
img2 = 'Pooled';

% Recording the overall mean and sd
fprintf(statistics_pre_pos, '%s\t%.4f\t%.4f\t%s\t%.4f\t%.4f', img1, M_pre, Sd_pre, img2, M_pos, Sd_pos);

fclose('all'); % close all open .txt

disp('Progress: lum_calc sucessful') 
disp('Progress: summary stats are in OUTPUT/DIAGNOSTICS');

end