clear; clc; close all;


%% paramter
k=20;

%%
img_path = './train/';
img_dir = dir([img_path,'*CP*']);
img_num = length(img_dir);

ID_gt = zeros(img_num,1);

%% 
for ii=1:img_num
    name = img_dir(ii).name;
    ul_idx = strfind(name,'_'); 
    ID_gt(ii) = str2double(name(1:ul_idx(1)-1));
end

%% training
IDx_feature=zeros(img_num,k);
IDy_feature=zeros(img_num,k);
for ii=1:img_num
    ii
    [xx,yy]=ID_ExtractFeature([img_path,img_dir(ii).name],k);
    IDx_feature(ii,1:length(xx))=xx;
    IDy_feature(ii,1:length(yy))=yy;
end
save('model.mat','ID_gt','IDx_feature','IDy_feature');


%% Recognition
img_path = './val/';
img_dir = dir([img_path,'*CP*']);
img_num = length(img_dir);

n=10;
pic_val=imread([img_path,img_dir(n).name]);
[xx,yy]=ID_ExtractFeature([img_path,img_dir(n).name],k);
B=zeros(k,2);
B(1:length(xx),1)=xx;
B(1:length(yy),2)=yy;
A=[IDx_feature(1,:)' IDy_feature(1,:)'];
%for ii=1:img_num
   Idx= knnsearch(A,B);
   A=A(Idx,1)+j*A(Idx,2);
   B=B(:,1)+j*B(:,2);
   F=(A-B).^2;
  % F=sum(abs(F));
%end