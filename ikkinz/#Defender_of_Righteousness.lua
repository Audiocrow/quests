--Ikkinz Raid #1: Chambers of Righteousness  

function event_combat(e)
	if e.joined then
		eq.set_timer("OOBcheck", 3 * 1000);	
	else
		eq.stop_timer("OOBcheck");
	end
end


function event_timer(e)
if(e.timer=="OOBcheck") then
eq.stop_timer("OOBcheck");
	if (e.self:GetX() > 115 or e.self:GetX() < -180 or e.self:GetY() > -360 or e.self:GetY() < -470) then
		e.self:CastSpell(3791,e.self:GetID()); -- Spell: Ocean's Cleansing
		e.self:GotoBind();
		e.self:WipeHateList();
	else
		eq.set_timer("OOBcheck", 3 * 1000);
	end
end
end

function event_death_complete(e)
	eq.signal(294141,2); -- NPC: #Trigger_Ikkinz_1
	local dz = eq.get_expedition()
	if dz.valid then
		dz:AddReplayLockoutDuration(eq.seconds("2h"))
	end
end
