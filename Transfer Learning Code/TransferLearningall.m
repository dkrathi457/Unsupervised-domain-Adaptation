clc
close all
clear

addpath('C:\Users\Deepak Kumar\Documents\Breast Image Transfer Learning\libsvm-3.11\matlab');
addpath('C:\Users\Deepak Kumar\Documents\Breast Image Transfer Learning');
%addpath('C:\Users\MingShao\Dropbox\Matlab_Tool\transferlearning-master\code');

% load source
load('DDSM\Resnet Full Image classifier\DDSMfeatures.mat');
%load('DDSMPATCHES.mat');
Label(Label==0) = -1;

srcData = Features;
% srcData = CentralizeFea(srcData,1);
% srcData = NormalizeFea(srcData,1);

srcData = zscore(srcData,1); %srcData = srcData';
srcLabel = Label;

fts = Features;
labels = Label;
fts = fts ./ repmat(sum(fts,2),1,size(fts,2)); 
Xs = zscore(fts,1);    clear fts
Ys = labels;           clear labels
Ps = pca(Xs);  % source subspace



clear Features Label

% load target
%load ('MIAS.mat')
load('Inbreast\Resnet Full Image Classifier\Inbreastfeatures_Resnet.mat');
%load('MIASPATCHES.mat');
Label(Label==0) = -1;

tarData = Features;
% tarData = CentralizeFea(tarData,1);
% tarData = NormalizeFea(tarData,1);
tarData = zscore(tarData,1); %tarData = tarData';
tarLabel = Label;
fts = Features;
labels = Label;
fts = fts ./ repmat(sum(fts,2),1,size(fts,2)); 
Xt = zscore(fts,1);     clear fts
Yt = labels;            clear labels
Pt = pca(Xt);  % target subspace



clear Features Label

% TCA

options = [];
options.lambda = 1;              %% lambda for the regularization
options.dim = 200;                    %% dim is the dimension after adaptation
options.kernel_type = 'rbf';    %% kernel_type is the kernel name, primal|linear|rbf
options.gamma = .1;                %% gamma is the bandwidth of rbf kernel

[srcData1,tarData1,A] = MyTCA(srcData,tarData,options);

model = svmtrain(srcLabel, srcData1, '-t 0 -c 1');
% Use the SVM model to classify the data
[predict_label_tca, accuracy_tca, prob_values_tca] = svmpredict(tarLabel, tarData1, model, '-b 0'); % run the SVM model on the test data

%Coral 

options2=[];
options2.ReducedDim = 200;
 [eigvector,eigvalue] = PCA([srcData;tarData],options2);
 srcData_coral = srcData*eigvector;
 tarData_coral = tarData*eigvector;

[Xs_new] = MyCORAL(srcData_coral,tarData_coral);

model1 = svmtrain(srcLabel, Xs_new, '-t 0 -c 1 -h 0');

[predict_label_coral, accuracy_coral, prob_values_coral] = svmpredict(tarLabel, tarData_coral, model1, '-b 0');




%BDA
options1 =[]
options1.gamma = 1;
options1.lambda = 1;
options1.kernel_type = 'rbf';
options1.T = 10;
options1.dim = 200;
options1.mu = 0.2;

[knn_model_bda,Y_tar_pseudo,Acc_bda,acc_ite,~] = MyBDA(Xs,Ys,Xt,Yt,options1);

figure;
auc = plotroc(tarLabel,tarData1, ':r', 'TCA',  model);
hold on
auc1 = plotroc(Yt,Y_tar_pseudo, '--b', 'BDA' )
auc2 = plotroc(tarLabel,tarData_coral,'-.k' ,'CORAL',model1);
legend('Location','northwest')
lgd = legend('show');
lgd.FontSize = 13
title(lgd,'AUC')
set(gca,'fontsize',13)
set(gcf, 'PaperPosition', [0 0 8 5]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [8 5]); %Set the paper to have width 5 and height 5.
saveas(gcf, 'DDSM-INBREAST-ROC2', 'pdf')



hold off








