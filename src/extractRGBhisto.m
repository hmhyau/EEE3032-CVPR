function F=extractRGBhisto(img, q)
%% From Lab Worksheet 3: Compute the mean RGB values of img,
%% followed by reshaping into a 3-dimensional array as the image descriptor.
%%
%% Input params:
% img: Input image.
% q: Number of colour quantisation levels.

%% Output params:
% F:        Feature vector of img.

%%

red = img(:,:,1);
green = img(:,:,2);
blue = img(:,:,3);

rdash = floor(red.*q);
gdash = floor(green.*q);
bdash = floor(blue.*q);

bin = rdash*(q^2) + gdash*(q) + bdash;
vals = reshape(bin, 1, size(bin,1) * size(bin, 2));
H = hist(vals, q^3);
F = H./sum(H);
return;