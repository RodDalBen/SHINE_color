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
    template_folder = fullfile(pwd,'SHINE_color_TEMPLATE');

% SHINE_color: wizard
else
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SHINE_color: Wizard
% Specify the image format and the input/output directories here if SHINE
% is called without input or output arguments:
input_folder = fullfile(pwd, 'SHINE_color_INPUT'); % SHINE_color: input folder in the current dir
output_folder = fullfile(pwd,'SHINE_color_OUTPUT'); % SHINE_color: output folder in the current dir
template_folder = fullfile(pwd,'SHINE_color_TEMPLATE'); % SHINE_color: template folder in the current dir

% SHINE_color: define initial values for:
im_vid = 0; % SHINE_color: static image or video
quitmsg = 'SHINE_color was quit.'; % SHINE_color: quit std message
cs = 0; % SHINE_color: colorspace to be used
y_n_plot = 0; % SHINE_color: to plot manipulations or not

% SHINE_color: start by selecting image or video processing:
while im_vid ~= 1 && im_vid ~= 2
    prompt = 'Input     [1=images, 2=video]: ';
    im_vid = input(prompt);
    if isempty(im_vid) == 1 % SHINE_color: forced choice
        disp(quitmsg)
        return;
    end 
end

y_n = 0;

if im_vid == 2
    while y_n ~= 1 && y_n ~= 2
    prompt = 'The INPUT folder contains only one video and the OUTPUT folder is empty? [1=yes, 2=no]: ';
    y_n = input(prompt);
        if isempty(y_n) == 1 % SHINE_color: forced choice
            disp(quitmsg)
            return;
        end 
    end
        if y_n == 2
            disp('Error: the INPUT folder must contain only one video and the OUTPUT folder must be empty');
            return
        else
            prompt = 'Type the video format    [e.g., mp4, avi]: ';
            video_format = input(prompt,'s');
            imformat = 'png';
            if isempty(video_format)
                video_format = 'mp4';
                disp('mp4 as default');
            end
        end

    videoList = dir(fullfile(input_folder, strcat('*.', video_format)));
    if length(videoList) > 1
        disp('Error: The INPUT folder must contain only one video at a time.')
        return
    end

    [frame_rate] = video2frames(input_folder, video_format);
    
    while cs ~= 1 && cs ~= 2 && cs ~= 3
        cs = input('Select the colorspace to perform the manipulations    [1=HSV, 2=CIELab, 3=RGB]: ');
        if isempty(cs) == 1
            disp(quitmsg);
            return
        end
    end
    
elseif im_vid == 1
    
    % SHINE_color: user input on img format
    prompt = 'Type the image format  [e.g., jpg, png]: ';
    imformat = input(prompt,'s');
    if isempty(imformat)
      imformat = 'jpg';
      disp('jpg as default');
    end
    
    while cs ~= 1 && cs ~= 2 && cs ~= 3
    cs = input('Select the colorspace to perform the manipulations    [1=HSV, 2=CIELab, 3=RGB]: ');
        if isempty(cs) == 1
            disp(quitmsg);
            return
        end
    end
    
    while y_n_plot ~= 1 && y_n_plot ~= 2
    y_n_plot = input('Do you want diagnostic plots? (may take some time)    [1=yes, 2=no]: ');
        if isempty(y_n_plot) == 1
            disp(quitmsg);
            return
        end
    end
    
end

% Default values
temp = 0; md = 0; wim = 0; backg = 0;

while temp ~= 1 && temp ~= 2
    temp = input('SHINE_color options    [1=default, 2=custom]: ');
    if isempty(temp) == 1
        disp(quitmsg)
        return;
    end
end

if temp == 2
    temp = 0;

    while temp ~= 1 && temp ~= 2 && temp ~= 3
        temp = input('Matching mode    [1=luminance, 2=spatial frequency, 3=both]: ');
        if isempty(temp) == 1 
            disp(quitmsg)
            return;
        end
    end
    
    if temp == 1
        while md ~= 1 && md ~= 2
            md = input('Luminance option [1=lumMatch, 2=histMatch]: ');
            if isempty(md) == 1 
                disp(quitmsg)
                return;
            end
            if md == 2
                while optim ~= 2 && optim ~= 3
                optim = 1+input('Optimize SSIM    [1=no, 2=yes]: ');
                if isempty(optim) == 1 
                    disp(quitmsg)
                    return;
                end 
                end
            end
        end
        
    elseif temp == 2
        while md ~= 3 && md ~= 4
            md = 2+input('Spectrum options [1=sfMatch, 2=specMatch]: ');
            if isempty(md) == 1
                disp(quitmsg)
                return;
            end
        end
        
    elseif temp == 3
        while md ~= 5 && md ~= 6 && md ~= 7 && md ~= 8
            md = 4+input('Matching of both [1=hist&sf, 2=hist&spec, 3=sf&hist, 4=spec&hist]: ');
            if isempty(md) == 1
                disp(quitmsg)
                return;
            end 
        end
        
        while optim ~= 2 && optim ~= 3
            optim = 1+input('Optimize SSIM    [1=no, 2=yes]: ');
            if isempty(optim) == 1
                disp(quitmsg)
                return;
            end
        end
        optim = optim-2;
            
        it = input('# of iterations? ');
        if isempty(it) == 1
           disp('Will run 1 iteration.')
        end
                
    end

    mode = md;

    if temp == 1 || temp == 3
        if nargin < 2
            while wim ~= 1 && wim ~= 2
                wim = input('Matching region  [1=whole image, 2=foreground/background]: ');
                if isempty(wim) == 1
                    disp(quitmsg)
                    return;
                end
            end
        else
            wim = 2;
        end
        if wim == 2
            wim = 0;
            if nargin < 2
                while wim ~= 2 && wim ~= 3
                    wim = 1+input('Segmentation of: [1=source images, 2=template(s)]: ');
                    if isempty(wim) == 1
                        disp(quitmsg)
                        return;
                    end
                end
            else
                wim = 3;
            end
            if wim == 2
                while backg ~= 1 && backg ~= 2
                    backg = input('Image background [1=specify lum, 2=find automatically (most frequent lum in the image)]: ');
                    if isempty(backg) == 1
                        disp(quitmsg)
                        return;
                    end
                end
            else
                while backg ~= 1 && backg ~= 2
                    backg = input('Templ background [1=specify lum, 2=find automatically (most frequent lum in the template)]: ');
                    if isempty(backg) == 1
                        disp(quitmsg)
                        return;
                    end
                end
            end
            if backg == 1
                backg = 1.1;
                while mod(backg,1) > 0 || backg < 0 || backg > 255
                    backg = input('Enter lum value  [integer between 0 and 255]: ');
                    if isempty(backg) == 1
                        disp(quitmsg)
                        return;
                    end
                end
            else
                backg = 300;
            end
            background = backg;
        end
        wholeIm = wim;
    end
end

clear temp md wim backg

% SHINE_color: store channel information as a function of colorspace
[channel1, channel2, channel3, images, numim, imname] = readImages(input_folder,imformat,cs,im_vid); 

end

disp(' ')
disp(sprintf('Number of images: %d', numim));
disp(' ')

if numim < 2
    error('At least 2 images are required. Please check pathnames and file format.') % SHINE_color: >= 2 images required
end

% SHINE_color: Wizard end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% FIX
images_orig = images; % SHINE_color: copy of original images for future calculations

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SHINE_color: display info about transformations
it=displayInfo(mode,wholeIm,background,it);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SHINE_color: perform transformations
for iteration = 1:it
    if it > 1
        disp(' ')
        disp(sprintf('Iteration %d', iteration))
    end
    if cs == 1
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % SHINE_color: separate foreground from background
        [mask_fgr,mask_bgr,background] = maskFgrBgr(wholeIm,channel3,numim,background,template_folder,imformat,nargin);
        channel3_mod = processImage(channel3, mode, wholeIm, mask_fgr, mask_bgr, optim, rescaling);
    elseif cs == 2
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
            elseif cs == 2 % SHINE_color: CIELab
                channel1_mod{im} = scale2lum(channel1_mod{im}, cs); % SHINE_color: channel created on readImages.m
                % SHINE_color: create a color image (from HSV, CIELab, or RGB)
                color_im = cat(3, channel1_mod{im}, channel2{im}, channel3{im});
                 % SHINE_color: transform HSV or CIELab to RGB and create label
                color_im = lab2rgb(color_im);
                cs_tag = 'cielab_';
             elseif cs == 3 % rgb
                 % SHINE_color: create a color image (from HSV, CIELab, or RGB)
                 color_im = cat(3, channel1_mod{im}, channel2_mod{im}, channel3_mod{im});
                 cs_tag = 'rgb_'; 
            end
                   
            % SHINE_color: SHINE original command, deprecated
            %imwrite(images{im},fullfile(output_folder,strcat('SHINE_color_d_',num2str(im),'.tif'))); 
            
            % SHINE_color: writing the colorful image
            imwrite(color_im,fullfile(output_folder,strcat('SHINE_color_',cs_tag, num2str(im),'.png'))); 
    end
    %rmsqe = getRMSE(images_orig{im},images{im}); -todo separate by
    %colorspace
    %rmsqe_all = rmsqe_all+rmsqe;
    %mssim = ssim_index(images_orig{im},images{im});
    %mssim_all = mssim_all+mssim;
end

lum_calc(images_orig, images, imname, cs); % SHINE_color: luminance calculation for original and manipulated images

if y_n_plot == 1
    diag_plots(images_orig, images, imname, cs, mode); % SHINE_color: diagnostic plots
end

RMSE = rmsqe_all/numim;
SSIM = mssim_all/numim;

disp(' ')
disp(sprintf('RMSE:     %d',RMSE))
disp(sprintf('SSIM:     %d',SSIM))

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
