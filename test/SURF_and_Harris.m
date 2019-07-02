%% test 
clc
clear 
close all

%%
n=50;

%%   SURF
RGB = imread('001_CP13_HP10_SD200_6259_10.png');
imshow(RGB)
I = rgb2gray(RGB);% to gray
figure
imshow(I)
points = detectSURFFeatures(I);
hold on
plot(points.selectStrongest(n));


%% Harris
corners = detectHarrisFeatures(I);
figure
imshow(I); hold on;
plot(corners.selectStrongest(n));