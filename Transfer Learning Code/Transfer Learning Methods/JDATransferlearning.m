clc
close all
clear

addpath('C:\Users\Deepak Kumar\Documents\Breast Image Transfer Learning\libsvm-3.11\matlab');
addpath('C:\Users\Deepak Kumar\Documents\Breast Image Transfer Learning');
%addpath('C:\Users\MingShao\Dropbox\Matlab_Tool\transferlearning-master\code');

% load source
%load('DDSM\Resnet Full Image classifier\DDSMfeatures.mat');
load('DDSMPATCHES.mat');
Label(Label==0) = -1;

srcData = Features;
% srcData = CentralizeFea(srcData,1);
% srcData = NormalizeFea(srcData,1);
srcData = zscore(srcData); %srcData = srcData';
srcLabel = Label;
clear Features Label

% load target
%load('Inbreast\Resnet Full Image Classifier\Inbreastfeatures_Resnet.mat');
%load ('MIAS.mat')
load('MIASPATCHES.mat');

Label(Label==0) = -1;

tarData = Features;
% tarData = CentralizeFea(tarData,1);
% tarData = NormalizeFea(tarData,1);
tarData = zscore(tarData); %tarData = tarData';
tarLabel = Label;
clear Features Label

%PCA first
% options=[];
% options.ReducedDim = 50;
% [eigvector,eigvalue] = PCA([srcData;tarData],options);
% srcData = srcData*eigvector;
% tarData = tarData*eigvector;

% TCA
options = [];
options.lambda = 1;              %% lambda for the regularization
options.dim = 1000;                    %% dim is the dimension after adaptation
options.kernel_type = 'rbf';    %% kernel_type is the kernel name, primal|linear|rbf
options.gamma = 1.0;                %% gamma is the bandwidth of rbf kernel
options.T = 10;


%[srcData,tarData,A] = MyTCA(srcData,tarData,options);
[predict,score,acc,acc_list,A] = MyJDA(srcData,srcLabel,tarData,tarLabel,options);

plotroc(tarLabel,predict)

