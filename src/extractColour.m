function F = extractColour( img,  rowGrids , colGrids )
%% extractColour Extract colour grid cells feature vectors of img.
%% Extract grid cells as specified in input arguments rowGrids and colGrids,
%% then calculate mean red, green and blue pixels.
%% Normalise the pixel values and concatenate into feature vector F. 
%% 
%% Input params:
% img:      input image
% rowGrids: number of grid cells to be divided vertically
% colGrids: number of grid cells to be divided horizontally

%% Output params:
% F:        Feature vector of img.
%%
F = [];
[height, width, ~] = size(img);

%The nested for loops are to calculate the appropriate size of each grid.
for row = 1:rowGrids
    for col = 1:colGrids
        rowSize = round(height/rowGrids);
        colSize = round(width/colGrids);
        if(col == colGrids) endCol = width;
        else endCol = colSize * col; end
        if(row == rowGrids) endRow = height;
        else endRow = rowSize * row; end
        curGrid = img(rowSize*(row-1)+1:endRow, colSize*(col-1)+1:endCol,:);
        
        meanRed = mean(mean(curGrid(:,:,1)));
        meanGreen = mean(mean(curGrid(:,:,2)));
        meanBlue = mean(mean(curGrid(:,:,3)));
        totalMean = meanRed + meanGreen + meanBlue;
        F = horzcat(F, [meanRed, meanGreen, meanBlue]./totalMean);
    end
end

return;