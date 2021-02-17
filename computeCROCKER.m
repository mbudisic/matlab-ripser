function contourValues = computeCROCKER(X, scales, maxHomDim)
% COMPUTECROCKER Computes CROCKER plot contours.
% function contourValues = computeCROCKER(paths, maxEps, stepEps, maxHomDim)
%
% Inputs:
%
%      paths - nTimes x nDims x nPaths matrix containing time traces for
%              all paths
%
%      scales - list of epsilon values (spatial scales) for which to compute
%              CROCKER (defines "vertical" axis for the CROCKER plot)
%
%      maxHomDim - maximum dimension of homology computed (0-clusters,
%                  1-loops, etc.)
%      
% 
% This function takes as input a matrix cellPaths (whose dimensions are
% timeframes as rows, X and Y position as the two columns, and cell ID as
% the "layers"), maxEps which is the maximum epsilon value for the creation
% of the CROCKER matrix, stepEps which allows you to specify how many steps
% are taken before reaching maxEps or in other words how many rows the
% CROCKER matrix will include, and finally maxHomDim as a way to control
% the maximum homology dimension used in the py.ripser.ripser call.

arguments
   
    X (:,:,:) {mustBeFinite}
    scales (1,:) {mustBeNonnegative,mustBeNonempty}
    maxHomDim {mustBeNonnegative} = 1;
    
end

% store nubmer of frames, dimensions, particles
[nT, nD, nP] = size(X);

% make sure the scale axis is sorted
scales = sort(scales); 

% the following matrix contains the CROCKER matrix!
% rows - scales
% columns - timeframes
% layers - Betti # order (since MATLAB index must start at 1, the 0th Betti
% number would be the 1st index)
contourValues = nan(numel(scales), nT, maxHomDim+1);

for frame_idx = 1:nT
    % We freeze the matrix at a specific timeframe, which basically freezes
    % all the cells in place to allow us to compute the topological data
    % for that timeframe of the CROCKER matrix using the scale values
    % defined above.
    frame = transpose(squeeze(X(frame_idx, :, :)));
    
    barcodes = computeBarcodes( frame, maxHomDim );
    
    % Once this is done, the information we have are numbers which describe
    % the birth and death of components for the specific homology
    % dimension, which are called persistent barcodes

    for scale_idx = 1:(numel(scales)-1)
        % We index along each of our scales and betti numbers to assign
        % each value properly into the CROCKER matrix
        for hom_idx = 1:maxHomDim+1
            barcode = barcodes{hom_idx};
            % Here we select the specific barcode we are interested in
            % computing connections for, and then we sum based on criteria
            % given below...
            contourValues(scale_idx,frame_idx,hom_idx) = ...
                sum( (barcode(:,2) > scales(scale_idx) | isnan(barcode(:,2) ) ) & ... % barcodes that end after the current interval
                     barcode(:,1)<= scales(scale_idx+1) ); % barcodes that begin before the current interval
        end
               
    end

end
