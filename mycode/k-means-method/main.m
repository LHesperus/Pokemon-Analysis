clear; clc; close all;


%% paramter
k=100;

%% train
img_path = './train/';
img_dir = dir([img_path,'*CP*']);
img_num = length(img_dir);
n_train=img_num;
% 
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
model=load('model.mat');
img_path = './val/';
img_dir = dir([img_path,'*CP*']);
img_num = length(img_dir);
ID_val=zeros(img_num,1);


for ii=1:img_num
    name = img_dir(ii).name;
    ul_idx = strfind(name,'_'); 
    ID_val_theory(ii) = str2double(name(1:ul_idx(1)-1));
end

for ii=1:img_num
    ii
     ID_val(ii)=ID_recongnition([img_path,img_dir(ii).name],k,model,n_train);
end

aa=sum(ID_val==ID_val_theory')