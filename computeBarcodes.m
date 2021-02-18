function [barcodes, rips_complex] = computeBarcodes( input, opts )
% [barcodes, rips_complex] = computeBarcodes( input )
%
% Compute barcodes using py.ripser.
% [barcodes, rips_complex] = computeBarcodes( input )
%      input is EITHER a N x D matrix of points (every row is a vector of
%                     points) - Vietoris-Rips complex will be computed using Euclidean distance
%               OR a N x N pairwise distance matrix between points
% Output:
%      barcodes - cell array of Kx2 matrices each corresponding to a set of
%                 barcodes for a different homology dimension
%      rips_complex - raw Python object returned by ripser
%
% Optional arguments:
% [barcodes, rips_complex] = computeBarcodes( xy, 'maxHomDim', D, ...)
%      maximum homology dimension = D requested (default:2)
% [barcodes, rips_complex] = computeBarcodes( xy, 'doCocycles',TF, ...)
%      compute cocycles true/false (default:false)
%
% If no output is requested, the function plots all barcodes using
% `plotBarcode` and `plotPersistenceDiagram` functions.

arguments
    
    input (:,:) {mustBeFinite,mustBeReal}
    opts.maxHomDim (1,1) {mustBeNonnegative, mustBeFinite} = 2
    opts.doCocycles logical = false;
    
end


%% call to Ripser and conversion of outputs
    % We call Ripser using python, giving it our cell data and getting out
    % the persistence diagrams.
    args = pyargs('maxdim', opts.maxHomDim, 'do_cocycles', opts.doCocycles);
    rips_complex = py.ripser.ripser(input, args );
    
    % These persistent diagrams are spit out in a python object, and need
    % to be converted into matrices by use of the double function
    barcodes = cellfun( @double, cell(rips_complex{'dgms'}), 'UniformOutput',false );
    
    %% plot if no arguments requested
    if nargout == 0
        h_bars = cell( numel(barcodes), 1);
        h_pers = cell( numel(barcodes), 1);
        
        colors = lines( numel(barcodes) );
        figure;
        for k = 1:numel(barcodes)
            if ~isempty( barcodes{k} )
                
                % plot barcodes
                subplot(1,2,1);
                
                h_bars{k} = plotBarcode(barcodes{k});
                hold on;
                [h_bars{k}.Color] = deal( ...
                    colors( k, : ) );
                
                % plot persistence diagrams
                subplot(1,2,2);
                
                h_pers{k} = plotPersistenceDiagram( barcodes{k} );
                hold on;
                [h_pers{k}.Color] = deal( ...
                    colors( k, : ) );
                
                
            end
            
        end
        subplot(1,2,1); hold off;
        subplot(1,2,2); hold off;
    end
        
end

