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