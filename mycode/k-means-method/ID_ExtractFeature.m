function [xx,yy]=ID_ExtractFeature(imag,k)
%% resize imag
pic = imread(imag);
pic = imresize(pic,[1780 1070]);
%% cut imag
% get pic size
% x=size(pic,1);
% y=size(pic,2);
% %xy=[0.10*x 0.16*y 0.4*x 0.55*y];
% xy=[0.15*x 0.25*y 0.3*x 0.45*y];  %high 44/139
% %xy=[0.10*x 0.20*y 0.4*x 0.50*y]; % 38/139
% %xy=[0.20*x 0.30*y 0.2*x 0.40*y];  %36/139
% pic_1 = imcrop(pic,xy);%cut


x=size(pic,2);
y=size(pic,1);

pic_1 = imcrop(pic,[0.30*x 0.16*y 0.4*x 0.24*y]);%cut
%%   SURF
RGB = pic_1;
if length(size(RGB))>=3  % avoid RGB gray imag
    I = rgb2gray(RGB);% to gray
else
    I=RGB;
end

%edge
%I=edge(I, 'Canny');
points = detectSURFFeatures(I);
%points = detectHarrisFeatures(I);
%points=detectMSERFeatures(I);
%points=detectKAZEFeatures(I);
%% Harris
% corners = detectHarrisFeatures(I);
% figure
% imshow(I); hold on;
% plot(corners.selectStrongest(n));

%% k means
if points.Count<=k
    k=points.Count;
end
X=points.Location;
[idx,C] = kmeans(X,k);
%k_freq=sum(idx==(1:k));
xx=C(:,1);
yy=C(:,2);
end