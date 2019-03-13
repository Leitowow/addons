local _G = _G
local select = _G.select
local pairs = _G.pairs
local ipairs = _G.ipairs
local string = _G.string
local type = _G.type
local error = _G.error
local table = _G.table
local C_Reputation = _G.C_Reputation

local loc_id = ArkInventory.Const.Location.Reputation

ArkInventory.Collection.Reputation = { }

local collection = {
	
	isInit = false,
	isScanning = false,
	isReady = false,
	
	numTotal = 0, -- number of total reputations
	numOwned = 0, -- number of known reputations
	
	list = { }, -- [index] = { } - reputations and headers in order from the blizard frame
	cache = { }, -- [id] -- all reputations
	
	filter = {
		ignore = false,
		expanded = { },
		backup = false,
	},
	
}


local function FilterActionBackup( )
	
	if collection.filter.backup then return end
	
	local n, e, c
	local p = 0
	table.wipe( collection.filter.expanded )
	
	repeat
		
		p = p + 1
		n = GetNumFactions( )
		--ArkInventory.Output( "pass=", p, " num=", n )
		e = true
		
		for index = 1, n do
			
			local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus = GetFactionInfo( index )
			
			if isHeader and isCollapsed then
				collection.filter.ignore = true
				--ArkInventory.Output( "expanding ", index )
				collection.filter.expanded[index] = true
				ExpandFactionHeader( index )
				e = false
				break
			end
			
		end
		
	until e or p > n * 1.5
	
	collection.filter.backup = true
	
end

local function FilterActionRestore( )
	
	if not collection.filter.backup then return end
	
	local n = GetNumFactions( )
	
	for index = n, 1, -1 do
		if collection.filter.expanded[index] then
			collection.filter.ignore = true
			--ArkInventory.Output( "collapsing ", index )
			CollapseFactionHeader( index )
		end
	end
	
	collection.filter.backup = false
	
end


function ArkInventory.Collection.Reputation.OnHide( )
	ArkInventory:SendMessage( "EVENT_ARKINV_COLLECTION_REPUTATION_UPDATE_BUCKET", "FRAME_CLOSED" )
end

function ArkInventory.Collection.Reputation.IsReady( )
	return collection.isReady
end

function ArkInventory.Collection.Reputation.GetCount( )
	return collection.numOwned, collection.numTotal
end

function ArkInventory.Collection.Reputation.Iterate( )
	local t = collection.cache
	return ArkInventory.spairs( t, function( a, b ) return ( t[a].name or "" ) < ( t[b].name or "" ) end )
end

function ArkInventory.Collection.Reputation.IterateList( )
	local t = collection.list
	return ArkInventory.spairs( t, function( a, b ) return ( t[a].index or 0 ) < ( t[b].index or 0 ) end )
end

function ArkInventory.Collection.Reputation.GetReputation( id )
	if type( id ) == "number" then
		return collection.cache[id]
	end
end

function ArkInventory.Collection.Reputation.GetReputationList( index )
	if type( index ) == "number" then
		return collection.list[index]
	end
end

function ArkInventory.Collection.Reputation.LevelText( ... )
	
	local id, style, standingText, barValue, barMax, isCapped, paragonLevel, hasReward = ...
	
	local n = select( '#', ... )
	
	if n == 0 then return end
	
--[[
	*nn* = faction name
	*st* = standing text
	*pv* = paragon value (+N)
	*pr* = paragon reward icon
	*bv* = bar value
	*bm* = bar max
	*bc* = bar value / bar max
	*bp* = bar percent
	*br* = bar remaining
]]--
	
	local info = ArkInventory.Collection.Reputation.GetReputation( id )
	
	local name = info.name or ArkInventory.Localise["UNKNOWN"]
	local barRemaining = 0
	--local rewardIcon = string.format( "|T%s:0|t", [[Interface\MINIMAP\TRACKING\Banker]] )
	local rewardIcon = string.format( "|T%s:0|t", [[Interface\ICONS\INV_Misc_Coin_01]] )
	
	local result = string.lower( style or ArkInventory.Const.Reputation.Style.OneLine )
	
	
	if n <= 2 then
		
		standingText = info.standingText
		barMax = info.barMax
		barValue = info.barValue
		
		isCapped = info.isCapped
		paragonLevel = info.paragonLevel
		hasReward = info.hasReward
		
	end
	
	
	standingText = standingText or ArkInventory.Localise["UNKNOWN"]
	barMax = barMax or 0
	barValue = barValue or 0
	
	isCapped = isCapped or 0
	paragonLevel = paragonLevel or 0
	hasReward = hasReward or 0
	
	
	if barValue == 0 then
		
		-- hit rep limit so clear all tokens
		result = string.gsub( result, "%*bv%*", "" )
		result = string.gsub( result, "%*bm%*", "" )
		result = string.gsub( result, "%*bc%*", "" )
		result = string.gsub( result, "%*bp%*", "" )
		result = string.gsub( result, "%*br%*", "" )
		
	else
		
		result = string.gsub( result, "%*bv%*", FormatLargeNumber( barValue ) )
		result = string.gsub( result, "%*bm%*", FormatLargeNumber( barMax ) )
		result = string.gsub( result, "%*bc%*", string.format( "%s / %s", FormatLargeNumber( barValue ), FormatLargeNumber( barMax ) ) )
		result = string.gsub( result, "%*bp%*", string.format( "%.2f", barValue / barMax * 100 ) .. "%%" )
		result = string.gsub( result, "%*br%*", FormatLargeNumber( barMax - barValue ) )
		
	end
	
	if isCapped == 1 then
		
		if paragonLevel > 0 then
			
			paragonLevel = paragonLevel - 1
			
			if paragonLevel == 0 then
				result = string.gsub( result, "%*pv%*", "" )
			else
				result = string.gsub( result, "%*pv%*", "+" .. FormatLargeNumber( paragonLevel ) )
			end
			
			if hasReward == 1 then
				result = string.gsub( result, "%*pr%*", rewardIcon )
			else
				result = string.gsub( result, "%*pr%*", "" )
			end
			
		else
			
			result = string.gsub( result, "%*pv%*", "" )
			result = string.gsub( result, "%*pr%*", "" )
			
		end
			
	else
		
		result = string.gsub( result, "%*pv%*", "" )
		result = string.gsub( result, "%*pr%*", "" )
		
	end
	
	result = string.gsub( result, "%*nn%*", name )
	result = string.gsub( result, "%*st%*", standingText )
	
	result = string.gsub( result, "%(%s*%)", "" )
	result = string.gsub( result, "\n$", "" )
	result = string.gsub( result, "|n$", "" )
	result = string.gsub( result, "  ", " " )
	result = string.trim( result )
	
	return result
	
end

local function ScanBase( id )
	
	if not id or type( id ) ~= "number" then
		return
	end
	
	local c = collection.cache
	
	local name, description, standingID, barMin, barMax, repValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus = GetFactionInfoByID( id )
	
	if name and name ~= "" then
		
		if not c[id] then
			
			c[id] = {
				
				id = id,
				
				name = name,
				description = description,
				canToggleAtWar = canToggleAtWar,
				isHeader = isHeader,
				hasRep = hasRep,
				isChild = isChild,
				hasBonusRepGain = hasBonusRepGain,
				canBeLFGBonus = canBeLFGBonus,
				
				link = string.format( "reputation:%s", id ),
				
			}
			
			collection.numTotal = collection.numTotal + 1
			
		end
			
	end
	
end

local function ScanInit( )
	
	--ArkInventory.Output( "Reputation Init: Start Scan @ ", time( ) )
	
	for id = 1, 5000 do
		ScanBase( id )
	end
	
	if collection.numTotal > 0 then
		collection.isInit = true
	end
	
	--ArkInventory.Output( "Reputation Init: End Scan @ ", time( ), " [", collection.numTotal, "]" )
	
end

local function Scan_Threaded( thread_id )
	
	local update = false
	
	local numOwned = 0
	
	--ArkInventory.Output( "Reputation: Start Scan @ ", time( ) )
	
	if not collection.isInit then
		ScanInit( )
		ArkInventory.ThreadYield_Scan( thread_id )
	end
	
	FilterActionBackup( )
	
	-- scan the reuptation frame (now fully expanded) for known factions
	
	table.wipe( collection.list )
	local c = collection.cache
	local active = true
	
	for index = 1, GetNumFactions( ) do
		
		if ReputationFrame:IsVisible( ) then
			--ArkInventory.Output( "ABORTED (REPUTATION FRAME WAS OPENED)" )
			FilterActionRestore( )
			return
		end
		
		local name, description, standingID, barMin, barMax, repValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus = GetFactionInfo( index )
		
		if isHeader and name == FACTION_INACTIVE then
			active = false
		end
		
		if factionID and name and name ~= "" then
			
			local i = factionID
			
			if not c[i] then
				ScanBase( i )
			end
			
			local owned = true
			if isHeader and not hasRep then
				owned = false
			end
			
			c[i].owned = owned
			c[i].index = index
			
			numOwned = numOwned + 1
			
			local icon
			local barValue = 0
			local standingMax = 0
			local standingText = ""
			local isCapped = 0
			local paragonLevel = 0
			local hasParagonReward = 0
			
			local friendID, friendRep, friendMaxRep, friendName, friendText, friendTexture, friendTextLevel, friendBarMin, friendBarMax = GetFriendshipReputation( i )
			if friendID then
				
				c[i].friendID = friendID
				
				local currentFriendRank, maxFriendRank = GetFriendshipReputationRanks( friendID )
				
				icon = friendTexture
				standingID = currentFriendRank
				standingMax = maxFriendRank
				standingText = friendTextLevel
				repValue = friendRep
				
				if friendBarMax then
					barMin = friendBarMin
					barMax = friendBarMax
				else
					barMin = repValue
					barMax = repValue
				end
				
			else
				
				standingMax = MAX_REPUTATION_REACTION
				standingText = _G["FACTION_STANDING_LABEL" .. standingID] or ArkInventory.Localise["UNKNOWN"]
				
			end
			
			if standingID == standingMax then
				if false then -- fix me
					-- dont care if youre 1/1000 or 1000/1000 in the last rank
					-- its really only important for the paragon reps as you have to get to the end to start the paragon stage (unless thats changed)
					isCapped = 1
				else
					if repValue == barMax and barMax == barMin then
						isCapped = 1
					end
				end
			end
			
			local isParagon = C_Reputation.IsFactionParagon( i )
			if isParagon then
				
				-- reputation level stops at exalted 42,000 - paragon values take over from there
				
				-- highmountain
				-- /dump GetFactionInfoByID( 1828 )
				-- /dump C_Reputation.GetFactionParagonInfo( 1828 ) 
				
				local paragonValue, paragonThreshold, paragonRewardQuestID, hasParagonRewardPending, tooLowLevelForParagon = C_Reputation.GetFactionParagonInfo( i )
				
				if not tooLowLevelForParagon then	
					standingText = ArkInventory.Localise["PARAGON"]
					paragonLevel = math.floor( paragonValue / paragonThreshold ) + 1
					barMin = 0
					barMax = paragonThreshold
					hasParagonReward = hasParagonRewardPending and 1 or 0
					repValue = paragonValue % paragonThreshold
				end
				
			end
			
			barMax = barMax - barMin
			barValue = repValue - barMin
			
			if c[i].active ~= active then
				update = true
				c[i].active = active
			end
			
			if c[i].atWarWith ~= atWarWith then
				update = true
				c[i].atWarWith = atWarWith
			end
			
			if c[i].isWatched ~= isWatched then
				update = true
				c[i].isWatched = isWatched
			end
			
			if c[i].isCapped ~= isCapped then
				update = true
				c[i].isCapped = isCapped
			end
			
			if c[i].barValue ~= barValue then
				
				update = true
				
				c[i].repValue = repValue
				c[i].standingText = standingText
				c[i].barMin = barMin
				c[i].barMax = barMax
				c[i].barValue = barValue
				c[i].paragonLevel = paragonLevel
				c[i].hasParagonReward = hasParagonReward
				
				c[i].icon = icon or ArkInventory.Global.Location[loc_id].Texture
				
				-- custom itemlink, not blizzard supported
				c[i].h = string.format( "reputation:%s:%s:%s:%s:%s:%s:%s", i, standingText, barValue, barMax, isCapped, paragonLevel, hasParagonReward )
				
			end
			
			
			-- update the list order array
			collection.list[index] = c[i]
			
		end
		
	end
	
	ArkInventory.ThreadYield_Scan( thread_id )
	
	FilterActionRestore( )
	
	collection.numOwned = numOwned
	
	--ArkInventory.Output( "Reputation: End Scan @ ", time( ), " ( ", collection.numOwned, " of ", collection.numTotal, " ) update=", update )
	
	collection.isReady = true
	
	if update then
		ArkInventory.ScanLocation( loc_id )
		ArkInventory.Frame_Status_Update_Tracking( )
--		ArkInventory.LDB.Tracking_Reputation:Update( )
	end
	
end

local function Scan( )
	
	local thread_id = string.format( ArkInventory.Global.Thread.Format.Collection, "reputation" )
	
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


function ArkInventory:EVENT_ARKINV_COLLECTION_REPUTATION_UPDATE_BUCKET( events )
	
	--ArkInventory.Output( "REPUTATION BUCKET [", events, "]" )
	
	if not ArkInventory:IsEnabled( ) then return end
	
	if not ArkInventory.LocationIsMonitored( loc_id ) then
		--ArkInventory.Output( "IGNORED (REPUTATION NOT MONITORED)" )
		return
	end
	
	if ArkInventory.Global.Mode.Combat then
		-- set to scan when leaving combat
		ArkInventory.Global.LeaveCombatRun[loc_id] = true
		return
	end
	
	if ReputationFrame:IsVisible( ) then
		--ArkInventory.Output( "IGNORED (REPUTATION FRAME IS OPEN)" )
		return
	end
	
	if not collection.isScanning then
		collection.isScanning = true
		Scan( )
		collection.isScanning = false
	else
		--ArkInventory.Output( "IGNORED (REPUTATION BEING SCANNED - WILL RESCAN WHEN DONE)" )
		ArkInventory:SendMessage( "EVENT_ARKINV_COLLECTION_REPUTATION_UPDATE_BUCKET", "RESCAN" )
	end
	
end

function ArkInventory:EVENT_ARKINV_COLLECTION_REPUTATION_UPDATE( event, ... )
	
	--ArkInventory.Output( "REPUTATION UPDATE [", event, "]" )
	
	if event == "UPDATE_FACTION" then
		if collection.filter.ignore then
			--ArkInventory.Output( "IGNORED (FILTER CHANGED BY ME)" )
			collection.filter.ignore = false
			return
		end
	end
	
	ArkInventory:SendMessage( "EVENT_ARKINV_COLLECTION_REPUTATION_UPDATE_BUCKET", event )
	
end
