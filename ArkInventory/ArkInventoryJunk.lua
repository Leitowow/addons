local _G = _G
local select = _G.select
local pairs = _G.pairs
local ipairs = _G.ipairs
local string = _G.string
local type = _G.type
local error = _G.error
local table = _G.table


function ArkInventory.JunkCheck( i, codex )
	
	local isJunk = false
	local vendorPrice = -1
	
	if i and i.h and codex then
		
		local cat_id = ArkInventory.ItemCategoryGet( i )
		local cat_z, cat_code = ArkInventory.CategoryCodeSplit( cat_id )
		
		isJunk = i.q <= ArkInventory.db.option.junk.raritycutoff and codex.catset.category.junk[cat_z][cat_code] == true
		
		if isJunk then
			vendorPrice = ArkInventory.ObjectInfoVendorPrice( i.h )
		end
		
	end
	
	return isJunk, vendorPrice
	
end

function ArkInventory.JunkIterate( )
	
	local loc_id = ArkInventory.Const.Location.Bag
	local codex = ArkInventory.GetLocationCodex( loc_id )
	
	local bag_id = 1
	local slot_id = 0
	
	local player = ArkInventory.GetPlayerStorage( nil, loc_id )
	local i
	
	local bags = ArkInventory.Global.Location[loc_id].Bags
	local blizzard_id = bags[bag_id]
	local numslots = GetContainerNumSlots( blizzard_id )
	
	local _, isJunk, isLocked, itemCount, itemLink, vendorPrice
	
	
	return function( )
		
		isJunk = false
		itemLink = nil
		itemCount = 0
		vendorPrice = -1
		
		while not isJunk do
			
			if slot_id < numslots then
				slot_id = slot_id + 1
			elseif bag_id < #bags then
				bag_id = bag_id + 1
				blizzard_id = bags[bag_id]
				numslots = GetContainerNumSlots( blizzard_id )
				slot_id = 1
			else
				blizzard_id = nil
				slot_id = nil
				itemCount = nil
				itemLink = nil
				vendorPrice = -1
				break
			end
			
			_, itemCount, isLocked, _, _, _, itemLink = GetContainerItemInfo( blizzard_id, slot_id )
			
			if itemCount and not isLocked and itemLink then
				isJunk, vendorPrice = ArkInventory.JunkCheck( player.data.location[loc_id].bag[bag_id].slot[slot_id], codex )
			end
			
		end
		
		--ArkInventory.Output( itemLink, " / ", itemCount, " / ", vendorPrice )
		return blizzard_id, slot_id, itemLink, itemCount, vendorPrice
		
	end
	
end

local function JunkSell_Threaded( thread_id )
	
--	ArkInventory.Output( "start amount ", GetMoney( ) )
	ArkInventory.Global.Junk.money = GetMoney( )
	
	local limit = ( ArkInventory.db.option.junk.limit and BUYBACK_ITEMS_PER_PAGE ) or 0
	
	for blizzard_id, slot_id, itemLink, itemCount, vendorPrice in ArkInventory.JunkIterate( ) do
		
		if not ArkInventory.Global.Mode.Merchant then
			--ArkInventory.Output( "ABORTED (MERCHANT WAS CLOSED)" )
			return
		end
		
		if vendorPrice > 0 then
			
			ArkInventory.Global.Junk.sold = ArkInventory.Global.Junk.sold + 1
			
			if limit > 0 and ArkInventory.Global.Junk.sold > limit then
				-- limited to buyback page
				ArkInventory.Global.Junk.sold = limit
				ArkInventory.Output( string.format( ArkInventory.Localise["CONFIG_JUNK_SELL_NOTIFY_LIMIT"], limit ) )
				return
			end
			
			if ArkInventory.db.option.junk.list then
				ArkInventory.Output( string.format( ArkInventory.Localise["CONFIG_JUNK_LIST_SELL_TEXT"], itemCount, itemLink, ArkInventory.MoneyText( itemCount * vendorPrice, true ) ) )
			end
			
			if not ArkInventory.db.option.junk.test then
				
				UseContainerItem( blizzard_id, slot_id )
				
				-- this will sometimes fail, without any notifcation, so you cant just add up the values as you go
				-- GetMoney doesnt update in realtime so also cannot be used here
				-- next best thing, record how much money we had beforehand and how much we have at the next PLAYER_MONEY, then print it out there
				
				ArkInventory.ThreadYield( thread_id )
				
			end
			
		elseif vendorPrice == 0 then
			
			if ArkInventory.db.option.junk.delete then
				
				ArkInventory.Global.Junk.destroyed = ArkInventory.Global.Junk.destroyed + 1
				
				if ArkInventory.db.option.junk.list then
					ArkInventory.Output( string.format( ArkInventory.Localise["CONFIG_JUNK_LIST_DESTROY_TEXT"], itemCount, itemLink ) )
				end
				
				if not ArkInventory.db.option.junk.test then
					
					-- might fail, might prompt user if quality is green or higher
					PickupContainerItem( blizzard_id, slot_id )
					DeleteCursorItem( )
					
					ArkInventory.ThreadYield( thread_id )
					
				end
				
			end
			
		end
		
	end
	
	if ArkInventory.db.option.junk.test and ( ArkInventory.Global.Junk.sold > 0 or ArkInventory.Global.Junk.destroyed > 0 ) then
		ArkInventory.OutputWarning( ArkInventory.Localise["CONFIG_JUNK_TEST_ALERT"] )
	end
	
	--ArkInventory.Output( "tried to sell ", ArkInventory.Global.Junk.sold, " items" )
	
	
	-- notifcation is at EVENT_ARKINV_PLAYER_MONEY, call it in case it tripped before the final yield came back
--	ArkInventory:SendMessage( "EVENT_ARKINV_PLAYER_MONEY_BUCKET", "JUNK" )
	
end

local junk_addons = {"Scrap","SellJunk"}
function ArkInventory.JunkSell( )
	
	if not ArkInventory.db.option.junk.sell then return end
	
	for _, a in pairs( junk_addons ) do
		--ArkInventory.Output( "checking ", a )
		if IsAddOnLoaded( a ) then
			if ArkInventory.db.option.junk.test then
				ArkInventory.Output( a, " is loaded, aborting ArkInventory junk sell" )
			end
			return
		end
	end
	
	ArkInventory.Global.Junk.sold = 0
	ArkInventory.Global.Junk.destroyed = 0
	ArkInventory.Global.Junk.money = 0
	
	local thread_id = ArkInventory.Global.Thread.Format.JunkSell
	
	if ArkInventory.Global.Junk.run then
		ArkInventory.Output( "junksell already running, please wait" )
		--return
	end
	
	if not ArkInventory.Global.Thread.Use then
		local tz = debugprofilestop( )
		ArkInventory.OutputThread( thread_id, " start" )
		JunkSell_Threaded( thread_id )
		tz = debugprofilestop( ) - tz
		ArkInventory.OutputThread( string.format( "%s took %0.0fms", thread_id, tz ) )
		return
	end
	
	local tf = function ( )
		ArkInventory.Global.Junk.run = true
		JunkSell_Threaded( thread_id )
		ArkInventory.Global.Junk.run = false
	end
	
	ArkInventory.ThreadStart( thread_id, tf )
	
end
