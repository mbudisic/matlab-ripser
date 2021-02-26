function h = plotPersistenceDiagram( barcode, opts )
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

arguments
    
    barcode (:,:) {mustBeNonempty}
    opts.type {mustBeMember(opts.type,{'birthdeath','birthpersistence','deathpersistence'})} = 'rips'
    
end

% barcodes with infinite duration
isPersistent = isinf(barcode(:,2));

% set the "inf" values to twice the max;
%barcode(isPersistent, 2) = 2*max( barcode(~isPersistent,2) );

switch(opts.type)
    case 'birthdeath'
        xvec = @(m)m(:,1); xtext = 'Birth';
        yvec = @(m)m(:,2); ytext = 'Death';
        
    case 'birthpersistence'
        xvec = @(m)m(:,1); xtext = 'Birth';
        yvec = @(m)diff(m,1,2); ytext = 'Persistence';
        
        
    case 'deathpersistence'
        xvec = @(m)m(:,2); xtext = 'Death';
        yvec = @(m)diff(m,1,2); ytext = 'Persistence';
    
end


h1 = plot( xvec( barcode(~isPersistent,:) ), yvec( barcode(~isPersistent,:) ), '.', 'MarkerSize',10 ); hold all;
h2 = plot( xvec( barcode(isPersistent,:) ), yvec( barcode(isPersistent,:) ), 'x', 'MarkerSize',8, 'Color',h1.Color );
hold off;
xlabel(xtext); ylabel(ytext);

h = [h1,h2];
end
