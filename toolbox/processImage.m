%
% processImage, April 2023
%
% Apply transformations to provided channel, regardless of colorspace.
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


function [channel_mod] = processImage(channel, mode, wholeIm, mask_fgr, mask_bgr, optim, rescaling)

channel_mod = [];

    switch mode
        case 1
            if wholeIm == 1
                channel_mod = lumMatch(channel);
            else
                channel_mod = lumMatch(channel,mask_fgr);
                channel_mod = lumMatch(channel,mask_bgr);
            end
            disp('Progress: lumMatch successful')                
        case {2, 5, 6}
            if wholeIm == 1
                channel_mod = histMatch(channel,optim);
            else
                channel_mod = histMatch(channel,optim,[],mask_fgr);
                channel_mod = histMatch(channel,optim,[],mask_bgr);
            end
            disp('Progress: histMatch successful')
    end
    switch mode
        case {3, 5, 7}
            channel_mod = sfMatch(channel,rescaling);
            disp('Progress: sfMatch successful')
        case {4, 6, 8}
            channel_mod = specMatch(channel,rescaling); %channel mod or channel?
            disp('Progress: specMatch successful')
    end
    switch mode
        case {7, 8}
            if wholeIm == 1
                channel_mod = histMatch(channel,optim);
            else
                channel_mod = histMatch(channel,optim,[],mask_fgr);
                channel_mod = histMatch(channel,optim,[],mask_bgr);
            end
            disp('Progress: histMatch successful')
    end
    
        