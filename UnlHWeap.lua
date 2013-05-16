--Opensauce -   V1

CTF =
{beavercreek_CTF, bloodgulch_CTF, boardingaction_CTF,
carousel_CTF, chillout_CTF,
damnation_CTF, dangercanyon_CTF, deathisland_CTF,
gephyrophobia_CTF, hangemhigh_CTF,
icefields_CTF, infinity_CTF,
longest_CTF, prisoner_CTF, putput_CTF,
ratrace_CTF, sidewinder_CTF,
timberland_CTF, wizard_CTF}

Slayer =
{beavercreek_Slayer, bloodgulch_Slayer, boardingaction_Slayer,
carousel_Slayer, chillout_Slayer,
damnation_Slayer, dangercanyon_Slayer, deathisland_Slayer,
gephyrophobia_Slayer, hangemhigh_Slayer,
icefields_Slayer, infinity_Slayer,
longest_Slayer, prisoner_Slayer, putput_Slayer,
ratrace_Slayer, sidewinder_Slayer,
timberland_Slayer, wizard_Slayer}

spawnweaps = CTF, Slayer

score_limit = 5

--custom weapon - Humain weapons only will get unlimited ammo
weapon = "weapons\\flamethrower\\flamethrower"
weapon_message = "Unlimited flamethrower"

local bool

function GetRequiredVersion()
  return 10058
end

function OnScriptLoad(process)
	local gametype_game = readbyte(gametype_base, 0x30)
	if gametype_game == 1 then spawnweaps = CTF
	elseif gametype_game == 2 then spawnweaps = Slayer
	end
	local scorelimit = score_limit
	gametype_base = 0x671340
	writebyte(gametype_base, 0x58, scorelimit)
end

function GetGameAddresses()
end

function OnScriptUnload()
end

function OnNewGame(map)

end

function OnGameEnd(mode)
end

function OnServerChat(player, chattype, message)
	return 1
end

function OnServerCommand(player, command)
	return 1
end

function OnTeamDecision(cur_team)
	return cur_team
end

function OnPlayerJoin(player, team)
privatesay(player, weapon_message)
end

function OnPlayerLeave(player, team)
bool = true
end

function OnPlayerKill(killer, victim, mode)
end

function OnKillMultiplier(player, multiplier)
end

function OnPlayerSpawn(player, m_objectId)
    local m_object = getobject(m_objectId)
	if m_object then
		for i = 0,3 do
            local weapID = readdword(m_object, 0x2F8 + i*4)
            local weap = getobject(weapID)
            if weap then
                destroyobject(weapID)
            end
        end
	writebyte(m_object, 0x31E, 0)
	writebyte(m_object, 0x31F, 0)
    end

end

function WeaponAssign(id, count, player)
	return 0
end

function OnPlayerSpawnEnd(player, m_objectId)

	registertimer(1, "WeaponAssign", player)

end

function WeaponAssign(id, count, player)
	local m_object = getobject(getplayerobjectid(player))
	if m_object then
		local m_weapId = createobject("weap", weapon, 0, -1, false, 0, 0, 0)
		assignweapon(player, m_weapId)
		m_weapon = getobject(m_weapId)
		writeword(m_weapon, 0x2B6, 100)
		writeword(m_weapon, 0x2B8, 9999)
		updateammo(m_weapId)
	end
	return 0
end

function OnTeamChange(relevant, player, team, dest_team)
	return 1
end

function OnObjectInteraction(player, m_ObjectId, tagType, tagName)
    if tagType == "eqip" then
		return 1
	end
end

function OnWeaponReload(player, weapon)
	return 1
end

function OnVehicleEntry(player)
	return 1
end

function OnVehicleEject(player, forceEject)
	return 1
end

function OnDamageLookup(receiving_obj, causing_obj, tagdata, tagname)
	if not bool then
		writefloat(tagdata, 0x1D0, 0.0001)
		writefloat(tagdata, 0x1D4, 0.0001)
		writefloat(tagdata, 0x1D8, 0.0001)
	end
bool = false
end

function OnWeaponAssignment(player, object, count, tag)
	return 0
end

function OnObjectCreation(m_objectId, player_owner, tag)
local tagType, tagName = getobjecttag(m_objectId)
if tagType == "eqip" then
	if tagName == "weapons\\plasma grenade\\plasma grenade" then
		local x, y, z = getobjectcoords(m_objectId)
		movobjcoords(m_objectId, 0, 0, -100)
	end
	if tagName == "weapons\\frag grenade\\frag grenade" then
		local x, y, z = getobjectcoords(m_objectId)
		movobjcoords(m_objectId, 0, 0, -100)
	end
end
if tagType == "weap" then
	if tagName ~= weapon then
		local x, y, z = getobjectcoords(m_objectId)
		movobjcoords(m_objectId, 0, 0, -100)
	end
end
end

function OnClientUpdate(player, m_objectId)
end


-- Written by Smiley

function getobjecttag(m_objId)

local m_object = getobject(m_objId)
local object_map_id = readdword(m_object, 0x0)

local map_pointer = 0x460678
local map_base = readdword(map_pointer, 0x0)
local map_tag_count = todec(endian(map_base, 0xC, 0x3))
local tag_table_base = map_base + 0x28
local tag_table_size = 0x20

for i = 0, (map_tag_count - 1) do
	local tag_id = todec(endian(tag_table_base, 0xC + (tag_table_size * i), 0x3))

	if tag_id == object_map_id then
		local tag_class = readstring(tag_table_base, (tag_table_size * i), 0x3, 1)
		local tag_name_address = endian(tag_table_base, 0x10 + (tag_table_size * i), 0x3)
		local tag_name = readtagname("0x" .. tag_name_address)

		return tag_class, tag_name
	end
end
end

function readstring(address, offset, length, endian)

local char_table = {}
local string = ""
for i=0,length do
	if readbyte(address, (offset + (0x1 * i))) ~= 0 then
		table.insert(char_table, string.char(readbyte(address, (offset + (0x1 * i)))))
	end
end
for k,v in pairs(char_table) do
	if endian == 1 then
		string = v .. string
	else
		string = string .. v
	end
end

return string
end

function readtagname(address)

local char_table = {}
local i = 0
local string = ""
while readbyte(address, (0x1 * i)) ~= 0 do
	table.insert(char_table, string.char(readbyte(address, (0x1 * i))))
	i = i + 1
end
for k,v in pairs(char_table) do
	string = string .. v
end

	return string
end

function endian(address, offset, length)

local data_table = {}
local data = ""
for i=0,length do
	local hex = string.format("%X", readbyte(address, offset + (0x1 * i)))
	if tonumber(hex, 16) < 16 then
		hex = 0 .. hex
	end
	table.insert(data_table, hex)
end
for k,v in pairs(data_table) do
	data = v .. data
end

	return data
end

function tohex(number)
	return string.format("%X", number)
end

function todec(number)
	return tonumber(number, 16)
end
