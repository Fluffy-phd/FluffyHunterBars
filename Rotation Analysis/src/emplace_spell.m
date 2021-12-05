function [queue] = emplace_spell(queue, i, spell)

t1s = queue(i, 1);
t2e = spell(2);
delay = max(t2e - t1s, 0);

m = length(queue(:, 1));

queue = [
    queue(1:i-1, :);
    spell;
    queue(i:m, :) + [delay, delay, 0];
];

end

