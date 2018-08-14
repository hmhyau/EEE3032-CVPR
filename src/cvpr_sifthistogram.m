function [ F ] = cvpr_sifthistogram(img, centers , NCLUSTERS)
%% CVPR_SIFTHISTOGRAM Obtain histogram of visual words occurrences for img.
%% The function first converts input image img to grayscale of type single,
%% then run vl_sift to obtain SIFT frames f and descriptors d. d is then
%% used to assign each SIFT descriptor in img to the nearest cluster in the
%% visual codebook.
%%
%% Input params:
% img:       Input image.
% centers:   Centroids of k-means clustered visual codebook.
% NCLUSTERS: Number of clusters in the visual codebook.

%% Output params:
% F: Feature vector of img.
%%
gimg = single(rgb2gray(img));
[f, d] = vl_sift(gimg);

H = zeros(1, NCLUSTERS);
for i=1:size(d,2)
    [~, k] = min(vl_alldist(double(d(:,i)), double(centers)));
    H(k) = H(k) + 1;
end
F = H./sum(H);
end

