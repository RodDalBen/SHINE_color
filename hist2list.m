% targetlist = hist2list(hist)
% 
% Converts a luminance histogram into a sorted list of luminance values 
%
% INPUT:
% (1) hist: luminance histogram (e.g. hist=imhist(image))
%
% OUTPUT:
% (1) targetlist: sorted list of luminance values (in ascending order); 
%     the length of the list equals the number of pixels in the source 
%     image

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

function targetlist = hist2list(hist)

targetlist = [];
lum = 0:length(hist)-1;
for list = 1:length(hist)
    if hist(list) > 0
        temp = zeros(1,hist(list));
        temp(:) = lum(list);
    else
        temp = [];
    end
    targetlist = cat(2,targetlist,temp);
end

