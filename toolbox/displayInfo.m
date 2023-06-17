%
% displayInfo, April 2023
%
% Display information about transformations on Console.
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


function it=displayInfo(mode,wholeIm,background,it)

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
end