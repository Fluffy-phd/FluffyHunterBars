addpath('src')

dmg_A = 500;
dmg_S = 500;
base_speed = 2.9;

a_res = [];
s_res = [];
A_res = [];
S_res = [];
h_res = [];
n = 1000;
for h = 1:0.1:4
    h_res = [h_res h];
    [a, s] = AS_prio(base_speed, h, n);
    [A, S] = AS_prio_exp(base_speed, h, n, dmg_A, dmg_S);
    a_res = [a_res a];
    s_res = [s_res s];
    A_res = [A_res A];
    S_res = [S_res S];
end

hold on;
subplot(3, 1, 1);
plot(h_res, A_res*dmg_A + S_res*dmg_S) %total dps
hold on;
subplot(3, 1, 2);
plot(h_res, A_res*60) %Autoshots per minute
hold on;
subplot(3, 1, 3);
plot(h_res, S_res*60) %Steadyshots per minute
% subplot(3, 1, 1);
% plot(h_res, a_res*dmg_A + s_res*dmg_S, '-r', h_res, A_res*dmg_A + S_res*dmg_S, '-b') %total dps
% subplot(3, 1, 2);
% plot(h_res, a_res*60, '-r', h_res, A_res*60, '-b') %Autoshots per minute
% subplot(3, 1, 3);
% plot(h_res, s_res*60, '-r', h_res, S_res*60, '-b') %Steadyshots per minute



% fprintf("[%3.2f] CPM: [%6.1f %6.1f] [%6.1f %6.1f]\n", 1.15, a1, s1, a2, s2);

% for haste = 1:0.01:3
%     [a1, s1] = SS_prio(base_speed, haste);
%     [a2, s2] = AS_prio(base_speed, haste);
%     fprintf("[%3.2f] CPM: [%6.1f %6.1f] [%6.1f %6.1f]\n", haste, a1, s1, a2, s2);
% end

h = 1.9;
ws = 2.9;
na = 1;

fprintf('acceptable delay: %10.4f\n', (dmg_S*(0.5 + ws*(na-1)))/(dmg_A*h));
