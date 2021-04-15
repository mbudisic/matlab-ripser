function [] = cplot(fullB0,fullB1,startSnap,endSnap)
% PLOTTING OF CROCKER PLOT
% This plotting function allows for plotting the full CROCKER plots of B0
% and B1 homologies along with a truncated version of the timeframes 
% between startSnap and endSnap (inclusive) to show what the SVM is
% being fed as input when producing the "window" model.

%% Error Checks
if nargin < 3
    
else
    
    if startSnap > endSnap
        error('startSnap cannot be greater than endSnap')
    end

    cols = size(fullB0,2);
    if startSnap < 1
        error('startSnap cannot be less than 1')
    end

    if endSnap > cols
        error('endSnap cannot be greater than the size of the CROCKER matrix')
    end

end

%% Plotting
% Full Plot - This is the full plot of B0 and B1. If only two arguments are
% given, the function will plot only these.

figure('Name','Full CROCKER Plot B1')
contourf(fullB1,10)
title('B1 10 contour line')
colorbar
figure('Name','Full CROCKER Plot B0')
contourf(fullB0,10)
title('B0 10 contour line')
colorbar

if nargin < 3
    disp('No reduced model produced')
else
    
% Truncated plot - user specified plot based on startSnap and endSnap. The
% resulting figures are the full plots above limited to the timeframe
% interval specified.

trunB0 = fullB0(:,startSnap:endSnap);
trunB1 = fullB1(:,startSnap:endSnap);

figure('Name','Reduced CROCKER Plot')
tiledlayout(2,1)
ax1 = nexttile;
contourf(ax1,trunB1,10)
title('B1 10 contour line')
colorbar
ax2 = nexttile;
contourf(ax2,trunB0,10)
hold on
title('B0 10 contour line')
colorbar
end

end