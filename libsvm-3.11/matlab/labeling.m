%% While Creating dictionary labels are generated from the filename. 
%% The labels are character format and the libsvm package only accepts the
%% Labels in the double format. So here we converted the character label to 
%% Numbers.




function[svmlab, svmlab_t] = labeling(label, label_t)




label_change = label;
label_t_change = label_t;

label_change(strcmp('boxing', label_change)) =  {'1'};
label_change(strcmp('walking', label_change))= {'2'};
label_change(strcmp('running', label_change))= {'3'};
label_change(strcmp('jogging', label_change))= {'4'};
label_change(strcmp('handclapping', label_change))= {'5'};
label_change(strcmp('handwaving', label_change))= {'6'};



label_t_change(strcmp('boxing', label_t_change))= {'1'};
label_t_change(strcmp('walking', label_t_change))= {'2'};
label_t_change(strcmp('running', label_t_change))= {'3'};
label_t_change(strcmp('jogging', label_t_change))= {'4'};
label_t_change(strcmp('handclapping', label_t_change))= {'5'};
label_t_change(strcmp('handwaving', label_t_change))= {'6'};



S = sprintf('%s*', label_change{:});
svmlab = sscanf(S, '%f*');


S_t = sprintf('%s*', label_t_change{:});
svmlab_t = sscanf(S_t, '%f*');

end
