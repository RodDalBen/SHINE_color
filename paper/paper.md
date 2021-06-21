---
title: 'SHINE_color: controlling low-level properties of colorful images'
tags:
- MATLAB
- Pupillometry
- Eye-tracking
authors:
- name: Rodrigo Dal Ben
  orcid: 0000-0003-2185-8762
  affiliation: 1
affiliations:
- name: Concordia University
  index: 1
date: 21 June 2021
bibliography: paper.bib
---

# Summary

Pupil dilation responses can be used to investigate an array of cognitive abilities across the lifespan [@Hepach2016; @Sirois2014; @Zhang2019; @Zhang2019]. Whereas it is a versatile measure of high-level abilities, pupil dilation can be greatly affected by low-level properties of stimuli and experimental setting such as luminance of visual stimuli and experimental room [e.g., @Hepach2016; @Tsukahara2020]. 

One powerful way to control low-level properties of experimental stimuli is to use the SHINE toolbox for MATLAB [@Willenbockel2010]. This toolbox contains a set of functions that allows users to precisely specify luminance and contrast, histogram, and Fourier amplitude spectra of visual stimuli. These parametric manipulations minimize potential low-level confounds when investigating higher-level processes (e.g., cognitive effort, recognition). However, SHINE only works with greyscale images. Whereas this serves well to many research purposes [e.g., @Lawson2017; @Rodger2015], other research goals might benefit from colorful images [e.g., @Cheng2019; @Hepach2016; @Zhang2019]. Here, we describe the SHINE_color, an adaptation of SHINE that allow users to perform all operations from SHINE toolbox to colorful images.

# Implementation

The SHINE_color toolbox works in an intuitive way (\autoref{fig:Figure 1}). Once called in the command window of MATLAB, by typing SHINE_color, the script guides the user through a series of questions that specify the input files characteristics (either a set of images or a video) and the operations to be performed (luminance, histogram, Fourier amplitude spectra specification; \autoref{fig:Figure 1}). Following, the input RBG images are transformed to HSV images. If a video is provided, its’ frames are first extracted, then they are transformed to HSV color space. The HSV color space separates Hue, Saturation, and Value (luminance) channels. Once transformed, Hue and Saturation are hold in memory and are not manipulated, but the Value channel (originally ranging from 0 to 1) is rescaled to match greyscale range (from 0 to 255). Then, all operations from SHINE (TABLE 1 - DOUBLE CHECK HOW TO ADD) can be performed in the scaled Value channel. Following, the Value channel is rescaled to its’ original range (0-1) and is combined with its’ original Hue and Saturation channels. These HSV images are transformed back to RBG images. For videos, the frames are recombined back into a video. In addition, to quantify the changes, the mean and standard deviation of each image’s Value channel is automatically calculated before and after manipulations.

![SHINE_color workflow. Green boxes are adaptations that allow SHINE operations to be performed on colorful images.\label{fig:Figure 1}](fig1.png)


Table 1. Overview of the functions from SHINE_color. Most functions come from the SHINE toolbox, and their descriptions are also available on REF. Single stars (\*) denotes functions that has been adapted from SHINE, double stars (\**) indicates new functions from SHINE_color. Functions are listed in alphabetical order.

|     Function                 |     Description                                                                                        |
|------------------------------|--------------------------------------------------------------------------------------------------------|
|     avgHist                  |     computes average   histogram                                                                       |
|     frames2mpeg**            |     creates a mpeg   (.mp4) video from a sequence of frames                                            |
|     getAllFilesInFolder**    |     read all frames   from a folder                                                                    |
|     getRMSE                  |     computes root mean   square error                                                                  |
|     hist2list                |     transforms   histogram into a sorted (darker-to-brigther) list                                     |
|     histMatch                |     exact histogram   matching across images                                                           |
|     imstats                  |     computes image   statistics                                                                        |
|     lum_calc**               |     computes the   luminance average and standard deviation                                            |
|     lumMatch                 |     scales mean   luminance and contrast                                                               |
|     match                    |     histogram   specification                                                                          |
|     readImages*              |     read input images   and apply the v2scale function (see below)                                     |
|     rescale                  |     luminance rescaling                                                                                |
|     scale2v**                |     scales the Value   channel from greyscale range to HSV range                                       |
|     separate                 |     foreground-background   segregation                                                                |
|     sfMatch                  |     equates the   rotational average of the amplitude spectra                                          |
|     sfPlot                   |     plots the energy at   each spatial frequency                                                       |
|     SHINE_color*             |     main function for   loading, equating, and saving greyscale and colorful images                    |
|     specMatch                |     matches amplitude   spectrum                                                                       |
|     spectrumPlot             |     plots amplitude   spectrum                                                                         |
|     ssim_index               |     computes Structural   Similarity index                                                             |
|     ssim_sens                |     computes SSIM   gradient                                                                           |
|     tarhist                  |     computes a target   histogram                                                                      |
|     v2scale**                |     converts RGB to HSV   color spaces, extracts the Value channel, and scale it to greyscale range    |
|     video2frames**           |     extracts all frames   from a video                                                                 |


The SHINE_color toolbox is openly available at [OSF](https://osf.io/auzjy/) and [GitHub](https://github.com/RodDalBen/SHINE_color). Plans for future development include a MATLAB guided user interface and an adaptation to Python language, for integration with experimental packages such as PsychoPy [@Peirce2019]. The control of low-level properties of visual stimuli is an essential step for minimizing confounds that might affect pupil dilation responses [@Hepach2016; @Sirois2014; @Tsukahara2020]. SHINE_color allow users to take full advantage of the powerful functions from the SHINE toolbox [@Willenbockel2010] for controlling low-level properties of colorful images and videos.

# Acknowledgments

I am thankful for my former supervisors, Jessica Hay, Ph.D., and Debora de Hollanda Souza, Ph.D., for their support. This work was partially funded by grants from FAPESP (#2015/26389-7, #2018/04226-7) and CAPES (\#001). The funders had no role in study design, data collection, analysis and interpretation of the data, decision to publish, or preparation of the manuscript.

# References
