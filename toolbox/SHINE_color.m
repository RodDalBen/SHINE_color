% images = SHINE(images,templ)
%
% Equates a number of image properties across an image set
%
% INPUT:
% (1) images: a cell (1xN or Nx1) that contains N source image matrices
%      Example 1:
%       images = cell(3,1);
%       images{1} = pic1;
%       images{2} = pic2;
%       images{3} = pic3;
%      Example 2:
%       [images,N] = readImages(pathname,imformat);
% (2) templ: optional; contains the template(s) for figure-ground
%     segregation; templ can be a single matrix (of the same size as the
%     pictures) or a cell of N matrices; the background must be
%     uniform and of a luminance that does NOT occur in the foreground
%     (e.g., recommended: use a background of 255 and a foreground
%     of values between 0 and 254)
%
% OUTPUT:
% (1) images: optional; SHINEd images stored in a cell
%
% Alternatively, SHINE can be used to load and save the images
% automatically:
% 1. Put all source images in the SHINE_INPUT folder and make sure that it
%    does not contain any other files of the same format and that the
%    pathnames are correct (lines 70-72 of SHINE.m)
% 2. Specify the image format in line 69 of SHINE.m (imformat)
% 3. Optional: Put the templates in the SHINE_TEMPLATE folder and make sure
%    the folder does not contain any other files of the same format
% 4. Type the following in the Matlab command window to start the program:
%    SHINE
% 5. Press enter and choose among the shine options that appear in the
%    command window.
%
%    If you want to QUIT the program, press ENTER without
%    choosing an option.

% ------------------------------------------------------------------------
% SHINE toolbox, May 2010
% (c) Verena Willenbockel, Javid Sadr, Daniel Fiset, Greg O. Horne,
% Frederic Gosselin, James W. Tanaka
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
% Please refer to the following paper:
% Willenbockel, V., Sadr, J., Fiset, D., Horne, G. O., Gosselin, F.,
% Tanaka, J. W. (2010). Controlling low-level image properties: The
% SHINE toolbox. Behavior Research Methods, 42, 671-684.
%
% Kindly report any suggestions or corrections to verena.vw@gmail.com
% ------------------------------------------------------------------------
% SHINE_color toolbox, February 2019, version 0.0.1
% adapted by Rodrigo Dal Ben
%
% Convert RGB images to HSV and apply SHINE toolbox functions to the
% scaled Value channel (luminance). Then, the Value channel is rescaled
% and concatenated with Hue and Saturation channels.
%
% Three customs functions are used:
% v2scale: convert RGB to HSV and scale the Value channel (0-1) to 0-255;
% scale2v: rescale values from 0-255 to 0-1;
% lum_calc: calculates the Value channel values of the original and new
% images (the output is a .txt file saved on the images output folder).
%
% The major adaptations were made on the "readImages" function.
% Nonetheless the function "rgb2gray" was replaced by "v2scale" on all
% functions that it was called.
%
% All adaptations are commented and comments always begin with
% "SHINE_color:"
%
% Kindly report any suggestions or corrections on the adaptations to
% dalbenwork@gmail.com
% ------------------------------------------------------------------------
% SHINE_color toolbox, April 2019, version 0.0.2
% adapted by Rodrigo Dal Ben
%
% The toolbox now handles video files.
% If a video file is provided, all frames will be extracted, SHINE_color
% operations will be performed on each frame, and the video will be
% re-created with the manipulated frames.
% All the frames (pre and pos manipulations), their statistics, and the
% new video are outputted.
%
% Two functions were added:
% video2frames: to extract all frames of a video;
% frames2mpeg (+ getAllFilesInFolder): to re-create the video. This is an
% adaptation of the "imageFolder2mpeg" function created by Todd Karin.
%
% All adaptations are commented and comments always begin with
% "SHINE_color:"
%
% Kindly report any suggestions or corrections on the adaptations to
% dalbenwork@gmail.com
% ------------------------------------------------------------------------
% SHINE_color toolbox, September 2021, version 0.0.3
% (c) Rodrigo Dal Ben (dalbenwork@gmail.com)
%
% Updates & improvements:
% - Require selection to every prompt (except for prompts with default values);
% - Require at least 2 images to advance;
% - Fix the pooled SD calculation from 'lum_calc';
% - Update 'lum_calc' output, now with a single pre vs. pos file;
% - Add CIELab colorspace;
% - Update functions' input to account for new colorspace (e.g., sfPlot, spectrumPlot); 
% - 'v2scale' is now 'lum2scale';
% - 'scale2v' is now 'scale2lum';
% - Add 'DIAGNOSTICS' subfolder in 'SHINE_color_OUTPUT', for storing img stats and diag plots;
% - Add a new function 'diag_plots' for img input;
%
% Kindly report any suggestions or corrections on the adaptations to
% dalbenwork@gmail.com
% ------------------------------------------------------------------------
% SHINE_color toolbox, October 2021, version 0.0.4
% (c) Rodrigo Dal Ben (dalbenwork@gmail.com)
%
% Updates & improvements:
% - Updates on lum_calc & diag_plots functions;
%
% Kindly report any suggestions or corrections on the adaptations to
% dalbenwork@gmail.com
% ------------------------------------------------------------------------
% SHINE_color toolbox, March 2023, version 0.0.5
% (c) Rodrigo Dal Ben (dalbenwork@gmail.com)
%
% Updates & improvements:
% - Functional command line call for images and videos, all input is read by readImages; DONE! 
% - Remove transformation within individual functions; TO-DO
% - Updates on diag_plots; (TO-DO)
% - Add manipulation directly on RGB channels: (TO-DO)
% -- RGB added as a cs option (SHINE_color);
% -- RGB channels stored as a cell array (readImages);
% -- Iterate between rgb channels (lumMatch, ADD.............)
%
% - describe new functions
%
% Kindly report any suggestions or corrections on the adaptations to
% dalbenwork@gmail.com
% ------------------------------------------------------------------------


function images = SHINE_color(inputpath, outputpath, extension, cs, im_vid, plots)

% SHINE_color: default values for call from command line
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If desired, the default values can be changed here:

it = 1;           % number of iterations (default = 1)

wholeIm = 1;      % 1 = whole image (default)
                  % 2 = figure-ground separated (input images as templates)
                  % 3 = figure-ground separated (based on templates)

mode = 8;         % 1 = lumMatch only
                  % 2 = histMatch only
                  % 3 = sfMatch only
                  % 4 = specMatch only
                  % 5 = histMatch & sfMatch
                  % 6 = histMatch & specMatch
                  % 7 = sfMatch & histMatch
                  % 8 = specMatch & histMatch (default)

background = 300; % background lum of template, or 300=automatic (default)
                  % (automatically, the luminance that occurs most
                  % frequently in the image is used as background lum);
                  % basically, all regions of that lum are treated as
                  % background

rescaling = 1;    % 0 = no rescaling
                  % 1 = rescale absolute values (default)
                  % 2 = rescale average values

optim = 0;        % 0 = no SSIM optimization
                  % 1 = SSIM optimization (Avanaki, 2009; to change the
                  % number if iterations (default = 10) and adjust step
                  % size (default = 67), see histMatch.m)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% SHINE_color: differentiating between call on command line or wizard

% SHINE_color: command line
if nargin ~= 0
    if nargin < 6
        y_n_plot = 2;
    else
        y_n_plot = plots;
    end
    
    if im_vid == 2 % SHINE_color: if a video is provided
        video_format = extension;
        [frame_rate] = video2frames(inputpath, video_format);
        [channel1, channel2, channel3, images, numim, imname] = readImages(inputpath,'png',cs,im_vid);
        y_n_plot = 2;
    else
        imformat = extension;
        [channel1, channel2, channel3, images, numim, imname] = readImages(inputpath,imformat,cs,im_vid); 
    end
    
    output_folder = outputpath;
    template_folder = fullfile(pwd,'SHINE_color_TEMPLATE'); %marretado pra funcionar

% SHINE_color: wizard
else
    
[input_folder,output_folder,template_folder,cs,imformat,im_vid,frame_rate,mode,background,wholeIm,optim,y_n_plot] = userWizard(mode,background,wholeIm,optim);

% SHINE_color: store channel information as a function of colorspace
[channel1, channel2, channel3, images, numim, imname] = readImages(input_folder,imformat,cs,im_vid); 

end

disp(' ')
fprintf('Number of images: %d\n', numim);
disp(' ')

if numim < 2
    error('At least 2 images are required. Please check pathnames and file format.') % SHINE_color: >= 2 images required
end

% SHINE_color: Wizard end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SHINE_color: display info about transformations
it = displayInfo(mode,wholeIm,background,it);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SHINE_color: perform transformations
for iteration = 1:it
    if it > 1
        disp(' ')
        fprintf('Iteration %d\n', iteration)
    end
    if cs == 1
        % SHINE_color: separate foreground from background
        [mask_fgr,mask_bgr,background] = maskFgrBgr(wholeIm,channel3,numim,background,template_folder,imformat,nargin);
        channel3_mod = processImage(channel3, mode, wholeIm, mask_fgr, mask_bgr, optim, rescaling);
    elseif cs == 2
        % SHINE_color: separate foreground from background
        [mask_fgr,mask_bgr,background] = maskFgrBgr(wholeIm,channel1,numim,background,template_folder,imformat,nargin);
        channel1_mod = processImage(channel1, mode, wholeIm, mask_fgr, mask_bgr, optim, rescaling);
    elseif cs == 3
        channel1_mod = processImage(channel1, mode, wholeIm, [], [], optim, rescaling);
        channel2_mod = processImage(channel2, mode, wholeIm, [], [], optim, rescaling);
        channel3_mod = processImage(channel3, mode, wholeIm, [], [], optim, rescaling);
    end
    
    
    % SHINE_color: uncomment next line to save each iteration's result
    % to output folder
    %save(fullfile(output_folder,sprintf('SHINE_color_d_%d_it',iteration)),'images')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rmsqe_all = 0;
mssim_all = 0;


for im = 1:numim
    if nargout == 0
        
        % SHINE_color: rescale value channel from 0-255 to 0-1 (HSV) or 0-100 (CIELab)
            if cs == 1 % SHINE_color: HSV
                channel3_mod{im} = scale2lum(channel3_mod{im}, cs); % SHINE_color: channel created on readImages.m
                % SHINE_color: create a color image (from HSV, CIELab, or RGB)
                color_im = cat(3, channel1{im}, channel2{im}, channel3_mod{im});
                 % SHINE_color: transform HSV or CIELab to RGB and create label
                color_im = hsv2rgb(color_im);
                cs_tag = 'hsv_';
                rmsqe = getRMSE(channel3{im},channel3_mod{im});
                rmsqe_all = rmsqe_all+rmsqe;
                mssim = ssim_index(channel3{im},channel3_mod{im});
                mssim_all = mssim_all+mssim;
                
            elseif cs == 2 % SHINE_color: CIELab
                channel1_mod{im} = scale2lum(channel1_mod{im}, cs); % SHINE_color: channel created on readImages.m
                % SHINE_color: create a color image (from HSV, CIELab, or RGB)
                color_im = cat(3, channel1_mod{im}, channel2{im}, channel3{im});
                 % SHINE_color: transform HSV or CIELab to RGB and create label
                color_im = lab2rgb(color_im);
                cs_tag = 'cielab_';
                rmsqe = getRMSE(channel1{im},channel1_mod{im});
                rmsqe_all = rmsqe_all+rmsqe;
                mssim = ssim_index(channel1{im},channel1_mod{im});
                mssim_all = mssim_all+mssim;
                
             elseif cs == 3 % SHINE_color: RGB
                 % SHINE_color: create a color image (from HSV, CIELab, or RGB)
                 color_im = cat(3, channel1_mod{im}, channel2_mod{im}, channel3_mod{im});
                 cs_tag = 'rgb_'; 
                 
                 %how to calculate RMSE for rgb?
            end
                   
            % SHINE_color: SHINE original command, deprecated
            %imwrite(images{im},fullfile(output_folder,strcat('SHINE_color_d_',num2str(im),'.tif'))); 
            
            % SHINE_color: writing the colorful image
            imwrite(color_im,fullfile(output_folder,strcat('SHINE_color_',cs_tag, num2str(im),'.png'))); 
    end
    %mssim_all = mssim_all+mssim; %uncomment will break for RGB

end

if cs == 1 % SHINE_color: HSV
    lum_calc(channel3, channel3_mod, imname, cs); % SHINE_color: luminance calculation for original and manipulated images
    if y_n_plot == 1
    diag_plots(channel3, channel3_mod, imname, cs, mode); % SHINE_color: diagnostic plots
    end
elseif cs == 2 %SHINE_color: CIELab
    lum_calc(channel1, channel1_mod, imname, cs); % SHINE_color: luminance calculation for original and manipulated images
    if y_n_plot == 1
    diag_plots(channel1, channel1_mod, imname, cs, mode); % SHINE_color: diagnostic plots
    end
elseif cs == 3 %SHINE_color: RGB
    lum_calc(channel1, channel1_mod, imname, cs); % SHINE_color: luminance calculation for original and manipulated images
    lum_calc(channel2, channel2_mod, imname, cs); 
    lum_calc(channel3, channel3_mod, imname, cs); 
    if y_n_plot == 1
    diag_plots(channel1, channel1_mod, imname, cs, mode, 'R'); % SHINE_color: diagnostic plots
    diag_plots(channel2, channel2_mod, imname, cs, mode, 'G'); 
    diag_plots(channel3, channel3_mod, imname, cs, mode, 'B');
    end
end


RMSE = rmsqe_all/numim;
SSIM = mssim_all/numim;

disp(' ')
fprintf('RMSE:     %d\n',RMSE)
fprintf('SSIM:     %d\n',SSIM)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if im_vid == 2
    disp([10 'Progress: Re-creating video with new properties.' 10]);
    frames2mpeg(output_folder,frame_rate);
    disp([10 'Progress: New video in OUTPUT folder, statistics in OUTPUT/DIAGNOSTICS.']);
end

disp(' ')
disp('All done, please remember to check your Monitor calibration to ensure proper luminance display.')
disp(' ')

% SHINE_color: display citation info. 
%%%%% Should we add License info? Match GitHub

fprintf(['Please cite: \n',... 
    'Dal Ben, R. (2021, July 5). SHINE_color: controlling low-level properties of colorful images. \n',...
    'PsyArXiv: https://doi.org/10.31234/osf.io/fec6x \n',...
    '\n',...
    'Willenbockel, V., Sadr, J., Fiset, D., Horne, G. O., Gosselin, F., & Tanaka, J. W. (2010).\n',...
    'Controlling low-level image properties: The SHINE toolbox.\n',... 
    'Behavior Research Methods, 42(3), 671?684. http://doi.org/10.3758/BRM.42.3.671\n'])

if nargout < 1
    clear images
end
