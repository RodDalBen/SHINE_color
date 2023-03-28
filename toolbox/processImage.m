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
    
        