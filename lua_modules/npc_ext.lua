function NPC:ForeachHateList(func, cond)
	cond = cond or function(ent, hate, damage, frenzy) return true end;
	local lst = self:GetHateList();
	for ent in lst.entries do
		local cv = cond(ent.ent, ent.hate, ent.damage, ent.frenzy);
		if(cv) then
			func(ent.ent, ent.hate, ent.damage, ent.frenzy);
		end
	end
end

function NPC:CountHateList(cond)
	cond = cond or function(ent, hate, damage, frenzy) return true end;
	local lst = self:GetHateList();
	local ret = 0;
	for ent in lst.entries do
		local cv = cond(ent.ent, ent.hate, ent.damage, ent.frenzy);
		if(cv) then
			ret = ret + 1;
		end
	end
	
	return ret;
end

function NPC:RandomRoam(maxx,maxy,maxz,los)
	maxz = maxz or 15;
	los = los or 5;

	if not self:IsEngaged() then
		local curx = self:GetX();
		local cury = self:GetY();
		local origx = self:GetSpawnPointX() or 0;
		local origy = self:GetSpawnPointY() or 0;
		local origz = self:GetSpawnPointZ() or 0;
		local guardx = self:GetGuardPointX() or 0;
		local guardy = self:GetGuardPointY() or 0;

		if curx == guardx and cury == guardy then
			local randomx = math.random(maxx) + 1;
			local randomy = math.random(maxy) + 1;
			local posx = origx + randomx;
			local posy = origy + randomy;
			local negx = origx - randomx;
			local negy = origy - randomy;
			local newx, newy, newz = 0;
			if posx > negx then -- Flip order
				newx = math.random(negx, posx);
			else
				newx = math.random(posx,negx);
			end

			if posy > negy then -- Flip order
				newy = math.random(negy, posy);
			else
				newy = math.random(posy,negy);
			end
			local newz = self:FindGroundZ(newx,newy, 5) + 1;

			if newz > -999999 and origz > (newz - maxz + 1) and origz < (newz + maxz - 1) then
				local loscheck = self:CheckLoSToLoc(newx, newy, newz, los);
				if loscheck then
					self:MoveTo(newx,newy,newz,-1,true);
				end
			end
		end
	end
end

function NPC:CastedSpellFinished(spell_id, target) -- note, we do have a server side function (not exported) called this too ...
	self:SendBeginCast(spell_id, 0);
	self:SpellFinished(spell_id, target);
end

function NPC:GetClientsInProximity(distance)
	local clients = {}
	local client_list = eq.get_entity_list():GetClientList()
	for client in client_list.entries do
		if client.valid and self:CalculateDistance(client:GetX(), client:GetY(), client:GetZ()) <= distance then
			clients[#clients+1] = client
		end
	end
	return clients
end

function NPC:DeathNotification(e)
	if (eq.is_content_flag_enabled("production")) then
		eq.discord_send("Kill_Tracker", " **NPC Kill Tracker** ["..os.date ("%c").."] ```YAML\n NPC: [".. e.self:GetCleanName().."] ["..e.self:GetNPCTypeID().."] \n Zone: ["..eq.get_zone_long_name().."] ID: ["..eq.get_zone_id().."] Loc: ["..tonumber(string.format("%.2f", e.self:GetX())).." "..tonumber(string.format("%.2f", e.self:GetY())).." "..tonumber(string.format("%.2f", e.self:GetZ())).." "..tonumber(string.format("%.2f", e.self:GetHeading())).."] \n Instance ID: ["..eq.get_zone_instance_id().."] \n Number on Hate List: ["..tonumber(e.self:CountHateList()).."] \n Killer: ["..e.other:GetName().."] ["..e.other:CastToClient():CharacterID().."] \n Guild Name: ["..eq.get_guild_name_by_id(eq.get_guild_id_by_char_id(e.other:CastToClient():CharacterID())).."]```");
	else
		eq.discord_send("Dev_Quest_Logging", " **NPC Kill Tracker** ["..os.date ("%c").."] ```YAML\n NPC: [".. e.self:GetCleanName().."] ["..e.self:GetNPCTypeID().."] \n Zone: ["..eq.get_zone_long_name().."] ID: ["..eq.get_zone_id().."] Loc: ["..tonumber(string.format("%.2f", e.self:GetX())).." "..tonumber(string.format("%.2f", e.self:GetY())).." "..tonumber(string.format("%.2f", e.self:GetZ())).." "..tonumber(string.format("%.2f", e.self:GetHeading())).."] \n Instance ID: ["..eq.get_zone_instance_id().."] \n Number on Hate List: ["..tonumber(e.self:CountHateList()).."] \n Killer: ["..e.other:GetName().."] ["..e.other:CastToClient():CharacterID().."] \n Guild Name: ["..eq.get_guild_name_by_id(eq.get_guild_id_by_char_id(e.other:CastToClient():CharacterID())).."]```");
	end
end
