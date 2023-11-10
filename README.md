## SHINE_color

See release notes below. Please, send suggestions and doubts to <dalbenwork@gmail.com>

***

`SHINE_color` was adapted from the `SHINE` toolbox and allows the control of low-level properties of colorful images. It does so by either manipulating RGB channels directly or by converting RGB into HSV or CIELab color space, extracting the luminance channel, applying `SHINE` controls, and concatenating it with the other channels (i.e., Hue, Saturation) to create a colorful image with controlled luminance.

`SHINE` documentation (see a [manual here](http://www.mapageweb.umontreal.ca/gosselif/shine/SHINEmanual.pdf)) extends to `SHINE_color`. See a step-by-step on how to use `SHINE_color` following.

#### STEP-BY-STEP

If you have no experience with MATLAB, just follow these steps (images available on the files tab of the [OSF project](https://osf.io/auzjy/)):

1. Download/clone the `SHINE_color` & unzip it on the desired folder;
2. Go into the SHINE_color/toolbox subfolder;
3. Add the images/videos to be processed in the "SHINE_color_INPUT" folder;
4. Open MATLAB and select the "SHINE_color" folder, then the "SHINE_color/toolbox" subfolder;
5. Type "SHINE_color" (case sensitive);
6. Follow the prompts and select the operations you would like;
7. Once it is done (the sign ">>" is back on the editor), check the "SHINE_color_OUTPUT" folder. There you will find your processed images/videos and some statistics. Also check the input folder for pre-processing statistics.

Please note that `SHINE_color` does not read transparent (alpha) channels from .PNG images. If you want to display images with transparent background on your experiment, upload them to `SHINE_color`, perform manipulations on background and foreground separately, then remove the background on an image manipulation software (e.g., GIMP, Photoshop). 

***

References    
Dal Ben, R. (2023). SHINE_color: controlling low-level properties of colorful images. MethodX, 11, 102377. https://doi.org/10.1016/j.mex.2023.102377

Willenbockel, V., Sadr, J., Fiset, D., Horne, G. O., Gosselin, F., & Tanaka, J. W. (2010). Controlling low-level image properties: The SHINE toolbox. Behavior Research Methods, 42(3), 671–684. http://doi.org/10.3758/BRM.42.3.671    
SHINE toolbox is available at: http://www.mapageweb.umontreal.ca/gosselif/SHINE/

***

Update, April 2023, version 0.0.5

Updates & improvements:
- Functional command line call, input is read by readImages; 
- Streamline readImages.m
- Streamline lum2scale.m;
- Remove image reading and preprocessing from individual functions;
- Streamline comments, descriptions, and standardize function naming;
- Add license info to main script;
- Add Command Window log (diary);
- Add message redirecting users to SHINE in case of greyscale input;
- Make main script modular, added: 
-- displayInfo.m; 
-- processImage.m;
-- userWizard.m;
- Add RGB colorspace: 
-- RGB added as a cs option (SHINE_color);
-- Transformations applied to each RGB channel;
-- diagPlots on each RGB channel;
-- lumCalc on each RGB channel;
-- Provide RMSE and SSIM to each RGB channel;

***

Update, October 2021, version 0.0.4

Updates & improvements:
- `lum_calc` is calculated directly from the input and output luminance channel. Previous versions re-read rgb images, transformed it to hsv or CIELab, and then calculated statistics. The new function is more accurate and faster;
- `diag_plots` plots luminance information directly from the input and output luminance channel. The previous versions re-read rgb images, transformed it to hsv or CIELab, and then plotted the luminance information. The new function is more accurate and faster.

***

Update, September 2021, version 0.0.3

Updates & improvements:
- Require input to every prompt (except for prompts with default values);
- When dealing with images, require at least 2 images to advance;
- Fix the pooled SD calculation from `lum_calc`;
- Update `lum_calc` output, now with pre vs. pos summary in a single file;
- Add option for CIELab colorspace;
- Update functions' input to account for new colorspace (e.g., `sfPlot`, `spectrumPlot`);
- `v2scale` is now `lum2scale`;
- `scale2v` is now `scale2lum`;
- Add `DIAGNOSTICS` subfolder in `SHINE_color_OUTPUT`, for storing img stats and diag plots;
- Add a new function `diag_plots` for diagnostic plots of operations with images.

***

Update, April 2019, version 0.0.2

The new version of the `SHINE_color` now handles video files. If a video file is provided, all frames will be extracted, `SHINE_color` operations will be performed on each frame, and the video will be re-created with the manipulated frames.

***

