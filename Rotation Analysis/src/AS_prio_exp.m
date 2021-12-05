function [ASf, SSf] = AS_prio_exp(ws, h, n, dmgA, dmgS)

ASf = 0;
SSf = 0;

dpsA = dmgA/ws*h;
dpsS = dmgS/1.5;

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
%(1.5/h - t)*dpsA = (t + 0.5/h)*dpsS
%t = (3*dpsA - dpsS)/(2*h*(dpsS + dpsA))
% p_equi = max((3*dpsA - dpsS)/(2*h*(dpsS + dpsA)), 0);
% p_equi = max((1.5/h*dmgA - 0.5/h*dmgS)/(dmgS + dmgA), 0);

na = 1;
p_equi = max(1.5/h - (dmgS*(0.5 + ws*(na-1)))/(dmgA*h), 0);

while t_ < queue(n, 1)
    if t_ < queue(i, 1) - p_equi %SS is ready before the next AS is ready to be cast
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

%validation, 1st pass, check for correct intervals
for i = 1:m
    if queue(i, 1) > queue(i, 2)
        ASf = -1;
        SSf = -1;
        return;
    end
end
%validation, 2nd pass, check for non-overlapping intervals
for i = 2:m
    if queue(i, 1) < queue(i - 1, 2) - 0.0005
        ASf = -2;
        SSf = -2;
        return;
    end
end
%validation, 3rd pass, check if cooldowns and cast times are satisfied
cds = [(ws - 0.5)/h, 1.5*(1-1/h)];
casts = [0.5/h, 1.5/h];
for a = 1:2
    last_finish = -1;
    cd = cds(a);
    cast = casts(a);
    
    for i = 1:m
        if queue(i, 3) == a
            if last_finish >=0
                start = queue(i, 1);
                if start < last_finish + cd - 0.0005
                    ASf = -3;
                    SSf = -3;
                    return;
                end
            end
            last_finish = queue(i, 2);
            if abs(queue(i, 2) - queue(i, 1) - cast) >= 0.005
                ASf = -4;
                SSf = -4;
                return;
            end
        end
    end
end


end

