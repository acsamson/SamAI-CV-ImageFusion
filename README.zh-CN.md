[English](./README.md) | [简体中文](./README.zh-CN.md)
# SamAI-CV-ImageFusion
## 🍧Intro
SamAI-CV-ImageFusion主要是为了解决多源图像聚焦问题，通过构建一个可以区分清晰和模糊图像块的CNN分类模型，再通过融合规则可 实现将不同景深的图像进行融合成信息完整的图像，从而在聚焦方面完成类似HDR方式来实现图像的整体细节信息提升。
## 🍧Result
如果只是为了查看结果， 在MATLAB中运行 `Evaluation/CNN_Fusion/Script.m` 即可。
![ImageFusion](https://cdn.nlark.com/yuque/0/2021/gif/437349/1630327292873-edcae938-1ed2-44ff-957a-13b7abdeff27.gif)
[Video Link](https://cloud.video.taobao.com/play/u/437349/p/1/d/hd/e/6/t/1/324831602650.mp4?auth_key=YXBwX2tleT04MDAwMDAwMTImYXV0aF9pbmZvPXsidGltZXN0YW1wRW5jcnlwdGVkIjoiYjhjOTllMDBlNjQwOTEyNWJhNmQxYjY1MzU0N2ExODgifSZkdXJhdGlvbj0mdGltZXN0YW1wPTE2MzAzNDI4Mjg=)
## 🍧RUN
### 🔖Training
1. 运行前需要先搭建`caffe`框架， 我使用的电脑是mac， 没有CUDA， 因此运行模式设为CPU， 这样是很低效的， 建议改成GPU训练速度至少差上百倍以上。修改代码中的路径为自己的路径即可。
2. 新建`sourseImages`、`train`、`val`三个空文件夹
3. 在`train`文件夹里再新建`0`和`1`两个文件夹
4. 需要先下载`ImageNet`的`ILSVRC2012`的5万张验证集自然采集图像保存到`sourseImages`文件夹里
5. 运行`imageInitialize.m`生成训练集到`train`文件夹里的`0`和`1`文件夹里
6. 运行`create_val.m`生成验证集图像到`val`文件夹里
7. 运行`imag2txt.sh`生成`train.txt`和`val.txt`两个文件
8. 运行`create_lmdb.sh`生成`train_lmdb`和`val_lmdb`两个文件夹，里面存放对应的`lmdb`数据格式文件
9. 运行`time.sh`查看网络各个`layer`所占用的时间，运行`draw_net.sh`来绘制神经网络
10. 运行`train_net.sh`来训练网络，网络日志保存到`log`文件夹里，`model`保存到`models`文件夹里
11. 生成`loss`图和`accuracy`图在`log`文件夹里进行操作，具体看`log`文件夹中的`README.md`
12. 对于训练最后生成的`caffemodel`要转换为`mat`格式才可以在`matlab`中进行验证导入
13. 在models文件夹中的`load_caffemodel.py`文件生成`caffemodel.mat`
14. 复制`caffemodel.mat`到`CNN_Fusion`文件夹中的`model`文件夹即可
### 🔖Evaluation
> 将四种图像融合的结果放入PSNR和SSIM这两个文件中，分别与原始图像进行对比即可产生最终评价
* `CNN_Fusion`: 是本次项目的验证部分，在matlab中完成实验，运行Script.m即可，其中CNN_Fusion.m是处理模拟网络和图像融合文件
* `DCT`: 离散余弦变换的图像融合算法
* `sourceImages`: 存放图像融合所用的多聚焦图
* `GFF`: 基于导向滤波器的图像融合
* `DWT`: 图像融合在matlab中通过wavemanu来生成结果
* `PSNR`: PSNR文件夹是运行峰值信噪比评价所用
* `SSIM`: SSIM文件夹是运行图像结构相似性评价所用