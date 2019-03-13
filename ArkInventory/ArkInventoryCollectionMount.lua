local _G = _G
local select = _G.select
local pairs = _G.pairs
local ipairs = _G.ipairs
local string = _G.string
local type = _G.type
local error = _G.error
local table = _G.table
local C_MountJournal = _G.C_MountJournal

local loc_id = ArkInventory.Const.Location.Mount
local PLAYER_MOUNT_LEVEL = 20

ArkInventory.Collection.Mount = { }

local collection = {
	
	isInit = false,
	isScanning = false,
	isReady = false,
	
	numTotal = 0,
	numOwned = 0,
	
	cache = { },
	owned = { }, -- [mta] = { } array of all mounts of that type that you own, updated here when scanned
	usable = { }, -- [mta] = { } array of all mounts of that type that you can use at the location you called it, updated via LDB
	
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


-- the UI filters have no impact on the mount source so we can safely ignore them

function ArkInventory.Collection.Mount.OnHide( )
	ArkInventory:SendMessage( "EVENT_ARKINV_COLLECTION_MOUNT_UPDATE_BUCKET", "FRAME_HIDE" )
end

function ArkInventory.Collection.Mount.IsReady( )
	return collection.isReady
end

function ArkInventory.Collection.Mount.GetCount( mta )
	if mta then
		return ArkInventory.Table.Elements( collection.usable[mta] ), ArkInventory.Table.Elements( collection.owned[mta] )
	else
		return collection.numOwned, collection.numTotal
	end
end

function ArkInventory.Collection.Mount.GetMount( index )
	if type( index ) == "number" then
		return collection.cache[index]
	end
end

function ArkInventory.Collection.Mount.GetUsable( mta )
	if mta then
		return collection.usable[mta]
	end
end

function ArkInventory.Collection.Mount.GetMountBySpell( spellID )
	for _, v in pairs( collection.cache ) do
		if v.spellID == spellID then
			return v
		end
	end
end

function ArkInventory.Collection.Mount.IterateAll( )
	local t = collection.cache
	return ArkInventory.spairs( t, function( a, b ) return ( t[a].name or "" ) < ( t[b].name or "" ) end )
end

function ArkInventory.Collection.Mount.Iterate( mta )
	local t = collection.owned
	if mta and t[mta] then
		return ArkInventory.spairs( t[mta], function( a, b ) return ( t[mta][a].name or "" ) < ( t[mta][b].name or "" ) end )
	end
end

function ArkInventory.Collection.Mount.Dismiss( )
	C_MountJournal.Dismiss( )
end

function ArkInventory.Collection.Mount.Summon( id )
	local obj = ArkInventory.Collection.Mount.GetMount( id )
	if obj then
		C_MountJournal.SummonByID( obj.index )
	end
end

function ArkInventory.Collection.Mount.GetFavorite( id )
	local obj = ArkInventory.Collection.Mount.GetMount( id )
	if obj then
		return C_MountJournal.GetIsFavorite( obj.index )
	end
end

function ArkInventory.Collection.Mount.SetFavorite( id, value )
	-- value = true|false
	local obj = ArkInventory.Collection.Mount.GetMount( id )
	--ArkInventory.Output( id, " / ", value, " (", type(value), ") / ", obj )
	if obj then
		C_MountJournal.SetIsFavorite( obj.index, value )
	end
end

function ArkInventory.Collection.Mount.IsUsable( id )
	
	local md = ArkInventory.Collection.Mount.GetMount( id )
	if md then
		local mu = select( 5, C_MountJournal.GetMountInfoByID( id ) ) -- is not always correct
		return IsOutdoors( ) and mu and ( IsUsableSpell( md.spellID ) ) -- so check outdoors, mount, and spell
	end
	
end

function ArkInventory.Collection.Mount.SkillLevel( )
	
	local skill = 1 -- the chauffer and sea tutle mounts can be ridden by anyone reagrdless of riding skill
	
	if UnitLevel( "player" ) >= PLAYER_MOUNT_LEVEL then
		
		if IsSpellKnown( 90265 ) then
			-- master
			-- level 80
			-- 310% flying
			-- 100% ground
			skill = 310
		elseif IsSpellKnown( 34091 ) then
			-- artisan
			-- level 70
			-- 280% flying
			-- 100% ground
			skill = 300
		elseif IsSpellKnown( 34090 ) then
			-- expert
			-- level 60
			-- 150% flying
			-- 100% ground
			skill = 225
		elseif IsSpellKnown( 33391 ) then
			-- journeyman
			-- level 40
			-- 100% ground
			skill = 150
		elseif IsSpellKnown( 33388 ) then
			-- apprentice
			-- level 20
			-- 60% ground
			skill = 75
		end
		
	end
	
	return skill
	
end

function ArkInventory.Collection.Mount.UpdateOwned( )
	
	for mta, mt in pairs( ArkInventory.Const.MountTypes ) do
		if not collection.owned[mta] then
			collection.owned[mta] = { }
		else
			wipe( collection.owned[mta] )
		end
	end
	
	for _, md in ArkInventory.Collection.Mount.IterateAll( ) do
		if md.owned then
			collection.owned[md.mta][md.index] = md
		end
	end
	
end

function ArkInventory.Collection.Mount.UpdateUsable( )
	
	for mta in pairs( ArkInventory.Const.MountTypes ) do
		if not collection.usable[mta] then
			collection.usable[mta] = { }
		else
			wipe( collection.usable[mta] )
		end
	end
	
	if not ArkInventory.Collection.Mount.IsReady( ) then return end
	
	local n = ArkInventory.Collection.Mount.GetCount( )
	if n == 0 then return end
	
	local me = ArkInventory.GetPlayerCodex( )
	
	for mta, mt in pairs( ArkInventory.Const.MountTypes ) do
		
		for _, md in ArkInventory.Collection.Mount.Iterate( mta ) do
			
			local usable = true
			
			if me.player.data.ldb.mounts.type[mta].selected[md.spellID] == false then
				usable = false
			elseif not me.player.data.ldb.mounts.type[mta].useall then
				usable = me.player.data.ldb.mounts.type[mta].selected[md.spellID]
			end
			
			if usable then
				usable = ArkInventory.Collection.Mount.IsUsable( md.index )
			end
			
			if usable then
				collection.usable[mta][md.index] = md
			end
			
		end
		
		--ArkInventory.Output( "usable ", mta, " = ", collection.usable[mta] )
		
	end
	
end

function ArkInventory.Collection.Mount.ApplyUserCorrections( )
	
	-- apply user corrections (these are global settings so the mount may not exist for this character)
	
	for _, md in ArkInventory.Collection.Mount.IterateAll( ) do
		
		local correction = ArkInventory.db.option.mount.correction[md.spellID]
		
		if correction ~= nil then -- check for nil as we use both true and false
			if correction == md.mto then
				-- code has been updated, clear correction
				--ArkInventory.Output( "clearing mount correction ", md.spellID, ": system=", md.mt, ", correction=", correction )
				ArkInventory.db.option.mount.correction[md.spellID] = nil
				md.mt = md.mto
			else
				-- apply correction
				--ArkInventory.Output( "correcting mount ", md.spellID, ": system=", md.mt, ", correction=", correction )
				md.mt = correction
				
				for mta, mt in pairs( ArkInventory.Const.MountTypes ) do
					if md.mt == mt then
						md.mta = mta
						break
					end
				end
				
			end
		end
		
	end
	
	ArkInventory.Collection.Mount.UpdateOwned( )
	
end


local function ScanInit( )
	
	collection.isInit = true
	
end

local function Scan_Threaded( thread_id )
	
	local update = false
	
	local numTotal = 0
	local numOwned = 0
	
	--ArkInventory.Output( "Mount: Start Scan @ ", time( ) )
	
	if not collection.isInit then
		ScanInit( )
		ArkInventory.ThreadYield_Scan( thread_id )
	end
	
	if not collection.isInit then
		-- recheck later
		return
	end
	
	local c = collection.cache
	
	local data_source = C_MountJournal.GetMountIDs( )
	
	for _, index in pairs( data_source ) do
		
		numTotal = numTotal + 1
		
		local name, spellID, icon, isActive, isUsable, source, isFavorite, isFactionSpecific, faction, shouldHideOnChar, isCollected, mountID = C_MountJournal.GetMountInfoByID( index )
		local creatureDisplayInfoID, description, source2, isSelfMount, mountTypeID, uiModelSceneID = C_MountJournal.GetMountInfoExtraByID( index )
--		local isFavorite, canSetFavorite = C_MountJournal.GetIsFavorite( i )
		
		local i = mountID
		
		local isOwned = isCollected and not shouldHideOnChar
		
		if isFactionSpecific and not shouldHideOnChar then
			-- faction is either 0 = horde / 1 = alliance
			-- cater for races who are neutral until they choose a faction
			local f0 = -1
			local f1, f2 = UnitFactionGroup( "player" )
			f2 = f2 or FACTION_OTHER
			if f2 == FACTION_HORDE then
				f0 = 0
			elseif f2 == FACTION_ALLIANCE then
				f0 = 1
			end
			if faction ~= f0 then
				shouldHideOnChar = true
				isOwned = false
			end
		end
		
		if not c[i] then
			update = true
			c[i] = { index = index }
		end
		
		if c[i].name ~= name or c[i].index ~= index or c[i].spellID ~= spellID then
			
			update = true
			
			c[i].name = name
			c[i].spellID = spellID
			c[i].icon = icon
			c[i].source = source
			c[i].isFactionSpecific = isFactionSpecific
			c[i].faction = faction
			c[i].creatureDisplayInfoID = creatureDisplayInfoID
			c[i].description = description
			c[i].isSelfMount = isSelfMount
			c[i].mountTypeID = mountTypeID
			c[i].uiModelSceneID = uiModelSceneID
			
			c[i].link = GetSpellLink( spellID )
			
			local mta = "x"
			if mountTypeID == 230 or mountTypeID == 241 or mountTypeID == 284 then
				-- land
				mta = "l"
			elseif mountTypeID == 248 or mountTypeID == 247 or mountTypeID == 242 then
				-- flying
				mta = "a"
			elseif mountTypeID == 231 or mountTypeID == 232 or mountTypeID == 254 then
				--underwater
				mta = "u"
			elseif mountTypeID == 269 then
				-- surface
				mta = "s"
			end
			
			c[i].mta = mta
			c[i].mt = ArkInventory.Const.MountTypes[mta]
			c[i].mto = c[i].mt -- save original mount type (user corrections can override the other value)
			
		end
		
		if c[i].isCollected ~= isCollected then
			update = true
			c[i].isCollected = isCollected
		end
		
		if c[i].isActive ~= isActive then
			update = true
			c[i].isActive = isActive
		end
		
		if c[i].isUsable ~= isUsable then
			update = true
			c[i].isUsable = isUsable
		end
		
		if c[i].isFavorite ~= isFavorite then
			update = true
			c[i].isFavorite = isFavorite
		end
		
		if isOwned then
			numOwned = numOwned + 1
		end
		
		if c[i].owned ~= isOwned then
			update = true
			c[i].owned = isOwned
		end
		
	end
	
	ArkInventory.ThreadYield_Scan( thread_id )
	
	collection.numOwned = numOwned
	collection.numTotal = numTotal
	
	ArkInventory.Collection.Mount.ApplyUserCorrections( )
	
	--ArkInventory.Output( "Mount: End Scan @ ", time( ), " [", collection.numOwned, "] [", collection.numTotal, "] [", update, "]" )
	
	collection.isReady = true
	
	if update then
		ArkInventory.ScanLocation( loc_id )
--		ArkInventory.LDB.Mounts:Update( )
	end
	
end

local function Scan( )
	
	local thread_id = string.format( ArkInventory.Global.Thread.Format.Collection, "mount" )
	
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


function ArkInventory:EVENT_ARKINV_COLLECTION_MOUNT_UPDATE_BUCKET( events )
	
	--ArkInventory.Output( "MOUNT BUCKET [", events, "]" )
	
	if not ArkInventory:IsEnabled( ) then return end
	
	if ArkInventory.Global.Mode.Combat then
		-- set to scan when leaving combat
		ArkInventory.Global.LeaveCombatRun[loc_id] = true
		return
	end
	
	if not ArkInventory.LocationIsMonitored( loc_id ) then
		--ArkInventory.Output( "IGNORED (MOUNTS NOT MONITORED)" )
		return
	end
	
	if MountJournal:IsVisible( ) then
		--ArkInventory.Output( "ABORTED (MOUNT JOURNAL IS OPEN)" )
		return
	end
	
	if not collection.isScanning then
		collection.isScanning = true
		Scan( )
		collection.isScanning = false
	else
		--ArkInventory.Output( "IGNORED (MOUNT JOURNAL BEING SCANNED - WILL RESCAN WHEN DONE)" )
		ArkInventory:SendMessage( "EVENT_ARKINV_COLLECTION_MOUNT_UPDATE_BUCKET", "RESCAN" )
	end
	
end

function ArkInventory:EVENT_ARKINV_COLLECTION_COMPANION_UPDATE( event, ctype )
	
	--ArkInventory.Output( "MOUNT UPDATE [ ", event, " | ", ct, " | ", arg2, " ]" )
	
	if ctype == "MOUNT" then
		ArkInventory:SendMessage( "EVENT_ARKINV_COLLECTION_MOUNT_UPDATE_BUCKET", event )
	elseif ctype == "PET" then
		ArkInventory:SendMessage( "EVENT_ARKINV_COLLECTION_PET_UPDATE_BUCKET", event )
	end
	
end
