% newimages = histMatch(images,optim,hist,mask)
%
% Equates a set of images in terms of luminance histograms by using the 
% function match.m
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
% (2) optim: optional; if set to 0, only the basic histogram matching
%     is performed (default); if set to 1, the SSIM optimization method of 
%     Avanaki (2009) will be used (with a default step size of 67 and 10 
%     iterations; see code lines 59-60) 
% (3) hist: optional; target histogram (e.g., hist=imhist(image));
%     if not specified or hist=[], the target will be computed using
%     avgHist.m
% (4) mask: optional; can be a single matrix (of the same size as the 
%     pictures) or a cell of N matrices; mask should contain ones where the
%     histograms will be equated (e.g., foreground) and zeros elsewhere 
%
% OUTPUT:
% (1) newimages: a cell containing the histogram-equated images

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
% Please refer to the following papers:
%
% Willenbockel, V., Sadr, J., Fiset, D., Horne, G. O., Gosselin, F.,
% Tanaka, J. W. (2010). Controlling low-level image properties: The
% SHINE toolbox. Behavior Research Methods, 42, 671-684.
%
% For the SSIM optimization algorithm please cite:
% Avanaki, A. N. (2009). Exact global histogram specification optimized for
% structural similarity. Optical Review, 16, 613-621.
%
% Kindly report any suggestions or corrections to verena.vw@gmail.com
% ------------------------------------------------------------------------

function newimages = histMatch(images,optim,hist,mask)

if nargin < 2
   optim = 0; 
end

if optim == 1
z = 10; % number of iterations for SSIM optimization (default = 10)
u = 67; % step size (default = 67)
end

if iscell(images) == 0
    error('The input must be a cell.')
elseif min(size(images)>1)
    error('The input cell must be of size 1 x numim or numim x 1.')
end

numims = max(size(images));

if nargin < 4
    if nargin < 3 || isempty(hist) == 1
        hist = avgHist(images);
    end
    targ = hist2list(hist);
    for ix = 1:numims
        if ndims(images{ix}) == 3
            images{ix} = rgb2gray(images{ix});
        end
        if optim == 1
            X = images{ix};
            M = numel(images{ix});
            for iter = 1:z
                Y = match(X,targ);
                sens = ssim_sens(double(images{ix}),Y);
                X = Y+u*M*sens;
            end
            images{ix} = uint8(Y);
        else
            images{ix} = uint8(match(images{ix},targ));
        end
    end
else
    if isempty(hist) == 1
        hist = avgHist(images,mask);
    end
    targ = hist2list(hist);
    if iscell(mask) == 0
        m = mask;
    elseif max(size(mask))~=max(size(images)) || min(size(mask))~=min(size(images))
        error('The size of the input cells must be equal.')
    end
    for ix = 1:numims
        if ndims(images{ix}) == 3
            images{ix} = rgb2gray(images{ix});
        end
        if iscell(mask)==1
            m = mask{ix};
        end
        if optim == 1
            X = images{ix};
            M = numel(images{ix});
            for iter = 1:z
                Y = match(X,targ,m);
                sens = ssim_sens(double(images{ix}),Y);
                X = Y+u*M*sens;
            end
            images{ix} = uint8(Y);
        else
            images{ix} = uint8(match(images{ix},targ,m));
        end
    end
end
newimages = images;