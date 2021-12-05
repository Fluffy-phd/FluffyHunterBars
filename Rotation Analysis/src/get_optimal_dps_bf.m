function [dps] = get_optimal_dps_bf(fist_spell_idx, dmg_as, dmg_ss, base_speed, h, trdy_ss, trdy_as, nspells)

    
    
    
    cast_as = 0.5/h;
    cast_ss = 1.5/h;
    
    cd_as = (base_speed - 0.5)/h;
    cd_ss = 1.5*(1 - 1/h);

    if fist_spell_idx == 1
        [dmg, time] = get_max_dps_recursive([cast_as, cast_ss], [cd_as, cd_ss], [dmg_as, dmg_ss], [cd_as, max(0, trdy_ss - (trdy_as + cast_as))], nspells - 1, dmg_as, trdy_as + cast_as);
    else
        [dmg, time] = get_max_dps_recursive([cast_as, cast_ss], [cd_as, cd_ss], [dmg_as, dmg_ss], [max(0, trdy_as - (trdy_ss + cast_ss)), cd_ss], nspells - 1, dmg_ss, trdy_ss + cast_ss);
    end
    
    dps = dmg/time;
end

