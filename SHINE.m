% images = SHINE(images,templ)
%
% Equates a number of image properties across an image set
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
% (2) templ: optional; contains the template(s) for figure-ground 
%     segregation; templ can be a single matrix (of the same size as the 
%     pictures) or a cell of N matrices; the background must be 
%     uniform and of a luminance that does NOT occur in the foreground
%     (e.g., recommended: use a background of 255 and a foreground 
%     of values between 0 and 254)
%
% OUTPUT:
% (1) images: optional; SHINEd images stored in a cell
%
% Alternatively, SHINE can be used to load and save the images 
% automatically:
% 1. Put all source images in the SHINE_INPUT folder and make sure that it 
%    does not contain any other files of the same format and that the 
%    pathnames are correct (lines 70-72 of SHINE.m) 
% 2. Specify the image format in line 69 of SHINE.m (imformat)
% 3. Optional: Put the templates in the SHINE_TEMPLATE folder and make sure
%    the folder does not contain any other files of the same format
% 4. Type the following in the Matlab command window to start the program:
%    SHINE
% 5. Press enter and choose among the shine options that appear in the 
%    command window. 
%
%    If you want to QUIT the program, press ENTER without
%    choosing an option.

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

function images = SHINE(images,templ)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Specify the image format and the input/output directories here if SHINE  
% is called without input or output arguments:

imformat = 'tif';
input_folder = fullfile(matlabroot,'work','SHINEtoolbox','SHINE_INPUT');
output_folder = fullfile(matlabroot,'work','SHINEtoolbox','SHINE_OUTPUT');
template_folder = fullfile(matlabroot,'work','SHINEtoolbox','SHINE_TEMPLATE');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If desired, the default values can be changed here:

it = 1;           % number of iterations (default = 1)

wholeIm = 1;      % 1 = whole image (default)
                  % 2 = figure-ground separated (input images as templates)
                  % 3 = figure-ground separated (based on templates)

mode = 8;         % 1 = lumMatch only
                  % 2 = histMatch only
                  % 3 = sfMatch only
                  % 4 = specMatch only
                  % 5 = histMatch & sfMatch
                  % 6 = histMatch & specMatch
                  % 7 = sfMatch & histMatch
                  % 8 = specMatch & histMatch (default)

background = 300; % background lum of template, or 300=automatic (default)
                  % (automatically, the luminance that occurs most
                  % frequently in the image is used as background lum); 
                  % basically, all regions of that lum are treated as 
                  % background

rescaling = 1;    % 0 = no rescaling
                  % 1 = rescale absolute values (default)
                  % 2 = rescale average values
                 
optim = 0;        % 0 = no SSIM optimization
                  % 1 = SSIM optimization (Avanaki, 2009; to change the
                  % number if iterations (default = 10) and adjust step
                  % size (default = 67), see histMatch.m)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

temp = 0; md = 0; wim = 0; backg = 0;
quitmsg = 'SHINE was quit.';

while temp ~= 1 && temp ~= 2
    temp = input('SHINE options    [1=default, 2=custom]: ');
    if isempty(temp) == 1
        disp(quitmsg)
        return;
    end
end

if temp == 2
    temp = 0;

    while temp ~= 1 && temp ~= 2 && temp ~= 3
        temp = input('Matching mode    [1=luminance, 2=spatial frequency, 3=both]: ');
        if isempty(temp) == 1
            disp(quitmsg)
            return;
        end
    end

    if temp == 1
        while md ~= 1 && md ~= 2
            md = input('Luminance option [1=lumMatch, 2=histMatch]: ');
            if md == 2  
                while optim ~= 2 && optim ~= 3
                optim = 1+input('Optimize SSIM    [1=no, 2=yes]: ');    
                end
                optim = optim-2;
            elseif isempty(md) == 1
                disp(quitmsg)
                return;
            end
        end
    elseif temp == 2
        while md ~= 3 && md ~= 4
            md = 2+input('Spectrum options [1=sfMatch, 2=specMatch]: ');
            if isempty(md) == 1
                disp(quitmsg)
                return;
            end
        end
    elseif temp == 3
        while md ~= 5 && md ~= 6 && md ~= 7 && md ~= 8
            md = 4+input('Matching of both [1=hist&sf, 2=hist&spec, 3=sf&hist, 4=spec&hist]: ');
                while optim ~= 2 && optim ~= 3
                optim = 1+input('Optimize SSIM    [1=no, 2=yes]: ');    
                end
                optim = optim-2;
            if isempty(md) == 1
                disp(quitmsg)
                return;
            end
            it = input('# of iterations? ');
            if isempty(it) == 1
                disp(quitmsg)
                return;
            end
        end
    end

    mode = md;

    if temp == 1 || temp == 3
        if nargin < 2
            while wim ~= 1 && wim ~= 2
                wim = input('Matching region  [1=whole image, 2=foreground/background]: ');
                if isempty(wim) == 1
                    disp(quitmsg)
                    return;
                end
            end
        else
            wim = 2;
        end
        if wim == 2
            wim = 0;
            if nargin < 2
                while wim ~= 2 && wim ~= 3
                    wim = 1+input('Segmentation of: [1=source images, 2=template(s)]: ');
                    if isempty(wim) == 1
                        disp(quitmsg)
                        return;
                    end
                end
            else
                wim = 3;
            end
            if wim == 2
                while backg ~= 1 && backg ~= 2
                    backg = input('Image background [1=specify lum, 2=find automatically (most frequent lum in the image)]: ');
                    if isempty(backg) == 1
                        disp(quitmsg)
                        return;
                    end
                end
            else
                while backg ~= 1 && backg ~= 2
                    backg = input('Templ background [1=specify lum, 2=find automatically (most frequent lum in the template)]: ');
                    if isempty(backg) == 1
                        disp(quitmsg)
                        return;
                    end
                end
            end
            if backg == 1
                backg = 1.1;
                while mod(backg,1) > 0 || backg < 0 || backg > 255
                    backg = input('Enter lum value  [integer between 0 and 255]: ');
                    if isempty(backg) == 1
                        disp(quitmsg)
                        return;
                    end
                end
            else
                backg = 300;
            end
            background = backg;
        end
        wholeIm = wim;
    end
end

clear temp md wim backg

if nargin == 0
    [images,numim,imname] = readImages(input_folder,imformat);
else
    numim = max(size(images));
end

disp(' ')
disp(sprintf('Number of images: %d', numim));
disp(' ')

if numim == 0
    error('No images found. Please check pathnames and file format.')
end

images_orig = images;

switch wholeIm
    case 2
        mask_fgr = cell(numim,1);
        mask_bgr = cell(numim,1);
        for im = 1:numim
            image = images{im};
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

switch mode
    case 1
        if wholeIm == 1
            disp('Option:   Mean luminance matching on the whole images')
        else
            disp(sprintf('Option:   Mean luminance matching separately for the foregrounds and backgrounds (background = all regions of lum %d)',background))
        end
        it = 1;
    case 2
        if wholeIm == 1
            disp('Option:   histMatch on the whole images')
        else
            disp(sprintf('Option:   histMatch separately for the foregrounds and backgrounds (background = all regions of lum %d)',background'))
        end
        it = 1;
    case 3
        disp('Option:   sfMatch')
        it = 1;
    case 4
        disp('Option:   specMatch')
        it = 1;
    case 5
        disp(sprintf('Option:   histMatch & sfMatch with %d iteration(s)',it))
        if wholeIm == 1
            disp('Option:   whole image')
        else
            disp(sprintf('Option:   histMatch separately for the foregrounds and backgrounds (background = all regions of lum %d)',background'))
        end
    case 6
        disp(sprintf('Option:   histMatch & specMatch with %d iteration(s)',it))
        if wholeIm == 1
            disp('Option:   whole image')
        else
            disp(sprintf('Option:   histMatch separately for the foregrounds and backgrounds (background = all regions of lum %d)',background'))
        end
    case 7
        disp(sprintf('Option:   sfMatch & histMatch with %d iteration(s)',it))
        if wholeIm == 1
            disp('Option:   whole image')
        else
            disp(sprintf('Option:   histMatch separately for the foregrounds and backgrounds (background = all regions of lum %d)',background'))
        end
    case 8
        disp(sprintf('Option:   specMatch & histMatch with %d iteration(s)',it))
        if wholeIm == 1
            disp('Option:   whole image')
        else
            disp(sprintf('Option:   histMatch separately for the foregrounds and backgrounds (background = all regions of lum %d)',background'))
        end
end

for iteration = 1:it
    if it > 1
        disp(' ')
        disp(sprintf('Iteration %d', iteration))
    end
    switch mode
        case 1
            if wholeIm == 1
                images = lumMatch(images);
            else
                images = lumMatch(images,mask_fgr);
                images = lumMatch(images,mask_bgr);
            end
            disp('Progress: lumMatch successful')
        case {2, 5, 6}
            if wholeIm == 1
                images = histMatch(images,optim);
            else
                images = histMatch(images,optim,[],mask_fgr);
                images = histMatch(images,optim,[],mask_bgr);
            end
            disp('Progress: histMatch successful')
    end
    switch mode
        case {3, 5, 7}
            images = sfMatch(images,rescaling);
            disp('Progress: sfMatch successful')
        case {4, 6, 8}
            images = specMatch(images,rescaling);
            disp('Progress: specMatch successful')
    end
    switch mode
        case {7, 8}
            if wholeIm == 1
                images = histMatch(images,optim);
            else
                images = histMatch(images,optim,[],mask_fgr);
                images = histMatch(images,optim,[],mask_bgr);
            end
            disp('Progress: histMatch successful')
    end
    % To save the result after each iteration
    %save(fullfile(output_folder,sprintf('SHINEd_%d_it',iteration)),'images')
end

rmsqe_all = 0;
mssim_all = 0;
for im = 1:numim
    if nargout == 0
        if nargin > 0
            imwrite(images{im},fullfile(output_folder,strcat('SHINEd_',num2str(im),'.tif')));
        else
            imwrite(images{im},fullfile(output_folder,strcat('SHINEd_',imname{im})));
        end
    end
    rmsqe = getRMSE(images_orig{im},images{im});
    rmsqe_all = rmsqe_all+rmsqe;
    mssim = ssim_index(images_orig{im},images{im});
    mssim_all = mssim_all+mssim;
end

RMSE = rmsqe_all/numim;
SSIM = mssim_all/numim;

disp(' ')
disp(sprintf('RMSE:     %d',RMSE))
disp(sprintf('SSIM:     %d',SSIM))

if nargout < 1
    clear images
end