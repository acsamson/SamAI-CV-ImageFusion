#!/usr/bin/env python
#encoding: utf-8
import numpy as np
import scipy.io as sio
import caffe

np.set_printoptions(threshold='nan')
MODEL_FILE = '/Users/lianshanchun/caffe/examples/imageFusion_Gold/train_val.prototxt'
PRETRAIN_FILE = '/Users/lianshanchun/caffe/examples/imageFusion_Gold/models/solver_iter_122000.caffemodel'
# 让caffe以测试模式读取网络参数
net = caffe.Net(MODEL_FILE, PRETRAIN_FILE, caffe.TRAIN)
for layer_name, param in net.params.iteritems():
    print layer_name + '\t' + str(param[0].data.shape), str(param[1].data.shape)
## 遍历每一层
#for param_name in net.params.keys():
#    conv1_b = net.params['conv_b1_1'][1].data.transpose().reshape(64,1)
#    conv2_b = net.params['conv_b1_2'][1].data.transpose().reshape(128,1)
#    conv3_b = net.params['conv_b1_3'][1].data.transpose().reshape(256,1)
#    feature_b = net.params['feature'][1].data.transpose().reshape(256,1)
#    output_b = net.params['output'][1].data.transpose().reshape(2,1)
#
#    conv1_w = net.params['conv_b1_1'][0].data.transpose().reshape(9,64)
#    conv2_w = net.params['conv_b1_2'][0].data.transpose().reshape(64,9,128)
#    conv3_w = net.params['conv_b1_3'][0].data.transpose().reshape(128,9,256)
#    feature_w = net.params['feature'][0].data.transpose().reshape(512,64,256)
#    output_w = net.params['output'][0].data.transpose().reshape(256,1,2)

    conv1_b = net.params['conv_b1_1'][1].data.reshape(64,1)
    conv2_b = net.params['conv_b1_2'][1].data.reshape(128,1)
    conv3_b = net.params['conv_b1_3'][1].data.reshape(256,1)
    feature_b = net.params['feature'][1].data.reshape(256,1)
    output_b = net.params['output'][1].data.reshape(2,1)
    
    conv1_w = net.params['conv_b1_1'][0].data.transpose(3,2,1,0).reshape(9,1,64).transpose(1,0,2).reshape(9,64)
    conv2_w = net.params['conv_b1_2'][0].data.transpose(3,2,1,0).reshape(9,64,128).transpose(1,0,2)
    conv3_w = net.params['conv_b1_3'][0].data.transpose(3,2,1,0).reshape(9,128,256).transpose(1,0,2)
    feature_w = net.params['feature'][0].data.transpose(3,2,1,0).reshape(64,512,256).transpose(1,0,2)
    output_w = net.params['output'][0].data.transpose(3,2,1,0).reshape(1,256,2).transpose(1,0,2)
    
    print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
#    sio.savemat('mat/conv1_w', {'weights_b1_1':conv1_w})
#    sio.savemat('mat/conv1_b', {'biases_b1_1':conv1_b})
#    sio.savemat('mat/conv2_w', {'weights_b1_2':conv2_w})
#    sio.savemat('mat/conv2_b', {'biases_b1_2':conv2_b})
#    sio.savemat('mat/conv3_w', {'weights_b1_3':conv3_w})
#    sio.savemat('mat/conv3_b', {'biases_b1_3':conv3_b})
#    sio.savemat('mat/feature_w', {'weights_feature':feature_w})
#    sio.savemat('mat/feature_b', {'biases_feature':feature_b})
#    sio.savemat('mat/output_w', {'weights_output':output_w})
#    sio.savemat('mat/output_b', {'biases_output':output_b})
    sio.savemat('mat/caffemodel', {'weights_b1_1':conv1_w,'biases_b1_1':conv1_b,'weights_b1_2':conv2_w,'biases_b1_2':conv2_b,'weights_b1_3':conv3_w,'biases_b1_3':conv3_b,'weights_feature':feature_w,'biases_feature':feature_b,'weights_output':output_w,'biases_output':output_b})
