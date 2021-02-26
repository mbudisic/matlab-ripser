

%% Input data
% This is the eyes.png blurred (convolution) using a rectangular kernel

ts = linspace(-1, 1, 50);
x1 = exp(-ts.^2/(0.1.^2));
ts = ts - 0.4;
x2 = exp(-ts.^2/(0.1.^2));
Mask = -x1.'*x1 - 2*x1.'*x2 - 3*x2.'*x2;


Image = imread('eyes.png');
Mask = any(Image,3); % any nonzero is treated as 1
Mask = flipud(Mask);
Mask = transpose( double(not(Mask)) );
Mask = conv2( Mask, ones(10,10)/10^2, 'same');
Mask = Mask + rand(size(Mask))*0.01;

figure;
surfc(Mask); shading flat;
%zlim([-1,1]);

%%
computeBarcodes( Mask, 'algtype','lowerstar' );
title('Image LowerStar');

