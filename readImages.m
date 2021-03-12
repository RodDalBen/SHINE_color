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
% SHINE_color toolbox, February 2019
% adapted by Rodrigo Dal Ben
%
% Convert RGB to HSV, and scale the Value channel (v2scale).
% Extracts hue and saturation (sat) for later concatenation. 
%
% Kindly report any suggestions or corrections on the adaptation to 
% dalbenwork@gmail.com
% ------------------------------------------------------------------------


function [hue_cell, sat_cell, v_cell,ims,nim,imname] = readImages(pathname,imformat)

all_images = dir(fullfile(pathname,strcat('*.',imformat)));
nim = length(all_images);
ims = cell(nim,1);

hue_cell = cell(nim,1); % SHINE_color: cell to store hue channel
sat_cell = cell(nim,1); % SHINE_color: cell to store saturation channel
v_cell = cell(nim,1); % SHINE_color: cell to store value channel (to be filled on SHINE_color)

imname = cell(nim,1); % SHINE_color: define imname

if nargout == 3
imname = cell(nim,1);
end

for im = 1:nim
    im1 = imread(fullfile(pathname,all_images(im).name));
    info = imfinfo(fullfile(pathname,all_images(im).name));
   
    hsv = rgb2hsv(im1); % SHINE_color: converting from rgb to hsv
    hue = hsv(:,:,1); % SHINE_color: extracting hue channel
    sat = hsv(:,:,2); % SHINE_color: extracting saturation channel
        
    hue_cell{im} = hue; % SHINE_color: storing hue
    sat_cell{im} = sat; % SHINE_color: storing saturation
    
    imname{im} = all_images(im).name; % SHINE_color: define imname
    
    if strcmp(info.ColorType(1:4),'gray')==1
        ims{im} = im1;
        if nargout == 3
        imname{im} = all_images(im).name;
        end
    elseif strcmp(info.ColorType(1:4),'true')==1
        
        im1 = v2scale(im1); % SHINE_color: replaced rgb2gray(im1) for a function that scales hsv Value channel
        ims{im} = im1; % SHINE_color: storing scaled Value channel
              
        if nargout == 3
        imname{im} = all_images(im).name;
        end
    else
        error('Please convert all images to grayscale. Some of your images might be indexed images.')
    end
end

