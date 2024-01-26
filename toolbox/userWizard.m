%
% userWizard, April 2023
%
% Wizard to walk users through manipulation options. 
%
% Adaptation to turn the main SHINE_color script into standalone modules.
% ------------------------------------------------------------------------
% Main script - (c) Verena Willenbockel, Javid Sadr, Daniel Fiset, 
% Greg O. Horne, Frederic Gosselin, James W. Tanaka
% Adaptation - (c) Rodrigo Dal Ben (dalbenwork@gmail.com)
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


function [input_folder,output_folder,template_folder,cs,imformat,im_vid,frame_rate,mode,background,wholeIm,optim,y_n_plot] = userWizard(mode,background,wholeIm,optim)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SHINE_color: Wizard
% Specify the image format and the input/output directories here if SHINE
% is called without input or output arguments:
input_folder = fullfile(pwd, 'SHINE_color_INPUT'); % SHINE_color: input folder in the current dir
output_folder = fullfile(pwd,'SHINE_color_OUTPUT'); % SHINE_color: output folder in the current dir
template_folder = fullfile(pwd,'SHINE_color_TEMPLATE'); % SHINE_color: template folder in the current dir

% SHINE_color: define initial values for:
im_vid = 0; % SHINE_color: static image or video
frame_rate = 0; % SHINE_color: initialize framerate to 0
quitmsg = 'SHINE_color was quit.'; % SHINE_color: quit std message
cs = 0; % SHINE_color: colorspace to be used
y_n_plot = 0; % SHINE_color: to plot manipulations or not



% SHINE_color: start by selecting image or video processing:
while im_vid ~= 1 && im_vid ~= 2
    prompt = 'Input     [1=images, 2=video]: ';
    im_vid = input(prompt);
    if isempty(im_vid) == 1 % SHINE_color: forced choice
        disp(quitmsg)
        error('Please select an option');
    end 
end

y_n = 0;

if im_vid == 2
    while y_n ~= 1 && y_n ~= 2
    prompt = 'The INPUT folder contains only one video and the OUTPUT folder is empty? [1=yes, 2=no]: ';
    y_n = input(prompt);
        if isempty(y_n) == 1 % SHINE_color: forced choice
            disp(quitmsg)
            error('Please select an option');
        end 
    end
        if y_n == 2
            disp('Error: the INPUT folder must contain only one video and the OUTPUT folder must be empty');
            error('Error: the INPUT folder must contain only one video and the OUTPUT folder must be empty');
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
        error('Error: The INPUT folder must contain only one video at a time.');
    end

    [frame_rate] = video2frames(input_folder, video_format);
    
    while cs ~= 1 && cs ~= 2 && cs ~= 3 && cs ~= 4
        cs = input('Select the colorspace to perform the manipulations    [1=HSV, 2=CIELab, 3=RGB, 4=Greyscale]: ');
        if isempty(cs) == 1
            disp(quitmsg);
            error('Please select an option');
        elseif cs == 4
            fprintf(['\nPlease refer to the SHINE toolbox for greyscale manipulations:\n'...
                'Willenbockel, V., Sadr, J., Fiset, D., Horne, G. O., Gosselin, F., & Tanaka, J. W. (2010).\n',...
                'Controlling low-level image properties: The SHINE toolbox.\n',... 
                'Behavior Research Methods, 42(3), 671?684. http://doi.org/10.3758/BRM.42.3.671\n\n'])
            error('Please select another colorspace.');
        end
    end
    
elseif im_vid == 1
    
    % SHINE_color: user input on img format
    prompt = 'Type the image format  [e.g., jpg, png]: ';
    imformat = input(prompt,'s');
    if isempty(imformat)
      imformat = 'jpg';
      disp('jpg as default');
    elseif imformat == 'png'
      fprintf(['\nPlease note that our toolbox does not support transparent backgrounds.\n',...
          'Transparent backgrounds will be converted during manipulations.\n',...
          'Please manipulate the fore and background separately, and then remove the background\n',...
          'in an image processing software (e.g., GIMP).\n\n']);  
    end
    
    while cs ~= 1 && cs ~= 2 && cs ~= 3
    cs = input('Select the colorspace to perform the manipulations    [1=HSV, 2=CIELab, 3=RGB, 4=Greyscale]: ');
        if isempty(cs) == 1
            disp(quitmsg);
            error('Please select an option');
        elseif cs == 4
            fprintf(['\nPlease refer to the SHINE toolbox for greyscale manipulations:\n'...
                'Willenbockel, V., Sadr, J., Fiset, D., Horne, G. O., Gosselin, F., & Tanaka, J. W. (2010).\n',...
                'Controlling low-level image properties: The SHINE toolbox.\n',... 
                'Behavior Research Methods, 42(3), 671?684. http://doi.org/10.3758/BRM.42.3.671\n\n'])
            error('Please select another colorspace.');
        
        end
    end
    
    while y_n_plot ~= 1 && y_n_plot ~= 2
    y_n_plot = input('Do you want diagnostic plots? (may take some time)    [1=yes, 2=no]: ');
        if isempty(y_n_plot) == 1
            disp(quitmsg);
            error('Please select an option');
        end
    end
    
end

% Default values
temp = 0; md = 0; wim = 0; backg = 0;

while temp ~= 1 && temp ~= 2
    temp = input('SHINE_color options    [1=default, 2=custom]: ');
    if isempty(temp) == 1
        disp(quitmsg)
        error('Please select an option');
    end
end

if temp == 2
    temp = 0;

    while temp ~= 1 && temp ~= 2 && temp ~= 3
        temp = input('Matching mode    [1=luminance, 2=spatial frequency, 3=both]: ');
        if isempty(temp) == 1 
            disp(quitmsg)
            error('Please select an option');
        end
    end
    
    if temp == 1
        while md ~= 1 && md ~= 2
            md = input('Luminance option [1=lumMatch, 2=histMatch]: ');
            if isempty(md) == 1 
                disp(quitmsg)
                error('Please select an option');
            end
            if md == 2
                while optim ~= 2 && optim ~= 3
                optim = 1+input('Optimize SSIM    [1=no, 2=yes]: ');
                if isempty(optim) == 1 
                    disp(quitmsg)
                    error('Please select an option');
                end 
                end
            end
        end
        
    elseif temp == 2
        while md ~= 3 && md ~= 4
            md = 2+input('Spectrum options [1=sfMatch, 2=specMatch]: ');
            if isempty(md) == 1
                disp(quitmsg)
                error('Please select an option');
            end
        end
        
    elseif temp == 3
        while md ~= 5 && md ~= 6 && md ~= 7 && md ~= 8
            md = 4+input('Matching of both [1=hist&sf, 2=hist&spec, 3=sf&hist, 4=spec&hist]: ');
            if isempty(md) == 1
                disp(quitmsg)
                error('Please select an option');
            end 
        end
        
        while optim ~= 2 && optim ~= 3
            optim = 1+input('Optimize SSIM    [1=no, 2=yes]: ');
            if isempty(optim) == 1
                disp(quitmsg)
                error('Please select an option');
            end
        end
        optim = optim-2;
            
        it = input('# of iterations? ');
        if isempty(it) == 1
           disp('Will run 1 iteration.')
        end
                
    end

    mode = md;

    if (temp == 1 || temp == 3) && cs ~= 3
        while wim ~= 1 && wim ~= 2
            wim = input('Matching region  [1=whole image, 2=foreground/background]: ');
            if isempty(wim) == 1
                disp(quitmsg)
                error('Please select an option');
            end
        end
        if wim == 2
            wim = 0;
            while wim ~= 2 && wim ~= 3
                wim = 1+input('Segmentation of: [1=source images]: '); %2=template(s)]: '); -template feature disable
                if isempty(wim) == 1 || wim ~= 2 %template feature disable
                    disp(quitmsg)
                    error('Please select an option');
                end
            end
            if wim == 2
                while backg ~= 1 && backg ~= 2
                    backg = input('Image background [1=specify lum, 2=find automatically (most frequent lum in the image)]: ');
                    if isempty(backg) == 1
                        disp(quitmsg)
                        error('Please select an option');
                    end
                end
            else
                while backg ~= 1 && backg ~= 2
                    backg = input('Templ background [1=specify lum, 2=find automatically (most frequent lum in the template)]: ');
                    if isempty(backg) == 1
                        disp(quitmsg)
                        error('Please select an option');
                    end
                end
            end
            if backg == 1
                backg = 1.1;
                while mod(backg,1) > 0 || backg < 0 || backg > 255
                    backg = input('Enter lum value  [integer between 0 and 255]: ');
                    if isempty(backg) == 1
                        disp(quitmsg)
                        error('Please select an option');
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
end
