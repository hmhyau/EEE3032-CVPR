function [ F ] = sift(img)
%% sift Helper function to extract SIFT image descriptors for
%% Visual codebook computation.

%% Input params:
% img: Input image.

%% Output params:
% F:        Feature vector of img.

%%

% Convert input images into greyscale
gimg = single(rgb2gray(img));

% Run SIFT detector, compute SIFT descriptors and keypoints
[f1, d1] = vl_sift(gimg);
F = d1;
end