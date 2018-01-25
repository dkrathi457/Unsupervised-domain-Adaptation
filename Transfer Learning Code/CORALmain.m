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

srcData = zscore(srcData,1); %srcData = srcData';
srcLabel = Label;
clear Features Label

% load target
%load ('MIAS.mat')
%load('Inbreast\Resnet Full Image Classifier\Inbreastfeatures_Resnet.mat');
load('MIASPATCHES.mat');
Label(Label==0) = -1;

tarData = Features;
% tarData = CentralizeFea(tarData,1);
% tarData = NormalizeFea(tarData,1);
tarData = zscore(tarData,1); %tarData = tarData';
tarLabel = Label;
clear Features Label

%PCA first
 options=[];
 options.ReducedDim = 1000;
 [eigvector,eigvalue] = PCA([srcData;tarData],options);
 srcData = srcData*eigvector;
 tarData = tarData*eigvector;




%[srcData,tarData,A] = MyTCA(srcData,tarData,options);
[Xs_new] = MyCORAL(srcData,tarData);

model1 = svmtrain(srcLabel, Xs_new, '-t 0 -c 1 -h 0');

[predict_label, accuracy, prob_values] = svmpredict(tarLabel, tarData, model1, '-b 0');


auc = plotroc(tarLabel,tarData,model1);

