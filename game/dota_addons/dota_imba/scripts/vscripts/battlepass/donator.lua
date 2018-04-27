function DonatorStatue(ID, statue_info)
	if IMBA_DONATOR_STATUE[tostring(PlayerResource:GetSteamID(ID))] then 
		statue_info = IMBA_DONATOR_STATUE[tostring(PlayerResource:GetSteamID(ID))]
	end

	print(ID)
	PrintTable(statue_info)

	local hero = PlayerResource:GetSelectedHeroEntity(ID)
--	if hero.donator_statue then
--		hero.donator_statue:ForceKill(false)

--		local unit = CreateUnitByName(statue_info[2], abs, true, nil, nil, PlayerResource:GetPlayer(ID):GetTeam())
--		unit:SetModelScale(statue_info[1])
--		unit:SetAbsOrigin(abs + Vector(0, 0, 17))
--		unit:AddNewModifier(unit, nil, "modifier_imba_contributor_statue", {})
--		hero.donator_statue = unit

--		return
--	end

	local team = "good"
	local fillers = {
		team.."_filler_2",
		team.."_filler_4",
		team.."_filler_6",
		team.."_filler_7",
	}

	if PlayerResource:GetPlayer(ID):GetTeam() == 3 then
		team = "bad"
	end

	for _, ent_name in pairs(fillers) do
		local filler = Entities:FindByName(nil, ent_name)
		if filler then
			local abs = filler:GetAbsOrigin()

			filler:RemoveSelf()

--			print(statue_info)
--			print(statue_info[1])
--			print(statue_info[2])

			local unit = CreateUnitByName(statue_info[2], abs, true, nil, nil, PlayerResource:GetPlayer(ID):GetTeam())
			unit:SetModelScale(statue_info[1])
			unit:SetAbsOrigin(abs + Vector(0, 0, 45))
			unit:AddNewModifier(unit, nil, "modifier_imba_donator_statue", {})
			unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
			hero.donator_statue = unit

			local steam_id = tostring(PlayerResource:GetSteamID(hero:GetPlayerID()))
			local name = PlayerResource:GetPlayerName(ID)

			if api.imba.is_donator(steam_id) == 1 then
				unit:SetCustomHealthLabel(name, 160, 20, 20)
--			elseif api.imba.is_donator(steam_id) == 2 then
--				unit:SetCustomHealthLabel("Baumi", 160, 20, 20)
			elseif api.imba.is_donator(steam_id) == 3 then
				unit:SetCustomHealthLabel(name, 160, 20, 20)
			elseif api.imba.is_donator(steam_id) == 4 then
				unit:SetCustomHealthLabel(name, 240, 50, 50)
			elseif api.imba.is_donator(steam_id) == 5 then
				unit:SetCustomHealthLabel(name, 218, 165, 32)
			elseif api.imba.is_donator(steam_id) == 7 then
				unit:SetCustomHealthLabel(name, 47, 91, 151)
			elseif api.imba.is_donator(steam_id) == 8 then
				unit:SetCustomHealthLabel(name, 153, 51, 153)
			elseif api.imba.is_donator(steam_id) then
				unit:SetCustomHealthLabel(name, 45, 200, 45)
			end

			if statue_info[2] == "npc_imba_donator_statue_suthernfriend" then
				unit:SetMaterialGroup("1")
			end

			local pedestal = CreateUnitByName("npc_imba_donator_statue", abs, true, nil, nil, PlayerResource:GetPlayer(ID):GetTeam())
			pedestal:AddNewModifier(pedestal, nil, "modifier_imba_contributor_statue", {})
--			pedestal:SetModelScale(statue_info[1])
			pedestal:SetAbsOrigin(abs + Vector(0, 0, 45))
			unit.pedestal = pedestal

			return
		end
	end
end

function DonatorCompanion(ID, unit_name)
if unit_name == nil then return end
local hero = PlayerResource:GetPlayer(ID):GetAssignedHero()
local color = hero:GetFittingColor()
local model = GetKeyValueByHeroName(unit_name, "Model")
local model_scale = GetKeyValueByHeroName(unit_name, "ModelScale")

	if hero.companion then
		hero.companion:ForceKill(false)
	end

	local companion = CreateUnitByName("npc_imba_donator_companion", hero:GetAbsOrigin() + RandomVector(200), true, hero, hero, hero:GetTeamNumber())
	companion:SetModel(model)
	companion:SetOriginalModel(model)
	companion:SetOwner(hero)
	companion:SetControllableByPlayer(hero:GetPlayerID(), true)

	companion:AddNewModifier(companion, nil, "modifier_companion", {})

	hero.companion = companion

	if model == "models/courier/baby_rosh/babyroshan.vmdl" then
		local particle_name = {}
		particle_name[0] = "particles/econ/courier/courier_donkey_ti7/courier_donkey_ti7_ambient.vpcf"
		particle_name[1] = "particles/econ/courier/courier_golden_roshan/golden_roshan_ambient.vpcf"
		particle_name[2] = "particles/econ/courier/courier_platinum_roshan/platinum_roshan_ambient.vpcf"
		particle_name[3] = "particles/econ/courier/courier_roshan_darkmoon/courier_roshan_darkmoon.vpcf" -- particles/econ/courier/courier_roshan_darkmoon/courier_roshan_darkmoon_flying.vpcf
		particle_name[4] = "particles/econ/courier/courier_roshan_desert_sands/baby_roshan_desert_sands_ambient.vpcf"
		particle_name[5] = "particles/econ/courier/courier_roshan_lava/courier_roshan_lava.vpcf"
		particle_name[6] = "particles/econ/courier/courier_roshan_frost/courier_roshan_frost_ambient.vpcf"
		-- also attach eyes effect later
		local random_int = RandomInt(0, #particle_name)

		local particle = ParticleManager:CreateParticle(particle_name[random_int], PATTACH_ABSORIGIN_FOLLOW, companion)
		if random_int <= 4 then
			companion:SetMaterialGroup(tostring(random_int))
		else
			companion:SetModel("models/courier/baby_rosh/babyroshan_elemental.vmdl")
			companion:SetOriginalModel("models/courier/baby_rosh/babyroshan_elemental.vmdl")
			companion:SetMaterialGroup(tostring(random_int-4))
		end
	elseif unit_name == "npc_imba_donator_companion_suthernfriend" then
		companion:SetMaterialGroup("1")
	elseif model == "models/items/courier/devourling/devourling.vmdl" then
		local particle = ParticleManager:CreateParticle("particles/econ/courier/courier_devourling/courier_devourling_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, companion)
		ParticleManager:ReleaseParticleIndex(particle)
	elseif unit_name == "npc_imba_donator_companion_baekho" then
		local particle = ParticleManager:CreateParticle("particles/econ/courier/courier_baekho/courier_baekho_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, companion)
		ParticleManager:ReleaseParticleIndex(particle)
	end

	companion:SetModelScale(model_scale)

	if string.find(model, "flying") then
		companion:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
	end

--	if super_donator then
--		local ab = companion:FindAbilityByName("companion_morph")
--		ab:SetLevel(1)
--		ab:CastAbility()		
--	end
end