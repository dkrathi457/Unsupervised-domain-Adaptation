clc
clear
close 

load('HOG.mat');

numTrain = 70;

trainInd = [];
testInd = [];

n_per = 5;
n_sub = 100;

%fea = fea'


%{

for i = 1: n_per
        trainInd = [trainInd, (i-1)*n_sub+1: (i-1)*n_sub+numTrain];
        testInd = [testInd, (i-1)*n_sub+numTrain+1: i*n_sub];
end


trainInd = trainInd';
testInd = testInd';

testInd(end,:) = [];
trainFea = fea(trainInd,:);
trainLabel = lab(trainInd,:);
testFea = fea(testInd,:);
testLabel = lab(testInd,:);



%% Please uncomment this part if run PCA
% % pca
% tic;
 options=[];
 options.ReducedDim=100;
[eigvector,eigvalue] = PCA(trainFea,options);
% pcaTime = toc;

pcaTestFea = testFea*eigvector;
 pcaTrainFea = trainFea*eigvector;

 

%norm_train = NormalizeFea(pcaTrainFea,1);
%norm_test = NormalizeFea(pcaTestFea, 1);


%pcaTrainFea = norm_train;
%pcaTestFea = norm_test;
 
 
 
best_cv = 0;
slack_val = 0.1;
gamma_val = 0.00001;
for i = 1:10
  for j = 1:10
    cmd = ['-t 2 -c ', num2str(slack_val), ' -g ', num2str(gamma_val)];
    cv = get_cv_ac(trainLabel, pcaTrainFea, cmd, 4);
    if (cv >= best_cv)
      best_cv = cv; bestc = slack_val; bestg = gamma_val;
    end
    gamma_val = gamma_val*10;
    fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n', i, j, cv, bestc, bestg, best_cv);
  end
  gamma_val = 1;
  slack_val = slack_val*10;
end

% #######################
% Train the SVM in one-vs-rest (OVR) mode
% #######################
bestParam = ['-q -c ', num2str(bestc), ' -g ', num2str(bestg)];
model = ovrtrain(trainLabel, pcaTrainFea, bestParam);
% #######################
% Classify samples using OVR model
% #######################
[predict_label, accuracy, prob_values] = ovrpredict(testLabel, pcaTestFea, model);
fprintf('Accuracy = %g%%\n', accuracy * 100);
 
%}