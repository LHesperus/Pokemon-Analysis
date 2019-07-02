function [xx,yy]=ID_ExtractFeature(imag,k)
%% resize imag
pic = imread(imag);
pic = imresize(pic,[1780 1070]);
%% cut imag
% get pic size
x=size(pic,1);
y=size(pic,2);
pic_1 = imcrop(pic,[0.15*x 0.25*y 0.3*x 0.45*y]);%cut
%%   SURF
RGB = pic_1;
if length(size(RGB))>=3  % avoid RGB gray imag
    I = rgb2gray(RGB);% to gray
else
    I=RGB;
end
points = detectSURFFeatures(I);
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