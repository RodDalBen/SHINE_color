% target = tarhist(images,mask)
%
% Computes a target "histogram" by first sorting the images' luminance 
% values in ascending order and then averaging them across  
% images, i.e., the values of the darkest pixels are averaged across 
% images, the values of the second-darkest pixels and so on.
%
% INPUT:
% (1) images: a cell (1xN or Nx1) that contains N source image matrices;
%     all images must have the same size.
%      Example 1: 
%       images = cell(3,1); 
%       images{1} = pic1; 
%       images{2} = pic2;
%       images{3} = pic3;
%      Example 2: 
%       [images,N] = readImages(pathname,imformat);
% (2) mask: optional; a matrix of the same size as the images, which
%     contains ones for the region of interest (e.g., the foreground) 
%     and zeros everywhere else
%
% OUTPUT:
% (1) targethist: vector containing a sorted list of luminance values; 
%     targethist can serve as input (target) for match.m 

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

function target = tarhist(images,mask)

if iscell(images) == 0
    error('The images must be stored in a cell.')
elseif min(size(images)>1)
    error('The input cell must be of size 1 x numim or numim x 1.')
end
if nargin > 1
    if numel(mask(mask==1))==0
        error('The mask must contain some ones.')
    end
    if sum(size(mask)~=size(images{1})) > 0
        error('The size of the mask must equal the size of the image.')
    end
end
numim = max(size(images));
pixels = 0;
[xs,ys] = size(images{1});
for im = 1:numim
    if ndims(images{im}) == 3
        images{im} = rgb2gray(images{im});
    end
    im1 = double(images{im});
    [xs1,ys1] = size(im1);
    if xs~=xs1 || ys~=ys1
        error('All images must have the same size.')
    end    
    if nargin < 2
        pixels = pixels+sort(im1(:));
    else
        pixels = pixels+sort(im1(mask==1));
    end
end
target = round(pixels/numim);



