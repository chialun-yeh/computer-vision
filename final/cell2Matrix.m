function matrix = cell2Matrix(cell)

l = length(cell);
max_col = 0;
[row n]= size(cell{1});

for i = 1:l
    [m n]= size(cell{i});
    if n > max_col
        max_col = n;
    end
end

matrix = [];

for i = 1:l
    [m n]= size(cell{i});
    frame = cell{i};
    if i == 1
        matrix_i = padarray(frame,[0,(max_col-n)],0, 'post');
    end
    matrix(:,:,i) = matrix_i;
end

end

%%
% T = {[1:5:21],[2:5:22],[3:5:23],[4:5:24],[5:5:20]}
% m=3
% n=8
% [M, tf] = padcat(T{:})
% M = M.' 
% out = reshape(M(tf.'),n,m).' % swap m and n, and then transpose
% 
% %%
%  str2num(char(cell))