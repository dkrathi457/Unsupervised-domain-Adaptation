load('CNN_dict.mat');
load('CNN_dict_t.mat');


[svmlab , svmlab_t] = labeling(label, label_t);
options=[];
 options.ReducedDim=10000;
[eigvector,eigvalue] = PCA(encode,options);

pcaTestFea = encode_t*eigvector;
 pcaTrainFea = encode*eigvector;

best_cv = 0;
slack_val = 0.1;
gamma_val = 0.00001;
for i = 1:10
  for j = 1:10
    cmd = ['-t 1 -c ', num2str(slack_val), ' -g ', num2str(gamma_val)];
    cv = get_cv_ac(svmlab, pcaTrainFea, cmd, 4);
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
model = ovrtrain(svmlab, pcaTrainFea, bestParam);
% #######################
% Classify samples using OVR model
% #######################
[predict_label, accuracy, prob_values] = ovrpredict(svmlab_t, pcaTestFea, model);
fprintf('Accuracy = %g%%\n', accuracy * 100);


Mdl = fitcknn(pcaTrainFea,Y,'NumNeighbors',5,'Standardize',1)