function [ASf, SSf] = AS_prio(ws, h, n)

ASf = 0;
SSf = 0;

queue = zeros(n, 3);

%initial AS placement
t = 0;
for i = 1:n
    queue(i, :) = [t, t + 0.5/h, 1];
    t = t + ws/h;
end

%weawing in SSs
t_ = 0;
i = 1;
while t_ < queue(n, 1)
    if t_ < queue(i, 1) %SS is ready before the next AS is ready to be cast
        queue = emplace_spell(queue, i, [t_, t_ + 1.5/h, 2]);
        t_ = t_ + 1.5;
        i = i + 1;
        n = n + 1;
    else
        t_ = max(t_, queue(i, 2));
        i = i + 1;
    end
end
% queue

%post processing
m = length(queue(:, 1));
for i = 1:m
    if queue(i, 3) == 1
        ASf = ASf + 1;
    elseif queue(i, 3) == 2
        SSf = SSf + 1;
    end
end
t = queue(m, 2);

ASf = ASf/t;
SSf = SSf/t;

end

