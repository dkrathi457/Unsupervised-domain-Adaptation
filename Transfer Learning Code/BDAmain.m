    %clc
    %close all
    %clear
    
addpath('D:\Ond Drive this pc\OneDrive - UMASS Dartmouth\Mammographic Image Analysis Final Version\Breast cancer Image transfer Learning\Transfer Learning Code')
%whole image feature path
addpath('D:\Ond Drive this pc\OneDrive - UMASS Dartmouth\Mammographic Image Analysis Final Version\Breast cancer Image transfer Learning\Features Files\Inbreast\Resnet Full Image Classifier')
addpath('D:\Ond Drive this pc\OneDrive - UMASS Dartmouth\Mammographic Image Analysis Final Version\Breast cancer Image transfer Learning\Features Files\MIAS\MIAS whole Images')
addpath('D:\Ond Drive this pc\OneDrive - UMASS Dartmouth\Mammographic Image Analysis Final Version\Breast cancer Image transfer Learning\Features Files\DDSM\Resnet Full Image classifier')
%patch feature path
addpath('D:\Ond Drive this pc\OneDrive - UMASS Dartmouth\Mammographic Image Analysis Final Version\Breast cancer Image transfer Learning\Features Files\DDSM\Patch Features')
addpath('D:\Ond Drive this pc\OneDrive - UMASS Dartmouth\Mammographic Image Analysis Final Version\Breast cancer Image transfer Learning\Features Files\MIAS\MIAS Patches')
addpath('D:\Ond Drive this pc\OneDrive - UMASS Dartmouth\Mammographic Image Analysis Final Version\Breast cancer Image transfer Learning\libsvm-3.11\matlab')
    %% Load data
    load('DDSM\Resnet Full Image classifier\DDSMfeatures.mat');
    %load('DDSMPATCHES.mat');
    Label(Label==0) = -1;
    fts = Features;
    labels = Label;
    fts = fts ./ repmat(sum(fts,2),1,size(fts,2)); 
    Xs = zscore(fts,1);    clear fts
    Ys = labels;           clear labels
    Ps = pca(Xs);  % source subspace


    %load ('MIAS.mat')     % target domain
    load('Inbreast\Resnet Full Image Classifier\Inbreastfeatures_Resnet.mat')
    %load('MIASPATCHES.mat');
    Label(Label==0) = -1
    fts = Features;
    labels = Label;
    fts = fts ./ repmat(sum(fts,2),1,size(fts,2)); 
    Xt = zscore(fts,1);     clear fts
    Yt = labels;            clear labels
    Pt = pca(Xt);  % target subspace

    %% Set algorithm options
    options.gamma = 1;
    options.lambda = 1;
    options.kernel_type = 'rbf';
    options.T = 10;
    options.dim = 100;
    options.mu = 0.2;
    %% Run algorithm
    [knn_model,Y_tar_pseudo,Acc,acc_ite,~] = MyBDA(Xs,Ys,Xt,Yt,options);
    fprintf('Acc:%.2f',Acc);
    hold on
    auc1 = plotroc(Yt,Y_tar_pseudo, '--b', 'BDA' )
