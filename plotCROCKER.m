function [h] = plotCROCKER( frames, scales, crockerMatrix )
% PLOTCROCKER Plots a CROCKER plot matrix.
%
% [h] = plotCROCKER( frames, scales, crockerMatrix )
%
% Right now, function simply calls imagesc. 
%

h = imagesc( frames, scales, crockerMatrix ); 
