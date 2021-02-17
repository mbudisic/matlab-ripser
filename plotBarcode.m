function h = plotBarcode( barcode )
% PLOTBARCODE Plots a barcode.
% h = plotBarcode( barcode )
%
% Input:
%
%      barcode - an N x 2 matrix of start/stop values representing each 
%                bar
%
% Output:
%      h - vector line objects representing each line in the bar plot.
%
% To change all colors to be the same, run, e.g.,
%
%  [h.Color] = deal( 'r' ); % make them all red.
%
% or to make them all thicker
%   [h.LineWidth] = deal( 2 );

arguments

    barcode (:,:) {mustBeNonempty}
    
end


% barcodes with infinite duration
isPersistent = isinf(barcode(:,2));

% set the "inf" values to twice the max;
barcode(isPersistent, 2) = 2*max( barcode(~isPersistent,2) );

h = plot( barcode.', repmat(1:size(barcode,1), 2,1) );


% set the color of the first to all
[h.Color] = deal(h(1).Color);
[h(isPersistent).Color] = deal('r');
[h(isPersistent).LineWidth] = deal(2);


end
