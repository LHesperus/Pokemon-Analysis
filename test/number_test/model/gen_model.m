clc
clear

%%
id_model=load('id_model.mat');
cp_model=load('cp_model.mat');
hp_model=load('hp_model.mat');
sd_model=load('sd_model.mat');
save('model.mat','id_model','cp_model','hp_model','sd_model')
