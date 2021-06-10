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


function lum_calc (input_folder, output_folder, imformat)
%% Initial setup
% Set input and output source and name pattern
src_input = dir(fullfile(strcat(input_folder, filesep, '*.', imformat))); 
src_output = dir(fullfile(strcat(output_folder, filesep, '*.', imformat)));

% Set number of im
numim = length(src_input);

% Opening the output .txt
statistics_pre = fopen([input_folder filesep 'img_statistics_pre.txt'], 'wt'); 
statistics_pos = fopen([output_folder filesep 'img_statistics_pos.txt'], 'wt');

% Setting data structure
fprintf(statistics_pre, 'Img\tMean_hsv_pre\tSD_hsv_pre\n'); 
fprintf(statistics_pos, 'Img\tMean_hsv_pos\tSD_hsv_pos\n'); 

% Setting initial Img
img1 = [];

% Setting initital number of hsv and lab imgs
n_hsv_pre = 0;
n_hsv_pos = 0;

% Setting initial mean and standard deviation
M_v_pre = 0;
Sd_v_pre = 0;

M_v_pos = 0;
Sd_v_pos = 0;

for i = 1:numim
   % load images
   file_name1 = strcat(input_folder, filesep, src_input(i).name); 
   I1 = imread(file_name1);
       %figure,imshow(I); % To check if imgs have been loaded properly delete the "%" mark
   
   file_name2 = strcat(output_folder, filesep, src_output(i).name); 
   I2 = imread(file_name2);
       %figure,imshow(I); % To check if imgs have been loaded properly delete the "%" mark
    
   % from rbg to hsv
   hsv1 = rgb2hsv(I1);
   hsv2 = rgb2hsv(I2);
   
   % defining channels
   v_hsv1 = hsv1(:,:,3);  
   v_hsv2 = hsv2(:,:,3); 
  
   % Recording indiviudal means and sds
   m_hsv1 = mean2(v_hsv1);
   m_hsv2 = mean2(v_hsv2);
   
   sd_hsv1 = std2(v_hsv1);
   sd_hsv2 = std2(v_hsv2);
   
   % Updating img name
   img1 = src_input(i).name;
   img2 = src_output(i).name;
   
   % Registering hsv and lab values
   fprintf(statistics_pre, '%s\t%.4f\t%.4f\n', img1, m_hsv1, sd_hsv1); 
   fprintf(statistics_pos, '%s\t%.4f\t%.4f\n', img2, m_hsv2, sd_hsv2); 
   
   n_hsv_pre = n_hsv_pre + 1; % updates the number of hsv files
   n_hsv_pos = n_hsv_pos + 1;
   
   M_v_pre = M_v_pre + m_hsv1; % sum of the mean of each iteration of hsv files
   M_v_pos = M_v_pos + m_hsv2;
   
   Sd_v_pre = Sd_v_pre + sd_hsv1; % sum of the sd of each iteration of hsv files
   Sd_v_pos = Sd_v_pos + sd_hsv2;
end
      
% Calculating pooled mean and sd
M_v_pre = M_v_pre/numim; 
M_v_pos = M_v_pos/numim; 

Sd_v_pre = Sd_v_pre/numim;
Sd_v_pos = Sd_v_pos/numim;

% Redifining img
img1 = 'Pooled';
img2 = 'Pooled';

% Recording the overall mean and sd
fprintf(statistics_pre, '%s\t%.4f\t%.4f', img1, M_v_pre, Sd_v_pre);
fprintf(statistics_pos, '%s\t%.4f\t%.4f', img2, M_v_pos, Sd_v_pos);

fclose('all'); % close all open .txt

disp('Progress: lum_calc successful')

end