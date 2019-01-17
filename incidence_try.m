N = 10;

A = zeros(N,N);

% for i = 1:N
%     A(i, i+1) = 1;
%     A(i+1, i) = -1;
% end

for i = 1:N
    for j = 1:N
        prob = rand(1);
        if(prob < 0.1) && (i ~= j) && (A(i,j) == 0)
            A(i,j) = 1;
%             A(j,i) = -1;
        end
    end
    if(i < N)
        A(i, i+1) = 1;
%         A(i+1, i) = -1;
    end
end

pmax = 10;
p = pmax*rand(2,N);
p(:, 1) = [0, 0];
theta = 2*pi*randn(1,N) - pi;
R_cells = euler_to_rot_mat(theta);
R_cells{1} = eye(2);
[rows, cols] = find(A == 1); M = length(rows);

A_inc = zeros(M,N);
for k = 1:M
    i = rows(k); j = cols(k);
    A_inc(k, j) = 1;
    A_inc(k, i) = -1;
end
disp(A_inc);

delta_p_cell = cell(1,M);
R_delta_cell = cell(1,M);

for k = 1:M
    i = rows(k); j = cols(k);
    delta_p_cell{k} = R_cells{i}'*(p(:,j) - p(:,i));
    R_delta_cell{k} = R_cells{i}'*R_cells{j};
end

delta_p_cell_noise = cell(1,M);
R_delta_cell_noise = cell(1,M);

for k = 1:M
    i = rows(k); j = cols(k);
    delta_p_cell_noise{k} = R_cells{i}'*(p(:,j) - p(:,i)) + 0.1*randn(2,1);
    R_noise = euler_to_rot_mat(0.1*(2*pi*randn(1) - pi));
    R_delta_cell_noise{k} = R_cells{i}'*R_cells{j}*R_noise{1};
end


cost = cost_calculator_incidence(p, R_cells, delta_p_cell, R_delta_cell, A_inc)
cost_noise = cost_calculator_incidence(p, R_cells, delta_p_cell_noise, R_delta_cell_noise, A_inc)


G = digraph(A);

figure;
plot(G, 'XData', p(1,:), 'YData', p(2,:));
title('Generated Random Pose Graph');
xlabel('x'); ylabel('y');





    