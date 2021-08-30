%% 初始清空
close all;
clear all;
clc;
%% 随机选取训练数据库中的1w张图像(源图像库有5w张图像)
N=10000;           %需要抽取的图片的数量  
num=50000;       %图片的总数量  
p=randperm(num);%随机生成1~num个随机整数  
a=p(1:num);         %按道理取p的前N个数就可以,不过以防图中有不可用的数据图,改取num
%% 初始化高斯滤波器
sigma = 1;%标准偏差
gausFilter = fspecial('gaussian', [7,7], sigma);%高斯滤波器
%% 初始化生成的结果图序号
imgGrayPatchNum=1;
%% 进度条
h= waitbar(0,['正在载入...']);
%随机采样1w张图
for i=1:N
%% 一般不用到
    if(N>=num)
        disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
        disp('所有图像已筛选完毕,符合规则的图像已经保存,正常是1w张筛选合格图,每个label有300w张裁切小图');
        waitbar(1,h,['采集完成 ','100','%']);
        return;
    end
    %% 载入源图
    imgNameStr=['ILSVRC2012_val_',num2str(a(i),'%08d'),'.JPEG'];
    imgpath=['sourseImages/','ILSVRC2012_val_',num2str(a(i),'%08d'),'.JPEG'];
    imageName=imread([imgpath]);
    %% 灰度初始化,并重新裁切源图大小
    img = double(imageName)/255;
    [hei, wid] = size(imageName);
    squareN=min(hei,wid);
    img=imresize(img,[squareN,squareN]);
    if size(img,3)>1
    img_gray=rgb2gray(img);
    else
    img_gray=img;
    end
    % figure,imshow(img1_gray),title('灰度图');
%{
    RGB对应着123,caffe中是321,抛弃第一个data通道,故只有用到23两个通道,分别作为label1(,清晰,模糊),label0(,模糊,清晰);
    高斯滤波裁切,生成五个模糊版本;
    这里定义源图为img,灰度图为img_gray,不同高斯模糊版本后面加上gaus*
    
%} 
    %% label1
    img_gray_gaus1= imfilter(img_gray, gausFilter, 'replicate');
    img_gray_gaus2= imfilter(img_gray_gaus1, gausFilter, 'replicate');
    img_gray_gaus3= imfilter(img_gray_gaus2, gausFilter, 'replicate');
    img_gray_gaus4= imfilter(img_gray_gaus3, gausFilter, 'replicate');
    img_gray_gaus5= imfilter(img_gray_gaus4, gausFilter, 'replicate');
    %% 在源图上查找不相同的位置,进行初始化
    img1CoordinateCheck= zeros(squareN,squareN); 
    img1CoordinateCheck_zoom=0;
    checkPosition=0;
%% 选取二十对位置图像块
    for j=1:20
        %% 随机采样(在原图中,则阈值设定大于25,即25/255)
        %设定选择区域范围
        i_min=1;i_max=squareN-16+1;%行
        j_min=1;j_max=squareN-16+1;%行
        imgRandi=randi([i_min,i_max]);
        imgRandj=randi([j_min,j_max]);
        img_gray_patch=img_gray(imgRandi:imgRandi+16-1,imgRandj:imgRandj+16-1);
        % 查看阈值
        imgthresh=graythresh(img_gray_patch);%获取阈值,阈值介于[0,1]
        %while (imgthresh<=50/255||imgthresh>=205/255)||(img1CoordinateCheck(imgRandi,imgRandj)==1)
        while (imgthresh<25/255)||(img1CoordinateCheck(imgRandi,imgRandj)==1)
            %% 该位置已经查看过
            img1CoordinateCheck(imgRandi,imgRandj)=1;   %%标记该位置
            img1CoordinateCheck_zoom=img1CoordinateCheck_zoom+1;
            %随机产生范围内的坐标,并找出对应图像块
            imgRandi=randi([i_min,i_max]);
            imgRandj=randi([j_min,j_max]);
            if img1CoordinateCheck_zoom>=i_max*j_max
                checkPosition=1;
                break;
            end
            img_gray_patch=img_gray(imgRandi:imgRandi+16-1,imgRandj:imgRandj+16-1);
            imgthresh=graythresh(img_gray_patch);%获取阈值,阈值介于[0,1]
        end
%% 图像不可用时
        if checkPosition==1
            N=N+1;
            disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
            disp({'该','ILSVRC2012_val_',num2str(a(i),'%08d'),'.JPEG','图像不符合筛选规则,换下一张'});
            figure,imshow(imageName),title('不符合筛选规则');
            break;
        end
        disp({'-- 灰度源图阈值为',imgthresh*255,'是label1第',num2str(imgGrayPatchNum,'%08d'),'张图'});
        % figure,imshow(img1_gray_patch),title('裁切小图');
%% 在源图的灰度图中随机采样后,选取高斯模糊版本的反例
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
        disp('该区域裁切小图5对已经写入完毕');
    end
    if checkPosition==1
        continue;
    end
    waitbar(i/N,h,['正在执行 ','---目前',num2str(i*100/N),'%']);
end
disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
disp({'所有图像已筛选完毕,符合规则的图像已经保存,正常是1w张筛选合格图,每个label有300w张裁切小图'});
disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
waitbar(1,h,['采集完成 ','100','%']);