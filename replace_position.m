function id_rep_pos = replace_position(pos, data, t_d)

%convert to datenum format
pos = pos./t_d;

clus_cent = unique(data(:, 15));

closest_clusters = zeros(size(pos));

% Determine the closest cluster for each initial value
for i = 1:numel(pos)
    
    % Find the index of the minimum difference (closest cluster)
    [~, idx] = min(abs(pos(i) - clus_cent));
    closest_clusters(i) = idx;
end

% Calculate the counts of each unique number
unique_numbers = unique(closest_clusters);
counts = histcounts(closest_clusters, [unique_numbers, max(unique_numbers) + 1]);
id_rep_pos = [];
for i = 1:numel(counts)
    aaa = data(data(:, 15) == clus_cent(unique_numbers(i)), :);
    aaa = aaa(aaa(:, 14) ~= -1, :);
    aaa = sortrows(aaa, [-14, -4, 3, 9, 10]);
    if size(aaa, 1) >= counts(i)
        id_rep_pos = [id_rep_pos; aaa(1:counts(i),1)];
    else
        disp('')
    end
end


disp("")