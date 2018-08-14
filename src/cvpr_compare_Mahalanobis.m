function dst=cvpr_compare_Mahalanobis(F1, F2, val)
%% cvpr_compare_Mahalanobis Compares F1 to F2 - i.e. compute the distance
%% between the two descriptors
%% The script is a modified version of L2 norm by dividing the subtracted
%% distance with eigenvalue.
%%
%% Input params:
% val:      Eigenvalue of the dimension reduced feature matrix.
% F1:       First feature vector
% F2:       Second feature vector

%% Output params:
% dst:      Distance between F1 and F2.

%% Comparison is done here.
x = F1 - F2;
x = x.^2/val;
x = sum(x);
dst = sqrt(x);

return;
