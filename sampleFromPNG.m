function xyPoint = sampleFromPNG(nSample, pngMask, xlim, ylim)
% xyPoint = sampleFromPNG(nSample, pngMask)
% Perform rejection sampling to sample uniformly from a density given by a
% PNG mask.
% 
%
% A brief analogy: this function essentially takes the picture and uses it
% like a dartboard, "throwing" points at random areas on the image and
% using the ones that lie in the dark areas to specify the starting and
% ending positions to use in the Brownian bridge model.
%
% Break down the .png file and do rejection sampling on it
% image INPUT MUST BE STRING e.g 'rectangle-and-circle.png'

arguments
% see https://www.mathworks.com/help/matlab/matlab_prog/function-argument-validation-1.html
% for syntax
    
    nSample (1,1) {mustBeNumeric, mustBePositive}
    pngMask {mustBeFile}
    xlim (1,2) {mustBeNumeric,mustBeFinite} = [175,225];
    ylim (1,2) {mustBeNumeric,mustBeFinite} = [175,225];
    
end


% read in the mask and orient it appropriately
Image = imread(pngMask);
Mask = any(Image,3); % any nonzero is treated as 1
Mask = flipud(Mask);
Mask = transpose( double(not(Mask)) );

% set up axis based on input limits and number of elements in the mask
xax = linspace(xlim(1), xlim(2), size(Mask,1));
yax = linspace(ylim(1), ylim(2), size(Mask,2));

% interpolate mask onto the grid
rejectFun = griddedInterpolant({xax,yax},Mask,'nearest','nearest');

% perform rejection sampling in batches for speed
BatchSize = ceil(nSample/2);
xyPoint = zeros(0,2);
Rejected = zeros(0,2);

while( size(xyPoint,1) < nSample)
    
    NewSample = rand(BatchSize,2); %  uniform randoms between 0 and 1
    
    % scale the random numbers to fit within chosen limits
    NewSample(:,1) = NewSample(:,1)*range(xlim) + xlim(1); %
    NewSample(:,2) = NewSample(:,2)*range(ylim) + ylim(1); %
    
    % test the entire batch by passing it to the rejection function
    KeepMe = rejectFun(NewSample(:,1),NewSample(:,2)) > 0;
    
    % use KeepMe to select those samples that satisfied
    % this is called "logical indexing":
    % https://blogs.mathworks.com/loren/2013/02/20/logical-indexing-multiple-conditions/
    xyPoint = [xyPoint; NewSample(KeepMe,:)];
    Rejected = [Rejected; NewSample(not(KeepMe),:)];
    
end
% since we proceed in batches, we don't stop exactly where we need,
% so we get more stored samples than requested. Therefore we throw away
% what we don't need
xyPoint = xyPoint(1:nSample,:);

if nargout == 0
    pcolor(xax, yax, Mask.'); 
    colormap([0,0,0; 1,1,1]); 
    shading flat; hold on;
    plot( xyPoint(:,1), xyPoint(:,2), 'r.', 'MarkerSize',5);
    hold off;
    
    
    
end



