% images = lumMatch(images,mask,lum)
%
% Matches the mean luminance and contrast of a set of images
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
%     histograms are obtained (e.g., foreground) and zeros elsewhere. 
%     If images=lumMatch(images) or images=lumMatch(images,[],val), 
%     the whole image is used. 
% (3) lum: optional; desired mean and standard deviation (e.g., [128 32])
%     If not provided, the average mean and std across the input set is 
%     used.
%
% OUTPUT:
% (1) images: a cell that contains the output images equated in mean
%     luminance and contrast

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

function images = lumMatch(images,mask,lum)

if iscell(images) == 0
    error('The input must be a cell.')
elseif min(size(images)>1)
    error('The input cell must be of size 1 x numim or numim x 1.')
end

if nargin > 1
    if iscell(mask) == 0
        m = mask;
    elseif max(size(mask))~=max(size(images))||min(size(mask))~=min(size(images))
        error('The size of the input cells must be equal.')
    end
end

numim = max(size(images));
if nargin == 1
    M = 0; S = 0;
    for im = 1:numim
        if ndims(images{im}) == 3
            images{im} = rgb2gray(images{im});
        end
        M = M + mean2(images{im});
        S = S + std2(images{im});
    end
    M = M/numim;
    S = S/numim;
    for im = 1:numim
        im1 = double(images{im});
        if std2(im1)~=0
            im1 = (im1-mean2(im1))/std2(im1)*S+M;
        else
            im1(:,:) = M;
        end
        images{im} = uint8(im1);
    end
elseif nargin == 2
    M = 0; S = 0;
    for im = 1:numim
        if ndims(images{im}) == 3
            images{im} = rgb2gray(images{im});
        end
        im1 = images{im};
        if iscell(mask) == 1
            m = mask{im};
        end
        if sum(size(m)~=size(images{im}))>0
            error('The size of the mask must equal the size of the image.')
        elseif numel(m(m==1))==0
            error('The mask must contain some ones.')
        end
        M = M + mean2(im1(m==1));
        S = S + std2(im1(m==1));
    end
    M = M/numim;
    S = S/numim;
    for im = 1:numim
        im1 = double(images{im});
        if iscell(mask) == 1
            m = mask{im};
        end
        if std2(im1(m==1))
            im1(m==1) = (im1(m==1)-mean2(im1(m==1)))/std2(im1(m==1))*S+M;
        else
            im1(m==1) = M;
        end
        images{im} = uint8(im1);
    end
elseif nargin == 3
    M = lum(1); S = lum(2);
    for im = 1:numim
        if ndims(images{im}) == 3
            images{im} = rgb2gray(images{im});
        end
        im1 = double(images{im});
        if isempty(mask) == 1
            if std2(im1) ~= 0
                im1 = (im1-mean2(im1))/std2(im1)*S+M;
            else
                im1(:,:) = M;
            end
        else
            if iscell(mask) == 1
                m = mask{im};
            end
            if sum(size(m)~=size(images{im}))>0
                error('The size of the mask must equal the size of the image.')
            elseif numel(m(m==1)) == 0
                error('The mask must contain some ones.')
            end
            if std2(im1(m==1)) ~= 0
                im1(m==1) = (im1(m==1)-mean2(im1(m==1)))/std2(im1(m==1))*S+M;
            else
                im1(m==1) = M;
            end
        end
        images{im} = uint8(im1);
    end
end



