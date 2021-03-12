% images = rescale(images,option)
%
% Rescales the luminance values so that either ALL values fall between
% 0 and 255, or so that the AVERAGE maximum and the average minimum 
% value obtained across all images are between 0 and 255
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
% (2) option: optional; 1 = rescale the absolute values (default);  
%     2 = rescale the average values; 
%
% OUTPUT:
% (2) images: rescaled images

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

function images = rescale(images,option)

if nargin < 2
    option = 1;
end
if iscell(images) == 0
    error('The input must be a cell.')
elseif min(size(images)>1)
    error('The input cell must be of size 1 x numim or numim x 1.')
end
numim = max(size(images));
brightests = zeros(numim,1);
darkests = zeros(numim,1);
for n = 1:numim
    if ndims(images{n}) == 3
        images{n} = rgb2gray(images{n});
    end
    images{n} = double(images{n});
    brightests(n) = max(max(images{n}));
    darkests(n) = min(min(images{n}));
end
the_brightest = max(brightests);
the_darkest = min(darkests);
avg_brightest = mean(brightests);
avg_darkest = mean(darkests);
for m = 1:numim
    if option == 1
        rescaled = (images{m}-the_darkest)/(the_brightest-the_darkest)*255;
    elseif option == 2
        rescaled = (images{m}-avg_darkest)/(avg_brightest-avg_darkest)*255;
    else
        error('Invalid rescaling option.')
    end
    images{m} = uint8(rescaled);
end