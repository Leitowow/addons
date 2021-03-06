
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Skycap'n Kragg", 1754, 2102)
if not mod then return end
mod:RegisterEnableMob(126832)
mod.engageId = 2093
mod.respawnTime = 25

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		255952, -- Charrrrrge
		272046, -- Dive Bomb
		256106, -- Azerite Powder Shot
		256060, -- Revitalizing Brew
		256016, -- Vile Coating
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	-- Stage 1
	self:Log("SPELL_CAST_START", "Charrrrrge", 255952)

	-- Stage 2
	self:Log("SPELL_CAST_START", "DiveBomb", 272046)
	self:Log("SPELL_CAST_START", "AzeritePowderShot", 256106)
	self:Log("SPELL_CAST_SUCCESS", "RevitalizingBrew", 256060)
	self:Log("SPELL_AURA_APPLIED", "VileCoatingDamage", 256016)
	self:Log("SPELL_PERIODIC_DAMAGE", "VileCoatingDamage", 256016)
	self:Log("SPELL_PERIODIC_MISSED", "VileCoatingDamage", 256016)
end

function mod:OnEngage()
	self:CDBar(255952, 4.8) -- Charrrrrge
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 256056 then -- Spawn Parrot
		self:StopBar(255952) -- Charrrrrge
		self:Message2("stages", "cyan", CL.stage:format(2), false)
		self:PlaySound("stages", "long", "stage2")

		self:CDBar(256106, 7) -- Azerite Powder Shot
	end
end

function mod:Charrrrrge(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert", "watchstep")
	self:CDBar(args.spellId, 8.5)
end

function mod:DiveBomb(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	self:CDBar(args.spellId, 15.5) -- ranges from 12-18
end

function mod:AzeritePowderShot(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 11)
end

function mod:RevitalizingBrew(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning", "interrupt")
end

do
	local prev = 0
	function mod:VileCoatingDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 1.5 then
				prev = t
				self:PersonalMessage(args.spellId, "underyou")
				self:PlaySound(args.spellId, "alarm", "gtfo")
			end
		end
	end
end
