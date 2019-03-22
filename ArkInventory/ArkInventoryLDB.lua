local _G = _G
local select = _G.select
local pairs = _G.pairs
local ipairs = _G.ipairs
local string = _G.string
local type = _G.type
local error = _G.error
local table = _G.table


ArkInventory.LDB = {
	Bags = ArkInventory.Lib.DataBroker:NewDataObject( string.format( "%s_%s", ArkInventory.Const.Program.Name, "Bags" ), {
		type = "data source",
		text = BLIZZARD_STORE_LOADING,
	} ),
	Money = ArkInventory.Lib.DataBroker:NewDataObject( string.format( "%s_%s", ArkInventory.Const.Program.Name, "Money" ), {
		type = "data source",
		text = BLIZZARD_STORE_LOADING,
	} ),
	Pets = ArkInventory.Lib.DataBroker:NewDataObject( string.format( "%s_%s", ArkInventory.Const.Program.Name, "Pets" ), {
		type = "data source",
		text = BLIZZARD_STORE_LOADING,
		next = 0,
	} ),
	Mounts = ArkInventory.Lib.DataBroker:NewDataObject( string.format( "%s_%s", ArkInventory.Const.Program.Name, "Mounts" ), {
		type = "data source",
		text = BLIZZARD_STORE_LOADING,
		next = 0,
	} ),
	Tracking_Currency = ArkInventory.Lib.DataBroker:NewDataObject( string.format( "%s_%s_%s", ArkInventory.Const.Program.Name, "Tracking", "Currency" ), {
		type = "data source",
		text = BLIZZARD_STORE_LOADING,
	} ),
	Tracking_Item = ArkInventory.Lib.DataBroker:NewDataObject( string.format( "%s_%s_%s", ArkInventory.Const.Program.Name, "Tracking", "Item" ), {
		type = "data source",
		text = BLIZZARD_STORE_LOADING,
	} ),
	Tracking_Reputation = ArkInventory.Lib.DataBroker:NewDataObject( string.format( "%s_%s_%s", ArkInventory.Const.Program.Name, "Tracking", "Reputation" ), {
		type = "data source",
		text = BLIZZARD_STORE_LOADING,
	} ),
}

local companionTable = { }



function ArkInventory.LDB.Bags:OnClick( button )
	if button == "RightButton" then
		ArkInventory.MenuLDBBagsOpen( self )
	else
		ArkInventory.Frame_Main_Toggle( ArkInventory.Const.Location.Bag )
	end
end

function ArkInventory.LDB.Bags:Update( )
	
	local icon = string.format( "|T%s:0|t", ArkInventory.Global.Location[ArkInventory.Const.Location.Bag].Texture )
	local hasText
	
	local me = ArkInventory.GetPlayerCodex( )
	local loc_id = ArkInventory.Const.Location.Bag
	
	hasText = ArkInventory.Frame_Status_Update_Empty( loc_id, me, true )
	
	if hasText then
		self.text = string.trim( string.format( "%s %s", icon, hasText ) )
	else
		self.text = icon
	end
	
end



function ArkInventory.LDB.Money:Update( )
	
	local icon = string.format( "|T%s:0|t", [[Interface\Icons\INV_Misc_Coin_02]] )
	local hasText
	
	hasText = ArkInventory.MoneyText( GetMoney( ) )
	
	if hasText then
		self.text = string.trim( hasText )
	else
		self.text = icon
	end
	
end

function ArkInventory.LDB.Money.OnTooltipShow( frame )
	ArkInventory.MoneyFrame_Tooltip( frame )
end



function ArkInventory.LDB.Tracking_Currency:Update( )
	
	local icon = string.format( "|T%s:0|t", ArkInventory.Global.Location[ArkInventory.Const.Location.Token].Texture )
	local hasText
	local me = ArkInventory.GetPlayerCodex( )
	
	for _, object in ArkInventory.Collection.Currency.IterateList( ) do
		if me.player.data.ldb.tracking.currency.tracked[object.id] then
			local info = ArkInventory.Collection.Currency.GetCurrency( object.id )
			hasText = string.format( "%s |T%s:0|t %s", hasText or "", info.icon, FormatLargeNumber( info.currentAmount ) )
		end
	end
	
	if hasText then
		self.text = string.trim( hasText )
	else
		self.text = icon
	end
	
end

function ArkInventory.LDB.Tracking_Currency.OnClick( frame, button )
	
	if button == "RightButton" then
		ArkInventory.MenuLDBTrackingCurrencyOpen( frame )
	else
		ArkInventory.Frame_Main_Toggle( ArkInventory.Const.Location.Token )
	end
	
end

function ArkInventory.LDB.Tracking_Currency:OnTooltipShow( )
	
	self:AddLine( string.format( "%s: %s", ArkInventory.Localise["TRACKING"], ArkInventory.Localise["CURRENCY"] ) )
	
	if ArkInventory.Collection.Currency.GetCount( ) == 0 then
		
		self:AddLine( " " )
		self:AddLine( "no known currencies" )
		
	else
		
		local header = ""
		
		for _, object in ArkInventory.Collection.Currency.IterateList( ) do
			
			--ArkInventory.Output( object )
			
			if object.isHeader then
				
				self:AddLine( " " )
				self:AddLine( object.name )
				
			else
				
				local info = ArkInventory.Collection.Currency.GetCurrency( object.id )
				local me = ArkInventory.GetPlayerCodex( )
				
				local txt = FormatLargeNumber( info.currentAmount )
				
				if info.maximumAmount > 0 then
					txt = string.format( "%s/%s", FormatLargeNumber( info.currentAmount ), FormatLargeNumber( info.maximumAmount ) )
				end
				
				if me.player.data.ldb.tracking.currency.tracked[object.id] then
					self:AddDoubleLine( object.name, txt, 0, 1, 0, 0, 1, 0 )
				else
					self:AddDoubleLine( object.name, txt, 1, 1, 1, 1, 1, 1 )
				end
				
				if info.hasWeeklyLimit and info.currentWeeklyAmount and info.currentWeeklyAmount > 0 then
					
					txt = string.format( "%s/%s", FormatLargeNumber( info.currentWeeklyAmount ), FormatLargeNumber( info.hasWeeklyLimit ) )
					
					if me.player.data.ldb.tracking.currency.tracked[object.id] then
						self:AddDoubleLine( string.format( "  * %s", ArkInventory.Localise["WEEKLY"] ), txt, 0, 1, 0, 0, 1, 0 )
					else
						self:AddDoubleLine( string.format( "  * %s", ArkInventory.Localise["WEEKLY"] ), txt, 1, 1, 1, 1, 1, 1 )
					end
				
				end
					
			end
			
		end
		
	end
	
	self:Show( )
	
end



function ArkInventory.LDB.Tracking_Reputation:Update( )
	
	local icon = string.format( "|T%s:0|t", ArkInventory.Global.Location[ArkInventory.Const.Location.Reputation].Texture )
	local hasText
	
	if ArkInventory.Collection.Reputation.GetCount( ) > 0 then
		
		local codex = ArkInventory.GetPlayerCodex( )
		
		local style_default = ArkInventory.Const.Reputation.Style.OneLineWithName
		local style = style_default
		if ArkInventory.db.option.tracking.reputation.custom ~= ArkInventory.Const.Reputation.Custom.Default then
			style = ArkInventory.db.option.tracking.reputation.style.ldb
			if string.trim( style ) == "" then
				style = style_default
			end
		end
		
		for _, object in ArkInventory.Collection.Reputation.IterateList( ) do
			
			if codex.player.data.ldb.tracking.reputation.watched == object.id then
				
				if object.active then
					
					local txt = ArkInventory.Collection.Reputation.LevelText( object.id, style )
					
					hasText = string.format( "|T%s:0|t %s", object.icon, txt )
					
				else
					
					codex.player.data.ldb.tracking.reputation.watched = nil
					
				end
				
				break
				
			end
			
		end
		
	end
	
	if hasText then
		self.text = string.trim( hasText )
	else
		self.text = icon
	end
	
end

function ArkInventory.LDB.Tracking_Reputation.OnClick( frame, button )
	
	if button == "RightButton" then
		ArkInventory.MenuLDBTrackingReputationOpen( frame )
	else
		ArkInventory.Frame_Main_Toggle( ArkInventory.Const.Location.Reputation )
		--ToggleCharacter( "ReputationFrame" )
	end
	
end

function ArkInventory.LDB.Tracking_Reputation:OnTooltipShow( )
	
	self:AddLine( string.format( "%s: %s", ArkInventory.Localise["TRACKING"], ArkInventory.Localise["REPUTATION"] ) )
	
	local count = 0
	
	if ArkInventory.Collection.Reputation.GetCount( ) > 0 then
		
		local me = ArkInventory.GetPlayerCodex( )
		
		local style_default = ArkInventory.Const.Reputation.Style.OneLine
		local style = style_default
		if ArkInventory.db.option.tracking.reputation.custom ~= ArkInventory.Const.Reputation.Custom.Default then
			style = ArkInventory.db.option.tracking.reputation.style.tooltip
			if string.trim( style ) == "" then
				style = style_default
			end
		end
		
		for _, object in ArkInventory.Collection.Reputation.IterateList( ) do
			
			if me.player.data.ldb.tracking.reputation.tracked[object.id] then
				
				if object.active then
					
					count = count + 1
					
					local txt = ArkInventory.Collection.Reputation.LevelText( object.id, style )
					
					if me.player.data.ldb.tracking.reputation.watched == object.id then
						self:AddDoubleLine( object.name, txt, 0, 1, 0, 0, 1, 0 )
					else
						self:AddDoubleLine( object.name, txt, 1, 1, 1, 1, 1, 1 )
					end
					
				else
					
					me.player.data.ldb.tracking.reputation.tracked[object.id] = false
					
				end
				
			end
			
		end
		
	end
	
	if count == 0 then
		self:AddLine( " " )
		self:AddLine( "no reputations are being tracked", 1, 1, 1 )
	end
	
	self:Show( )
	
end



function ArkInventory.LDB.Tracking_Item:Update( )
	
	local icon = string.format( "|T%s:0|t", [[Interface\Icons\Ability_Tracking]] )
	local hasText
	
	local me = ArkInventory.GetPlayerCodex( )
	
	for k in ArkInventory.spairs( ArkInventory.db.option.tracking.items )  do
		
		if me.player.data.ldb.tracking.item.tracked[k] then
			
			local count = GetItemCount( k, true )
			local icon = select( 10, GetItemInfo( k ) )
			hasText = string.format( "%s  |T%s:0|t %s", hasText or "", icon or ArkInventory.Const.Texture.Missing, FormatLargeNumber( count or 0 ) )
			
		end
		
	end
	
	if hasText then
		self.text = string.trim( hasText )
	else
		self.text = icon
	end
	
end

function ArkInventory.LDB.Tracking_Item:OnClick( button )
	
	if button == "RightButton" then
		ArkInventory.MenuLDBTrackingItemOpen( self )
	end
	
end

function ArkInventory.LDB.Tracking_Item:OnTooltipShow( )
	
	self:AddLine( string.format( "%s: %s", ArkInventory.Localise["TRACKING"], ArkInventory.Localise["ITEMS"] ) )
	
	self:AddLine( " " )
	
	local me = ArkInventory.GetPlayerCodex( )
	
	for k in ArkInventory.spairs( ArkInventory.db.option.tracking.items ) do
		
		local count = GetItemCount( k, true )
		local name = GetItemInfo( k )
		
		local checked = me.player.data.ldb.tracking.item.tracked[k]
		
		if checked then
			self:AddDoubleLine( name, count, 0, 1, 0, 0, 1, 0 )
		else
			self:AddDoubleLine( name, count, 1, 1, 1, 1, 1, 1 )
		end
		
	end
	
	self:Show( )
	
end



function ArkInventory.LDB.Pets.Cleanup( )
	
	if ArkInventory.Collection.Pet.IsReady( ) then
		
		-- check for and remove any selected companions we no longer have (theyve either been caged or released)
		local me = ArkInventory.GetPlayerCodex( )
		local selected = me.player.data.ldb.pets.selected
		for k, v in pairs( selected ) do
			if v ~= nil and not ArkInventory.Collection.Pet.GetPet( k ) then
				selected[k] = nil
				--ArkInventory.Output( "removing selected pet we dont have any more - ", k )
			end
		end
		
	end
	
end

function ArkInventory.LDB.Pets.BuildList( ignoreActive )
	
	table.wipe( companionTable )
	
	if not ArkInventory.Collection.Pet.IsReady( ) then
		return
	end
	
	local n = ArkInventory.Collection.Pet.GetCount( )
	--ArkInventory.Output( "pet count = ", n )
	if n == 0 then return end
	
	local me = ArkInventory.GetPlayerCodex( )
	local selected = me.player.data.ldb.pets.selected
	local selectedCount = 0
	for k, v in pairs( selected ) do
		if v == true then
			selectedCount = selectedCount + 1
		end
	end
	
	if selectedCount < 2 then
		ignoreActive = true
	end
	
	--ArkInventory.Output( "count = ", selectedCount, ", selected = ", selected )
	
	local count = 0
	local _, _, activePet = ArkInventory.Collection.Pet.GetCurrent( )
	local activeSpecies = activePet and activePet.sd.speciesID
	
	for index, pd in ArkInventory.Collection.Pet.Iterate( ) do
		
		if ( not activePet or ignoreActive ) and ( pd.sd.speciesID ~= activeSpecies ) and ( selectedCount == 0 or selected[index] == true ) and ArkInventory.Collection.Pet.CanSummon( pd.guid ) then
			
			-- cannot be same species as the active pet, if one was active
			-- must be summonable
			
			if selected[index] == false then
				-- never summon
			else
				count = count + 1
				companionTable[count] = index
			end
			
		end
		
	end
	
end

function ArkInventory.LDB.Pets:Update( )
	
	local icon = string.format( "|T%s:0|t", ArkInventory.Global.Location[ArkInventory.Const.Location.Pet].Texture )
	local hasText
	
	ArkInventory.LDB.Pets.Cleanup( )
	
	if hasText then
		self.text = string.trim( hasText )
	else
		self.text = icon
	end
	
end

function ArkInventory.LDB.Pets:OnTooltipShow( )
	
	if not ArkInventory.Collection.Pet.IsReady( ) then
		self:AddLine( "journal not ready", 1, 0, 0 )
		return
	end
	
	self:AddDoubleLine( MODE, ArkInventory.Localise["SELECTION"] )
	
	local total = ArkInventory.Collection.Pet.GetCount( )
	
	if total < 1 then
		self:AddDoubleLine( ArkInventory.Localise["PET"], ArkInventory.Localise["LDB_COMPANION_NONE"], 1, 1, 1, 1, 1, 1 )
		return
	end
	
	local me = ArkInventory.GetPlayerCodex( )
	local selected = me.player.data.ldb.pets.selected
	local count = ArkInventory.Table.Elements( selected )
	local selectedCount = 0
	for k, v in pairs( selected ) do
		if v == true then
			selectedCount = selectedCount + 1
		end
	end
	
	if count == 0 then
		
		self:AddDoubleLine( ArkInventory.Localise["PET"], string.format( "%s (%s)", ArkInventory.Localise["ALL"], total ), 1, 1, 1, 1, 1, 1 )
		
	elseif selectedCount == 1 then
		
		-- just the one selected, there may be ignored but they dont matter
		for k, v in pairs( selected ) do
			if v == true then
				local pd = ArkInventory.Collection.Pet.GetPet( k )
				local name = pd.sd.name
				if pd.cn and pd.cn ~= "" then
					name = string.format( "%s (%s)", name, pd.cn )
				end
				self:AddDoubleLine( ArkInventory.Localise["PET"], string.format( "%s: %s", ArkInventory.Localise["SELECTION"], name ), 1, 1, 1, 1, 1, 1 )
			end
		end
	
	else
	
		-- random selection, possibly some ignored
		
		if selectedCount == 0 then
			-- none selected so must be ignored
			self:AddDoubleLine( ArkInventory.Localise["PET"], string.format( "%s (%s %s)", ArkInventory.Localise["ALL"], ArkInventory.Localise["IGNORE"], count - selectedCount ), 1, 1, 1, 1, 1, 1 )
		else
			-- more than one selected, there may be ignored but they dont matter
			self:AddDoubleLine( ArkInventory.Localise["PET"], string.format( "%s (%s)", ArkInventory.Localise["SELECTION"], selectedCount ), 1, 1, 1, 1, 1, 1 )
		end
		
	end

end

function ArkInventory.LDB.Pets:OnClick( button )
	
	if not ArkInventory.Collection.Pet.IsReady( ) then
		return
	end
	
	if IsModifiedClick( "CHATLINK" ) then
		-- dismiss current pet
		ArkInventory.Collection.Pet.Dismiss( )
		return
	end
	
	ArkInventory.LDB.Pets:Update( )
	
	if button == "RightButton" then
		
		ArkInventory.MenuLDBPetsOpen( self )
		
	else
		
		if ArkInventory.Collection.Pet.GetCount( ) == 0 then
			ArkInventory.Output( string.format( ArkInventory.Localise["NONE_OWNED"], ArkInventory.Localise["PETS"] ) )
			return
		end
		
		ArkInventory.LDB.Pets.BuildList( true )
		
		--ArkInventory.Output( #companionTable, " usable pets" )
		
		if #companionTable == 0 then
			
			ArkInventory.Output( string.format( ArkInventory.Localise["NONE_USABLE"], ArkInventory.Localise["PETS"] ) )
			return
			
		else
			
			local me = ArkInventory.GetPlayerCodex( )
			local userandom = me.player.data.ldb.pets.randomise
			
			if #companionTable <= 3 then
				userandom = false
			end
			
			if userandom then
				ArkInventory.LDB.Pets.next = random( 1, #companionTable )
			else
				ArkInventory.LDB.Pets.next = ArkInventory.LDB.Pets.next + 1
				if ArkInventory.LDB.Pets.next > #companionTable then
					ArkInventory.LDB.Pets.next = 1
				end
			end
			
			--ArkInventory.Output( ArkInventory.LDB.Pets.next, " = ", companionTable[ArkInventory.LDB.Pets.next] )
			ArkInventory.Collection.Pet.Summon( companionTable[ArkInventory.LDB.Pets.next] )
			
		end
		
	end
	
end



function ArkInventory.LDB.Mounts.Cleanup( )
	
	-- remove any selected mounts we no longer have (not sure how but just in case)
	
	if ArkInventory.Collection.Mount.IsReady( ) then
		
		--ArkInventory.Output( "mount journal ready" )
		
		local me = ArkInventory.GetPlayerCodex( )
		
		for mta, mt in pairs( ArkInventory.Const.MountTypes ) do
			
			if mta ~= "x" then
				
				local selected = me.player.data.ldb.mounts.type[mta].selected
				
				for spell, value in pairs( selected ) do
					local md = ArkInventory.Collection.Mount.GetMountBySpell( spell )
					if value ~= nil and not md then
						ArkInventory.OutputWarning( "removing a selected mount [", spell, "] as you dont have it any more" )
						selected[spell] = nil
					elseif md and md.mt ~= mt then
						ArkInventory.OutputWarning( "removing a selected mount ", md.link, " that has changed type" )
						selected[spell] = nil
					end
				end
				
			end
			
		end
		
	else
		--ArkInventory.Output( "mount journal NOT ready" )
	end
	
end

function ArkInventory.LDB.Mounts.IsFlyable( )
	
	if IsIndoors( ) or ArkInventory.Collection.Mount.SkillLevel( ) < 225 then
		return false
	end
	
	local IsFlyable = IsFlyableArea( )  -- its dynamic based off skill and location but its got some issues.  its usually only wrong about flying zones but it got worse in 7.3.5
	
	--local name, instanceType, difficulty, difficultyName, maxPlayers, playerDifficulty, isDynamicInstance, instanceMapId, instanceGroupSize, lfgID = GetInstanceInfo( )
	local imid = select( 8, GetInstanceInfo( ) )
	-- /dump GetInstanceInfo( )
	
	local flyreq = {
		["never"] = {
			[1191] = true, -- Ashran (PvP)
			[1203] = true, -- Frostfire Finale
			[1265] = true, -- Tanaan Jungle Intro
			[1463] = true, -- Helheim Exterior Area
			[1669] = true, -- Argus
			
			[1107] = true, -- Warlock Order Hall - Dreadscar Rift
			[1469] = true, -- Shaman Order Hall - The Heart of Azeroth
			[1479] = true, -- Warrior Order Hall - Skyhold
			[1514] = true, -- Monk Order Hall - The Wandering Isle
			[1519] = true, -- Demon Hunter Order Hall - The Fel Hammer
			
			[1557] = true, -- Class Trial Boost
			
			[1750] = true, -- Exodar - Argus Intro
			[1760] = true, -- Battle for Lordaeron Scenario
			[1642] = true, -- Zandalar (until pathfinder part 2 is available)
			[1643] = true, -- Kul Tiras (until pathfinder part 2 is available)
			[1876] = true, -- Battle for Stormgarde
			
			-- island expeditions
			[1893] = true, -- dread chain
			[1897] = true, -- molten cay
			[1892] = true, -- rotting mire
			[1898] = true, -- skittering hollow
			[1813] = true, -- un'gol ruins
			[1882] = true, -- verdant isles
			[1883] = true, -- whispering reef
			
			-- extra races
			[1917] = true, -- Gorgrond - Mag'har scenario
			
			-- /dump GetInstanceInfo( )
			
		},
		["achieve"] = {
			[1116] = 10018, -- Draenor / Draenor Pathfinder
			[1464] = 10018, -- Tanaan Jungle
			[1152] = 10018, -- Horde Garrison Level 1
			[1330] = 10018, -- Horde Garrison Level 2
			[1153] = 10018, -- Horde Garrison Level 3
			[1154] = 10018, -- Horde Garrison Level 4
			[1158] = 10018, -- Alliance Garrison Level 1
			[1331] = 10018, -- Alliance Garrison Level 2
			[1159] = 10018, -- Alliance Garrison Level 3
			[1160] = 10018, -- Alliance Garrison Level 4
			
			[1220] = 11446, -- Broken Isles / Broken Isles Pathfinder Part 2
			
--			[1642] = 00000, -- Zandalar / Battle for Azeroth Pathfinder Part 2
--			[1643] = 00000, -- Kul Tiras / Battle for Azeroth Pathfinder Part 2
		},
		["spell"] = {
			
		},
		["bug735"] = {
			[0] = true, -- Eastern Kingdoms
			[1] = true, -- Kalimdor
--			[530] = true, -- Outland (appears to be working now)
			[571] = true, -- Northrend
			[730] = true, -- Maelstrom (Deepholm)
--			[870] = true, -- Pandaria (appears to be working now)
		},
	}
	
	if IsFlyable then
		
		--ArkInventory.Output( "blizzard says this is a flyable area" )
		
		if flyreq.never[imid] then
			
			IsFlyable = false
			
		elseif flyreq.achieve[imid] then
			
			local known = select( 4, GetAchievementInfo( flyreq.achieve[imid] ) )
			
			if not known then
				
				--ArkInventory.Output( imid, " but you dont have the achievement ", flyreq.achieve[imid] )
				IsFlyable = false
				
			end
			
		elseif flyreq.spell[imid] then
			
			local known = IsSpellKnown( flyreq.spell[imid] )
			
			if not known then
				
				--ArkInventory.Output( imid, " but you dont have the spell ", flyreq.achieve[imid] )
				IsFlyable = false
				
			end
			
		end
		
	else
		
		--ArkInventory.Output( "blizzard says this is NOT a flyable area" )
		
		-- /run ArkInventory.Output(IsFlyableArea())
		-- /run ArkInventory.Output({GetInstanceInfo()})
		
		if flyreq.bug735[imid] then
			--ArkInventory.Output( "Overriding blizzard IsFlyableArea, you can fly here" )
			IsFlyable = true
		end
		
	end
	
	if IsFlyable then
		
		-- world pvp battle in progress?
		
		for index = 1, GetNumWorldPVPAreas( ) do
			
			local pvpID, pvpZone, isActive = GetWorldPVPAreaInfo( index )
			--ArkInventory.Output( pvpID, " / ", pvpZone, " / ", isActive )
			
			if isActive and GetRealZoneText( ) == pvpZone then
				-- ArkInventory.Output( "battle in progress, no flying allowed" )
				IsFlyable = false
				break
			end
			
		end
		
	end
	
	return IsFlyable
	
end

function ArkInventory.LDB.Mounts.IsSubmerged( )
	
	-- its always right about being in the water, just not under the water
	
	if ( GetMirrorTimerInfo( 2 ) ) == "BREATH" then
		-- breath timer so were underwater
		return true
	end
	
	if not IsSubmerged( ) then
		return false
	end
	
	if not IsSwimming( ) then
		-- zone with a seabed where you can walk/mount (eg, vash'jir)
		return false
	end
	
	-- if you get here you are submerged and swimming and not holding your breath
	-- so youre either at the surface, have some sort of underwater breathing, or possibly both, theres no real way to tell
	
	return true
	
end


local function helper_companionTable_update( tbl )
	
	if type( tbl ) ~= "table" then return end
	
	local count = #companionTable
	
	for index, md in pairs( tbl ) do
		count = count + 1
		companionTable[count] = md.index
	end
	
end

function ArkInventory.LDB.Mounts.GetUsable( forceAlternative )
	
	-- builds companionTable and returns the type
	
	local forceAlternative = forceAlternative
	
	wipe( companionTable )
	
	if not ArkInventory.Collection.Mount.IsReady( ) then return end
	
	ArkInventory.Collection.Mount.UpdateUsable( )
	
	if ArkInventory.LDB.Mounts.IsSubmerged( ) then
		
		if not forceAlternative then
			
			ArkInventory.OutputDebug( "primary - check underwater" )
			if ArkInventory.Collection.Mount.GetCount( "u" ) > 0 then
				ArkInventory.OutputDebug( "primary - using underwater" )
				helper_companionTable_update( ArkInventory.Collection.Mount.GetUsable( "u" ) )
				return "u"
			end
			
			ArkInventory.OutputDebug( "fallback - check surface" )
			if ArkInventory.Collection.Mount.GetCount( "s" ) > 0 then
				ArkInventory.OutputDebug( "fallback - using surface" )
				helper_companionTable_update( ArkInventory.Collection.Mount.GetUsable( "s" ) )
				return "s"
			end
			
		else
			ArkInventory.OutputDebug( "ignore underwater, force flying (or land if you cant fly here)" )
			if ArkInventory.LDB.Mounts.IsFlyable( ) then
				forceAlternative = false
			end
		end
		
	else
		
		if IsSwimming( ) then
			
			if not forceAlternative then
				ArkInventory.OutputDebug( "primary - check surface" )
				if ArkInventory.Collection.Mount.GetCount( "s" ) > 0 then
					ArkInventory.OutputDebug( "primary - using surface" )
					helper_companionTable_update( ArkInventory.Collection.Mount.GetUsable( "s" ) )
					return "s"
				end
			else
				ArkInventory.OutputDebug( "ignore surface, force flying (or land if you cant fly here)" )
				if ArkInventory.LDB.Mounts.IsFlyable( ) then
					forceAlternative = false
				end
			end
			
		end
		
	end
	
	if ArkInventory.LDB.Mounts.IsFlyable( ) then
		ArkInventory.OutputDebug( "flight check - can fly here" )
		if not forceAlternative then
			ArkInventory.OutputDebug( "primary - check flying" )
			if ArkInventory.Collection.Mount.GetCount( "a" ) > 0 then
				ArkInventory.OutputDebug( "primary - using flying" )
				helper_companionTable_update( ArkInventory.Collection.Mount.GetUsable( "a" ) )
				return "a"
			end
		else
			ArkInventory.OutputDebug( "ignore flying, force land" )
			forceAlternative = false
		end
	else
		ArkInventory.OutputDebug( "flight check - cannot fly here" )
	end
	
	ArkInventory.OutputDebug( "primary - check land" )
	if not forceAlternative then
		
		if ArkInventory.Collection.Mount.GetCount( "l" ) > 0 then
			ArkInventory.OutputDebug( "primary - adding land" )
			helper_companionTable_update( ArkInventory.Collection.Mount.GetUsable( "l" ) )
		end
		
		local me = ArkInventory.GetPlayerCodex( )
		
		if me.player.data.ldb.mounts.type.l.usesurface and ArkInventory.Collection.Mount.GetCount( "s" ) > 0 then
			ArkInventory.OutputDebug( "primary - adding surface" )
			helper_companionTable_update( ArkInventory.Collection.Mount.GetUsable( "s" ) )
		end
		
		if me.player.data.ldb.mounts.type.l.useflying and ArkInventory.Collection.Mount.GetCount( "a" ) > 0 then
			ArkInventory.OutputDebug( "primary - adding flying" )
			helper_companionTable_update( ArkInventory.Collection.Mount.GetUsable( "a" ) )
		end
		
		if #companionTable > 0 then
			ArkInventory.OutputDebug( "primary - using land" )
			return "l"
		end
		
	else
		
		if ArkInventory.Collection.Mount.GetCount( "a" ) > 0 then
			ArkInventory.OutputDebug( "alternative - using flying" )
			helper_companionTable_update( ArkInventory.Collection.Mount.GetUsable( "a" ) )
			return "a"
		end
		
	end
	
	--fallback
	
	if ArkInventory.Collection.Mount.GetCount( "l" ) > 0 then
		ArkInventory.OutputDebug( "fallback - using land" )
		helper_companionTable_update( ArkInventory.Collection.Mount.GetUsable( "l" ) )
		return "l"
	end
	
	if ArkInventory.Collection.Mount.GetCount( "s" ) > 0 then
		ArkInventory.OutputDebug( "fallback - using surface" )
		helper_companionTable_update( ArkInventory.Collection.Mount.GetUsable( "s" ) )
		return "s"
	end
	
	if ArkInventory.Collection.Mount.GetCount( "a" ) > 0 then
		ArkInventory.OutputDebug( "fallback - using flying" )
		helper_companionTable_update( ArkInventory.Collection.Mount.GetUsable( "a" ) )
		return "a"
	end
	
	if ArkInventory.Collection.Mount.GetCount( "u" ) > 0 then
		ArkInventory.OutputDebug( "fallback - underwater" )
		helper_companionTable_update( ArkInventory.Collection.Mount.GetUsable( "u" ) )
		return "u"
	end
	
end

function ArkInventory.LDB.Mounts:Update( )
	
	local icon = string.format( "|T%s:0|t", ArkInventory.Global.Location[ArkInventory.Const.Location.Mount].Texture )
	local hasText
	
	ArkInventory.LDB.Mounts.Cleanup( )
	
	if hasText then
		self.text = string.trim( hasText )
	else
		self.text = icon
	end
	
end

function ArkInventory.LDB.Mounts:OnTooltipShow( ... )
	
	if not ArkInventory.Collection.Mount.IsReady( ) then
		self:AddLine( "journal not ready", 1, 0, 0 )
		return
	end
	
	ArkInventory.Collection.Mount.UpdateUsable( )
	
	self:AddDoubleLine( MODE, ArkInventory.Localise["SELECTION"] )
	
	local me = ArkInventory.GetPlayerCodex( )
	
	for mta in pairs( ArkInventory.Const.MountTypes ) do
		
		local mode = ArkInventory.Localise[string.upper( string.format( "LDB_MOUNTS_TYPE_%s", mta ) )]
		local numusable, numtotal = ArkInventory.Collection.Mount.GetCount( mta )
		
		--ArkInventory.Output( mta, " / ", mode, " / ", numusable, " / ", numtotal )
		
		if mta ~= "x" then
			
			if numtotal == 0 then
				
				self:AddDoubleLine( mode, ArkInventory.Localise["NONE"], 1, 1, 1, 1, 0, 0 )
				
			else
				
				local selected = me.player.data.ldb.mounts.type[mta].selected
				local numselected = 0
				for k, v in pairs( selected ) do
					if v == true then
						numselected = numselected + 1
					end
				end
				
				if me.player.data.ldb.mounts.type[mta].useall then
					
					self:AddDoubleLine( mode, string.format( "%s (%s)", ArkInventory.Localise["ALL"], numtotal ), 1, 1, 1, 1, 1, 1 )
					
				elseif numselected == 0 then
					
					self:AddDoubleLine( mode, ArkInventory.Localise["NONE"], 1, 1, 1, 1, 1, 1 )
					
				elseif numselected == 1 then
					
					-- just the one selected, there may be ignored but they dont matter
					for k, v in pairs( selected ) do
						if v then
							local name = GetSpellInfo( k )
							self:AddDoubleLine( mode, string.format( "%s: %s", ArkInventory.Localise["SELECTION"], name ), 1, 1, 1, 1, 1, 1 )
						end
					end
					
				else
					
					-- more than one selected, there may be ignored but they dont matter
					self:AddDoubleLine( mode, string.format( "%s (%s/%s)", ArkInventory.Localise["SELECTION"], numselected, numtotal ), 1, 1, 1, 1, 1, 1 )
					
				end
				
			end
			
		end
		
	end
	
end

function ArkInventory.LDB.Mounts:OnClick( button )
	
	if button == "RightButton" then
		
		ArkInventory.MenuLDBMountsOpen( self )
		
	else
		
		local c, r = ArkInventory.CheckPlayerHasControl( )
		if not c then
			-- you cant mount while you are not in control
			ArkInventory.Output( r )
			return
		end
		
		if IsIndoors( ) then
			-- you shouldnt be able to mount here at all
			ArkInventory.Output( ArkInventory.Localise["LDB_MOUNTS_FAIL_NOT_ALLOWED"] )
			return
		end
		
		local me = ArkInventory.GetPlayerCodex( )
		
		if IsMounted( ) then
			
			if IsFlying( ) then
				if not me.player.data.ldb.mounts.type.a.dismount then
					ArkInventory.OutputWarning( ArkInventory.Localise["LDB_MOUNTS_FLYING_DISMOUNT_WARNING"] )
					return
				end
			end
			
			ArkInventory.Collection.Mount.Dismiss( )
			
			return
			
		end
		
		if InCombatLockdown( ) or IsFlying( ) or not ArkInventory.Collection.Mount.IsReady( ) then return end
		
		ArkInventory.OutputDebug( "----- start mount check -----" )
		
		if ArkInventory.Collection.Mount.GetCount( ) == 0 then
			--ArkInventory.Output( "you don't own any mounts" )
			return
		end
		
		local forceAlternative = IsModifiedClick( "CHATLINK" )
		ArkInventory.LDB.Mounts.GetUsable( forceAlternative )
		
		--ArkInventory.Output( #companionTable, " usable mounts", companionTable )
		
		if #companionTable == 0 then
			
			ArkInventory.Output( string.format( ArkInventory.Localise["NONE_USABLE"], ArkInventory.Localise["MOUNTS"] ) )
			return
			
		else
			
			local userandom = me.player.data.ldb.mounts.randomise
			
			if #companionTable <= 3 then
				userandom = false
			end
			
			if userandom then
				-- random
				ArkInventory.LDB.Mounts.next = random( 1, #companionTable )
			else
				-- cycle
				ArkInventory.LDB.Mounts.next = ArkInventory.LDB.Mounts.next + 1
				if ArkInventory.LDB.Mounts.next > #companionTable then
					ArkInventory.LDB.Mounts.next = 1
				end
			end
			
			local i = companionTable[ArkInventory.LDB.Mounts.next]
			--local md = ArkInventory.Collection.Mount.GetMount( i )
			--ArkInventory.Output( "use mount ", i, ": ", md.link, " ", ArkInventory.LDB.Mounts.next, " / ", #companionTable, " / usable=", (IsUsableSpell( md.spellID )), " / flight=", IsFlyableArea( ) )
			ArkInventory.Collection.Mount.Summon( i )
		end
		
	end
	
end
