# CVPR Assignment

## HOW TO RUN

1.  Open MATLAB.

2.  Run cvpr_computedescriptors.m to compute the necessary descriptors. Note that the MSVC-v2 dataset and descriptor save folders must be modified and point to the correct locations.

3. Run cvpr_visualsearch.m to evaluate the performance of the visual search system with your chosen image descriptor!

### Note
For SIFT, use the sift variants, i.e. cvpr_sift_computedescriptors.m, cvpr_sift_visualsearch.m. These scripts requires setting up VLFEAT toolbox, which can be done by "${path_to_your_VLFEAT_toolbox}/toolbox/vl_setup" for one-time setup.
