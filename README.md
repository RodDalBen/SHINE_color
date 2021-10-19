## SHINE_color

Please, send suggestions and doubts to <dalbenwork@gmail.com>

***

Update, October 2021, version 0.0.4:

Updates & improvements:
- `lum_calc` is calculated directly from the input and output luminance channel. Previous versions re-read rgb images, transformed it to hsv or CIELab, and then calculated statistics. The new function is more accurate and faster;
- `diag_plots` plots luminance information directly from the input and output luminance channel. The previous versions re-read rgb images, transformed it to hsv or CIELab, and then plotted the luminance information. The new function is more accurate and faster.

***

Update, September 2021, version 0.0.3:

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

Update, April 2019, version 0.0.2:

The new version of the `SHINE_color` now handles video files. If a video file is provided, all frames will be extracted, `SHINE_color` operations will be performed on each frame, and the video will be re-created with the manipulated frames.

***

An adaptation of the `SHINE` toolbox, dubbed `SHINE_color`. This adaptation allows to apply all `SHINE` transformations to colorful images. It does so by converting rgb images into hsv color space, extracting and scaling the Value channel, and, after the transformations are performed, rescale the channel and concatenate it with Hue and Saturation channels to create a colorful image with the new luminance.

All documentation of `SHINE` toolbox is extensible to the `SHINE_color` adaptation. It also works in a similar way, except that it can be launched from the current working directory and the user must provide the image format.

As for the outputs, colorful images with new luminance will be saved in the output folder and a `.txt` document with mean and standard deviation for the Value channel of the input (saved in the input folder) and the output images (saved in the output folder) will also be generated (using an adaptation of the `lum_calc`--see the [`lum_fun` repository](https://github.com/RodDalBen/lum_fun)).

For illustration purposes, the input folder contains 4 pictures from the NOUN database. Furthermore, NOUN images (Horst & Hout, 2016) with histogram matched (using SHINE_color) are available on the files tab.

#### TUTORIAL

If you have no experience with MATLAB, just follow these steps (images available on the files tab of the [OSF project](https://osf.io/auzjy/)):

1. Download/clone the `SHINE_color` & unzip it on the desired folder;
2. Go into the SHINE_color/toolbox subfolder;
3. Add the images/videos to be processed in the "SHINE_color_INPUT" folder;
4. Open MATLAB and select the "SHINE_color" folder, then the "SHINE_color/toolbox" subfolder;
5. Type "SHINE_color" (case sensitive);
6. Follow the prompts and select the operations you would like;
7. Once it is done (the sign ">>" is back on the editor), check the "SHINE_color_OUTPUT" folder. There you will find your processed images/videos and some statistics. Also check the input folder for pre-processing statistics.

***

References

Dal Ben, R. (2021). SHINE_color and Lum_fun: A set of tools to control luminance of colorful images (Version 0.0.3). [Computer program]. doi: 10.17605/OSF.IO/AUZJY, retrieved from https://osf.io/auzjy/

The original SHINE toolbox is available at: http://www.mapageweb.umontreal.ca/gosselif/SHINE/

NOUN database available at: http://www.sussex.ac.uk/wordlab/noun

Willenbockel, V., Sadr, J., Fiset, D., Horne, G. O., Gosselin, F., & Tanaka, J. W. (2010). Controlling low-level image properties: The SHINE toolbox. Behavior Research Methods, 42(3), 671–684. http://doi.org/10.3758/BRM.42.3.671

Horst, J. S., & Hout, M. C. (2016). The Novel Object and Unusual Name (NOUN) Database: A collection of novel images for use in experimental research. Behavior Research Methods, 48(4), 1393–1409. http://doi.org/10.3758/s13428-015-0647-3
