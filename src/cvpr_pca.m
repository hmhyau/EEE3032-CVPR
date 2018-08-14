function [ FPCA, vct, val ] = cvpr_pca( F )
%% CVPR_PCA Apply PCA to feature descriptor matrix F.
%%   The function first calculates the mean of each image descriptor in F
%%   and subtract with F for standardisation. Covariance matrix C is then
%%   calculated as per definition and obtain the eigenvalue and eigenvector
%%   by built-in MATLAB function eig. They are then sorted appropriately
%%   and truncated such that 95% of energy is retained, balancing the
%%   trade-off between dimensionality reduction and information loss.
%%
%% Input params:
% F: Feature descriptor matrix.

%% Output params:
% FPCA: Feature descriptor matrix after PCA.
% vct: Eigenvector of FPCA's covariance matrix.
% val: Eigenvalue of FPCA's covaiance matrix.

%% Calculate eigenvalue and eigenvector first.
org = mean(F')';

Fsub = F - repmat(org, 1, size(F, 2));
C = (Fsub*Fsub')./size(F, 2);

[vct, val] = eig(C);

val(val==0) = [];
val = sort(val, 'descend')';

%% Now truncate eigenvalue and eigenvector to retain 95% of original energy.
retainedEnergy = sum(abs(val))*0.95;
currentEnergy = 0;

for rank = 1:size(val,1)
    currentEnergy = sum(val(1:rank, 1));
    if (currentEnergy < retainedEnergy) continue;
    else break;
    end
end

val = val(1:rank);
vct = fliplr(vct);
vct = vct(:, 1:rank);

FPCA = vct'*Fsub;
end
