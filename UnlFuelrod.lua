-- This function is required for scripts to run on Phasor (including and after 01.00.03.104)
-- You should return the minimum required version of Phasor
-- Official releases:
--   01.00.03.104 - 3104
--   01.00.10.057 - 10057
-- Test inspired from [SC]Nuggets work


function GetRequiredVersion()
  return 10057
end

-- called when the script is loaded
function OnScriptLoad(process)
end

-- called when the script is unloaded
-- Do not return a value
function OnScriptUnload()
end

-- called when a game is starting (before any players join)
-- Do not return a value.
function OnNewGame(map)
end

-- called when a game is ending
-- Do not return a value.
function OnGameEnd(mode)
	-- mode 1 = score menu (F1) is being displayed to clients, they are still ingame
	-- mode 2 = post game menu appeared
	-- mode 3 = players can quit via the post game score card
end

-- Called when there is chat within the server
-- It must return a value which indicates whether or not the chat is sent.
function OnServerChat(player, chattype, message)
	return 1
end

-- Called when a server command is being executed
-- It must return a value which indicates whether or not the command should be processed
-- Note: It is only called when an authenticated (and allowed) player attempts to use the command.
--		 player is -1 when being executed via the server console.
function OnServerCommand(player, command)
	return 1
end

-- Called when a player's team is being chosen as the join the server.
-- It must return a value which indicates the team the player is to be put on.
-- Note: this function being called doesn't guarantee that the player will be able to successfully join.
function OnTeamDecision(cur_team)
	return dest_team
end

-- Called when a player joins the server.
-- Do not return a value.
function OnPlayerJoin(player, team)
end

-- Called when a player the server.
-- Do not return a value.
function OnPlayerLeave(player, team)
end

-- called when a player kills another, 'killer' is the index of the killing player, 'victim' is the index of the dead player
-- Do not return a value.
function OnPlayerKill(killer, victim, mode)
end

-- called when a player gets a double kill, killing spree etc
-- see Phasor documentation for multiplier values
function OnKillMultiplier(player, multiplier)
end

-- Called when a player s (after object is created, before players are notified)
-- Do not return a value
function OnPlayerSpawn(player, m_objectId)

    local m_object = getobject(m_objectId)
	if m_object then
		for i = 0,1 do
            local weapID = readdword(m_object, 0x2F8 + i*2)
            local weap = getobject(weapID)
            if weap then
                destroyobject(weapID)
            end
        end
    end
	registertimer(1, "WeaponAssign", player)
end

--Starting weapons
function WeaponAssign(id, count, player)

	local m_object = getobject(getplayerobjectid(player))
	if m_object then
		local weapa = createobject("weap", "weapons\\plasma_cannon\\plasma_cannon", 0, -1, false, 0, 0, 0)
		assignweapon(player, weapa)
		local weapb = createobject("weap", "weapons\\plasma_cannon\\plasma_cannon", 0, -1, false, 0, 0, 0)
		assignweapon(player, weapb)
	end
	return 0
end

-- Called after clients have been notified of a player spawn
-- Do not return a value
function OnPlayerSpawnEnd(player, m_objectId)

end

-- Called when a player is attempting to .
-- A value must be returned. The return value indicates whether or not the player is allowed the change team.
-- Notes: If relevant is 1 the return value is considered, if it's 0 then the return value is ignored.
function OnTeamChange(relevant, player, team, dest_team)
	return 1
end

-- This is called when a client sends the server an update packet.
-- This includes things such as movement vectors, camera positions, button presses etc.
-- This function is called frequently so care should be taken to keep processing
-- to a minimum.
-- Do not return a value
function OnClientUpdate(player, m_objectId)

--Thanks to Nuggets for the OnWeaponSwitch function
local m_object = getobject(m_objectId)
local m_playerObjId = getplayerobjectid(player)

local cur_weap = readword(m_object, 0x2F2) -- Current weapon slot
local next_weap = readword(m_object, 0x2F4) -- Weapon slot the player is trying to change to
if cur_weap ~= next_weap and cur_weap ~= 65535 then
local cur_weap_id = readdword(m_object, 0x118) -- Current weapon ID
local next_weap_id = readdword(m_object, 0x2F8 + (next_weap*2)) -- Weapon ID the player is trying to change to
OnWeaponSwitch(player, m_playerObjId, cur_weap_id, next_weap_id) -- Call the function, i haven't made a way to block it yet.
end

end

-- Called when a player interacts with an object
-- It can be called while attempting to pick the object up
-- It is also called when standing above an object so can be called various times quickly
function OnObjectInteraction(player, m_ObjectId, tagType, tagName) -- a retouche

end

-- Called when a player attempts to reload their weapon.
-- A value must be returned. The return value indicates whether or not the player is allowed to reload.
-- Notes: If player is -1 then the weapon being reload wasn't located (it could be a vehicle's weapon)
function OnWeaponReload(player, weapon)
	return 1
end

-- Called when a player attempts to enter a vehicle.
--The return value indicates whether or not the player is allowed to enter.
function OnVehicleEntry(relevant, player, vehicleId, vehicle_tag, seat)
	return 1
end

-- Called when a player is being ejected from their vehicle
-- Return 1 or 0 to allow/block it.
function OnVehicleEject(player, forceEject)
	return 1
end


-- Called when damage is being done to an object.
-- This doesn't always need to be a player.
-- Do not return a value
function OnDamageLookup(receiving_obj, causing_obj, tagdata, tagname)
end

-- Called when a player is being assigned a weapon (usually when they spawn)
-- A value must be returned. The return value is the id of the weapon they're to spawn with. Return zero if the weapon shouldn't change.
-- Notes: 	This is called for all weapon spawns the player has
--			This is also called with player 255 when vehicles are being assigned weapons.
-- 			This is only considered if in gametype, the weapon set is 'generic' if not this has no effect.
function OnWeaponAssignment(player, object, count, tag)

	return 0
end

-- Called when an object is created
-- Do not return a value.
function OnObjectCreation(m_objectId, player_owner, tag)
end

function OnWeaponSwitch(player, m_playerObjId, cur_weapId, next_weapId)

local weapc = createobject("weap", "weapons\\plasma_cannon\\plasma_cannon", 0, -1, false, 0, 0, 0)
assignweapon(player, weapc)
end
