local _G = _G
local select = _G.select
local pairs = _G.pairs
local ipairs = _G.ipairs
local string = _G.string
local type = _G.type
local error = _G.error
local table = _G.table


local loc_id = ArkInventory.Const.Location.Token

ArkInventory.Collection.Currency = { }

local collection = {
	
	isInit = false,
	isReady = false,
	isScanning = false,
	
	numTotal = 0, -- number of total currencies
	numOwned = 0, -- number of known currencies
	
	list = { }, -- [index] = { } - currencies and headers from the blizard frame
	cache = { }, -- [id] = { } - all currencies

	filter = {
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
		n = GetCurrencyListSize( )
		--ArkInventory.Output( "pass=", p, " num=", n )
		e = true
		
		for index = 1, n do
			
			local name, isHeader, isExpanded, isUnused, isWatched, currentAmount, icon, maximumAmount, hasWeeklyLimit, currentWeeklyAmount, boolean1, number1 = GetCurrencyListInfo( index )
			
			--ArkInventory.Output( "i=[",index,"] h=[", isHeader, "] e=[", isExpanded, "] [", name, "]" )
			
			if isHeader and not isExpanded then
				--ArkInventory.Output( "expanding ", index )
				collection.filter.expanded[index] = true
				ExpandCurrencyList( index, 1 )
				e = false
				break
			end
			
		end
		
	until e or p > n * 1.5
	
	collection.filter.backup = true
	
end

local function FilterActionRestore( )
	
	if not collection.filter.backup then return end
	
	local n = GetCurrencyListSize( )
	
	for index = n, 1, -1 do
		if collection.filter.expanded[index] then
			--ArkInventory.Output( "collapsing ", index )
			ExpandCurrencyList( index, 0 )
		end
	end
	
	collection.filter.backup = false
	
end


function ArkInventory.Collection.Currency.OnHide( )
	ArkInventory:SendMessage( "EVENT_ARKINV_COLLECTION_CURRENCY_UPDATE_BUCKET", "FRAME_CLOSED" )
end

function ArkInventory.Collection.Currency.IsReady( )
	return collection.isReady
end

function ArkInventory.Collection.Currency.GetCount( )
	return collection.numOwned, collection.numTotal
end

function ArkInventory.Collection.Currency.Iterate( )
	local t = collection.cache
	return ArkInventory.spairs( t, function( a, b ) return ( t[a].name or "" ) < ( t[b].name or "" ) end )
end

function ArkInventory.Collection.Currency.IterateList( )
	local t = collection.list
	return ArkInventory.spairs( t, function( a, b ) return ( t[a].index or 0 ) < ( t[b].index or 0 ) end )
end

function ArkInventory.Collection.Currency.GetCurrency( id )
	if type( id ) == "number" then
		return collection.cache[id]
	end
end

function ArkInventory.Collection.Currency.GetCurrencyList( index )
	if type( index ) == "number" then
		return ArkInventory.Collection.Currency.info[index]
	end
end

function ArkInventory.Collection.Currency.GetCurrencyByName( name )
	if type( name ) == "string" and name ~= "" then
		for _, obj in ArkInventory.Collection.Currency.Iterate( ) do
			if obj.name == name then
				return obj.index, obj
			end
		end
	end
end


local function ScanInit( )
	
	--ArkInventory.Output( "Currency Init: Start Scan @ ", time( ) )
	
	local c = collection.cache
	
	local numTotal = 0
	
	for id = 1, 5000 do
		
		local name, currentAmount, icon, currentWeeklyAmount, weeklyLimit, maximumAmount, isDiscovered, rarity = GetCurrencyInfo( id )
		
		-- /dump GetCurrencyInfo( 1342 ) legionfall war supplies (has a maximum)
		-- /dump GetCurrencyInfo( 1220 ) order resources (no limits)
		-- /dump GetCurrencyInfo( 1314 ) order resources (no limits)
		
		if name and name ~= "" then
			
			local i = id
			
			numTotal = numTotal + 1
			
			if not c[i] then
				
				c[i] = {
					index = i,
					link = GetCurrencyLink( i, 1 ),
					name = name,
					icon = icon,
					weeklyLimit = weeklyLimit,
					maximumAmount = maximumAmount,
					rarity = rarity,
				}
				
			end
			
		end
		
	end
	
	collection.numTotal = numTotal
	
	collection.isInit = true
	
	--ArkInventory.Output( "Currency Init: End Scan @ ", time( ), " [", collection.numTotal, "]]" )
	
end

local function Scan_Threaded( thread_id )
	
	local update = false
	
	local numOwned = 0
	
	--ArkInventory.Output( "Currency: Start Scan @ ", time( ) )
	
	if not collection.isInit then
		ScanInit( )
		ArkInventory.ThreadYield_Scan( thread_id )
	end
	
	FilterActionBackup( )
	
	-- scan the reuptation frame (now fully expanded) for known factions
	
	for index = 1, GetCurrencyListSize( ) do
		
		if TokenFrame:IsVisible( ) then
			--ArkInventory.Output( "ABORTED (CURRENCY FRAME WAS OPENED)" )
			FilterActionRestore( )
			return
		end

		local name, isHeader, isExpanded, isUnused, isWatched, currentAmount, icon, maximumAmount, hasWeeklyLimit, currentWeeklyAmount, boolean1, number1 = GetCurrencyListInfo( index )
		
		local c = collection.list
		local i = index
		
		if not c[i] then
			update = true
			c[i] = { index = index }
		end
		
		local currencyID = ArkInventory.Collection.Currency.GetCurrencyByName( name )
		
		if c[i].name ~= name or c[i].id ~= currencyID then
			
			update = true
			
			c[i].name = name
			c[i].isHeader = isHeader
			
			c[i].id = currencyID
			
		end
		
		if c[i].active ~= isUnused then
			update = true
			c[i].active = isUnused
		end
		
		if c[i].isWatched ~= isWatched then
			update = true
			c[i].isWatched = isWatched
		end
		
		
		-- update cache
		
		if currencyID and not isHeader and name and name ~= "" then
			
			numOwned = numOwned + 1
			
			local c = collection.cache
			local i = currencyID
			
			c[i].owned = true
			
			local name, currentAmount, icon, currentWeeklyAmount, weeklyLimit, maximumAmount, isDiscovered, rarity = GetCurrencyInfo( i )
			
			if c[i].currentAmount ~= currentAmount then
				update = true
				c[i].currentAmount = currentAmount
			end
				
			if c[i].currentWeeklyAmount ~= currentWeeklyAmount then
				update = true
				c[i].currentWeeklyAmount = currentWeeklyAmount
			end
			
			if c[i].isDiscovered ~= isDiscovered then
				update = true
				c[i].isDiscovered = isDiscovered
			end
			
		end
		
		
	end
	
	ArkInventory.ThreadYield_Scan( thread_id )
	
	FilterActionRestore( )
	
	collection.numOwned = numOwned
	
	--ArkInventory.Output( "Currency: End Scan @ ", time( ), " [", collection.numOwned, "] [", collection.numTotal, "] [", update, "]" )
	
	collection.isReady = true
	
	if update then
		ArkInventory.ScanLocation( loc_id )
		ArkInventory.Frame_Status_Update_Tracking( )
--		ArkInventory.LDB.Tracking_Currency:Update( )
	end
	
end

local function Scan( )
	
	local thread_id = string.format( ArkInventory.Global.Thread.Format.Collection, "currency" )
	
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


function ArkInventory:EVENT_ARKINV_COLLECTION_CURRENCY_UPDATE_BUCKET( events )
	
	--ArkInventory.Output( "CURRENCY BUCKET [", events, "]" )
	
	if not ArkInventory:IsEnabled( ) then return end
	
	if ArkInventory.Global.Mode.Combat then
		-- set to scan when leaving combat
		ArkInventory.Global.LeaveCombatRun[loc_id] = true
		return
	end
	
	if not ArkInventory.LocationIsMonitored( loc_id ) then
		--ArkInventory.Output( "IGNORED (CURRENCY NOT MONITORED)" )
		return
	end
	
	if TokenFrame:IsVisible( ) then
		--ArkInventory.Output( "IGNORED (CURRENCY FRAME IS OPEN)" )
		return
	end
	
	if not collection.isScanning then
		collection.isScanning = true
		Scan( )
		collection.isScanning = false
	else
		--ArkInventory.Output( "IGNORED (CURRENCY BEING SCANNED - WILL RESCAN WHEN DONE)" )
		ArkInventory:SendMessage( "EVENT_ARKINV_COLLECTION_CURRENCY_UPDATE_BUCKET", "RESCAN" )
	end
	
end

function ArkInventory:EVENT_ARKINV_COLLECTION_CURRENCY_UPDATE( event, ... )
	
	--ArkInventory.Output( "CURRENCY UPDATE [", event, "]" )
	
	ArkInventory:SendMessage( "EVENT_ARKINV_COLLECTION_CURRENCY_UPDATE_BUCKET", event )
	
end
