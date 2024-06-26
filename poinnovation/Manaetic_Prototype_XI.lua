local instance_id = eq.get_zone_instance_id();

function event_combat(e)
	if(e.joined == true) then
		eq.set_timer("banish",math.random(15,30) * 1000);
	else
		eq.stop_timer("banish");
	end
end

function event_timer(e)
	if e.timer == "banish" then
		local cur_target = e.self:GetHateTop():CastToClient();

		eq.stop_timer(e.timer);
		eq.set_timer("banish",math.random(15,30) * 1000);

		if cur_target.valid and not cur_target:IsPet() then
			cur_target:MovePCInstance(206, instance_id,-1,-478,3.13,256);
		end
	end
end
