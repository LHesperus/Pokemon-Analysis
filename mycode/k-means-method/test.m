% Feel free changing any thing in this script except the interface of
% pokemon_stats and the name of "model.mat". The final test script will be
% almost the same as this. The only thing you need to submit is
% pokemon_stats.m and model.mat.
clear; clc; close all;
warning('off');
img_path = './val/';
img_dir = dir([img_path,'*CP*']);
img_num = length(img_dir);
model=load ('./model.mat');

ID_gt = zeros(img_num,1);
CP_gt = zeros(img_num,1);
HP_gt = zeros(img_num,1);
stardust_gt = zeros(img_num,1);
ID = zeros(img_num,1);
CP = zeros(img_num,1);
HP = zeros(img_num,1);
stardust = zeros(img_num,1);

for i = 1:img_num
% for i = 11
    i
    close all;
    
    img = imread([img_path,img_dir(i).name]);
    
    % get ground truth annotation from image name
    name = img_dir(i).name;
    ul_idx = findstr(name,'_'); 
    ID_gt(i) = str2num(name(1:ul_idx(1)-1));
    CP_gt(i) = str2num(name(ul_idx(1)+3:ul_idx(2)-1));
    HP_gt(i) = str2num(name(ul_idx(2)+3:ul_idx(3)-1));
    stardust_gt(i) = str2num(name(ul_idx(3)+3:ul_idx(4)-1));
    
    [ID(i), CP(i), HP(i), stardust(i), level, cir_center] = pokemon_stats (img, model);
    [HP_gt(i) HP(i)]
%     imshow(img); hold on;
%     plot(level(1),level(2),'b*');
%     hold on
%     plot(cir_center(1),cir_center(2),'g^');
    %pause(3)
end

accuracy_ID = sum(ID_gt==ID) / img_num;
accuracy_CP = sum(CP_gt==CP) / img_num;
accuracy_HP = sum(HP_gt==HP) / img_num;
accuracy_stardust = sum(stardust_gt==stardust) / img_num;
id_data=[ID_gt,ID];
cp_data=[CP_gt,CP];
hp_data=[HP_gt,HP];
sd_data=[stardust_gt,stardust];
save('accuracy.mat','accuracy_ID','accuracy_CP','accuracy_HP','accuracy_stardust')
save('data.mat','id_data','cp_data','hp_data','sd_data')