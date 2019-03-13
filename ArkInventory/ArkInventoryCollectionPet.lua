local _G = _G
local select = _G.select
local pairs = _G.pairs
local ipairs = _G.ipairs
local string = _G.string
local type = _G.type
local error = _G.error
local table = _G.table
local C_PetJournal = _G.C_PetJournal
local C_PetBattles = _G.C_PetBattles

local loc_id = ArkInventory.Const.Location.Pet
local BreedAvailable = IsAddOnLoaded( "BattlePetBreedID" )

ArkInventory.Collection.Pet = { }

local collection = {
	
	isScanning = false,
	isReady = false,
	
	numTotal = 0, -- number of total pets
	numOwned = 0, -- number of owned pets
	
	cache = { }, -- [guid] = { }
	species = { }, -- [speciesID] = { } - all pet types
	ability = { }, -- [abilityID] = { } - all pet types
	creature = { },	-- [creatureID] = speciesID
	
	filter = {
		ignore = false,
		search = nil,
		collected = true,
		uncollected = true,
		family = { },
		source = { },
		backup = false,
	},
	
}


local function FilterGetSearch( )
	return PetJournal.searchBox:GetText( )
end

local function FilterSetSearch( s )
	PetJournal.searchBox:SetText( s )
	C_PetJournal.SetSearchFilter( s )
end

local function FilterSetCollected( value )
	C_PetJournal.SetFilterChecked( LE_PET_JOURNAL_FILTER_COLLECTED, value )
end

local function FilterGetCollected( )
	return C_PetJournal.IsFilterChecked( LE_PET_JOURNAL_FILTER_COLLECTED )
end

local function FilterGetUncollected( )
	return C_PetJournal.IsFilterChecked( LE_PET_JOURNAL_FILTER_NOT_COLLECTED )
end

local function FilterSetUncollected( value )
	C_PetJournal.SetFilterChecked( LE_PET_JOURNAL_FILTER_NOT_COLLECTED, value )
end

local function FilterGetFamilyTypes( )
	return C_PetJournal.GetNumPetTypes( )
end

local function FilterSetFamily( t )
	if type( t ) == "table" then
		for i = 1, FilterGetFamilyTypes( ) do
			C_PetJournal.SetPetTypeFilter( i, t[i] )
		end
	elseif type( t ) == "boolean" then
		for i = 1, FilterGetFamilyTypes( ) do
			C_PetJournal.SetPetTypeFilter( i, t )
			
		end
	else
		assert( false, "parameter is " .. type( t ) .. ", not a table or boolean" )
	end
end

local function FilterGetFamily( t )
	assert( type( t ) == "table", "parameter is not a table" )
	for i = 1, FilterGetFamilyTypes( ) do
		t[i] = C_PetJournal.IsPetTypeChecked( i )
	end
end

local function FilterGetSourceTypes( )
	return C_PetJournal.GetNumPetSources( )
end

local function FilterGetSource( t )
	assert( type( t ) == "table", "parameter is not a table" )
	for i = 1, FilterGetSourceTypes( ) do
		t[i] = C_PetJournal.IsPetSourceChecked( i )
	end
end

local function FilterSetSource( t )
	if type( t ) == "table" then
		for i = 1, FilterGetSourceTypes( ) do
			C_PetJournal.SetPetSourceChecked( i, t[i] )
		end
	elseif type( t ) == "boolean" then
		for i = 1, FilterGetSourceTypes( ) do
			C_PetJournal.SetPetSourceChecked( i, t )
		end
	else
		assert( false, "parameter is not a table or boolean" )
	end
end

local function FilterActionClear( )
	
	collection.filter.ignore = true
	
	FilterSetSearch( "" )
	FilterSetCollected( true )
	FilterSetUncollected( true )
	FilterSetFamily( true )
	FilterSetSource( true )
	
end

local function FilterActionBackup( )
	
	if collection.filter.backup then return end
	
	collection.filter.search = FilterGetSearch( )
	collection.filter.collected = FilterGetCollected( )
	collection.filter.uncollected = FilterGetUncollected( )
	FilterGetFamily( collection.filter.family )
	FilterGetSource( collection.filter.source )
	
	collection.filter.backup = true
	
end

local function FilterActionRestore( )
	
	if not collection.filter.backup then return end
	
	collection.filter.ignore = true
	
	FilterSetSearch( collection.filter.search )
	FilterSetCollected( collection.filter.collected )
	FilterSetUncollected( collection.filter.uncollected )
	FilterSetFamily( collection.filter.family )
	FilterSetSource( collection.filter.source )
	
	collection.filter.backup = false
	
end


function ArkInventory.Collection.Pet.OnHide( )
	ArkInventory:SendMessage( "EVENT_ARKINV_COLLECTION_PET_UPDATE_BUCKET", "FRAME_CLOSED" )
end

function ArkInventory.Collection.Pet.IsReady( )
	return collection.isReady
end

function ArkInventory.Collection.Pet.GetCount( )
	return collection.numOwned, collection.numTotal
end

function ArkInventory.Collection.Pet.Iterate( )
	local t = collection.cache
	return ArkInventory.spairs( t, function( a, b ) return ( t[a].fullname or "" ) < ( t[b].fullname or "" ) end )
end

function ArkInventory.Collection.Pet.GetPet( arg1 )
	
	if type( arg1 ) == "number" then
		--ArkInventory.Output( "GetPet( index=", arg1, " ) " )
		for _, obj in ArkInventory.Collection.Pet.Iterate( ) do
			if obj.index == arg1 then
				return obj
			end
		end
		--ArkInventory.Output( "no pet found at index ", arg1 )
		return
	elseif type( arg1 ) == "string" then
		--ArkInventory.Output( "GetPet( guid=", arg1, " ) " )
		if collection.cache[arg1] then
			return collection.cache[arg1]
		else
			--ArkInventory.Output( "no pet found with guid ", arg1 )
		end
	end
	
end

function ArkInventory.Collection.Pet.CanSummon( arg1 )
	local obj = ArkInventory.Collection.Pet.GetPet( arg1 )
	if obj then
		return not C_PetJournal.PetIsRevoked( obj.guid ) and not C_PetJournal.PetIsLockedForConvert( obj.guid ) and C_PetJournal.PetIsSummonable( obj.guid )
	end
end

function ArkInventory.Collection.Pet.CanRelease( arg1 )
	local obj = ArkInventory.Collection.Pet.GetPet( arg1 )
	if obj then
		return C_PetJournal.PetCanBeReleased( obj.guid )
	end
end

function ArkInventory.Collection.Pet.CanTrade( arg1 )
	local obj = ArkInventory.Collection.Pet.GetPet( arg1 )
	if obj then
		return C_PetJournal.PetIsTradable( obj.guid )
	end
end

function ArkInventory.Collection.Pet.Summon( arg1 )
	local obj = ArkInventory.Collection.Pet.GetPet( arg1 )
	if obj then
		C_PetJournal.SummonPetByGUID( obj.guid )
	end
end

function ArkInventory.Collection.Pet.GetCurrent( )
	local guid = C_PetJournal.GetSummonedPetGUID( )
	if guid then
		local obj = ArkInventory.Collection.Pet.GetPet( guid )
		if obj then
			return obj.guid, guid, obj
		end
	end
end

function ArkInventory.Collection.Pet.Dismiss( )
	local guid = ArkInventory.Collection.Pet.GetCurrent( )
	if guid then
		C_PetJournal.SummonPetByGUID( guid )
	end
end

function ArkInventory.Collection.Pet.GetStats( arg1 )
	local obj = ArkInventory.Collection.Pet.GetPet( arg1 )
	if obj then
		return C_PetJournal.GetPetStats( obj.guid )
	end
end

function ArkInventory.Collection.Pet.PickupPet( arg1, arg2 )
	local obj = ArkInventory.Collection.Pet.GetPet( arg1 )
	if obj then
		return C_PetJournal.PickupPet( obj.guid, arg2 )
	end
end

function ArkInventory.Collection.Pet.IsRevoked( arg1 )
	local obj = ArkInventory.Collection.Pet.GetPet( arg1 )
	if obj then
		return C_PetJournal.PetIsRevoked( obj.guid )
	end
end

function ArkInventory.Collection.Pet.IsLockedForConvert( arg1 )
	local obj = ArkInventory.Collection.Pet.GetPet( arg1 )
	if obj then
		return C_PetJournal.PetIsLockedForConvert( obj.guid )
	end
end

function ArkInventory.Collection.Pet.IsFavorite( arg1 )
	local obj = ArkInventory.Collection.Pet.GetPet( arg1 )
	if obj then
		return C_PetJournal.PetIsFavorite( obj.guid )
	end
end

function ArkInventory.Collection.Pet.IsSlotted( arg1 )
	local obj = ArkInventory.Collection.Pet.GetPet( arg1 )
	if obj then
		return C_PetJournal.PetIsSlotted( obj.guid )
	end
end

function ArkInventory.Collection.Pet.IsHurt( arg1 )
	local obj = ArkInventory.Collection.Pet.GetPet( arg1 )
	if obj then
		return C_PetJournal.PetIsHurt( obj.guid )
	end
end

function ArkInventory.Collection.Pet.InBattle( )
	return C_PetBattles.IsInBattle( )
end

function ArkInventory.Collection.Pet.SetName( arg1, arg2 )
	local obj = ArkInventory.Collection.Pet.GetPet( arg1 )
	if obj then
		C_PetJournal.SetCustomName( obj.guid, arg2 )
	end
end

function ArkInventory.Collection.Pet.IsUnlocked( )
	return C_PetJournal.IsJournalUnlocked( )
end

function ArkInventory.Collection.Pet.SetFavorite( arg1, arg2 )
	-- arg2 = 0 (remove) | 1 (set)
	local obj = ArkInventory.Collection.Pet.GetPet( arg1 )
	if obj then
		C_PetJournal.SetFavorite( obj.guid, arg2 )
	end
end

function ArkInventory.Collection.Pet.IsUsable( arg1 )
	local obj = ArkInventory.Collection.Pet.GetPet( arg1 )
	if obj then
		return ( IsUsableSpell( obj.spell ) )
	end
end

function ArkInventory.Collection.Pet.GetSpeciesInfo( speciesID )
	return collection.species[speciesID]
end

function ArkInventory.Collection.Pet.GetSpeciesIDfromGUID( guid )
	
	-- breaks apart a guid to get the battlepet speciesid
	-- Creature-[unknown]-[serverID]-[instanceID]-[zoneUID]-[npcID]-[spawnUID]
	
	-- replaced with UnitBattlePetSpeciesID( unit )
	
	local creatureID = string.match( guid or "", "Creature%-.-%-.-%-.-%-.-%-(.-)%-.-$" )
	--ArkInventory.Output( creatureID, " / ", guid )
	if creatureID then
		creatureID = tonumber( creatureID ) or 0
		return ArkInventory.Collection.Pet.GetSpeciesIDForCreatureID( creatureID )
	end
	
end

function ArkInventory.Collection.Pet.GetSpeciesIDForCreatureID( creatureID )
	return collection.creature[creatureID]
end

function ArkInventory.Collection.Pet.PetTypeName( arg1 )
	return _G[string.format( "BATTLE_PET_NAME_%s", arg1 )] or ArkInventory.Localise["UNKNOWN"]
end


local PET_STRONG = { 2, 6, 9, 1, 4, 3, 10, 5, 7, 8 }
--[[
	HUMANOID vs DRAGONKIN
	DRAGONKIN vs MAGIC
	FLYING vs AQUATIC
	UNDEAD vs HUMANOID
	CRITTER vs UNDEAD
	MAGIC vs FLYING
	ELEMENTAL vs MECHANICAL
	BEAST vs CRITTER
	AQUATIC vs ELEMENTAL
	MECHANICAL vs BEAST
]]--

local PET_WEAK = { 8, 4, 2, 8, 1, 10, 5, 3, 6, 7 }
--[[
	HUMANOID vs BEAST
	DRAGONKIN vs UNDEAD
	FLYING vs DRAGONKIN
	UNDEAD vs AQUATIC
	CRITTER vs HUMANOID
	MAGIC vs MECHANICAL
	ELEMENTAL vs CRITTER
	BEAST vs FLYING
	AQUATIC vs MAGIC
	MECHANICAL vs ELEMENTAL
]]--

local function ScanAbility( abilityID )
	
	if ( not abilityID ) or ( type( abilityID ) ~= "number" ) or ( abilityID <= 0 ) then
		error( "invalid abilityID" )
		return
	end
	
	if not collection.ability[abilityID] then
		
		local id, name, icon, maxCooldown, unparsedDescription, numTurns, petType, noStrongWeakHints = C_PetBattles.GetAbilityInfoByID( abilityID )
		
		collection.ability[abilityID] = {
			name = name,
			icon = icon,
			petType = petType,
			noStrongWeakHints = noStrongWeakHints,
			strong = PET_STRONG[petType],
			weak = PET_WEAK[petType],
		}
		
	end
	
	return collection.ability[abilityID]
	
end

local function ScanSpecies( speciesID )
	
	assert( speciesID, "speciesID is nil" )
	assert( type( speciesID ) == "number", "speciesID not a number" )
	assert( speciesID > 0, "species ID <= 0 " )

--	if ( not speciesID ) or ( type( speciesID ) ~= "number" ) or ( speciesID <= 0 ) then
--		error( "invalid speciesID [", speciesID, "]" )
--		return
--	end
	
	if ( not collection.species[speciesID] ) then
		
		local name, icon, petType, creatureID, sourceText, description, isWild, canBattle, isTradable, unique = C_PetJournal.GetPetInfoBySpeciesID( speciesID )
		
--		if name and ( name ~= "" ) then
			
			collection.species[speciesID] = {
				speciesID = speciesID,
				name = name or ArkInventory.Localise["UNKNOWN"],
				icon = icon,
				petType = petType,
				strong = PET_STRONG[petType],
				weak = PET_WEAK[petType],
				creatureID = creatureID,
				sourceText = sourceText,
				description = description,
				isWild = isWild,
				canBattle = canBattle,
				isTradable = isTradable,
				unique = unique,
				abilityID = { },
				abilityLevel = { },
			}
			
			local _, maxAllowed = C_PetJournal.GetNumCollectedInfo( speciesID )
			collection.species[speciesID].maxAllowed = maxAllowed
			
			if canBattle then
				
				C_PetJournal.GetPetAbilityList( speciesID, collection.species[speciesID].abilityID, collection.species[speciesID].abilityLevel )
				--ArkInventory.Output( "id = ", collection.species[speciesID].abilityID )
				--ArkInventory.Output( "level = ", collection.species[speciesID].abilityLevel )
				
				for i, abilityID in ipairs( collection.species[speciesID].abilityID ) do
					ScanAbility( abilityID )
				end
				
			end
			
--		end
		
	end
	
	return collection.species[speciesID]
	
end

local function Scan_Threaded( thread_id )
	
	local update = false
	
	local numTotal = 0
	local numOwned = 0
	
	--ArkInventory.Output( "Pets: Start Scan @ ", time( ) )
	
	FilterActionBackup( )
	FilterActionClear( )
	
	
	-- flag all pets as not being processed this scan
	for _, obj in ArkInventory.Collection.Pet.Iterate( ) do
		obj.processed = false
	end
	
	-- scan the pet frame (now unfiltered)
	
	local c = collection.cache
	
	for index = 1, C_PetJournal.GetNumPets( ) do
		
		if PetJournal:IsVisible( ) then
			ArkInventory.Output( "ABORTED (PET JOURNAL WAS OPENED)" )
			FilterActionRestore( )
			return
		end
		
		numTotal = numTotal + 1
		
		local petID, speciesID, isOwned, customName, level, isFavorite, isRevoked, petName, petIcon, petType, creatureID, sourceText, description, isWild, canBattle, isTradable, isUnique, isObtainable = C_PetJournal.GetPetInfoByIndex( index )
		
		-- species data (generate for all species)
		local sd = ScanSpecies( speciesID )
		if not sd then
			FilterActionRestore( )
			ArkInventory:SendMessage( "EVENT_ARKINV_COLLECTION_PET_UPDATE_BUCKET", "NO_SPECIES_DATA" )
			return
		end
		
		-- creatureid to speciesid lookup (generate for all species)
		if not collection.creature[sd.creatureID] then
			collection.creature[sd.creatureID] = speciesID
			--ArkInventory.Output( sd.creatureID, " = ", speciesID )
		end
		
		
		if petID and isOwned then
			
			local speciesID, customName, level, xp, maxXp, displayID, isFavorite, petName, petIcon, petType, creatureID, sourceText, description, isWild, canBattle, isTradable, isUnique, isObtainable = C_PetJournal.GetPetInfoByPetID( petID )
			local needsFanfare = petID and C_PetJournal.PetNeedsFanfare( petID )
			local health, maxHealth, power, speed, rarity = C_PetJournal.GetPetStats( petID )
			rarity = rarity - 1 -- back down to item colour	
			local link = C_PetJournal.GetBattlePetLink( petID )
			--ArkInventory.Output( link )
			
			numOwned = numOwned + 1
			
			local i = petID
			
			if not c[i] then
				update = true
				c[i] = { index = index }
			end
			
			if c[i].guid ~= petID then
				
				update = true
				
				c[i].guid = petID
				c[i].sd = collection.species[speciesID] -- species data for this pet
				
				if BreedAvailable then
					c[i].breed = GetBreedID_Journal( petID )
				end
				
			end
			
			if c[i].cn ~= customName then
				update = true
				c[i].cn = customName
			end
			
			if c[i].fav ~= isFavorite then
				update = true
				c[i].fav = isFavorite
			end
			
			if c[i].isRevoked ~= isRevoked then
				update = true
				c[i].isRevoked = isRevoked
			end
			
			if customName and customName ~= "" then
				petName = string.format( "%s (%s)", petName, customName )
			end
			c[i].fullname = petName
			
			if c[i].needsFanfare ~= needsFanfare then
				update = true
				c[i].needsFanfare = needsFanfare
			end
			
			if c[i].level ~= level then
				update = true
				c[i].level = level
				c[i].maxXp = maxXp
				c[i].maxHealth = maxHealth
				c[i].power = power
				c[i].speed = speed
			end
			
			if c[i].xp ~= xp then
				update = true
				c[i].xp = xp
			end
			
			if c[i].health ~= health then
				update = true
				c[i].health = health
			end
			
			if c[i].rarity ~= rarity then
				update = true
				c[i].rarity = rarity
			end
			
			if c[i].link ~= link then
				update = true
				c[i].link = link
			end
			
			c[i].active = false
			c[i].processed = true
			
		end
		
	end
	
	
	-- cleanup any old pets that were released/caged
	for _, obj in ArkInventory.Collection.Pet.Iterate( ) do
		if not obj.processed then
			update = true
			c[obj.guid] = nil
		end
	end
		
		
	ArkInventory.ThreadYield_Scan( thread_id )
	
	FilterActionRestore( )
	
	collection.numOwned = numOwned
	collection.numTotal = numTotal
	
	--ArkInventory.Output( "Pets: End Scan @ ", time( ), " [", collection.numOwned, "] [", collection.numTotal, "]  [", update, "]" )
	
	collection.isReady = true
	
	if update then
		ArkInventory.ScanLocation( loc_id )
--		ArkInventory.LDB.Pets:Update( )
	end
	
	
end

local function Scan( )
	
	local thread_id = string.format( ArkInventory.Global.Thread.Format.Collection, "pet" )
	
	if not ArkInventory.Global.Thread.Use then
		local tz = debugprofilestop( )
		ArkInventory.OutputThread( thread_id, " start" )
		Scan_Threaded( )
		tz = debugprofilestop( ) - tz
		ArkInventory.OutputThread( string.format( "%s took %0.0fms", thread_id, tz ) )
		return
	end
	
	local tf = function ( )
		Scan_Threaded( thread_id )
	end
	
	ArkInventory.ThreadStart( thread_id, tf )
	
end


function ArkInventory:EVENT_ARKINV_COLLECTION_PET_UPDATE_BUCKET( events )
	
	--ArkInventory.Output( "PET BUCKET [", events, "]" )
	
	if not ArkInventory:IsEnabled( ) then return end
	
	if ArkInventory.Global.Mode.Combat then
		-- set to scan when leaving combat
		ArkInventory.Global.LeaveCombatRun[loc_id] = true
		return
	end
	
	if not ArkInventory.LocationIsMonitored( loc_id ) then
		--ArkInventory.Output( "IGNORED (PETS NOT MONITORED)" )
		return
	end
	
	if PetJournal:IsVisible( ) then
		--ArkInventory.Output( "IGNORED (PET JOURNAL IS OPEN)" )
		return
	end
	
	if not collection.isScanning then
		collection.isScanning = true
		Scan( )
		collection.isScanning = false
	else
		--ArkInventory.Output( "IGNORED (PET JOURNAL BEING SCANNED - WILL RESCAN WHEN DONE)" )
		ArkInventory:SendMessage( "EVENT_ARKINV_COLLECTION_PET_UPDATE_BUCKET", "RESCAN" )
	end
	
end

function ArkInventory:EVENT_ARKINV_COLLECTION_PET_UPDATE( event, ... )
	
	--ArkInventory.Output( "PET UPDATE [", event, "]" )
	
	if event == "PET_JOURNAL_LIST_UPDATE" then
		
		if collection.filter.ignore then
			--ArkInventory.Output( "IGNORED (FILTER CHANGED BY ME)" )
			collection.filter.ignore = false
			return
		end
		
		ArkInventory:SendMessage( "EVENT_ARKINV_COLLECTION_PET_UPDATE_BUCKET", event )
		
	elseif ( event == "COMPANION_UPDATE" ) then
		
		local c = ...
		if ( c == "CRITTER" ) then
			ArkInventory:SendMessage( "EVENT_ARKINV_COLLECTION_PET_UPDATE_BUCKET", event )
		end
		
	else
		
		ArkInventory:SendMessage( "EVENT_ARKINV_COLLECTION_PET_UPDATE_BUCKET", event )
		
	end
	
end

function ArkInventory:LISTEN_BATTLEPET_UPDATE( event )
	ArkInventory:EVENT_ARKINV_COLLECTION_PET_UPDATE( event )
end

function ArkInventory:EVENT_ARKINV_BATTLEPET_OPENING_DONE( event, ... )
	
	--ArkInventory.Output( "EVENT_ARKINV_BATTLEPET_OPENING_DONE" )
	-- /run ArkInventory:EVENT_ARKINV_BATTLEPET_OPENING_DONE( "MANUAL" )
	if not ArkInventory.db.option.message.battlepet.opponent then return end
	
	local player = 2
	local isnpc = C_PetBattles.IsPlayerNPC( player )
	local opponents = C_PetBattles.GetNumPets( player )
	
--	if opponents > 1 then
		ArkInventory.Output( "--- --- --- --- --- --- ---" )
--	end
	
	if not ArkInventory.Collection.Pet.IsReady( ) then
		ArkInventory.Output( "pet journal not ready" )
		return
	end
	
	for i = 1, opponents do
		
		local name = C_PetBattles.GetName( player, i )
		
		local speciesID = C_PetBattles.GetPetSpeciesID( player, i )
		local level = C_PetBattles.GetLevel( player, i )
		local fullHealth = C_PetBattles.GetMaxHealth( player, i )
		local power = C_PetBattles.GetPower( player, i )
		local speed = C_PetBattles.GetSpeed( player, i )
		local breed = ""
		
		if BreedAvailable then
			breed = string.format( " %s", GetBreedID_Battle( { ["petOwner"] = player, ["petIndex"] = i } ) )
		end
		
		local rarity = C_PetBattles.GetBreedQuality( player, i )
		rarity = ( rarity and ( rarity - 1 ) ) or -1
		
		local info = ""
		local count
		
		local sd = collection.species[speciesID] or ScanSpecies( speciesID )
		
		if not sd then
			
			ArkInventory.Output( YELLOW_FONT_COLOR_CODE, "#", i, ": ", name, " - ", RED_FONT_COLOR_CODE, ArkInventory.Localise["NO_DATA_AVAILABLE"] )
			
		else
			
			if C_PetBattles.IsWildBattle( ) then
				
				--ArkInventory.Output( "wild battle" )
				if not sd.canBattle then
					-- opponent cannot battle (and yet it is), its one of the secondary non-capturabe opponents
					info = string.format( "%s- %s", YELLOW_FONT_COLOR_CODE, ArkInventory.Localise["BATTLEPET_OPPONENT_IMMUNE"] )
				else
					count = true
				end
				
			elseif isnpc then
				
				--ArkInventory.Output( "trainer battle" )
				
			else
				
				--ArkInventory.Output( "pvp battle" )
				
				count = true
				
			end
			
			local h = string.format( "%s|Hbattlepet:%s:%s:%s:%s:%s:%s:%s|h[%s]|h|r", select( 5, ArkInventory.GetItemQualityColor( rarity ) ), speciesID, level, rarity, fullHealth, power, speed, "", name )
			
			if not count then
				
				-- dont do anything
				
			else
				
				local numOwned, maxAllowed = C_PetJournal.GetNumCollectedInfo( speciesID )
				
				if numOwned == 0 then
					
					info = string.format( "%s- %s", RED_FONT_COLOR_CODE, ArkInventory.Localise["NOT_COLLECTED"] )
					
					local h = string.format( "%sbattlepet:%s:%s:%s:%s:%s:%s:%s|h[%s]", select( 5, ArkInventory.GetItemQualityColor( rarity ) ), speciesID, level, rarity, fullHealth, power, speed, "", name )
					
				else
					
					if numOwned >= maxAllowed then
						
						info = string.format( "- %s", ArkInventory.Localise["BATTLEPET_OPPONENT_KNOWN_MAX"] )
						
					elseif C_PetBattles.IsWildBattle( ) then
						
						local upgrade = false
						
						for _, pd in ArkInventory.Collection.Pet.Iterate( ) do
							
							if ( pd.sd.speciesID == speciesID ) then
								
								local q = pd.rarity
								--ArkInventory.Output( "s=[", speciesID, "], ", h, ", [", rarity, "] / ", pd.link, " [", q, "]" )
								if ( rarity >= q ) then
									upgrade = true
								end
								
								if string.len( info ) < 2 then
									info = string.format( "- %s", ArkInventory.Localise["BATTLEPET_OPPONENT_UPGRADE"] )
								end
								
								info = string.format( "%s  %s", info, pd.link )
								
								if pd.breed then
									info = string.format( "%s %s", info, pd.breed )
								end
								
							end
							
						end
						
						if not upgrade then
							info = ""
						end
						
					end
					
				end
				
			end
		
			--ArkInventory.Output( YELLOW_FONT_COLOR_CODE, ArkInventory.Localise["BATTLEPET"], " #", i, ": ", h, " ", YELLOW_FONT_COLOR_CODE, info )
			ArkInventory.Output( YELLOW_FONT_COLOR_CODE, "#", i, ": ", h, breed, " ", YELLOW_FONT_COLOR_CODE, info )
		
		end
		
	end
	
end


-- unit guid, from mouseover = Creature-[unknown]-[serverID]-[instanceID]-[zoneUID]-[creatureID]-[spawnUID]
-- caged battletpet (item) = battlepet:
-- pet journal = battlepet:[speciesID]:16:3:922:185:185:[guid]

--[[

battlepet:1387:1:3:152:12:11:BattlePet-0-000006589760
battlepet:1387:1:3:155:12:10:0000000000000000
item:111660:0:0:0:0:0:0:0:90:0:11:0

]]--

