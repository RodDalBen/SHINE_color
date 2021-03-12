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

function [ims,nim,imname] = readImages(pathname,imformat)

all_images = dir(fullfile(pathname,strcat('*.',imformat)));
nim = length(all_images);
ims = cell(nim,1);

if nargout == 3
imname = cell(nim,1);
end

for im = 1:nim
    im1 = imread(fullfile(pathname,all_images(im).name));
    info = imfinfo(fullfile(pathname,all_images(im).name));
    if strcmp(info.ColorType(1:4),'gray')==1
        ims{im} = im1;
        if nargout == 3
        imname{im} = all_images(im).name;
        end
    elseif strcmp(info.ColorType(1:4),'true')==1
        im1 = rgb2gray(im1);
        ims{im} = im1;
        if nargout == 3
        imname{im} = all_images(im).name;
        end
    else
        error('Please convert all images to grayscale. Some of your images might be indexed images.')
    end
end

