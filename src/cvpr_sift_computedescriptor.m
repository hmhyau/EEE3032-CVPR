%% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
%%
%% cvpr_computedescriptors.m
%% Skeleton code provided as part of the coursework assessment
%% This code will iterate through every image in the MSRCv2 dataset
%% and call a function 'extractRandom' to extract a descriptor from the
%% image.  Currently that function returns just a random vector so should
%% be changed as part of the coursework exercise.
%%
%% (c) John Collomosse 2010  (J.Collomosse@surrey.ac.uk)
%% Centre for Vision Speech and Signal Processing (CVSSP)
%% University of Surrey, United Kingdom

close all;
clear all;
dictionary = [];
NCLUSTERS = 10000;

%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = 'E:\Coursework\MSRC_ObjCategImageDatabase_v2'; % Modify path to MSRCv2 dataset

%% Create a folder to hold the results...
OUT_FOLDER = 'E:\Coursework\descriptors'; % Modify path to descriptor subfolder

%% and within that folder, create another folder to hold these descriptors
%% the idea is all your descriptors are in individual folders - within
%% the folder specified as 'OUT_FOLDER'.
OUT_SUBFOLDER = 'SIFTdescriptor_1000_thresholded'; % Modify to descriptor subfolder

allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));
allfiles(strncmp({allfiles.name},'.',1))=[];

%% Obtain dictionary and do k-means clustering for the visual codebook.
for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    fprintf('Processing file %d/%d - %s\n',filenum,length(allfiles),fname);
    tic;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img=double(imread(imgfname_full))./255;
    fout=[OUT_FOLDER,'/',OUT_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    feat = sift(img);
    dictionary = [dictionary feat];
    toc
end
centers = vl_kmeans(double(dictionary), NCLUSTERS, 'Verbose');
fout=[OUT_FOLDER,'/',OUT_SUBFOLDER,'/','dictionary.mat'];
save(fout,'centers');

%% Now use the codebook to compute iamge descriptors for each of the image in the dataset.
for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    fprintf('Processing file %d/%d - %s\n',filenum,length(allfiles),fname);
    tic;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img=double(imread(imgfname_full))./255;
    fout=[OUT_FOLDER,'/',OUT_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    F = cvpr_sifthistogram(img, centers, NCLUSTERS);
    save(fout,'F');
    toc
end