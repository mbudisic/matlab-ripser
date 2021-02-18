%% PREPARE DATA

% a sample data file
load('vortices.mat')

% reorder coordinates of the matrix xy such that xy(:,:, k) is the snapshot
% for k-th frame
xy = permute( xy, [3,2,1]);

% label timeframes and scales
frames = 1:size(xy,3);
scales = 0:0.05:20; % this sets up the vertical subdivision in the crocker plot

%% Compute CROCKER
disp('Computing CROCKERs. This may take a minute.');
[crockerValues, scales] = computeCROCKER(xy, scales, 1);
disp('Done.');

%% Visualize
tiledlayout('flow');
nexttile;
plot( squeeze( xy(:,1,:) ).', squeeze( xy(:,2,:) ).' );
title('8 pairs of particles, coming together and then drifting apart');

nexttile;
h = plotCROCKER( frames, scales,  crockerValues(:,:,1) );
colorbar;
title('CROCKER for H0')

nexttile;
h = plotCROCKER( frames, scales, crockerValues(:,:,2) );
colorbar;
title('CROCKER for H1')

