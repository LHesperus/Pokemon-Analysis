%% test 
clc
clear 
close all

%%
%n=100;
k=100;

%% resize imag
pic = imread('001_CP13_HP10_SD200_6259_10.png');
figure
imshow(pic);
pic = imresize(pic,[1780 1070]);
figure
imshow(pic);
%% cut imag

% get pic size
x=size(pic,1);
y=size(pic,2);

pic_1 = imcrop(pic,[0.15*x 0.25*y 0.3*x 0.45*y]);%cut

figure,imshow(pic_1);
imwrite(pic_1,'1.png');

%%   SURF
RGB = imread('1.png');
imshow(RGB)
I = rgb2gray(RGB);% to gray
figure
imshow(I)
points = detectSURFFeatures(I);
hold on
%plot(points.selectStrongest(n));
plot(points.Location(:,1),points.Location(:,2),'o');

%% Harris
% corners = detectHarrisFeatures(I);
% figure
% imshow(I); hold on;
% plot(corners.selectStrongest(n));

%% k means
X=points.Location;
[idx,C] = kmeans(X,k);
hold on
plot(C(:,1),C(:,2),'kx', 'MarkerSize',15,'LineWidth',3)
k_freq=sum(idx==(1:k));

%% save data
save('data.mat','C')

%% knn
Idx = knnsearch(C,C);