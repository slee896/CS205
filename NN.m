% NN(Nearest_neighbor) algorithm  
function nearest_neighbor_class = NN(test_point, test_set)   % return: nearest_class
diff = test_point(1, 2:end)-test_set(:, 2:end);              
[square_root_r,index] = sort(sqrt(sum(sqrt(diff.*diff),2))); % Euclidean distance
nearest_neighbor_class = test_set(index(2),1);
