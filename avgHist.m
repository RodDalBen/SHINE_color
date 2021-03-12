% average = avgHist(images,mask)
% 
% Averages the histograms across a set of grayscale images
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
% (2) mask: optional; can be a single matrix (of the same size as the 
%     pictures) or a cell of N matrices; mask contains ones where the
%     histograms are obtained (e.g., foreground) and zeros elsewhere  
%
% OUTPUT:
% (1) average: average histogram (vector)

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

function average = avgHist(images,mask)

if iscell(images)== 0
    error('The input must be a cell of image matrices.')
elseif min(size(images)>1)
    error('The input cell must be of size 1 x numim or numim x 1.')
end

if nargin > 1
    if iscell(mask) == 0
        m = mask;
    elseif max(size(mask))~=max(size(images)) || min(size(mask))~=min(size(images))
        error('The size of the input cells must be equal.')
    end
end

numim = max(size(images));
pixels = 0;
for im = 1:numim
    if ndims(images{im}) == 3
        images{im} = rgb2gray(images{im});
    end
    im1 = images{im};
    if nargin > 1
        if iscell(mask) == 1
            m = mask{im};
        end
        if sum(size(m)~=size(im1)) > 0
            error('The size of the mask must equal the size of the image.')
        elseif numel(m(m==1))==0
            error('The mask(s) must contain some ones.')
        end
        counts = imhist(im1(m==1));
    else
        counts = imhist(im1);
    end
    pixels = pixels+counts;
end
average = round(pixels/numim);

