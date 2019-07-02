%% test 
clc
clear 
close all

%% parameter
%n=500;
k=20;
%%   SURF
RGB = imread('001_CP13_HP10_SD200_6259_10.png');
imshow(RGB)
I = rgb2gray(RGB);% to gray
figure
imshow(I)
points = detectSURFFeatures(I);
hold on
%plot(points.selectStrongest(n));


%% Harris
% corners = detectHarrisFeatures(I);
% figure
% imshow(I); hold on;
% plot(corners.selectStrongest(n));

plot(points.Location(:,1),points.Location(:,2),'o');


%% k means
X=points.Location;
[idx,C,sumd] = kmeans(X,k);
hold on
plot(C(:,1),C(:,2),'kx', 'MarkerSize',15,'LineWidth',3)
k_freq=sum(idx==(1:k));
