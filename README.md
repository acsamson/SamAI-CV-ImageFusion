本项目是`基于深度学习的图像融合系统`

* 运行前需要先搭建`caffe`框架,运行模式为CPU
* 修改代码中的路径为自己的路径即可
* 新建`sourseImages`、`train`、`val`三个空文件夹
* 在`train`文件夹里再新建`0`和`1`两个文件夹
* 需要先下载`ImageNet`的`ILSVRC2012`的5万张验证集自然采集图像保存到`sourseImages`文件夹里

---

第一步运行`imageInitialize.m`生成训练集到`train`文件夹里的`0`和`1`文件夹里

第二步运行`create_val.m`生成验证集图像到`val`文件夹里

第三步运行`imag2txt.sh`生成`train.txt`和`val.txt`两个文件

第四步运行`create_lmdb.sh`生成`train_lmdb`和`val_lmdb`两个文件夹,里面存放对应的`lmdb`数据格式文件

第五步运行`time.sh`查看网络各个`layer`所占用的时间,运行`draw_net.sh`来绘制神经网络

第六步运行`train_net.sh`来训练网络,网络日志保存到`log`文件夹里,`model`保存到`models`文件夹里

---

生成`loss`图和`accuracy`图在`log`文件夹里进行操作,具体看`log`文件夹中的`README.md`

---

对于训练最后生成的`caffemodel`要转换为`mat`格式才可以在`matlab`中进行验证导入.

在models文件夹中的`load_caffemodel.py`文件生成`caffemodel.mat`,

复制`caffemodel.mat`到`CNN_Fusion`文件夹中的`model`文件夹即可

---

最后一步的验证部分在`Final_val`文件夹中,具体的介绍在该文件夹中的`README.md`文件夹里有介绍