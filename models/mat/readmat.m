clear;close all;clc  
if ~exist('show_caffemodel','file')==0
    delete('show_caffemodel')
    diary on
    diary show_caffemodel
else
    
    diary on
    diary show_caffemodel
end

load('caffemodel.mat');
disp("%-----------------------------------------------------");
disp("%                                       caffemodel.mat");
disp("%-----------------------------------------------------");
whos -file caffemodel.mat;
disp("%-----------------------------------------------------");
disp("%                                               specific");
disp("%-----------------------------------------------------");

[conv1_patchsize2,conv1_filters] = size(weights_b1_1);  %9*64
conv1_patchsize = sqrt(conv1_patchsize2);
disp(["weights_b1_1","conv1_patchsize2",conv1_patchsize2,"conv1_filters",conv1_filters,"conv1_patchsize",conv1_patchsize]);

[conv2_channels,conv2_patchsize2,conv2_filters] = size(weights_b1_2);  %64*9*128
conv2_patchsize = sqrt(conv2_patchsize2);
disp(["weights_b1_2","conv2_channels",conv2_channels,"conv2_patchsize2",conv2_patchsize2,"conv2_filters",conv2_filters,"conv2_patchsize",conv2_patchsize]);

[conv3_channels,conv3_patchsize2,conv3_filters] = size(weights_b1_3);  %128*9*256
conv3_patchsize = sqrt(conv3_patchsize2);
disp(["weights_b1_3","conv3_channels",conv3_channels,"conv3_patchsize2",conv3_patchsize2,"conv3_filters",conv3_filters,"conv3_patchsize",conv3_patchsize]);


[conv4_channels,conv4_patchsize2,conv4_filters] = size(weights_feature); %512*64*256
conv4_patchsize = sqrt(conv4_patchsize2);
disp(["weights_feature","conv4_channels",conv4_channels,"conv4_patchsize2",conv4_patchsize2,"conv4_filters",conv4_filters,"conv4_patchsize",conv4_patchsize]);


[conv5_channels,conv5_patchsize2,conv5_filters] = size(weights_output);  %256*1*2
conv5_patchsize = sqrt(conv5_patchsize2);
disp(["weights_output","conv5_channels",conv5_channels,"conv5_patchsize2",conv5_patchsize2,"conv5_filters",conv5_filters,"conv5_patchsize",conv5_patchsize]);

diary off
