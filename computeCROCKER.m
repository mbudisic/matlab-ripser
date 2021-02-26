function [crockerValues, scales] = computeCROCKER(input, scales, maxHomDim)
% COMPUTECROCKER Computes CROCKER plot contours.
% function [crockerValues, scales] = computeCROCKER(input, scales, maxHomDim)
%
% Inputs:
%
%      input - EITHER nPoint x nDim x nFrame matrix containing time traces for
%                     all paths (each input(:,:,k) is a single timeframe )
%              OR     nPoint x nPoint x nFrame matrix containing pariwise
%              distanes for all frames (each input(:,:,k) is a distance
%              matrix for a single timeframe )
%
%      scales - list of epsilon values (spatial scales) for which to compute
%              CROCKER (defines "vertical" axis for the CROCKER plot)
%
%      maxHomDim - maximum dimension of homology computed (0-clusters,
%                  1-loops, etc.)
%      
% 
% This function takes as input a matrix X (whose dimensions are
% timeframes as rows, X and Y position as the two columns, and cell ID as
% the "layers"), scales which will be used to specify the persistent scale
% used in the creation of the CROCKER plot, and finally maxHomDim as a way 
% to control the maximum homology dimension used in the py.ripser.ripser 
% call.

arguments
   
    input (:,:,:) {mustBeFinite}
    scales (1,:) {mustBeNonnegative,mustBeNonempty}
    maxHomDim {mustBeNonnegative} = 1;
    
end

% store number of frames, dimensions, particles
nT = size(input,3);

% make sure the scale axis is sorted
scales = sort(scales); 

% the following matrix contains the CROCKER matrix!
% rows - scales
% columns - timeframes
% layers - Betti # order (since MATLAB index must start at 1, the 0th Betti
% number would be the 1st index)
crockerValues = nan(numel(scales), nT, maxHomDim+1);

for frame_idx = 1:nT
    % We freeze the matrix at a specific timeframe, which basically freezes
    % all the cells in place to allow us to compute the topological data
    % for that timeframe of the CROCKER matrix using the scale values
    % defined above.    
    barcodes = ripser.computeBarcodes( input(:,:,frame_idx), 'maxHomDim', maxHomDim );
    
    
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
            crockerValues(scale_idx,frame_idx,hom_idx) = ...
                sum( (barcode(:,2) > scales(scale_idx) | isnan(barcode(:,2) ) ) & ... % barcodes that end after the current interval
                     barcode(:,1)<= scales(scale_idx+1) ); % barcodes that begin before the current interval
        end
               
    end

end
