function dst=cvpr_compare(F1, F2, p)
%% cvpr_compare Compares F1 to F2 - i.e. compute the distance
%% between the two descriptors
%% The script implements L1 and L2 norm using a switch-case.
%%
%% Input params:
% p:        Distance metric to be used.
% p = 1:    Manhattan distance (L1-norm)
% p = 2:    Euclidean distance (L2-norm)
% F1:       First feature vector
% F2:       Second feature vector

%% Output params:
% dst:      Distance between F1 and F2.
%% Comparison is done here.
switch p
    case 1
        x = sum(abs(F1-F2));
        dst = x;
    case 2 
        x = F1 - F2;
        x = x.^p;
        x = sum(x);
        dst = x.^(1/p);
end

return;
