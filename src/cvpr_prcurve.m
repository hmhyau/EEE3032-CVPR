function [precision, recall] = cvpr_prcurve(searchresult, SHOW)
%% cvpr_prcurve Calculate PR curve for the visual search query.
%% Compute precision and recall value for each retrieved result wrt class,
%% then calculate the average precision for the specific query and 
%% plot the PR curve.
%%
%% Input params:
% searchresult: Query images 
% SHOW:         Rank of query results to be computed 

%% Output params:
% precision:    Precision of query
% recall:       Recall of query

%% Calculate precision, recall and average precision...
precision = [];
recall = [];

queryclass = searchresult(1,3);
numRelevant = sum(searchresult(:,3)==queryclass);
for numRetrieved = 1:SHOW
    numRetrievedRelevant = sum(searchresult(1:numRetrieved,3)==queryclass);
    theprec = numRetrievedRelevant/numRetrieved;
    therecall = numRetrievedRelevant/numRelevant;
    precision = [precision; theprec];
    recall = [recall; therecall];
end

AP = sum(precision.*(searchresult(1:SHOW,3)==queryclass))/numRelevant;

%% Plot the PR Curve!
p = plot(recall, precision);
title(['Average Precision: ', num2str(AP)])
xlabel('Recall')
ylabel('Precision')
ylim([0 1])
xlim([0 inf])
p.LineWidth = 2;
p.Marker = 'o';
figure;

return;
