
%% 初始清空,开始准备写入val
close all;
clear all;
clc;
if ~exist('val') 
    mkdir('val');        % 若不存在,则创建
else
    rmdir('val','s');
    mkdir('val');
end
%% train的label0,label1各100w张,从中各选10w张
N=100000;           %需要抽取的图片的数量  
num=1000000;       %图片的总数量 

p=randperm(num);  %随机生成1~num个随机整数
q=randperm(num);

label0=p(1:num);  %生成随机采样   
label1=q(1:num);
for i=1:N
    copyfile(['train/0/',num2str(label0(i),'%08d'),'.tif'],['val/',num2str(label0(i),'%08d'),'_0','.tif']);
    copyfile(['train/1/',num2str(label1(i),'%08d'),'.tif'],['val/',num2str(label1(i),'%08d'),'_1','.tif']);
    disp(i);
end
disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
disp({'随机拷贝各',N,'张到val文件夹完成'});
