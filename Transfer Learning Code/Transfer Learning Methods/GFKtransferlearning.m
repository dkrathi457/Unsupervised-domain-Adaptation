clc
close all
 clear

addpath('C:\Users\Deepak Kumar\Documents\Breast Image Transfer Learning\libsvm-3.11\matlab');
addpath('C:\Users\Deepak Kumar\Documents\Breast Image Transfer Learning');


load('DDSM\Resnet Full Image classifier\DDSMfeatures.mat');
Label(Label==0) = -1;

srcData = Features;
%srcData = CentralizeFea(srcData,1);
%srcData = NormalizeFea(srcData,1);
srcData = zscore(srcData); %srcData = srcData';
srcLabel = Label;
clear Features Label

% load target
%load('Inbreast\Resnet Full Image Classifier\Inbreastfeatures_Resnet.mat');
load ('MIAS.mat')
Label(Label==0) = -1;

tarData = Features;
%tarData = CentralizeFea(tarData,1);
%tarData = NormalizeFea(tarData,1);
tarData = zscore(tarData); %tarData = tarData';
tarLabel = Label;
clear Features Label


[kl,dist,prediction,acc,G] = MyGFK(srcData,srcLabel,tarData,tarLabel,100);

plotroc(tarLabel,kl)
