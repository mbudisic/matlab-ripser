function contourValues = compute(cellPaths, maxEps, stepEps, maxHomDim)
% COMPUTATION OF CONTOUR VALUES FOR CROCKER MATRIX
%
% This function takes as input a matrix cellPaths (whose dimensions are
% timeframes as rows, X and Y position as the two columns, and cell ID as
% the "layers"), maxEps which is the maximum epsilon value for the creation
% of the CROCKER matrix, stepEps which allows you to specify how many steps
% are taken before reaching maxEps or in other words how many rows the
% CROCKER matrix will include, and finally maxHomDim as a way to control
% the maximum homology dimension used in the py.ripser.ripser call.

X = cellPaths;
Tf = size(X,1);
% The number of timeframes will be equal to the number of rows in X

Scales = 0:stepEps:maxEps;
% The scales used to calculate the CROCKER matrix. This is a discrete form
% of the sliding epsilon scale approach common to calculations of CROCKER
% plots and matrices.

% the following matrix contains the CROCKER matrix!
% rows - scales
% columns - timeframes
% layers - Betti # order (since MATLAB index must start at 1, the 0th Betti
% number would be the 1st index)
contourValues = nan(numel(Scales), Tf, 2);

for frame_idx = 1:Tf
    % We freeze the matrix at a specific timeframe, which basically freezes
    % all the cells in place to allow us to compute the topological data
    % for that timeframe of the CROCKER matrix using the scale values
    % defined above.
    specCells = transpose(squeeze(X(frame_idx, :, :)));
    
    % We call Ripser using python, giving it our cell data and getting out
    % the persistence diagrams.
    pD = py.ripser.ripser(specCells, pyargs('maxdim', maxHomDim, 'do_cocycles', true));
    DGMS = pD{'dgms'};
    
    % These persistent diagrams are spit out in a python object, and need
    % to be converted into matrices by use of the double function
    for i = 1:maxHomDim+1
        barcodes{i} = double(DGMS{i});
    end
    % Once this is done, the information we have are numbers which describe
    % the birth and death of components for the specific homology
    % dimension, which are called persistent barcodes

    for scale_idx = 1:(numel(Scales)-1)
        % We index along each of our scales and betti numbers to assign
        % each value properly into the CROCKER matrix
        for betti_idx = 1:maxHomDim+1
            barcode = barcodes{betti_idx};
            % Here we select the specific barcode we are interested in
            % computing connections for, and then we sum based on criteria
            % given below...
            contourValues(scale_idx,frame_idx,betti_idx) = ...
                sum( (barcode(:,2) > Scales(scale_idx) | isnan(barcode(:,2) ) ) & ... % barcodes that end after the current interval
                     barcode(:,1)<= Scales(scale_idx+1) ); % barcodes that begin before the current interval
        end
               
    end

end