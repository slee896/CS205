% NN(Nearest_neighbor) algorithm (9 lines)
% For 1 feature, For 1 test_point with 
function nearest_neighbor_class = NN(test_point, test_set) % return: nearest_vector
diff = test_point(1, 2:end)-test_set(:, 2:end);
[square_root_r,index] = sort(sqrt(sum(sqrt(diff.*diff),2)));
nearest_neighbor_class = test_set(index(2),1);