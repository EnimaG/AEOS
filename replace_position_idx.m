function id_rep_pos = replace_position_idx(pos,data)

clusters = data(pos,13)';

% Calculate the counts of each unique number
unique_numbers = unique(clusters);
% counts = histcounts(clusters, [unique_numbers, max(unique_numbers) + 1]);
try
    counts = histcounts(clusters, [unique_numbers, max(unique_numbers) + 1]);
    % Additional code using 'counts' if no exception occurs
catch exception
    % Handle the exception here
    fprintf('An exception occurred: %s\n', exception.message);
    % Perform error handling tasks, log the error, or execute alternative code
end
id_rep_pos = [];
for i = 1:numel(counts)
    aaa = data(data(:, 13) == unique_numbers(i), :);
    aaa = aaa(aaa(:, 14) ~= -1, :);
    %aaa = sortrows(aaa, [-14, -4, 3, 9, 10]);
    aaa = sortrows(aaa, [-4, 3, 9, 10]);
    if size(aaa, 1) >= counts(i)
        id_rep_pos = [id_rep_pos; aaa(1:counts(i),1)];
    else
        id_rep_pos = [id_rep_pos; aaa(:,1)];
    end
end
