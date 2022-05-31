function z_score_data = z_score(data)
n = size(data,1)*size(data,2);              % # of elements
m = mean(data, 'all');                      % mean
s = sqrt(sum((data-m).*(data-m),'all')/n);  % standard deviation
z_score_data = (data-m)/s;                  % z_score = (x-μ) / σ
