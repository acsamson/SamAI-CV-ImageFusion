
%% ��ʼ���,��ʼ׼��д��val
close all;
clear all;
clc;
if ~exist('val') 
    mkdir('val');        % ��������,�򴴽�
else
    rmdir('val','s');
    mkdir('val');
end
%% train��label0,label1��100w��,���и�ѡ10w��
N=100000;           %��Ҫ��ȡ��ͼƬ������  
num=1000000;       %ͼƬ�������� 

p=randperm(num);  %�������1~num���������
q=randperm(num);

label0=p(1:num);  %�����������   
label1=q(1:num);
for i=1:N
    copyfile(['train/0/',num2str(label0(i),'%08d'),'.tif'],['val/',num2str(label0(i),'%08d'),'_0','.tif']);
    copyfile(['train/1/',num2str(label1(i),'%08d'),'.tif'],['val/',num2str(label1(i),'%08d'),'_1','.tif']);
    disp(i);
end
disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
disp({'���������',N,'�ŵ�val�ļ������'});
