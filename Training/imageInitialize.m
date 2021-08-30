%% ��ʼ���
close all;
clear all;
clc;
%% ���ѡȡѵ�����ݿ��е�1w��ͼ��(Դͼ�����5w��ͼ��)
N=10000;           %��Ҫ��ȡ��ͼƬ������  
num=50000;       %ͼƬ��������  
p=randperm(num);%�������1~num���������  
a=p(1:num);         %������ȡp��ǰN�����Ϳ���,�����Է�ͼ���в����õ�����ͼ,��ȡnum
%% ��ʼ����˹�˲���
sigma = 1;%��׼ƫ��
gausFilter = fspecial('gaussian', [7,7], sigma);%��˹�˲���
%% ��ʼ�����ɵĽ��ͼ���
imgGrayPatchNum=1;
%% ������
h= waitbar(0,['��������...']);
%�������1w��ͼ
for i=1:N
%% һ�㲻�õ�
    if(N>=num)
        disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
        disp('����ͼ����ɸѡ���,���Ϲ����ͼ���Ѿ�����,������1w��ɸѡ�ϸ�ͼ,ÿ��label��300w�Ų���Сͼ');
        waitbar(1,h,['�ɼ���� ','100','%']);
        return;
    end
    %% ����Դͼ
    imgNameStr=['ILSVRC2012_val_',num2str(a(i),'%08d'),'.JPEG'];
    imgpath=['sourseImages/','ILSVRC2012_val_',num2str(a(i),'%08d'),'.JPEG'];
    imageName=imread([imgpath]);
    %% �Ҷȳ�ʼ��,�����²���Դͼ��С
    img = double(imageName)/255;
    [hei, wid] = size(imageName);
    squareN=min(hei,wid);
    img=imresize(img,[squareN,squareN]);
    if size(img,3)>1
    img_gray=rgb2gray(img);
    else
    img_gray=img;
    end
    % figure,imshow(img1_gray),title('�Ҷ�ͼ');
%{
    RGB��Ӧ��123,caffe����321,������һ��dataͨ��,��ֻ���õ�23����ͨ��,�ֱ���Ϊlabel1(,����,ģ��),label0(,ģ��,����);
    ��˹�˲�����,�������ģ���汾;
    ���ﶨ��ԴͼΪimg,�Ҷ�ͼΪimg_gray,��ͬ��˹ģ���汾�������gaus*
    
%} 
    %% label1
    img_gray_gaus1= imfilter(img_gray, gausFilter, 'replicate');
    img_gray_gaus2= imfilter(img_gray_gaus1, gausFilter, 'replicate');
    img_gray_gaus3= imfilter(img_gray_gaus2, gausFilter, 'replicate');
    img_gray_gaus4= imfilter(img_gray_gaus3, gausFilter, 'replicate');
    img_gray_gaus5= imfilter(img_gray_gaus4, gausFilter, 'replicate');
    %% ��Դͼ�ϲ��Ҳ���ͬ��λ��,���г�ʼ��
    img1CoordinateCheck= zeros(squareN,squareN); 
    img1CoordinateCheck_zoom=0;
    checkPosition=0;
%% ѡȡ��ʮ��λ��ͼ���
    for j=1:20
        %% �������(��ԭͼ��,����ֵ�趨����25,��25/255)
        %�趨ѡ������Χ
        i_min=1;i_max=squareN-16+1;%��
        j_min=1;j_max=squareN-16+1;%��
        imgRandi=randi([i_min,i_max]);
        imgRandj=randi([j_min,j_max]);
        img_gray_patch=img_gray(imgRandi:imgRandi+16-1,imgRandj:imgRandj+16-1);
        % �鿴��ֵ
        imgthresh=graythresh(img_gray_patch);%��ȡ��ֵ,��ֵ����[0,1]
        %while (imgthresh<=50/255||imgthresh>=205/255)||(img1CoordinateCheck(imgRandi,imgRandj)==1)
        while (imgthresh<25/255)||(img1CoordinateCheck(imgRandi,imgRandj)==1)
            %% ��λ���Ѿ��鿴��
            img1CoordinateCheck(imgRandi,imgRandj)=1;   %%��Ǹ�λ��
            img1CoordinateCheck_zoom=img1CoordinateCheck_zoom+1;
            %���������Χ�ڵ�����,���ҳ���Ӧͼ���
            imgRandi=randi([i_min,i_max]);
            imgRandj=randi([j_min,j_max]);
            if img1CoordinateCheck_zoom>=i_max*j_max
                checkPosition=1;
                break;
            end
            img_gray_patch=img_gray(imgRandi:imgRandi+16-1,imgRandj:imgRandj+16-1);
            imgthresh=graythresh(img_gray_patch);%��ȡ��ֵ,��ֵ����[0,1]
        end
%% ͼ�񲻿���ʱ
        if checkPosition==1
            N=N+1;
            disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
            disp({'��','ILSVRC2012_val_',num2str(a(i),'%08d'),'.JPEG','ͼ�񲻷���ɸѡ����,����һ��'});
            figure,imshow(imageName),title('������ɸѡ����');
            break;
        end
        disp({'-- �Ҷ�Դͼ��ֵΪ',imgthresh*255,'��label1��',num2str(imgGrayPatchNum,'%08d'),'��ͼ'});
        % figure,imshow(img1_gray_patch),title('����Сͼ');
%% ��Դͼ�ĻҶ�ͼ�����������,ѡȡ��˹ģ���汾�ķ���
        img_gray_gaus1_patch=img_gray_gaus1(imgRandi:imgRandi+16-1,imgRandj:imgRandj+16-1);
        img_gray_gaus2_patch=img_gray_gaus2(imgRandi:imgRandi+16-1,imgRandj:imgRandj+16-1);
        img_gray_gaus3_patch=img_gray_gaus3(imgRandi:imgRandi+16-1,imgRandj:imgRandj+16-1);
        img_gray_gaus4_patch=img_gray_gaus4(imgRandi:imgRandi+16-1,imgRandj:imgRandj+16-1);
        img_gray_gaus5_patch=img_gray_gaus5(imgRandi:imgRandi+16-1,imgRandj:imgRandj+16-1);
        %% label1
        img_label1=img_gray_patch;
        img_label0=img_gray_patch;
        img_label1(:,:,3)=0;
        img_label0(:,:,3)=0;
        % 1
        img_label1(:,:,2)=img_gray_patch;
        img_label1(:,:,1)=img_gray_gaus1_patch;
        img_label0(:,:,2)=img_gray_gaus1_patch;
        img_label0(:,:,1)=img_gray_patch;
        imwrite(cat(3,img_label1(:,:,1),img_label1(:,:,2),img_label1(:,:,3)),[['train/0/',num2str(imgGrayPatchNum,'%08d'),'.tif']]);
        imwrite(cat(3,img_label0(:,:,1),img_label0(:,:,2),img_label0(:,:,3)),[['train/1/',num2str(imgGrayPatchNum,'%08d'),'.tif']]);
        imgGrayPatchNum=imgGrayPatchNum+1;
        %2
        img_label1(:,:,2)=img_gray_patch;
        img_label1(:,:,1)=img_gray_gaus2_patch;
        img_label0(:,:,2)=img_gray_gaus2_patch;
        img_label0(:,:,1)=img_gray_patch;
        imwrite(cat(3,img_label1(:,:,1),img_label1(:,:,2),img_label1(:,:,3)),[['train/0/',num2str(imgGrayPatchNum,'%08d'),'.tif']]);
        imwrite(cat(3,img_label0(:,:,1),img_label0(:,:,2),img_label0(:,:,3)),[['train/1/',num2str(imgGrayPatchNum,'%08d'),'.tif']]);
        imgGrayPatchNum=imgGrayPatchNum+1;
        %3
        img_label1(:,:,2)=img_gray_patch;
        img_label1(:,:,1)=img_gray_gaus3_patch;
        img_label0(:,:,2)=img_gray_gaus3_patch;
        img_label0(:,:,1)=img_gray_patch;
        imwrite(cat(3,img_label1(:,:,1),img_label1(:,:,2),img_label1(:,:,3)),[['train/0/',num2str(imgGrayPatchNum,'%08d'),'.tif']]);
        imwrite(cat(3,img_label0(:,:,1),img_label0(:,:,2),img_label0(:,:,3)),[['train/1/',num2str(imgGrayPatchNum,'%08d'),'.tif']]);
        imgGrayPatchNum=imgGrayPatchNum+1;
        %4
        img_label1(:,:,2)=img_gray_patch;
        img_label1(:,:,1)=img_gray_gaus4_patch;
        img_label0(:,:,2)=img_gray_gaus4_patch;
        img_label0(:,:,1)=img_gray_patch;
        imwrite(cat(3,img_label1(:,:,1),img_label1(:,:,2),img_label1(:,:,3)),[['train/0/',num2str(imgGrayPatchNum,'%08d'),'.tif']]);
        imwrite(cat(3,img_label0(:,:,1),img_label0(:,:,2),img_label0(:,:,3)),[['train/1/',num2str(imgGrayPatchNum,'%08d'),'.tif']]);
        imgGrayPatchNum=imgGrayPatchNum+1;
        %5
        img_label1(:,:,2)=img_gray_patch;
        img_label1(:,:,1)=img_gray_gaus5_patch;
        img_label0(:,:,2)=img_gray_gaus5_patch;
        img_label0(:,:,1)=img_gray_patch;
        imwrite(cat(3,img_label1(:,:,1),img_label1(:,:,2),img_label1(:,:,3)),[['train/0/',num2str(imgGrayPatchNum,'%08d'),'.tif']]);
        imwrite(cat(3,img_label0(:,:,1),img_label0(:,:,2),img_label0(:,:,3)),[['train/1/',num2str(imgGrayPatchNum,'%08d'),'.tif']]);
        imgGrayPatchNum=imgGrayPatchNum+1;
        disp('���������Сͼ5���Ѿ�д�����');
    end
    if checkPosition==1
        continue;
    end
    waitbar(i/N,h,['����ִ�� ','---Ŀǰ',num2str(i*100/N),'%']);
end
disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
disp({'����ͼ����ɸѡ���,���Ϲ����ͼ���Ѿ�����,������1w��ɸѡ�ϸ�ͼ,ÿ��label��300w�Ų���Сͼ'});
disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
waitbar(1,h,['�ɼ���� ','100','%']);