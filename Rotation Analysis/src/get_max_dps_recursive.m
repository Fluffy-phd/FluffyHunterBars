function [dmg, time] = get_max_dps_recursive(spell_casts, spell_cds, spells_dmg, spells_ready, n, total_dmg, total_time)
    if n == 0
        dmg = total_dmg;
        time = total_time;
        return;
    end
    
    cast1 = spell_casts(1);
    cast2 = spell_casts(2);
    
    rdy1 = spells_ready(1);
    rdy2 = spells_ready(2);
    
    %trivial case, no overlap
    if rdy1 + cast1 <= rdy2
        %we cast ability 1
        [dmg, time] = get_max_dps_recursive(spell_casts, spell_cds, spells_dmg, [spell_cds(1), rdy2 - (rdy1 + cast1)], n-1, total_dmg + spells_dmg(1), total_time + rdy1 + cast1);
        return;
        
    elseif rdy2 + cast2 <= rdy1
        %we cast ability 2
        [dmg, time] = get_max_dps_recursive(spell_casts, spell_cds, spells_dmg, [rdy1 - (rdy2 + cast2), spell_cds(2)], n-1, total_dmg + spells_dmg(2), total_time + rdy2 + cast2);
        return;
        
    end
    
    %we cast ability 1
    [dmg1, time1] = get_max_dps_recursive(spell_casts, spell_cds, spells_dmg, [spell_cds(1), max(rdy2 - (rdy1 + cast1),0)], n-1, total_dmg + spells_dmg(1), total_time + rdy1 + cast1);
    %or we cast ability 2
    [dmg2, time2] = get_max_dps_recursive(spell_casts, spell_cds, spells_dmg, [max(rdy1 - (rdy2 + cast2), 0), spell_cds(2)], n-1, total_dmg + spells_dmg(2), total_time + rdy2 + cast2);
    
    if dmg1/time1 > dmg2/time2
        dmg = dmg1;
        time = time1;
    else
        dmg = dmg2;
        time = time2;
    end
end