DDSMfeatures = csvread('D:\Inbreastfeatures.csv');
Label1 = N_Label;

% Import Labels

p = .7      % proportion of rows to select for training
N = size(DDSMfeatures,1)  % total number of rows 
tf = false(N,1)    % create logical index vector
tf(1:round(p*N)) = true     
tf = tf(randperm(N))   % randomise order
dataTraining = DDSMfeatures(tf,:) ;
labelTraining = Label1(tf,:);
dataTesting = DDSMfeatures(~tf,:) ;
labelTesting = Label1(~tf,:);

 options=[];
 options.ReducedDim=100;
[eigvector,eigvalue] = PCA(dataTraining,options);
% pcaTime = toc;

pcaTestFea = dataTesting*eigvector;
pcaTrainFea = dataTraining*eigvector;

norm_train = NormalizeFea(pcaTrainFea,1);
norm_test = NormalizeFea(pcaTestFea, 1);


pcaTrainFea = norm_train;
pcaTestFea = norm_test;


best_cv = 0;
slack_val = 0.1;
gamma_val = 0.00001;
for i = 1:10
  for j = 1:10
    cmd = ['-t 1 -c ', num2str(slack_val), ' -g ', num2str(gamma_val)];
    cv = get_cv_ac(labelTraining, pcaTrainFea, cmd, 5);
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
model = ovrtrain(labelTraining, pcaTrainFea, bestParam);
% #######################
% Classify samples using OVR model
% #######################
[predict_label, accuracy, prob_values] = ovrpredict(labelTesting, pcaTestFea, model);
fprintf('Accuracy = %g%%\n', accuracy * 100);
 




 Mdl = fitcknn(pcaTrainFea,labelTraining,'NumNeighbors',5,'Standardize',1)
 
 CVMdl = crossval(Mdl);
 kloss = kfoldLoss(CVMdl)
 [label,score,cost] = predict(Mdl,pcaTestFea)
 