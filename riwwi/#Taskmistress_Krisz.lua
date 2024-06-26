function event_spawn(e)
	eq.zone_emote(MT.White,"Taskmistress Krisz shouts, 'Kekken, Uxnikk! What are you fools doing?");
	eq.set_next_hp_event(40);
	e.self:ModSkillDmgTaken(8, -50); -- backstab
	e.self:ModSkillDmgTaken(36, -60); -- piercing
	e.self:ModSkillDmgTaken(77, -60); -- 2h piercing
	eq.set_timer("depop", 1200 * 1000); -- 20 min depop
end

function event_hp(e)
	if e.hp_event == 40 then
	eq.set_next_hp_event(30);
		eq.modify_npc_stat("min_hit", "1050");
		eq.modify_npc_stat("max_hit", "2950");
		eq.set_next_inc_hp_event(42);
    elseif e.hp_event == 30 then
		eq.set_next_hp_event(20);
		eq.modify_npc_stat("min_hit", "1160");
		eq.modify_npc_stat("max_hit", "3250");
		eq.set_next_inc_hp_event(32);
    elseif e.hp_event == 20 then
		eq.set_next_hp_event(10);
		eq.modify_npc_stat("min_hit", "1380");
		eq.modify_npc_stat("max_hit", "3850");
		eq.set_next_inc_hp_event(22);
    elseif e.hp_event == 10 then
		eq.set_next_hp_event(5);
		eq.modify_npc_stat("min_hit", "2100");
		eq.modify_npc_stat("max_hit", "6850");
		eq.set_next_inc_hp_event(12);
    elseif e.hp_event == 5 then
		eq.modify_npc_stat("min_hit", "3986");
		eq.modify_npc_stat("max_hit", "13980");
		eq.set_next_inc_hp_event(7);
    elseif e.inc_hp_event == 42 then
		eq.modify_npc_stat("min_hit", "964");
		eq.modify_npc_stat("max_hit", "2700");
		eq.set_next_hp_event(40);
	elseif e.inc_hp_event == 32 then
		eq.set_next_inc_hp_event(42);
		eq.modify_npc_stat("min_hit", "1050");
		eq.modify_npc_stat("max_hit", "2950");
		eq.set_next_hp_event(30);
	elseif e.inc_hp_event == 22 then
		eq.set_next_inc_hp_event(32);
		eq.modify_npc_stat("min_hit", "1160");
		eq.modify_npc_stat("max_hit", "3250");
		eq.set_next_hp_event(20);
	elseif e.inc_hp_event == 12 then
		eq.set_next_inc_hp_event(22);
		eq.modify_npc_stat("min_hit", "1380");
		eq.modify_npc_stat("max_hit", "3850");
		eq.set_next_hp_event(10);
	elseif e.inc_hp_event == 7 then
		eq.set_next_inc_hp_event(12);
		eq.modify_npc_stat("min_hit", "2100");
		eq.modify_npc_stat("max_hit", "6850");
		eq.set_next_hp_event(5);
    end
end

function event_timer(e)
    if e.timer == "depop" then
        eq.stop_timer("depop");
        eq.depop();
    end
end

function event_combat(e)
	if e.joined then
		if not eq.is_paused_timer("depop") then
			eq.pause_timer("depop");
		end
	else
		eq.resume_timer("depop");
	end
end

function event_death_complete(e)
	eq.depop_with_timer(282115); -- #TM_Trigger (282115)
end
