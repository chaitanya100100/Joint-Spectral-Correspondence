% This script first loads a mat file which has eigen function computed for an
% image pair and then extract mser features from each of them. Then it
% matches extracted features and show matched features. 

% It uses matlab inbuilt extractFeature and matchFeature functions for matching.

% For matching, area bigger than mser region is required to consider. To
% do it in easier way, inbuilt 'extractFeature.m' is modified slightly on
% line no. 654. This modified file is kept in src/modified directory and it
% is added to matlab path while executing this script.

clear all;

fold = 'stargarder' ;
addpath('../modified') ;

load(strcat('../../results/', fold, '/', fold,'.mat')) ;

num = size(IS1, 2) ;

im1 = imread(strcat('../../dataset/', fold, '/01.png')) ;
imr1(:, :, 1) = imresize(im1(:, :, 1), size(IS1{1})) ;
imr1(:, :, 2) = imresize(im1(:, :, 2), size(IS1{1})) ;
imr1(:, :, 3) = imresize(im1(:, :, 3), size(IS1{1})) ;
im1 = imr1 ;

im2 = imread(strcat('../../dataset/', fold, '/02.png')) ;
imr2(:, :, 1) = imresize(im2(:, :, 1), size(IS2{1})) ;
imr2(:, :, 2) = imresize(im2(:, :, 2), size(IS2{1})) ;
imr2(:, :, 3) = imresize(im2(:, :, 3), size(IS2{1})) ;
im2 = imr2 ;


stackedImage = cat(2, im1, im2);
x = figure; 
imshow(stackedImage, []);
axis off;
%saveas(x, strcat(fold, '.jpg'));


for j = 1 : num

I1 = IS1{j} ;
I2 = IS2{j} ;
%I2 = imresize(I2, size(I1)) ;

I1 = normalize(I1) ;
I2 = normalize(I2) ;

points1 = detectMSERFeatures(I1, 'MaxAreaVariation', 0.25, 'ThresholdDelta', 2);
points2 = detectMSERFeatures(I2, 'MaxAreaVariation', 0.25, 'ThresholdDelta', 2); 

points1 = points1(threshMSER(points1, 2));
points2 = points2(threshMSER(points2, 2));

[f1, vpts1] = extractFeatures(I1, points1, 'SURFSize', 64) ;
[f2, vpts2] = extractFeatures(I2, points2, 'SURFSize', 64) ;

indexPairs = matchFeatures(f1, f2, 'Unique', true,'MaxRatio',0.4,'MatchThreshold',8) ;

matched_pts1 = vpts1(indexPairs(:, 1)) ;
matched_pts2 = vpts2(indexPairs(:, 2)) ;

matched_pts1 = matched_pts1.Location ;
matched_pts2 = matched_pts2.Location ;

%{
figure ;
imagesc(I1) ; colormap jet ;
hold on ; %plot(points1) ;

figure ;
imagesc(I2) ; colormap jet ;
hold on ; %plot(points2) ;
%}

%{
fx = figure; axis off ;
stackedImage = cat(2, I1, I2); % Places the two images side by side
imagesc(stackedImage); colormap jet;
%}
width = size(I1, 2);
hold on;
numPoints = size(matched_pts1, 1); % points2 must have same # of points
% Note, we must offset by the width of the image
for i = 1 : numPoints
    plot(matched_pts1(i, 1), matched_pts1(i, 2), 'y+', matched_pts2(i, 1) + width, ...
         matched_pts2(i, 2), 'y+');
    line([matched_pts1(i, 1) matched_pts2(i, 1) + width], [matched_pts1(i, 2) matched_pts2(i, 2)], ...
         'Color', 'black');
end
axis off ;
%saveas(fx, strcat(num2str(j), 'p.jpg')) ;

end

saveas(x, strcat(fold, '.jpg'));

restoredefaultpath;

%{
figure; showMatchedFeatures(im1,im2,matched_pts1,matched_pts2,'montage');
legend('matched points 1','matched points 2');
%}


%{
figure ;
imagesc(I1) ; colormap jet ;
hold on ; %plot(points1) ;

figure ;
imagesc(I2) ; colormap jet ;
hold on ; %plot(points2) ;
%}
