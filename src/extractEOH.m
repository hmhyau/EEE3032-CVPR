function [F] = extractEOH( img, rowGrids, colGrids, Q )
%% extractEOH Extract edge orientation histogram feature vector of img.
%% The function converts input image into grayscale,
%% then masks it with Sobel filters to obtain horizontal and vertical edges.
%% Magnitude and orientation are then computed, where magnitude is further
%% thresholded to reject weak edges.
%% The function then proceeds to bin edge orientation histogram on a
%% grid by grid basis with Q, remedy special conditions and concatenate 
%% the feature vectors into output parameter F.
%  
%% Input params:
% img:      Input image
% rowGrids: Number of grid cells to be divided vertically
% colGrids: Number of grid cells to be divided horizontally
% Q:        Number of angle quantisation levels

%% Output params:
% F:        Feature vector of img.

%%

F=[];
truncated = [];
mx = [1, 0, -1; 2, 0, -2; 1, 0, -1]./4;
my = [1, 2, 1; 0, 0, 0; -1, -2, -1]./4;
edges = linspace(0, 2*pi, Q+1);
edges = edges(1:end-1);

greyimg = img(:,:,1)*0.30 + img(:,:,2)*0.59 + img(:,:,3)*0.11;
[height, width] = size(greyimg);
Gx = imfilter(greyimg, mx, 'replicate');
Gy = imfilter(greyimg, my, 'replicate');
% Gx = conv2(greyimg, mx, 'same');
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
        curMagGrid = thresholded(rowSize*(row-1)+1:endRow, colSize*(col-1)+1:endCol);
        curOrienGrid = orien(rowSize*(row-1)+1:endRow, colSize*(col-1)+1:endCol);
        curOrienGrid = curOrienGrid+pi;
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
        h(isnan(h)) = 0;
        F = [F h];
    end
end
end
