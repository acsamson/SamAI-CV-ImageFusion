[English](./README.md) | [简体中文](./README.zh-CN.md)
# SamAI-CV-ImageFusion
## 🍧Intro
SamAI-CV-ImageFusion is building for the multi-source image focusing problem. By constructing a CNN classification model that can distinguish clear and blurred image blocks, and then fusing images with different depths of field into images with complete information through fusion rules, the overall detail information of the image can be improved in a similar HDR way in the focusing area.
## 🍧Result
Running `Evaluation/CNN_Fusion/Script.m` to have a result:
![ImageFusion](https://cdn.nlark.com/yuque/0/2021/gif/437349/1630327292873-edcae938-1ed2-44ff-957a-13b7abdeff27.gif)
[Video Link](https://www.aliyundrive.com/s/GXtgGVmAPng)
## 🍧RUN
### 🔖Training
1. Before running this project, We have to make sure a 'Cafe' framework be settled. My computer is MAC without CUDA, so the running mode is set to CPU, which is very inefficient. It is recommended to change to GPU mode, and the training speed is at least hundreds of times worse.
2. Modify the path in the code to your path. Create three empty folders, 'sourseimages', 'train',  and 'Val'
3. Create two new folders '0' and '1' in the 'train' folder
4. We need to download 50000 verification sets of 'ilsvrc2012' of 'Imagenet' and save the naturally collected images to the 'sourseimages' folder
5. Run 'imageinitialize.m' to generate training sets into '0' and '1' folders in the 'train' folder
6. Run `create_Val.m` to generate the verification set image into the 'Val' folder
7. Run `imag2txt.Sh` to generate 'train.txt' and 'val.txt'
8. Run `create_LMDB.sh` to generate `train_LMDB` and `val_LMDB` two folders, which store the corresponding 'LMDB' data format files
9. Run `time.sh` to view the time occupied by each 'layer' of the network, and run `draw_Net.Sh` to draw neural networks
10. Run `train_Net.Sh` to train the network. Save the network log into the 'log' folder and the 'model' in the 'models' folder
11. Generate 'loss' and' accuracy 'diagrams and operate in the 'log' folder. See 'README.md' in the 'log' folder for details
12. For training, the final generated 'caffemodel' must be converted to 'mat' format before it can be verified and imported in 'matlab'
13. Run `load_Caffemodel.py` file in the models' folder to generation `caffemodel.mat`
14. Copy 'caffemodel.mat' to 'model' folder in the `CNN_Fusion` folder
### 🔖Evaluation
> The results of four kinds of image fusion should be put into PSNR and SSIM files and compared with the original image to produce the final evaluation
* `CNN_Fusion`: it is the verification part of this project. Complete the experiment in MATLAB and run script. M, including CNN_ Fusion. M deals with analog networks and image fusion files
* `DCT`: image fusion algorithm based on discrete cosine transform
* `sourceImages`: store multi-focus images used for image fusion
* `GFF`: image fusion based on guided filter
* `DWT`: image fusion generates results through wave menu in MATLAB
* `PSNR`: the PSNR folder is used to run the peak signal-to-noise ratio evaluation
* `SSIM`: SSIM folder is used to run image structure similarity evaluation
