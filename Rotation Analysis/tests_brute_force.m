addpath('src')

dmg_A = 500;
dmg_S = 500;

n = 30;
hmax = 4;
haste_coeff = (hmax - 1)/(n-1);
ss_better = [];
as_better = [];
% for hi = 1:n
%     h = (hi-1)*haste_coeff + 1;
%     
%     for ardyi = 1:n
%         ardy = (ardyi-1)/(n-1)*base_speed/h;
%         
%         
%         trdy_ss = 0;
%         trdy_as = ardy;
%         
%         dps_as = get_optimal_dps_bf(1, dmg_A, dmg_S, base_speed, h, trdy_ss, trdy_as, nspells);%autoshot first
%         dps_ss = get_optimal_dps_bf(2, dmg_A, dmg_S, base_speed, h, trdy_ss, trdy_as, nspells);%steadyshot first
%         
%         if dps_ss > dps_as
%             ss_better = [ss_better;[h, max(0, ardy - 1.5/h)]];
%         elseif dps_as > dps_ss
%             as_better = [as_better;[h, max(0, ardy - 1.5/h)]];
%         end
%     end
% end

base_speed = 2.9;
nspells = 2;
x = [];
y = [];
for h = 1:0.02:3
    trdy_as_min = 0;
    trdy_as_max = base_speed-0.5;
    
    while trdy_as_max - trdy_as_min > 0.005 
        trdy_as = (trdy_as_max + trdy_as_min)/2;
        
        dps_as = get_optimal_dps_bf(1, dmg_A, dmg_S, base_speed, h, 0, trdy_as/h, nspells);
        dps_ss = get_optimal_dps_bf(2, dmg_A, dmg_S, base_speed, h, 0, trdy_as/h, nspells);
        
        if dps_as > dps_ss
            %steady clips too much => increase trdy_as
            trdy_as_min = trdy_as;
        else
            %steady clips too little => decrease trdy_as
            trdy_as_max = trdy_as;
        end
    end
    
    trdy_as = (trdy_as_max + trdy_as_min)/2;
    x = [x, h];
    y = [y, max(0, 1.5 - trdy_as)];
end

plot(x, y);

% figure(1);
% hist3(ss_better,'Nbins',[n/2, n/2]);
% xlabel('haste') 
% ylabel('relative delay')
% colormap(jet(8));
% colorbar;
% view(2)
% 
% figure(2);
% hist3(as_better,'Nbins',[n/2, n/2]);
% xlabel('haste') 
% ylabel('relative delay')
% colormap(jet(8));
% colorbar;
% view(2)
