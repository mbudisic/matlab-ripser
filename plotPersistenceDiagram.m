function h = plotPersistenceDiagram( barcode )
% PLOTPERSISTENCEDIAGRAM Plots a barcode.
% h = plotPersistenceDiagram( barcode )
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

if isempty(barcode)
    warning("Barcode is empty. No plots created.")
    return;
end

% barcodes with infinite duration
isPersistent = isinf(barcode(:,2));

% set the "inf" values to twice the max;
barcode(isPersistent, 2) = 2*max( barcode(~isPersistent,2) );


h1 = plot( barcode(~isPersistent,1), barcode(~isPersistent,2), '.', 'MarkerSize',10 ); hold all;
h2 = plot( barcode(isPersistent,1), barcode(isPersistent,2), 'x', 'MarkerSize',8, 'Color',h1.Color );
hold off;

h = [h1,h2];
end
