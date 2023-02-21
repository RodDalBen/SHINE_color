% [ims,nim,imname] = readImages(pathname,imformat)
%
% Loads all images of the type specified by imformat that are saved in 
% the folder specified by pathname
%
% INPUT:
% (1) pathname: directory (e.g. pathname = '/Applications/MATLAB/work')
% (2) imformat: file format of the input images (e.g., imformat = 'tif')
%
% OUTPUT:
% (1) ims: a cell containing the image matrices
% (2) nim: number of images

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
% Convert RGB to HSV, and scale the Value channel (channel 3) (v2scale).
% Extracts hue (channel 1) and saturation (channel 2) for later 
% concatenation. 
%
% Kindly report any suggestions or corrections on the adaptation to 
% dalbenwork@gmail.com
% ------------------------------------------------------------------------
% SHINE_color toolbox, September 2021, version 0.0.3
% adapted by Rodrigo Dal Ben
%
% Convert RGB to CIELab, and scale the Luminance (channel 1) (v2scale).
% Extracts A (channel 2) and B (channel 3) for later concatenation. 
% ------------------------------------------------------------------------
% SHINE_color toolbox, March 2023, version 0.0.5
% adapted by Rodrigo Dal Ben
%
% Extract RGB channels when selecting this colorspace. 
% ------------------------------------------------------------------------

function [channel1, channel2, channel3, ims, nim, imname] = readImages(pathname, imformat, cs)

all_images = dir(fullfile(pathname,strcat('*.',imformat)));
nim = length(all_images);
ims = cell(nim,1);

channel1 = cell(nim,1); % SHINE_color: stores hue (HSV) or luminance (CIELab) or red channel (RGB)
channel2 = cell(nim,1); % SHINE_color: stores saturation (HSV) or A (CIELab) or green channel (RGB)
channel3 = cell(nim,1); % SHINE_color: stores value (HSV) or b (CIELab) or blue channel (RGB)

% SHINE_color: store RGB channels
if cs == 3
    rgb_channels = cell(nim, 3); 
end

imname = cell(nim,1); % SHINE_color: define image name

if nargout == 3
imname = cell(nim,1);
end

for im = 1:nim
    im1 = imread(fullfile(pathname,all_images(im).name));
    info = imfinfo(fullfile(pathname,all_images(im).name));
   
    if cs == 1 % SHINE_color: HSV
        hsv = rgb2hsv(im1); % SHINE_color: convert RGB to HSV
        hue = hsv(:,:,1); % SHINE_color: extract hue channel
        sat = hsv(:,:,2); % SHINE_color: extract saturation channel
        
        channel1{im} = hue; % SHINE_color: stores hue
        channel2{im} = sat; % SHINE_color: stores saturation
    
    elseif cs == 2  % SHINE_color: CIELab
        lab = rgb2lab(im1); % SHINE_color: convert RGB to CIELab
        a = lab(:,:,2); % SHINE_color: extract A channel
        b = lab(:,:,3); % SHINE_color: extract B channel
        
        channel2{im} = a; % SHINE_color: stores A channel
        channel3{im} = b; % SHINE_color: stores B channel
        
    elseif cs == 3 % SHINE_color: RGB
        channel1{im} = im1(:,:,1); % SHINE_color: red channel
        channel2{im} = im1(:,:,2); % SHINE_color: green channel
        channel3{im} = im1(:,:,3); % SHINE_color: blue channel
                
        % SHINE_color: stores RGB channels a single cell, each image in one
        % row {number of images, 3 channels}
        rgb_channels{im, 1} = channel1{im}; % SHINE_color: red channel
        rgb_channels{im, 2} = channel2{im}; % SHINE_color: green channel
        rgb_channels{im, 3} = channel3{im}; % SHINE_color: blue channel
        
    end
    
    imname{im} = all_images(im).name; % SHINE_color: define image name
    
    if strcmp(info.ColorType(1:4),'gray')==1
        ims{im} = im1;
        if nargout == 3
            imname{im} = all_images(im).name;
        end
        
    elseif strcmp(info.ColorType(1:4),'true')==1
        
        % SHINE_color: scale cells with V (HSV) and L (CIELab)
        if cs == 1 || cs == 2
            im1 = lum2scale(im1, cs);
            ims{im} = im1; % SHINE_color: store scaled channel
        elseif cs == 3
            ims = rgb_channels; % SHINE_color: RGB extracted channels as a cell {n, 3}
        end
        
        if nargout == 3
            imname{im} = all_images(im).name;
        end
    else
        error('Please convert all images to grayscale. Some of your images might be indexed images.')
    end
end

