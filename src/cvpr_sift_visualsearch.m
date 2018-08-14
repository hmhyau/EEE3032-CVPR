%% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
%%
%% cvpr_visualsearch.m
%% Skeleton code provided as part of the coursework assessment
%%
%% This code will load in all descriptors pre-computed (by the
%% function cvpr_computedescriptors) from the images in the MSRCv2 dataset.
%%
%% It will pick a descriptor at random and compare all other descriptors to
%% it - by calling cvpr_compare.  In doing so it will rank the images by
%% similarity to the randomly picked descriptor.  Note that initially the
%% function cvpr_compare returns a random number - you need to code it
%% so that it returns the Euclidean distance or some other distance metric
%% between the two descriptors it is passed.
%%
%% (c) John Collomosse 2010  (J.Collomosse@surrey.ac.uk)
%% Centre for Vision Speech and Signal Processing (CVSSP)
%% University of Surrey, United Kingdom

close all;
clear all;

SAVE_PATH = 'G:\EEE3032\images\SIFT\L1\5000\';
%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = 'E:\Coursework\MSRC_ObjCategImageDatabase_v2'; % Modify path to MSRCv2 dataset

%% Folder that holds the results...
DESCRIPTOR_FOLDER = 'E:\Coursework\descriptors'; % Modify path to descriptor folder

%% and within that folder, another folder to hold the descriptors
%% we are interested in working with
DESCRIPTOR_SUBFOLDER='SIFTdescriptor_5000'; % Modify path to descriptor subfolder

%% 1) Load all the descriptors into "ALLFEAT"
%% each row of ALLFEAT is a descriptor (is an image)
ALLFEAT=[];
ALLFILES=cell(1,0);
ctr=1;
allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));
allfiles(strncmp({allfiles.name},'.',1))=[];
for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
%     fprintf('%s\n', fname);
    img=double(imread(imgfname_full))./255;
%     thesefeat=[];
    featfile=[DESCRIPTOR_FOLDER,'/',DESCRIPTOR_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    load(featfile,'F');
    ALLFILES{ctr}=imgfname_full;
    ALLFEAT=[ALLFEAT ; F];
    ctr=ctr+1;
end

%% 2) Pick an image at random to be the query
NIMG=size(ALLFEAT,1);           % number of images in collection
queryimg=floor(rand()*NIMG);    % index of a random image
%% Image ID used in evaluations
% queryimg=[415, 97, 502, 536, 5, 138];
% queryimgname=["Planes", "Books", "Cars", "Bikes", "Flowers", "Chairs"];

%% 3) Compute the distance of image to the query
% [FPCA, vct, val] = cvpr_pca(ALLFEAT');
% ALLFEAT = FPCA';
dst=[];
for i=1:NIMG
    candidate=ALLFEAT(i,:);
    query=ALLFEAT(queryimg,:);
    candidate_class = cvpr_fetchclass(i, allfiles(i).name);
    thedst=cvpr_compare(query,candidate, 1);
    %     thedst = cvpr_compare_Mahalanobis(query, candidate, val');
    dst=[dst ; [thedst i candidate_class]];
end
dst=sortrows(dst,1);  % sort the results
% [precision recall] = cvpr_prcurve(dst, NIMG);


%% 4) Visualise the results
%% These may be a little hard to see using imgshow
%% If you have access, try using imshow(outdisplay) or imagesc(outdisplay)

SHOW=15; % Show top 15 results
[precision, recall] = cvpr_prcurve(dst, SHOW);
truncdst=dst(1:SHOW,:);
outdisplay=[];
for i=1:size(truncdst,1)
    img=imread(ALLFILES{truncdst(i,2)});
    img=img(1:2:end,1:2:end,:); % make image a quarter size
    img=img(1:81,:,:); % crop image to uniform size vertically (some MSVC images are different heights)
    outdisplay=[outdisplay img];
end
imshow(outdisplay);