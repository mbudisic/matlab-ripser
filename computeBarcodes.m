function barcodes = computeBarcodes( xy, maxHomDim, doCocycles )
% barcodes = computeBarcodes( xy, maxHomDim )
%
% Compute barcodes using py.ripser.
%      xy is a N x D matrix of points (every row is a vector of points)
%      maxHomDim - maximum homology dimension requested
%      doCocycles - compute cocycles (default:false)
%
% Output:
%      barcodes - cell array of Nx2 matrices each corresponding to a set of
%                 barcodes for a different homology dimension
% 
% If no output is requested, the function plots all barcodes using
% `plotBarcode` function.

arguments
    
    xy (:,:) {mustBeFinite,mustBeReal}
    maxHomDim (1,1) {mustBeNonnegative, mustBeFinite} = 2
    doCocycles logical = false;
    
end


%% call to Ripser and conversion of outputs
    % We call Ripser using python, giving it our cell data and getting out
    % the persistence diagrams.
    args = pyargs('maxdim', maxHomDim, 'do_cocycles', doCocycles);
    pD = py.ripser.ripser(xy, args );
    DGMS = pD{'dgms'};
    
    % These persistent diagrams are spit out in a python object, and need
    % to be converted into matrices by use of the double function
    for i = 1:maxHomDim+1
        barcodes{i} = double(DGMS{i});
    end
    
    %% plot if no arguments requested
    if nargout == 0
        colors = lines( numel(barcodes) );
        
        for k = 1:numel(barcodes)
            h{k} = plotBarcode(barcodes{k}); hold on;
            [h{k}.Color] = deal( ...
                colors( k, : ) );
        end
        hold off;
    end
        
end

