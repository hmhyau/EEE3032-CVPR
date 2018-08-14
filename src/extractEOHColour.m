function [ F ] = extractEOHColour( img, rowGrids, colGrids, Q )
%% Extract combined edge orientation histogram and colour grid cells feature vector.
%% This function is simply the combination of extractColour and extract EOH
%% put into a single function. See extracColour.m and extractEOH for
%% deatils.
%%
%% Input params:
%% Input params:
% img:      Input image
% rowGrids: Number of grid cells to be divided vertically
% colGrids: Number of grid cells to be divided horizontally
% Q:        Number of angle quantisation levels
%% Output params:
% F:        Feature vector of img.

%%

F=[];
truncated = zeros(1, 8);
mx = [1, 0, -1; 2, 0, -2; 1, 0, -1]./4;
my = [1, 2, 1; 0, 0, 0; -1, -2, -1]./4;
edges = linspace(0, 2*pi, Q+1);
edges = edges(1:end-1);

greyimg = img(:,:,1)*0.30 + img(:,:,2)*0.59 + img(:,:,3)*0.11;
[height, width] = size(greyimg);
Gx = imfilter(greyimg, mx, 'replicate');
Gy = imfilter(greyimg, my, 'replicate');
% Gx = conv2(greyimg, mx, 'same');  % Use if imfilter is not available
% Gy = conv2(greyimg, my, 'same');
mag = sqrt(Gx.^2+Gy.^2);
orien = atan2(Gy, Gx);
thresholded = (mag>0.15);

for row = 1:rowGrids
    for col = 1:colGrids
        rowSize = round(height/rowGrids);
        colSize = round(width/colGrids);
        if(col == colGrids) endCol = width;
        else endCol = colSize * col; end
        if(row == rowGrids) endRow = height;
        else endRow = rowSize * row; end
        curColourGrid = img(rowSize*(row-1)+1:endRow, colSize*(col-1)+1:endCol,:);
        curMagGrid = thresholded(rowSize*(row-1)+1:endRow, colSize*(col-1)+1:endCol);
        curOrienGrid = orien(rowSize*(row-1)+1:endRow, colSize*(col-1)+1:endCol);
        curOrienGrid = curOrienGrid+pi; % Adjust range from [-pi, pi] to [0, 2pi]
        nz = find(curMagGrid == 1);
        for indices=nz'
            i = 1;
            truncate = curOrienGrid(indices);
            truncated = [truncated truncate];
            i = i+1;
        end
        h = hist(truncated, edges);
        truncated = [];
        h = h./sum(h);
        h(isnan(h)) = 0; % Divide by 0 ractification
        F = [F h];
        meanRed = mean(mean(curColourGrid(:,:,1)));
        meanGreen = mean(mean(curColourGrid(:,:,2)));
        meanBlue = mean(mean(curColourGrid(:,:,3)));
        totalMean = meanRed + meanGreen + meanBlue;
        F = horzcat(F, [meanRed, meanGreen, meanBlue]./totalMean);
    end
end

