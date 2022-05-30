clc;
clear all;

%%% define variables
data = load('CS205_SP_2022_SMALLtestdata__7.txt');       % file load
%data = load('CS205_SP_2022_LARGEtestdata__19.txt');      % file load
total = 0;                                 % # of total
success = 0;                               % # of success
distances = zeros(size(data,1),1);         % distance matrix
test_point = zeros(1);                     % test point. compare with test_set
data = [data(:,1) z_score(data(:,2:end))]; % Z-score normalized
test_set = [data(:,1)];                    % start with only class column
n = size(data, 1);                         % # of instances
features = size(data, 2);                  % # of features + 1(class)
best_choices =[];                          % |1.feature index|2.#ofsuccess|, order: selection first order
compensation = [ones(features,1) zeros(features,1)];    % compensate feature number (since feature_number = column# -1)

tic
%%% Start Forward_selection
for i = 1:n             % If there is no feature (My NN works if at least one feature exists)
    test_point = test_set(i,:);
    for j = 1:n
        if i~=j         % except itself
            if (test_point(1) == test_set(j,1))
                success = success +1;
            end
        end
    end
end
best_choices = [1, (success/(n*(n-1)))]
for m = 2:features                       % loop until test_set is full 
    accuracy = zeros(1,features);
    for i = 2:features                   % from class to the last feature
        if ~isempty(best_choices)
            if(~isempty(find(i == best_choices(:,1))))  % pass already seletected features 
                continue
            end
        end
        test_set = [test_set data(:,i)]; % add a test feature   
        success= 0;
        for j = 1:n                      % test for all rows   
            test_point = test_set(j,:);  % move test_point from 1 to the last one
            if (test_point(1) == NN(test_point, test_set))
                success = success +1 ;
            end           
        end
        accuracy(i) = success/n;      % store accuracy information        
        test_set(:,size(test_set,2)) = [];  % erase test column
    end
    %accuracy    
    [acc, ind] = sort(accuracy, 'descend'); % to find best feature easily. 
    best_choices = [best_choices;ind(1) acc(1)];   % Add highest accuracy feature |1.feature index|2.accuracies|, order: selection first order
    test_set = [test_set data(:,ind(1))]; % shape: |class|best_feature|2nd_feature|3rd_feature|4th...|5th...|...
    %size(test_set)    
end
toc
best_choices = best_choices - compensation;% = best_choices - [ones(size(best_choices,1),1) zeros(size(best_choices,1),1)]
best_choices' % print selected features' # ; success rate
%%% Terminate Forward selection 

% backward_elimination
test_set = data;                    % start with full features
test_copy = test_set;               % auxilary matrix for loop
best_choices = [];
candidates = [];
tic
for m = 1:features                  % loop until test_set is empty
    accuracy = zeros(1, features); 
    if(m ~=1)
        candidates = best_choices(:,1)';
        candidates(1) = [];
    else
        success = 0;
        for j = 1:n                                 % test for all rows
            test_point = test_set(j,:);             % move test_point from 1 to the last row
            if (test_point(1) == NN(test_point, test_set))
                success = success +1 ;
            end
        end           
        best_choices = [1 success/n];               % when features are full
        continue;
    end
            
    for i = 2:features                              % from feature one to the last        
        if ~isempty(best_choices)
            if(~isempty(find(i == best_choices(:,1)))) % pass already eliminated features
                continue
            end
        end
        candidates = [candidates i];            
        test_set = test_copy;
        test_set(:,candidates)=[];
        success = 0;
        if (size(test_set,2)>1)
            for j = 1:n                             % test for all rows
                test_point = test_set(j,:);         % move test_point from 1 to the last row
                if (test_point(1) == NN(test_point, test_set))
                    success = success +1 ;
                end
            end
        else                                        % for the last loop if there is no feature
            for j = 1:n
                test_point = test_set(j,:);
                for k = 1:n
                    if j~=k         %except itself
                        if (test_point(1) == test_set(k,1))
                            success = success +1;
                        end
                    end
                end
            end
            best_choices = [best_choices; i success/(n*(n-1))];
        end
        accuracy(i) = success/n;                    % store accuracy information    
        candidates(end) = [];       
    end
    if (size(test_set,2)==1)                        % If there is no feature anymore, then break;
        break;
    end
    [acc, ind] = sort(accuracy, 'descend');         % to find most useless feature easily.
    best_choices = [best_choices;ind(1) acc(1)];    % Add worst accuracy feature  |1.feature index|2.accuracies|, order: selection first order
    test_set = test_copy;
    test_set(:,best_choices(2:end,1)')=[];   
end
toc
best_choices = best_choices - compensation ; % make best_choices' features correct
best_choices'   % print eliminated features' # ; success rate
