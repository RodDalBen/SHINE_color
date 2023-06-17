function [mask_fgr,mask_bgr,background] = maskFgrBgr(wholeIm,channel,numim,background,template_folder,imformat,nargin)
    switch wholeIm
        case 1
            mask_fgr = [];
            mask_bgr = [];
        case 2
            mask_fgr = cell(numim,1);
            mask_bgr = cell(numim,1);
            for im = 1:numim
                image = channel{im};
                [mask_f,mask_b,background] = separate(image,0,background);
                mask_fgr{im} = mask_f;
                mask_bgr{im} = mask_b;
            end
        case 3
            if nargin < 2
                [templ,numtemp] = readImages(template_folder,imformat);
                if numtemp == 0
                    error('No templates found. Please check pathnames and file format.')
                end
            else
                if iscell(templ) == 1
                    numtemp = max(size(templ));
                    if numtemp == 1
                        templ = cell2mat(templ);
                    end
                else
                    numtemp = 1;
                end
            end
            if numtemp > 1
                if numtemp ~= numim
                    error('The number of templates must equal the number of images.')
                end
            end
            for im = 1:numtemp
                if iscell(templ) == 1
                    [mask_f,mask_b,background] = separate(templ{im},0,background);
                    mask_fgr{im} = mask_f;
                    mask_bgr{im} = mask_b;
                else
                    [mask_fgr,mask_bgr,background] = separate(templ,0,background);
                end
            end
    end

end