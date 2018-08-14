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

%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = 'E:\Coursework\MSRC_ObjCategImageDatabase_v2';
% DATASET_FOLDER = '/Volumes/SANDISK/Coursework/MSRC_ObjCategImageDatabase_v2';
% DATASET_FOLDER = '/media/hy00185/SANDISK/Coursework/MSRC_ObjCategImageDatabase_v2';

%% Create a folder to hold the results...
OUT_FOLDER = 'E:\Coursework\descriptors';
% OUT_FOLDER = '/Volumes/SANDISK/Coursework/descriptors';
% OUT_FOLDER = '/media/hy00185/SANDISK/Coursework/descriptors';
%% and within that folder, create another folder to hold these descriptors
%% the idea is all your descriptors are in individual folders - within
%% the folder specified as 'OUT_FOLDER'.
OUT_SUBFOLDER='ColourGrids';

allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));
allfiles(strncmp({allfiles.name},'.',1))=[];
for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    fprintf('Processing file %d/%d - %s\n',filenum,length(allfiles),fname);
    tic;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img=double(imread(imgfname_full))./255;
    fout=[OUT_FOLDER,'/',OUT_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    
%%   Comment/uncomment to choose one of the four available image descriptors. Feel free to tweak the input parameters for experiments.
%     F = extractRGBhisto(img, 4);
    F = extractColour(img, 4, 4);
%     F = extractEOH(img, 4, 4, 8);
%     F = extractEOHColour(img, 4, 4, 8);
    save(fout,'F');
    toc
end
