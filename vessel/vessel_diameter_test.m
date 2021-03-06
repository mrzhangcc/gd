clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 20;
% Read in mat file.
% storedStructure = load('binaryimage.mat');
% binaryImage = storedStructure.BWfinal;
SourceImg = imread('Picture4.tif');

I = rgb2gray(SourceImg(:, :, 1:3));

binaryImage = imbinarize(I);
% Display the image.
subplot(2, 2, 1);
imshow(binaryImage, []);
title('Original Binary Image', 'FontSize', fontSize, 'Interpreter', 'None');
% Set up figure properties:
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% Get rid of tool bar and pulldown menus that are along top of figure.
set(gcf, 'Toolbar', 'none', 'Menu', 'none');
% Give a name to the title bar.
set(gcf, 'Name', 'Demo by ImageAnalyst', 'NumberTitle', 'Off') 
drawnow;
% Fill the image.
% binaryImage(1,:) = true;
% binaryImage(end,:) = true;
binaryImageFilled = imfill(binaryImage, 'holes');
% Display the image.
subplot(2, 2, 2);
imshow(binaryImageFilled, []);
title('Original Binary Image', 'FontSize', fontSize, 'Interpreter', 'None');
drawnow;
% Get the Euclidean Distance Transform.
binaryImage(1,:) = false;
binaryImage(end,:) = false;
edtImage = bwdist(~binaryImage);
% Display the image.
subplot(2, 2, 3);
imshow(edtImage, []);
title('Distance Transform Image', 'FontSize', fontSize, 'Interpreter', 'None');
drawnow;
skelImage = bwmorph(binaryImage, 'skel', inf);
% skelImage = bwmorph(skelImage, 'spur', 2);
% There should be just one now.  Let's check
[labeledImage, numLines] = bwlabel(skelImage);
fprintf('Found %d lines\n', numLines);
% Display the image.
subplot(2, 2, 4);
imshow(skelImage, []);
title('Skeleton Image', 'FontSize', fontSize, 'Interpreter', 'None');
% Measure the radius be looking along the skeleton of the distance transform.
meanRadius = mean(edtImage(skelImage));
meanDiameter = 2 * meanRadius;
message = sprintf('Mean Radius = %.1f pixels.\nMean Diameter = %.1f pixels',...
  meanRadius, meanDiameter);
uiwait(helpdlg(message));

AllDiameter = 2 * edtImage(skelImage);
AllDiameter = sort(AllDiameter);

UniqDiameter = unique(AllDiameter);
QDiameter = histc(AllDiameter, UniqDiameter);

% figure;
% 
% plot(UniqDiameter, QDiameter);
% 
figure;

imshow(edtImage, []);