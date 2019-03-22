local _G = _G
local select = _G.select
local pairs = _G.pairs
local ipairs = _G.ipairs
local string = _G.string
local type = _G.type
local error = _G.error
local table = _G.table


function ArkInventory.TooltipCleanText( txt )
	
	local txt = txt or ""
	
	txt = ArkInventory.StripColourCodes( txt )
	
	txt = txt:gsub( '"', "" )
	txt = txt:gsub( "'", "" )
	
	txt = string.gsub( txt, "\194\160", " " ) -- i dont remember what this is for
	
	txt = string.gsub( txt, "%s", " " )
	txt = string.gsub( txt, "|n", " " )
	txt = string.gsub( txt, "\n", " " )
	txt = string.gsub( txt, "\13", " " )
	txt = string.gsub( txt, "\10", " " )
	txt = string.gsub( txt, "  ", " " )
	
	txt = string.trim( txt )
	
	return txt
	
end

function ArkInventory.TooltipDataReset( tooltip )
	
	if tooltip then
		
		--ArkInventory.Output( tooltip:GetName( ), " has been reset" )
		
		if tooltip.ARKTTD then
			
			if not tooltip.ARKTTD.nopurge then
				wipe( tooltip.ARKTTD.onupdate )
				wipe( tooltip.ARKTTD.args )
			end
			
			tooltip.ARKTTD.nopurge = nil
			
		else
			
			tooltip.ARKTTD = { args = { }, onupdate = { } }
			
		end
		
	end
	
end

function ArkInventory.TooltipScanInit( name )
	
	local tooltip = _G[name]
	assert( tooltip, string.format( "XML Frame [%s] not found", name ) )
	
	ArkInventory.TooltipDataReset( tooltip )
	tooltip.ARKTTD.scan = true
	
	return tooltip
	
end

function ArkInventory.TooltipGetNumLines( tooltip )
	return tooltip:NumLines( ) or 0
end

function ArkInventory.TooltipSetHyperlink( tooltip, h )
	
	tooltip:ClearLines( )
	
	if h then
		
		local osd = ArkInventory.ObjectStringDecode( h )
		
		if osd.class == "item" or osd.class == "spell" or osd.class == "keystone" then
			return tooltip:SetHyperlink( h )
		else
--			ArkInventory.Output( osd.class, " = ", h )
		end
		
	end
	
end

function ArkInventory.TooltipSetBagItem( tooltip, blizzard_id, slot_id )
	
	tooltip:ClearLines( )
	
	return tooltip:SetBagItem( blizzard_id, slot_id )
	
end

function ArkInventory.TooltipSetInventoryItem( tooltip, slot )
	
	tooltip:ClearLines( )
	
	return tooltip:SetInventoryItem( "player", slot )
	
end

function ArkInventory.TooltipSetGuildBankItem( tooltip, tab, slot )
	
	tooltip:ClearLines( )
	
	return tooltip:SetGuildBankItem( tab, slot )
	
end

function ArkInventory.TooltipSetGuildMailboxItem( tooltip, index, attachment )
	
	tooltip:ClearLines( )
	
	return tooltip:SetInboxItem( index, attachment )
	
end

function ArkInventory.TooltipSetItem( tooltip, bag_id, slot_id )
	
	-- not for offline mode, only direct online scanning of the current player
	
	if bag_id == BANK_CONTAINER then
		
		return ArkInventory.TooltipSetInventoryItem( tooltip, BankButtonIDToInvSlotID( slot_id ) )
		
	elseif bag_id == REAGENTBANK_CONTAINER then
		
		return ArkInventory.TooltipSetInventoryItem( tooltip, ReagentBankButtonIDToInvSlotID( slot_id ) )
		
	else
		
		return ArkInventory.TooltipSetBagItem( tooltip, bag_id, slot_id )
		
	end
	
end


function ArkInventory.TooltipBuildReputation( tooltip, h )
	
	if not tooltip then return end
	if not h then return end
	if not ArkInventory:IsEnabled( ) then return end
	if not ArkInventory.db.option.tooltip.show then return end
	
	local osd = ArkInventory.ObjectStringDecode( h )
	
	if osd.class ~= "reputation" then return end
	
	local info = ArkInventory.Collection.Reputation.GetReputation( osd.id )
	if not info then
		ArkInventory.OutputWarning( "no reputation data found for ", osd.id )
		return
	end
	
	tooltip:ClearLines( )
	
	tooltip:AddLine( info.name )
	
	if ArkInventory.db.option.tooltip.reputation.description and ( info.description and info.description ~= "" ) then
		tooltip:AddLine( info.description, 1, 1, 1, true )
	end
	
	tooltip:AddLine( " " )
	local style_default = ArkInventory.Const.Reputation.Style.TooltipNormal
	local style = style_default
	if ArkInventory.db.option.tooltip.reputation.custom ~= ArkInventory.Const.Reputation.Custom.Default then
		style = ArkInventory.db.option.tooltip.reputation.style.normal
		if string.trim( style ) == "" then
			style = style_default
		end
	end
	local txt = ArkInventory.Collection.Reputation.LevelText( osd.id, style )
	tooltip:AddDoubleLine( "", txt, 1, 1, 1, 1, 1, 1 )
	
	tooltip:Show( )
	
	ArkInventory.TooltipAddItemCount( tooltip, h )
	
	ArkInventory.API.CustomReputationTooltipReady( tooltip, h )
	
end


function ArkInventory.TooltipGetMoneyFrame( tooltip )
	
	return _G[string.format( "%s%s", tooltip:GetName( ), "MoneyFrame1" )]
	
end

function ArkInventory.TooltipGetItem( tooltip )
	
	local itemName, ItemLink = tooltip:GetItem( )
	return itemName, ItemLink
	
end

function ArkInventory.TooltipFindBackwards( tooltip, TextToFind, IgnoreLeft, IgnoreRight, CaseSensitive, maxDepth, BaseOnly )
	
	local TextToFind = ArkInventory.TooltipCleanText( TextToFind )
	if TextToFind == "" then
		return false
	end
	
	local IgnoreLeft = IgnoreLeft or false
	local IgnoreRight = IgnoreRight or false
	local CaseSensitive = CaseSensitive or false
	local maxDepth = maxDepth or 0
	local BaseOnly = BaseOnly or false
	
	local obj, txt
	local nextExit = false
	
	for i = ArkInventory.TooltipGetNumLines( tooltip ), 2, -1 do
		
		if nextExit then return end
		
		if maxDepth > 0 and i > maxDepth then return end
		
		obj = _G[string.format( "%s%s%s", tooltip:GetName( ), "TextLeft", i )]
		if obj and obj:IsShown( ) then
			
			txt = obj:GetText( )
			
			if BaseOnly and ( txt == "" or string.find( txt, "^\10" ) or string.find( txt, "^\n" ) or string.find( txt, "^|n" ) ) then
				nextExit = true
			end
			
			if not IgnoreLeft then
				
				txt = ArkInventory.TooltipCleanText( txt )
				
				if CaseSensitive then
					if string.find( txt, TextToFind ) then
						return string.find( txt, TextToFind )
					end
				else
					if string.find( string.lower( txt ), string.lower( TextToFind ) ) then
						return string.find( string.lower( txt ), string.lower( TextToFind ) )
					end
				end
				
			end
			
		end
		
		if not IgnoreRight then
			
			obj = _G[string.format( "%s%s%s", tooltip:GetName( ), "TextRight", i )]
			if obj and obj:IsShown( ) then
				
				txt = ArkInventory.TooltipCleanText( obj:GetText( ) )
				if txt ~= "" then
					
					if CaseSensitive then
						if string.find( txt, TextToFind ) then
							return string.find( txt, TextToFind )
						end
					else
						if string.find( string.lower( txt ), string.lower( TextToFind ) ) then
							return string.find( string.lower( txt ), string.lower( TextToFind ) )
						end
					end
					
				end
				
			end
			
		end
		
	end
	
	return
	
end

function ArkInventory.TooltipFind( tooltip, TextToFind, IgnoreLeft, IgnoreRight, CaseSensitive, maxDepth, BaseOnly )
	
	local TextToFind = ArkInventory.TooltipCleanText( TextToFind )
	if TextToFind == "" then
		return false
	end
	
	local IgnoreLeft = IgnoreLeft or false
	local IgnoreRight = IgnoreRight or false
	local CaseSensitive = CaseSensitive or false
	local maxDepth = maxDepth or 0
	local BaseOnly = BaseOnly or false
	
	local obj, txt
	
	for i = 2, ArkInventory.TooltipGetNumLines( tooltip ) do
		
		if maxDepth > 0 and i > maxDepth then return end
		
		obj = _G[string.format( "%s%s%s", tooltip:GetName( ), "TextLeft", i )]
		if obj and obj:IsShown( ) then
			
			txt = obj:GetText( )
			
			if BaseOnly and ( txt == "" or string.find( txt, "^\10" ) or string.find( txt, "^\n" ) or string.find( txt, "^|n" ) ) then
				return ArkInventory.TooltipFindBackwards( tooltip, TextToFind, IgnoreLeft, IgnoreRight, CaseSensitive, maxDepth, BaseOnly )
			end
			
			if not IgnoreLeft then
				
				txt = ArkInventory.TooltipCleanText( txt )
				
				if CaseSensitive then
					if string.find( txt, TextToFind ) then
						return string.find( txt, TextToFind )
					end
				else
					if string.find( string.lower( txt ), string.lower( TextToFind ) ) then
						return string.find( string.lower( txt ), string.lower( TextToFind ) )
					end
				end
				
			end
			
		end
		
		if not IgnoreRight then
			
			obj = _G[string.format( "%s%s%s", tooltip:GetName( ), "TextRight", i )]
			if obj and obj:IsShown( ) then
				
				txt = ArkInventory.TooltipCleanText( obj:GetText( ) )
				if txt ~= "" then
					
					--ArkInventory.Output( "R[", i, "] = [", txt, "]" )
					
					if CaseSensitive then
						if string.find( txt, TextToFind ) then
							return string.find( txt, TextToFind )
						end
					else
						if string.find( string.lower( txt ), string.lower( TextToFind ) ) then
							return string.find( string.lower( txt ), string.lower( TextToFind ) )
						end
					end
					
				end
				
			end
			
		end
		
	end
	
	return
	
end

function ArkInventory.TooltipGetLine( tooltip, i )

	if not i or i < 1 or i > ArkInventory.TooltipGetNumLines( tooltip ) then
		return
	end
	
	local obj, txt1, txt2
	
	obj = _G[string.format( "%s%s%s", tooltip:GetName( ), "TextLeft", i )]
	if obj and obj:IsShown( ) then
		txt1 = ArkInventory.TooltipCleanText( obj:GetText( ) )
	end
	
	obj = _G[string.format( "%s%s%s", tooltip:GetName( ), "TextRight", i )]
	if obj and obj:IsShown( ) then
		txt2 = ArkInventory.TooltipCleanText( obj:GetText( ) )
	end
	
	return txt1 or "", txt2 or ""
	
end
	
function ArkInventory.TooltipGetBaseStats( tooltip, activeonly )
	
	local obj, txt, ctxt
	
	local started = false
	local rv = ""
	
	for i = 2, ArkInventory.TooltipGetNumLines( tooltip ) do
		
		obj = _G[string.format( "%s%s%s", tooltip:GetName( ), "TextLeft", i )]
		if obj and obj:IsShown( ) then
			
			txt = obj:GetText( )
			ctxt = ArkInventory.TooltipCleanText( txt )
			
			local basestat = false
			if string.find( ctxt, "^%+%d+ " ) then
				--ArkInventory.Output( "1 - ", ctxt )
				basestat = true
			else
				for k, v in pairs( ArkInventory.Const.ItemStats ) do
					local searchtxt = string.format( "^%s$", v )
					if string.find( ctxt, searchtxt ) then
						--ArkInventory.Output( "2 - ", ctxt )
						basestat = true
						break
					end
				end
			end
			
			if started and ( txt == "" or string.find( txt, "^\10" ) or string.find( txt, "^\n" ) or string.find( txt, "^|n" ) or not basestat ) then
				--ArkInventory.Output( "X - ", ctxt )
				return rv
			end
			
			if basestat then
				started = true
				local r, g, b = obj:GetTextColor( )
				local c = string.format( "%02x%02x%02x", r * 255, g * 255, b * 255 )
				--ArkInventory.Output( string.format( "%02i = %s %s", i, c, txt ) )
				if not activeonly or ( activeonly and c ~= "7f7f7f" ) then
					--ArkInventory.Output( "A - ", ctxt )
					rv = rv .. " " .. ctxt
				end
			end
			
			--ArkInventory.Output( "Z - ", ctxt )
			
		end
		
	end
	
	return rv
	
	-- /run ArkInventory.TooltipGetBaseStats( GameTooltip )
	-- /run ArkInventory.TooltipGetBaseStats( GameTooltip, true )
	
end

function ArkInventory.TooltipContains( tooltip, TextToFind, IgnoreLeft, IgnoreRight, CaseSensitive, BaseOnly )
	
	if ArkInventory.TooltipFind( tooltip, TextToFind, IgnoreLeft, IgnoreRight, CaseSensitive, 0, BaseOnly ) then
		return true
	else
		return false
	end
	
end

function ArkInventory.TooltipCanUseBackwards( tooltip, ignoreknown )

	local l = { "TextLeft", "TextRight" }
	
	local n = ArkInventory.TooltipGetNumLines( tooltip )
	
	for i = n, 2, -1 do
		for _, v in pairs( l ) do
			local obj = _G[string.format( "%s%s%s", tooltip:GetName( ), v, i )]
			if obj and obj:IsShown( ) then
				
				local txt = obj:GetText( )
				
				if txt == "" or string.find( txt, "^\10" ) or string.find( txt, "^\n" ) or string.find( txt, "^|n" ) then
					return true
				end
				
				local txt = ArkInventory.TooltipCleanText( txt )
				
				local r, g, b = obj:GetTextColor( )
				local c = string.format( "%02x%02x%02x", r * 255, g * 255, b * 255 )
				if c == "fe1f1f" then
					
					if txt == ArkInventory.Localise["ALREADY_KNOWN"] then
						
						--ArkInventory.Output( "line[", i, "]=[", txt, "] backwards" )
						if not ignoreknown then
							return false
						end
					
					elseif not ( txt == ArkInventory.Localise["ITEM_NOT_DISENCHANTABLE"] or txt == ArkInventory.Localise["PREVIOUS_RANK_UNKNOWN"] or txt == ArkInventory.Localise["TOOLTIP_NOT_READY"] ) then
						
						--ArkInventory.Output( "line[", i, "]=[", txt, "] backwards" )
						return false
						
					end
					
				end

			end
		end
	end

	return true
	
end

function ArkInventory.TooltipCanUse( tooltip, ignoreknown )

	local l = { "TextLeft", "TextRight" }
	
	local n = ArkInventory.TooltipGetNumLines( tooltip )
	
	local t1 = tooltip:GetItem( )
	local line1 = _G[string.format( "%sTextLeft1", tooltip:GetName( ) )]:GetText( )
	
	for i = 2, n do
		for _, v in pairs( l ) do
			
			local obj = _G[string.format( "%s%s%s", tooltip:GetName( ), v, i )]
			if obj and obj:IsShown( ) then
				
				local txt = obj:GetText( )
				
				if txt == "" or string.find( txt, "^\10" ) or string.find( txt, "^\n" ) or string.find( txt, "^|n" ) then
					return ArkInventory.TooltipCanUseBackwards( tooltip, ignoreknown )
				end
				
				txt = ArkInventory.TooltipCleanText( txt )
				
				local r, g, b = obj:GetTextColor( )
				local c = string.format( "%02x%02x%02x", r * 255, g * 255, b * 255 )
				if c == "fe1f1f" then
					
					if txt == ArkInventory.Localise["ALREADY_KNOWN"] then
						
						--ArkInventory.Output( "line[", i, "]=[", txt, "] forwards" )
						if not ignoreknown then
							return false
						end
					
					elseif not ( txt == ArkInventory.Localise["ITEM_NOT_DISENCHANTABLE"] or txt == ArkInventory.Localise["PREVIOUS_RANK_UNKNOWN"] or txt == ArkInventory.Localise["TOOLTIP_NOT_READY"] ) then
						
						--ArkInventory.Output( "line[", i, "]=[", txt, "] forwards" )
						return false
						
					end
					
				end

			end
		end
	end

	return true
	
end

function ArkInventory.TooltipIsReady( tooltip )
	local txt = ArkInventory.TooltipGetLine( tooltip, 1 )
	if txt ~= "" and txt ~= ArkInventory.Localise["TOOLTIP_NOT_READY"] then
		return true
	end
end




function ArkInventory.HookTooltipSetAuctionItem( tooltip, ... )
	
--	checked ok - 3.08.
	
	if not tooltip then return end
	if not ArkInventory:IsEnabled( ) then return end
	if not ArkInventory.db.option.tooltip.show then return end
	if not ArkInventory.db.option.tooltip.add.count then end
	
	local fn = "SetAuctionItem"
	
	--ArkInventory.Output( "0 - ", tooltip:GetName( ), ":", fn )
	
	ArkInventory.SaveTooltipOnUpdateData( tooltip, fn, ... )
	
	local arg1, arg2 = ...

	if arg1 and arg2 then
		local h = GetAuctionItemLink( arg1, arg2 )
		ArkInventory.TooltipAddItemCount( tooltip, h )
	end
	
end

function ArkInventory.HookTooltipSetAuctionSellItem( ... )
	ArkInventory.HookTooltipSetGeneric( "SetAuctionSellItem", ... )
end

function ArkInventory.HookTooltipSetBagItem( ... )
	ArkInventory.HookTooltipSetGeneric( "SetBagItem", ... )
end

function ArkInventory.HookTooltipSetCraftItem( ... )
	ArkInventory.HookTooltipSetGeneric( "SetCraftItem", ... )
end

function ArkInventory.HookTooltipSetCraftSpell( ... )
	ArkInventory.HookTooltipSetGeneric( "SetCraftSpell", ... )
end

function ArkInventory.HookTooltipSetCurrencyTokenByID( ... )
	ArkInventory.HookTooltipSetGeneric( "SetCurrencyTokenByID", ... )
end

function ArkInventory.HookTooltipSetGuildBankItem( ... )
	ArkInventory.HookTooltipSetGeneric( "SetGuildBankItem", ... )
end

function ArkInventory.HookTooltipSetHeirloomByItemID( ... )
	ArkInventory.HookTooltipSetGeneric( "SetHeirloomByItemID", ... )
end

function ArkInventory.ReloadTooltipSetHyperlink( tooltip, ... )
	
	local arg1 = ...
	
	if arg1 then
		
		local osd = ArkInventory.ObjectStringDecode( arg1 )
		if osd.class == "item" or osd.class == "spell" or osd.class == "battlepet" or osd.class == "keystone" or osd.class == "currency" or osd.class == "reputation" or osd.class == "copper" or osd.class == "empty" then
			
			-- cant set the same hyperlink twice or it will close the tooltip, so clear it first
			tooltip.ARKTTD.nopurge = true
			tooltip:ClearLines( )
			ArkInventory.ReloadTooltipSetGeneric( tooltip )
			
		end
		
	end
	
end

function ArkInventory.HookTooltipSetHyperlink( ... )
	ArkInventory.HookTooltipSetGeneric( "SetHyperlink", ... )
end

function ArkInventory.HookTooltipSetHyperlinkCompareItem( ... )
	ArkInventory.HookTooltipSetGeneric( "SetHyperlinkCompareItem", ... )
end

function ArkInventory.HookTooltipSetInboxItem( ... )
	ArkInventory.HookTooltipSetGeneric( "SetInboxItem", ... )
end

function ArkInventory.HookTooltipSetInventoryItem( ... )
	ArkInventory.HookTooltipSetGeneric( "SetInventoryItem", ... )
end

function ArkInventory.HookTooltipSetItemByID( ... )
	ArkInventory.HookTooltipSetGeneric( "SetItemByID", ... )
end

function ArkInventory.HookTooltipSetLootItem( ... )
	ArkInventory.HookTooltipSetGeneric( "SetLootItem", ... )
end

function ArkInventory.HookTooltipSetLootRollItem( ... )
	ArkInventory.HookTooltipSetGeneric( "SetLootRollItem", ... )
end

function ArkInventory.HookTooltipSetMerchantItem( ... )
	ArkInventory.HookTooltipSetGeneric( "SetMerchantItem", ... )
end

function ArkInventory.HookTooltipSetBuybackItem( ... )
	ArkInventory.HookTooltipSetGeneric( "SetBuybackItem", ... )
end

function ArkInventory.HookTooltipSetMerchantCostItem( ... )
	ArkInventory.HookTooltipSetGeneric( "SetMerchantCostItem", ... )
end

function ArkInventory.HookTooltipSetQuestItem( ... )
	ArkInventory.HookTooltipSetGeneric( "SetQuestItem", ... )
end

function ArkInventory.HookTooltipSetQuestLogItem( ... )
	ArkInventory.HookTooltipSetGeneric( "SetQuestLogItem", ... )
end

function ArkInventory.HookTooltipSetQuestLogSpecialItem( ... )
	ArkInventory.HookTooltipSetGeneric( "SetQuestLogSpecialItem", ... )
end

function ArkInventory.HookTooltipSetQuestCurrency( tooltip, ... )
	
	-- some of these get their onupdate set in onenter
	-- so run with mine, then the blizzard one will kick in (just faster)
	
	if not tooltip then return end
	if not ArkInventory:IsEnabled( ) then return end
	if not ArkInventory.db.option.tooltip.show then return end
	if not ArkInventory.db.option.tooltip.add.count then end
	
	local fn = "SetQuestCurrency"
	
	--ArkInventory.Output( "0 - ", tooltip:GetName( ), ":", fn )
	
	ArkInventory.SaveTooltipOnUpdateData( tooltip, fn, ... )
	
	local arg1, arg2 = ...

	if arg1 and arg2 then
		local name = GetQuestCurrencyInfo( arg1, arg2 )
		local id, object = ArkInventory.Collection.Currency.GetCurrencyByName( name )
		if object then
			ArkInventory.TooltipAddItemCount( tooltip, object.link )
		end
	end
	
end

function ArkInventory.HookTooltipSetQuestLogCurrency( ... )
	ArkInventory.HookTooltipSetGeneric( "SetQuestLogCurrency", ... )
end

function ArkInventory.HookTooltipLogCurrency( ... )
	ArkInventory.HookTooltipSetGeneric( "HookLogCurrency", ... )
end

function ArkInventory.HookTooltipSetSendMailItem( ... )
	ArkInventory.HookTooltipSetGeneric( "SetSendMailItem", ... )
end

function ArkInventory.HookTooltipSetTradePlayerItem( ... )
	ArkInventory.HookTooltipSetGeneric( "SetTradePlayerItem", ... )
end

function ArkInventory.HookTooltipSetTradeTargetItem( ... )
	ArkInventory.HookTooltipSetGeneric( "SetTradeTargetItem", ... )
end

function ArkInventory.HookTooltipSetVoidDepositItem( ... )
	ArkInventory.HookTooltipSetGeneric( "SetVoidDepositItem", ... )
end

function ArkInventory.HookTooltipSetVoidItem( ... )
	ArkInventory.HookTooltipSetGeneric( "SetVoidItem", ... )
end

function ArkInventory.HookTooltipSetVoidWithdrawalItem( ... )
	ArkInventory.HookTooltipSetGeneric( "SetVoidWithdrawalItem", ... )
end

function ArkInventory.HookTooltipSetQuestLogRewardSpell( ... )
	ArkInventory.HookTooltipSetGeneric( "SetQuestLogRewardSpell", ... )
end

function ArkInventory.HookTooltipSetQuestRewardSpell( ... )
	ArkInventory.HookTooltipSetGeneric( "SetQuestRewardSpell", ... )
end

function ArkInventory.HookTooltipSetCurrencyByID( tooltip, ... )
	
--	checked ok - 3.08.
	
	if not tooltip then return end
	if not ArkInventory:IsEnabled( ) then return end
	if not ArkInventory.db.option.tooltip.show then return end
	if not ArkInventory.db.option.tooltip.add.count then end
	
	local fn = "SetCurrencyByID"
	
	--ArkInventory.Output( "0 - ", tooltip:GetName( ), ":", fn )
	
	ArkInventory.SaveTooltipOnUpdateData( tooltip, fn, ... )
	
	local arg1, arg2 = ...
	
	if arg1 then
		local h = GetCurrencyLink( arg1, 1 )
		ArkInventory.TooltipAddItemCount( tooltip, h )
	end
	
end

function ArkInventory.HookTooltipSetBackpackToken( tooltip, ... )
	
--	checked ok - 3.08.
	
	if not tooltip then return end
	if not ArkInventory:IsEnabled( ) then return end
	if not ArkInventory.db.option.tooltip.show then return end
	if not ArkInventory.db.option.tooltip.add.count then end
	
	local fn = "SetBackpackToken"
	
	--ArkInventory.Output( "0 - ", tooltip:GetName( ), ":", fn )
	
	ArkInventory.SaveTooltipOnUpdateData( tooltip, fn, ... )
	
	local arg1 = ...

	if arg1 then
		
		local name, count, icon, currencyID = GetBackpackCurrencyInfo( arg1 )
		
		if currencyID then
			local h = GetCurrencyLink( currencyID, 0 )
			ArkInventory.TooltipAddItemCount( tooltip, h )
		end
		
	end
	
end

function ArkInventory.HookTooltipSetCurrencyToken( tooltip, ... )
	
	if not tooltip then return end
	if not ArkInventory:IsEnabled( ) then return end
	if not ArkInventory.db.option.tooltip.show then return end
	if not ArkInventory.db.option.tooltip.add.count then end
	
	local fn = "SetCurrencyToken"
	
	--ArkInventory.Output( "0 - ", tooltip:GetName( ), ":", fn )
	
	ArkInventory.SaveTooltipOnUpdateData( tooltip, fn, ... )
	
	local arg1 = ...
	
	if arg1 then
		local h = GetCurrencyListLink( arg1 )
		ArkInventory.TooltipAddItemCount( tooltip, h )
	end
	
end

function ArkInventory.HookTooltipSetRecipeReagentItem( tooltip, ... )
	
--	checked ok - 3.08.09
	
	if not tooltip then return end
	if not ArkInventory:IsEnabled( ) then return end
	if not ArkInventory.db.option.tooltip.show then return end
	if not ArkInventory.db.option.tooltip.add.count then end
	
	local fn = "SetRecipeReagentItem"
	
	--ArkInventory.Output( "0 - ", tooltip:GetName( ), ":", fn )
	
	ArkInventory.SaveTooltipOnUpdateData( tooltip, fn, ... )
	
	local arg1, arg2 = ...
	
	if arg1 and arg2 then
		local h = C_TradeSkillUI.GetRecipeReagentItemLink( arg1, arg2 )
		ArkInventory.TooltipAddItemCount( tooltip, h )
	end
	
end

function ArkInventory.HookTooltipSetRecipeResultItem( tooltip, ... )
	
--	checked ok - 3.08.09
	
	if not tooltip then return end
	if not ArkInventory:IsEnabled( ) then return end
	if not ArkInventory.db.option.tooltip.show then return end
	if not ArkInventory.db.option.tooltip.add.count then end
	
	local fn = "SetRecipeResultItem"
	
	--ArkInventory.Output( "0 - ", tooltip:GetName( ), ":", fn )
	
	ArkInventory.SaveTooltipOnUpdateData( tooltip, fn, ... )
	
	local arg1 = ...
	
	if arg1 then
		local h = C_TradeSkillUI.GetRecipeItemLink( arg1 )
		ArkInventory.TooltipAddItemCount( tooltip, h )
	end

end

function ArkInventory.ReloadTooltipSetToyByItemID( tooltip, ... )
	
--	checked ok - 3.08.09
	
	local arg1 = ...
	
	if arg1 then
		
		-- need to manually clear lines as settoybyitemid doesnt seem to do it
		tooltip.ARKTTD.nopurge = true
		tooltip:ClearLines( )
		ArkInventory.ReloadTooltipSetGeneric( tooltip )
		
	end
	
end

function ArkInventory.HookTooltipSetToyByItemID( tooltip, ... )
	
--	checked ok - 3.08.09
	
	if not tooltip then return end
	if not ArkInventory:IsEnabled( ) then return end
	if not ArkInventory.db.option.tooltip.show then return end
	if not ArkInventory.db.option.tooltip.add.count then end
	
	local fn = "SetToyByItemID"
	
	--ArkInventory.Output( "0 - ", tooltip:GetName( ), ":", fn )
	
	ArkInventory.SaveTooltipOnUpdateData( tooltip, fn, ... )
	
	local arg1 = ...
	
	if arg1 then
		local h = C_ToyBox.GetToyLink( arg1 )
		ArkInventory.TooltipAddItemCount( tooltip, h )
	end
	
end


function ArkInventory.TooltipAddBattlepetDetail( tooltip, speciesID, i )
	
--	checked ok - 3.08.
	
	--ArkInventory.Output( "0 - TooltipAddBattlepetDetail" )
	
	if not tooltip then return end
	if not ArkInventory:IsEnabled( ) then return end
	if not ArkInventory.db.option.tooltip.show then return end
	if not ArkInventory.db.option.tooltip.battlepet.enable then return end
	
	if not speciesID then return end
	
	local h = string.format( "battlepet:%s", speciesID )
	
	ArkInventory.TooltipAddEmptyLine( tooltip )
	
	local numOwned, maxAllowed = C_PetJournal.GetNumCollectedInfo( speciesID )
	local info = ""
	
	if numOwned == 0 then
		info = ArkInventory.Localise["NOT_COLLECTED"]
	else
		info = string.format( ITEM_PET_KNOWN, numOwned, maxAllowed )
	end
	
	tooltip:AddLine( info )
	
	local tt = { }
	for _, pd in ArkInventory.Collection.Pet.Iterate( ) do
		if ( pd.sd.speciesID == speciesID ) then
			tt[#tt  + 1] = pd
		end
	end
	
	if ( i and numOwned > 1 ) or ( not i and numOwned > 0 ) then
		
		for k, pd in pairs( tt ) do
			
			info = ""
			
			local c = select( 5, ArkInventory.GetItemQualityColor( pd.rarity ) )
			info = string.format( "%s%s%s|r%s", info, c, _G[string.format( "ITEM_QUALITY%d_DESC", pd.rarity )], "|TInterface\\PetBattles\\PetBattle-StatIcons:0:0:0:0:32:32:16:32:0:16|t" )
			
			info = string.format( "%s  %s%s", info, pd.level, "|TInterface\\PetBattles\\BattleBar-AbilityBadge-Strong-Small:0|t" )
			
			if pd.sd.canBattle then
				
				local iconPetAlive = "|TInterface\\PetBattles\\PetBattle-StatIcons:0:0:0:0:32:32:16:32:16:32|t"
				local iconPetDead = "|TInterface\\Scenarios\\ScenarioIcon-Boss:0|t"
				if ( pd.health <= 0 ) then
					info = string.format( "%s  %.0f%s", info, pd.maxHealth, iconPetDead )
				else
					info = string.format( "%s  %.0f%s", info, pd.maxHealth, iconPetAlive )
				end
		
				info = string.format( "%s  %.0f%s", info, pd.power, "|TInterface\\PetBattles\\PetBattle-StatIcons:0:0:0:0:32:32:0:16:0:16|t" )
				info = string.format( "%s  %.0f%s", info, pd.speed, "|TInterface\\PetBattles\\PetBattle-StatIcons:0:0:0:0:32:32:0:16:16:32|t" )
				
				if pd.breed then
					info = string.format( "%s  %s", info, pd.breed )
				end
				
				if ( not i ) or ( i and i.guid ~= pd.guid ) then
					tooltip:AddLine( info )
				end
				
			end
			
		end
		
	end
	
	tooltip:AppendText( "" )
	
	ArkInventory.TooltipAddItemCount( tooltip, h )
	
end


function ArkInventory.TooltipBuildBattlepet( tooltip, h, i )
	
--	checked ok - 3.08.10
	
	if not tooltip then return end
	if not h then return end
	if not ArkInventory:IsEnabled( ) then return end
	if not ArkInventory.db.option.tooltip.show then return end
	
	--ArkInventory.Output( "0 - TooltipBuildBattlepet" )
	
	ArkInventory.TooltipDataReset( tooltip )

	-- mouseover pet items, and clicking on pet links
	-- unit mouseover tooltip for wild adn character pets is done at HookTooltipOnSetUnit, not here
	
	local osd = ArkInventory.ObjectStringDecode( h )
	
	if osd.class ~= "battlepet" then return end
	
	--ArkInventory.Output( "[", osd.class, " : ", osd.id, " : ", osd.level, " : ", osd.q, " : ", osd.maxhealth, " : ", osd.power, " : ", osd.speed, "]" )
	
	if not ArkInventory.db.option.tooltip.battlepet.enable then
		BattlePetToolTip_Show( osd.id, osd.level, osd.q, osd.maxhealth, osd.power, osd.speed )
		return
	end
	
	local sd = ArkInventory.Collection.Pet.GetSpeciesInfo( osd.id )
	if not sd then
		--ArkInventory.OutputWarning( "no species data found for ", osd.id )
		return
	end
	
	
	local name = sd.name
	local pd
	local rarity = osd.q
	
	if i and i.index then
		pd = ArkInventory.Collection.Pet.GetPet( i.index )
		if pd then
			if rarity == -1 then
				rarity = pd.rarity
			end
			name = pd.fullname
		end
	end
	
	tooltip:ClearLines( )
	
	if sd.isWild then
		name = string.format( "%s%s|r", select( 5, ArkInventory.GetItemQualityColor( rarity ) ), name )
	end
	
	tooltip:AddLine( string.format( "|T%s:32:32:-4:4:128:256:64:100:130:166|t %s", GetPetTypeTexture( sd.petType ), name ) )
	
	if ArkInventory.db.option.tooltip.battlepet.source then
		if sd.sourceText and sd.sourceText ~= "" then
			tooltip:AddLine( sd.sourceText, 1, 1, 1, true )
		end
	end
	
	if ( not sd.isTradable ) then
		tooltip:AddLine( BATTLE_PET_NOT_TRADABLE, 1, 0.1, 0.1, true )
	end
	
	if sd.unique then
		tooltip:AddLine( ITEM_UNIQUE, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true )
	end
	
	if ArkInventory.db.option.tooltip.battlepet.description and ( sd.description and sd.description ~= "" ) then
		tooltip:AddLine( " " )
		tooltip:AddLine( sd.description, nil, nil, nil, true )
	end
	
	if sd.canBattle then
		
		tooltip:AddLine( " " )
		
		local txt1 = LEVEL
		local txt2 = string.format( "%s %s", osd.level, "|TInterface\\PetBattles\\BattleBar-AbilityBadge-Strong-Small:0|t" )
		if pd and pd.xp and pd.maxXp and pd.xp > 0 then
			
			local pc = pd.xp / pd.maxXp * 100
			if pc < 1 then
				pc = 1
			elseif pc > 99 then
				pc = 99
			end
			
			txt1 = string.format( "%s (%d%%)", txt1, pc )
			
		end
		tooltip:AddDoubleLine( txt1, txt2 )
		
		
		local iconPetAlive = "|TInterface\\PetBattles\\PetBattle-StatIcons:0:0:0:0:32:32:16:32:16:32|t"
		local iconPetDead = "|TInterface\\Scenarios\\ScenarioIcon-Boss:0|t"
		txt1 = PET_BATTLE_STAT_HEALTH
		if pd and pd.health and ( pd.health <= 0 ) then
			
			txt1 = string.format( "%s (%s)", txt1, DEAD )
			txt2 = string.format( "%s %s", osd.maxhealth, iconPetDead )
			
		else
			
			if pd and ( pd.health ~= osd.maxhealth ) then
				
				local pc = pd.health / osd.maxhealth * 100
				if pc < 1 then
					pc = 1
				elseif pc > 99 then
					pc = 99
				end
				
				txt1 = string.format( "%s (%d%%)", txt1, pc )
				
			end
			
			txt2 = string.format( "%s %s", osd.maxhealth, iconPetAlive )
			
		end
		tooltip:AddDoubleLine( txt1, txt2 )
		
		
		-- |TTexturePath:size1:size2:offset-x:offset-y:original-size-x:original-size-y:crop-x1:crop-x2:crop-y1:crop-y2|t
		tooltip:AddDoubleLine( PET_BATTLE_STAT_POWER, string.format( "%s %s", osd.power, "|TInterface\\PetBattles\\PetBattle-StatIcons:0:0:0:0:32:32:0:16:0:16|t" ) )
		
		
		tooltip:AddDoubleLine( PET_BATTLE_STAT_SPEED, string.format( "%s %s", osd.speed, "|TInterface\\PetBattles\\PetBattle-StatIcons:0:0:0:0:32:32:0:16:16:32|t" ) )
		
		
		if ( not sd.isWild ) and ( rarity ~= -1 ) then
			-- only need this for system pets as the wild pets have their names colour coded
			-- ignore the -1, those will be from other peoples links and we cant get at that data
			local c = select( 5, ArkInventory.GetItemQualityColor( rarity ) )
			tooltip:AddDoubleLine( PET_BATTLE_STAT_QUALITY, string.format( "%s%s %s", c, _G[string.format( "ITEM_QUALITY%d_DESC", rarity )], "|TInterface\\PetBattles\\PetBattle-StatIcons:0:0:0:0:32:32:16:32:0:16|t" ) )
		end

	else
		
		tooltip:AddLine( ArkInventory.Localise["PET_CANNOT_BATTLE"], 1.0, 0.1, 0.1, true )
		
	end
	
	tooltip:Show( )
	
	ArkInventory.TooltipAddBattlepetDetail( tooltip, osd.id, i )
	
	ArkInventory.API.CustomBattlePetTooltipReady( tooltip, h, unpack( ArkInventory.ObjectStringDecode( h ) ) )
	
end

function ArkInventory.HookBattlePetToolTip_Show( ... )
	
--	checked ok - 3.08.
	
	-- speciesID, level, breedQuality, maxHealth, power, speed, customName
	
	if not ArkInventory:IsEnabled( ) then return end
	if not ArkInventory.db.option.tooltip.show then return end
	if not ArkInventory.db.option.tooltip.battlepet.enable then return end
	
	--ArkInventory.Output( "0 - HookBattlePetToolTip_Show" )
	
	local h = ArkInventory.BattlepetBaseHyperlink( ... )
	
	BattlePetTooltip:Hide( )
	
	-- anchor gametooltip to whatever originally called it
	ArkInventory.GameTooltipSetPosition( GetMouseFocus( ) )
	ArkInventory.TooltipBuildBattlepet( GameTooltip, h )
	
end


function ArkInventory.ReloadTooltipOnSetUnit( tooltip, ... )
	
	local arg1 = ...
	
	--ArkInventory.Output( "4 - ReloadTooltipOnSetUnit( ", arg1, " )" )
	
	if arg1 and ( UnitIsWildBattlePet( arg1 ) or UnitIsOtherPlayersBattlePet( arg1 ) or UnitIsBattlePetCompanion( arg1 ) ) then
		
		tooltip:SetUnit( arg1, arg2 )
		
		local speciesID = UnitBattlePetSpeciesID( arg1 )
		
		if speciesID then
			
			local sd = ArkInventory.Collection.Pet.GetSpeciesInfo( speciesID )
			
			if sd then
				
				if ArkInventory.db.option.tooltip.battlepet.mouseover.source and sd.sourceText and sd.sourceText ~= "" then
					tooltip:AddLine( " " )
					tooltip:AddLine( sd.sourceText, nil, nil, nil, true )
				end
				
				if ArkInventory.db.option.tooltip.battlepet.mouseover.description and sd.description and sd.description ~= "" then
					tooltip:AddLine( " " )
					tooltip:AddLine( sd.description, nil, nil, nil, true )
				end
				
			end
			
			tooltip:AppendText( "" )
			
			ArkInventory.TooltipAddBattlepetDetail( tooltip, speciesID )
			
		end
		

	else
		
		ArkInventory.TooltipDataReset( tooltip )
		
	end
	
end

function ArkInventory.HookTooltipOnSetUnit( tooltip, ... )
	
--	checked ok - 3.08.
	
	if not tooltip then return end
	if not ArkInventory:IsEnabled( ) then return end
	if not ArkInventory.db.option.tooltip.show then return end
	if not ArkInventory.db.option.tooltip.battlepet.mouseover.enable then return end
	
	local fn = "OnSetUnit"
	
	--ArkInventory.Output( "0 - ", tooltip:GetName( ), ":", fn )
	
	--ArkInventory.SaveTooltipOnUpdateData( tooltip, fn, ... )
	ArkInventory.TooltipDataReset( tooltip )
	
	local name, unit = tooltip:GetUnit( )
	
	tooltip.ARKTTD.onupdate.fn = fn
	tooltip.ARKTTD.args[1] = unit
	
	--ArkInventory.Output( fn, " = ", unit )
	
end

function ArkInventory.HookTooltipOnSetItem( ... )
	
--	checked ok - 3.08.
	
	local tooltip = ...
	
	if not tooltip then return end
	if not ArkInventory:IsEnabled( ) then return end
	if not ArkInventory.db.option.tooltip.show then return end
	if not ArkInventory.db.option.tooltip.battlepet.mouseover.enable then return end
	
	local fn = "OnSetItem"
	
	--ArkInventory.Output( "0 - ", tooltip:GetName( ), ":", fn )
	
	ArkInventory.TooltipDataReset( tooltip )
	
end

function ArkInventory.HookTooltipOnSetSpell( ... )
	
--	checked ok - 3.08.
	
	local tooltip = ...
	
	if not tooltip then return end
	if not ArkInventory:IsEnabled( ) then return end
	if not ArkInventory.db.option.tooltip.show then return end
	if not ArkInventory.db.option.tooltip.battlepet.mouseover.enable then return end
	
	local fn = "OnSetSpell"
	
	--ArkInventory.Output( "0 - ", tooltip:GetName( ), ":", fn )
	
	ArkInventory.TooltipDataReset( tooltip )
	
end





function ArkInventory.HookTooltipFadeOut( tooltip )
	--ArkInventory.Output( "FadeOut" )
	ArkInventory.TooltipDataReset( tooltip )
end

function ArkInventory.HookTooltipClearLines( tooltip )
	--ArkInventory.Output( "ClearLines" )
	ArkInventory.TooltipDataReset( tooltip )
end

function ArkInventory.HookTooltipSetText( tooltip )
	
	if not tooltip then return end
	if not ArkInventory:IsEnabled( ) then return end
	if not ArkInventory.db.option.tooltip.show then return end
	
--	ArkInventory.Output( "SetText" )
	ArkInventory.TooltipDataReset( tooltip )
	
end

function ArkInventory.HookTooltipOnHide( tooltip )
	
	if not tooltip then return end
	if not ArkInventory:IsEnabled( ) then return end
	if not ArkInventory.db.option.tooltip.show then return end
	
	--ArkInventory.Output( "OnHide" )
	ArkInventory.TooltipDataReset( tooltip )
	
end





function ArkInventory.TooltipGetItemOrSpell( tooltip )
	
	-- generic input, generic reload
	-- typically an item or spell has been set directly so no special handling is required
	
	if not tooltip:IsVisible( ) then
		-- dont add stuff to tooltips until after they become visible for the first time
		-- some of them just dont like it and it can stuff up the formatting
		return
	end
	
	local h
	
	if not h and tooltip["GetItem"] then
		
		local name, link = tooltip:GetItem( )
		--ArkInventory.Output( "[", name, "] = ", string.gsub( link, "\124", "\124\124" ) )
		
		-- check for broken hyperlink bug
		if name and name ~= "" then
			h = link
		end
		
	end
	
	if not h and tooltip["GetSpell"] then
		
		local name, rank, id = tooltip:GetSpell( )
		
		if id then
			h = GetSpellLink( id )
			--ArkInventory.Output( "GetSpell = ", h )
		end
		
	end
	
	if not h then return end
	
	ArkInventory.TooltipAddItemCount( tooltip, h )
	
end

function ArkInventory.ReloadTooltipSetGeneric( tooltip )
	
	local fn = tooltip.ARKTTD.onupdate.fn
	
	if fn then
		
		if tooltip[fn] then
			
			-- check for item comparison
			local compare = false
			
			if GetCVarBool( "alwaysCompareItems" ) then
				
				--ArkInventory.Output( "always compare" )
				compare = true
				
			elseif tooltip.comparing then
				
				--ArkInventory.Output( "comparing" )
				
				if IsModifiedClick( "COMPAREITEMS" ) then
					--ArkInventory.Output( "shift key still down" )
					compare = true
				else
					--ArkInventory.Output( "stop comparing" )
					tooltip.comparing = false
				end
				
			elseif IsModifiedClick( "COMPAREITEMS" ) then
				
				--ArkInventory.Output( "shift key down" )
				compare = true
				tooltip.comparing = true
				
			else
				
				if tooltip.shoppingTooltips then
					
					local shoppingTooltip1, shoppingTooltip2 = unpack( tooltip.shoppingTooltips )
					
					if shoppingTooltip1:IsShown( ) or shoppingTooltip2:IsShown( ) then
						--ArkInventory.Output( "shopping tooltips open" )
						compare = true
					end
					
				end
				
			end
			
			--ArkInventory.Output( "G9 - ", tooltip:GetName( ), ":", fn, "( ", tooltip.ARKTTD.args, " )" )
			tooltip[fn]( tooltip, unpack( tooltip.ARKTTD.args ) )
			
			-- compare if required
			if compare then
				GameTooltip_ShowCompareItem( )
			end

		else
			
			--ArkInventory.OutputError( "non fatal code issue - ", tooltip:GetName( ), " does not have a function named [", fn, "]" )
			
		end
		
	end
end

function ArkInventory.HookTooltipSetGeneric( fn, tooltip, ... )
	
	if not fn then return end
	if not tooltip then return end
	if not ArkInventory:IsEnabled( ) then return end
	if not ArkInventory.db.option.tooltip.show then return end
	if not ArkInventory.db.option.tooltip.add.count then end
	
	if tooltip.ARKTTD.scan then return end
	
	--ArkInventory.Output( "G0 - ", tooltip:GetName( ), ":", fn, "( ", arg1, ", ", arg2, ", ", arg3, ", ", arg4, " )" )
	
	ArkInventory.SaveTooltipOnUpdateData( tooltip, fn, ... )
	
	ArkInventory.TooltipGetItemOrSpell( tooltip )
	
end

function ArkInventory.SaveTooltipOnUpdateData( tooltip, fn, ... )
	
	ArkInventory.TooltipDataReset( tooltip )
	
	tooltip.ARKTTD.onupdate.fn = fn
	tooltip.ARKTTD.onupdate.timer = ArkInventory.Const.TOOLTIP_UPDATE_TIME
	
	local ac = select( '#', ... )
	for ax = 1, ac do
		tooltip.ARKTTD.args[ax] = ( select( ax, ... ) )
	end
	
end

function ArkInventory.HookTooltipOnUpdate( tooltip, elapsed )
	
	if not tooltip then return end
	
	tooltip.ARKTTD.onupdate.timer = ( tooltip.ARKTTD.onupdate.timer or ArkInventory.Const.TOOLTIP_UPDATE_TIME ) - elapsed
	if tooltip.ARKTTD.onupdate.timer > 0 then
		return
	end
	
	tooltip.ARKTTD.onupdate.timer = ArkInventory.Const.TOOLTIP_UPDATE_TIME
	
	if not ArkInventory:IsEnabled( ) then return end
	if not ArkInventory.db.option.tooltip.show then return end
	
	local owner = tooltip:GetOwner( )
	if ( not tooltip.UpdateTooltip ) and not ( owner and owner.UpdateTooltip ) then
		
		-- blizzards code runs the UpdateTooltip function of the tooltip
		-- if it doesnt have one it will check if the tooltips owner has one set and use that
		-- so dont set ours unless both are false
		
		local fn = tooltip.ARKTTD.onupdate.fn
		if fn then
			
			--ArkInventory.Output( tooltip:GetName( ), ":OnUpdate - ", fn, "( ", tooltip.ARKTTD.args, " )" )
			
			local rfn = "ReloadTooltip"..fn
			if ArkInventory[rfn] then
				ArkInventory[rfn]( tooltip, unpack( tooltip.ARKTTD.args ) )
			else
				ArkInventory.ReloadTooltipSetGeneric( tooltip )
				--ArkInventory.Output( "ArkInventory.", rfn, " does not exist" )
			end
			
		else
			
			--ArkInventory.Output( "nothing to do" )
			
		end
		
	else
		
		--ArkInventory.Output( tooltip:GetName( ), " or its owner has an onupdate" )
		
	end
	
	--ArkInventory.TooltipDataReset( tooltip )
	
end






function ArkInventory.TooltipAddEmptyLine( tooltip )
	if ArkInventory.db.option.tooltip.add.empty then
		tooltip:AddLine( " ", 1, 1, 1, 0 )
	end
end

function ArkInventory.TooltipAddItemCount( tooltip, h )
	
	if not h then return end
	if not tooltip then return end
	if not ArkInventory:IsEnabled( ) then return end
	if not ArkInventory.db.option.tooltip.show then return end
	if not ArkInventory.db.option.tooltip.add.count then return end
	
	--ArkInventory.Output( "1 - TooltipAddItemCount" )
	
	local osd = ArkInventory.ObjectStringDecode( h )
	if not ( osd.class == "item" or osd.class == "keystone" or osd.class == "battlepet" or osd.class == "spell" or osd.class == "currency" or osd.class == "reputation" ) then return end
	
	local search_id = ArkInventory.ObjectIDCount( h )
	ArkInventory.TooltipRebuildQueueAdd( search_id )
	
	local ta = ArkInventory.Global.Cache.ItemCountTooltip[search_id]
	
--[[
	data = {
		empty = true|false
		class[class] = { 1=user, 2=vault, 3=account
			count = 0
			total = "string - tooltip total"
			player_id[player_id] = {
				t1 = "string - tooltip left",
				t2 = "string - tooltip right"
			}
		}
	}
]]--	
	
	if ta and not ta.empty then
		
		ArkInventory.TooltipAddEmptyLine( tooltip )
		
		local tc = ArkInventory.db.option.tooltip.colour.count
		local gap = false
		
		for class, cd in ArkInventory.spairs( ta.class ) do
			
			if cd.entries > 0 then
				
				if gap then
					ArkInventory.TooltipAddEmptyLine( tooltip )
				end
				
				for player_id, pd in ArkInventory.spairs( cd.player_id ) do
					tooltip:AddDoubleLine( pd.t1, pd.t2, tc.r, tc.g, tc.b, tc.r, tc.g, tc.b )
				end
				
				if class == 1 and cd.entries > 1 and cd.total then
					tooltip:AddLine( cd.total, tc.r, tc.g, tc.b, 0 )
				end
				
				gap = true
				
			end
			
		end
		
		tooltip:AppendText( "" )
		
		return true
		
	end
	
end

function ArkInventory.TooltipAddItemAge( tooltip, h, blizzard_id, slot_id )
	
	if type( blizzard_id ) == "number" and type( slot_id ) == "number" then
		ArkInventory.TooltipAddEmptyLine( tooltip )
		local bag_id = ArkInventory.BlizzardBagIdToInternalId( blizzard_id )
		tooltip:AddLine( tt, 1, 1, 1, 0 )
	end

end

function ArkInventory.TooltipObjectCountGet( search_id, thread_id )
	
	local tc, changed = ArkInventory.ObjectCountGetRaw( search_id, thread_id )
	
	if not changed and ArkInventory.Global.Cache.ItemCountTooltip[search_id] then
		--ArkInventory.Output( "using cached tooltip count ", search_id )
		return ArkInventory.Global.Cache.ItemCountTooltip[search_id]
	end
	
	--ArkInventory.Output( "building tooltip count ", search_id )
	
	if thread_id then
		ArkInventory.ThreadYield( thread_id )
	end
	
	ArkInventory.Global.Cache.ItemCountTooltip[search_id] = { empty = true, class = { }, count = 0 }
--[[
		empty = true|false
		count = 0
		class[class] = {
			entries = 0,
			count = 0
			player_id[player_id] = {
				t1 = "string - tooltip left",
				t2 = "string - tooltip right"
			}
		}
]]--
	
	local data = ArkInventory.Global.Cache.ItemCountTooltip[search_id]
	
	if tc == nil then
		--ArkInventory.Output( "no count data ", search_id )
		return data
	end
	
	local paint = ArkInventory.db.option.tooltip.colour.class
	local colour = paint and HIGHLIGHT_FONT_COLOR_CODE or ""
	
	local codex = ArkInventory.GetPlayerCodex( )
	local info = codex.player.data.info
	local player_id = info.player_id
	
	local just_me = ArkInventory.db.option.tooltip.me
	local ignore_vaults = not ArkInventory.db.option.tooltip.add.vault
	local my_realm = ArkInventory.db.option.tooltip.realm
	local include_crossrealm = ArkInventory.db.option.tooltip.crossrealm
	local ignore_other_faction = ArkInventory.db.option.tooltip.faction
	
	local pd = { }
	
	--ArkInventory.Output( tc["Arkayenro - Khaz'goroth"] )
	for pid, rcd in ArkInventory.spairs( tc ) do
		
		local ok = false
		
		if ( not my_realm ) or ( my_realm and rcd.realm == info.realm ) or ( my_realm and include_crossrealm and ArkInventory.IsConnectedRealm( rcd.realm, info.realm ) ) then
			ok = true
		end
		
		if ignore_other_faction and rcd.faction ~= info.faction then
			ok = false
		end
		
		if rcd.class == "GUILD" and ignore_vaults then
			ok = false
		end
		
		if rcd.class == "ACCOUNT" then
			ok = true
		end
		
		if just_me and pid ~= player_id then
			ok = false
		end
		
		if ok then
			
			ArkInventory.GetPlayerStorage( pid, nil, pd )
			
			local class = rcd.class
			if class == "ACCOUNT" then
				class = 3
			elseif class == "GUILD" then
				class = 2
			else
				class = 1
			end
			
			if not data.class[class] then
				data.class[class] = { entries = 0, count = 0, player_id = { } }
			end
			
			if not data.class[class].player_id[pid] then
				data.class[class].player_id[pid] = { }
			end
			
			data.class[class].player_id[pid].count = rcd.total
			
			local name = ArkInventory.DisplayName3( pd.data.info, paint, codex.player.data.info )
			
			local location_entries = { }
			
			for loc_id, ld in pairs( rcd.location ) do
				
				if ld.c > 0 then
					
					data.empty = false
					
					if rcd.class == "GUILD" then
						
						local txt = ""
						
						if ArkInventory.db.option.tooltip.add.tabs then
							
							--local numtabs = ArkInventory.Table.Elements( rcd.tabs )
							local numtabs = ArkInventory.Table.Elements( rcd.extra[loc_id] )
							
							--for tab, count in ArkInventory.spairs( rcd.tabs ) do
							for tab, count in ArkInventory.spairs( rcd.extra[loc_id] ) do
								
								if numtabs > 1 then
									txt = string.format( "%s, %s %s: %s%s|r", txt, ArkInventory.Localise["TOOLTIP_VAULT_TABS"], tab, colour, FormatLargeNumber( count ) )
								else
									txt = string.format( "%s %s", ArkInventory.Localise["TOOLTIP_VAULT_TABS"], tab )
								end
							
							end
							
							if numtabs > 1 then
								txt = string.sub( txt, 2, string.len( txt ) - 2 )
							end
							
						else
							txt = ArkInventory.Global.Location[loc_id].Name
						end
						
						location_entries[#location_entries + 1] = txt
						
					else
						
						if loc_id == ArkInventory.Const.Location.Reputation then
							
							local rh = rcd.extra[ArkInventory.Const.Location.Reputation]
							if rh then
								
								local style_default = ArkInventory.Const.Reputation.Style.TooltipItemCount
								local style = style_default
								if ArkInventory.db.option.tooltip.reputation.custom ~= ArkInventory.Const.Reputation.Custom.Default then
									style = ArkInventory.db.option.tooltip.reputation.style.count
									if string.trim( style ) == "" then
										style = style_default
									end
								end
								
								local osd = ArkInventory.ObjectStringDecode( rh )
								local txt = ArkInventory.Collection.Reputation.LevelText( osd.id, style, osd.st, osd.bv, osd.bm, osd.ic, osd.pv, osd.pr )
								location_entries[#location_entries + 1] = string.format( "%s%s|r", colour, txt )
								
							end
							
						else
							
							if rcd.entries > 1 then
								location_entries[#location_entries + 1] = string.format( "%s %s%s|r", ArkInventory.Global.Location[loc_id].Name, colour, FormatLargeNumber( ld.c ) )
							else
								location_entries[#location_entries + 1] = string.format( "%s", ArkInventory.Global.Location[loc_id].Name )
							end
							
						end
						
					end
					
				end
				
			end
			
			if data.class[class].player_id[pid].count > 0 then
				
				local hl = ""
				if not ArkInventory.db.option.tooltip.me and pd.data.info.player_id == player_id then
					hl = ArkInventory.db.option.tooltip.highlight
				end
				
				data.class[class].entries = data.class[class].entries + 1
				
				local rh = rcd.extra[ArkInventory.Const.Location.Reputation]
				if rh then
					
					data.class[class].player_id[pid].t1 = string.format( "%s%s|r", hl, name )
					data.class[class].player_id[pid].t2 = string.format( "%s", table.concat( location_entries, ", " ) )
					
				else
					
					data.class[class].player_id[pid].t1 = string.format( "%s%s|r: %s%s", hl, name, colour, FormatLargeNumber( data.class[class].player_id[pid].count ) )
					data.class[class].player_id[pid].t2 = string.format( "%s", table.concat( location_entries, ", " ) )
					
					data.class[class].count = data.class[class].count + data.class[class].player_id[pid].count
					data.count = data.count + data.class[class].count
					
				end
				
			end
			
			if data.count > 0 then
				data.class[class].total = string.format( "%s: %s%s", ArkInventory.Localise["TOTAL"], colour, FormatLargeNumber( data.class[class].count ) )
				data.total = string.format( "%s: %s%s", ArkInventory.Localise["TOTAL"], colour, FormatLargeNumber( data.count ) )
			end
			
		end
		
	end
	
	return data
	
end

function ArkInventory.TooltipAddMoneyCoin( frame, amount, txt, r, g, b )
	
	if not frame or not amount then
		return
	end
	
	frame:AddDoubleLine( txt or " ", " ", r or 1, g or 1, b or 1 )
	
	local numLines = frame:NumLines( )
	if not frame.numMoneyFrames then
		frame.numMoneyFrames = 0
	end
	if not frame.shownMoneyFrames then
		frame.shownMoneyFrames = 0
	end
	
	local name = string.format( "%s%s%s", frame:GetName( ), "MoneyFrame", frame.shownMoneyFrames + 1 )
	local moneyFrame = _G[name]
	if not moneyFrame then
		frame.numMoneyFrames = frame.numMoneyFrames + 1
		moneyFrame = CreateFrame( "Frame", name, frame, "TooltipMoneyFrameTemplate" )
		name = moneyFrame:GetName( )
		ArkInventory.MoneyFrame_SetType( moneyFrame, "STATIC" )
	end
	
	moneyFrame:SetPoint( "RIGHT", string.format( "%s%s%s", frame:GetName( ), "TextRight", numLines ), "RIGHT", 15, 0 )
	
	moneyFrame:Show( )
	
	if not frame.shownMoneyFrames then
		frame.shownMoneyFrames = 1
	else
		frame.shownMoneyFrames = frame.shownMoneyFrames + 1
	end
	
	MoneyFrame_Update( moneyFrame:GetName( ), amount )
	
	local leftFrame = _G[string.format( "%s%s%s", frame:GetName( ), "TextLeft", numLines )]
	local frameWidth = leftFrame:GetWidth( ) + moneyFrame:GetWidth( ) + 40
	
	if frame:GetMinimumWidth( ) < frameWidth then
		frame:SetMinimumWidth( frameWidth )
	end
	
	frame.hasMoney = 1

end

function ArkInventory.TooltipAddMoneyText( frame, money, txt, r, g, b )
	if not money then
		return
	elseif money == 0 then
		--frame:AddDoubleLine( txt or "missing text", ITEM_UNSELLABLE, r or 1, g or 1, b or 1, 1, 1, 1 )
		frame:AddDoubleLine( txt or "missing text", ArkInventory.MoneyText( money ), r or 1, g or 1, b or 1, 1, 1, 1 )
	else
		frame:AddDoubleLine( txt or "missing text", ArkInventory.MoneyText( money ), r or 1, g or 1, b or 1, 1, 1, 1 )
	end
end


function ArkInventory.TooltipDump( tooltip )
	
	-- /run ArkInventory.TooltipDump( EmbeddedItemTooltip )
	-- /run ArkInventory.TooltipDump( GameTooltip )
	
	
	local tooltip = tooltip or ArkInventory.Global.Tooltip.Scan
	--local h = "|cffa335ee|Hkeystone:138019:234:2:0:0:0:0|h[Keystone: Return to Karazhan: Upper (2)]|h|r"
	--local h = "keystone:138019:234:2:0:0:0:0"
	--tooltip:SetHyperlink( h )
-- 
--	/run ArkInventory.TooltipDump( ArkInventory.Global.Tooltip.Scan )
--	/run ArkInventory.TooltipDump( GameTooltip )
	ArkInventory.Output( "----- ----- -----" )
	for i = 1, ArkInventory.TooltipGetNumLines( tooltip ) do
		local a, b = ArkInventory.TooltipGetLine( tooltip, i )
		ArkInventory.Output( i, " left: ", a )
		if b ~= "" then
			ArkInventory.Output( i, " right: ", b )
		end
	end
	
	if tooltip:GetParent( ) then
		ArkInventory.Output( "parent = ", tooltip:GetParent( ):GetName( ) )
	else
		ArkInventory.Output( "parent = *not set*" )
	end
	
	if tooltip:GetOwner( ) then
		ArkInventory.Output( "owner = ", tooltip:GetOwner( ):GetName( ) )
	else
		ArkInventory.Output( "owner = *not set*" )
	end
	
end

function ArkInventory.ListAllTooltips( )
	local tooltip = EnumerateFrames( )
	while tooltip do
		if tooltip:GetObjectType( ) == "GameTooltip" then
			local name = tooltip:GetName( )
			if name then
				ArkInventory.Output( name )
			end
		end
		tooltip = EnumerateFrames( tooltip )
	end
end


function ArkInventory.TooltipExtractValueSuffixCheck( level, suffix )
	
	--ArkInventory.Output( "check [", level, "] [", suffix, "]" )
	
	local level = level or 0
	if not ( level == 3 or level == 6 or level == 9 or level == 12 ) then
		return
	end
	
	local suffix = string.trim( suffix ) or ""
	if suffix == "" then
		return
	end
	
	local suffixes = ArkInventory.Localise[string.format( "WOW_ITEM_TOOLTIP_10P%dT", level )]
	if suffixes == "" then
		return
	end
	
	local check
	
	for s in string.gmatch( suffixes, "[^,]+" ) do
		
		check = string.sub( suffix, 1, string.len( s ) )
		
		
		
		if string.lower( check ) == string.lower( s ) then
			--ArkInventory.Output( "pass [", check, "] [", s, "]" )
			return true
		end
		
		--ArkInventory.Output( "fail [", check, "] [", s, "]" )
		
	end
	
end

function ArkInventory.TooltipExtractValueArtifactPower( h )
	
	ArkInventory.TooltipSetHyperlink( ArkInventory.Global.Tooltip.Scan, h )
	
	if not ArkInventory.TooltipFind( ArkInventory.Global.Tooltip.Scan, ArkInventory.Localise["WOW_TOOLTIP_ARTIFACT_POWER"], false, true, false, 0, true ) then
		return 0
	end
	
	local _, _, amount, suffix = ArkInventory.TooltipFind( ArkInventory.Global.Tooltip.Scan, ArkInventory.Localise["WOW_TOOLTIP_ARTIFACT_POWER_AMOUNT"], false, true, true, 0, true )
	
	--ArkInventory.Output( h, "[", amount, "] [", suffix, "]" )
	
	if amount then
		
		amount = string.gsub( amount, ",", "." )
		amount = tonumber( amount )
		
		if amount then
			
			if ArkInventory.TooltipExtractValueSuffixCheck( 12, suffix ) then
				--ArkInventory.Output( "12: ", amount, " ", suffix, "]" )
				amount = amount * 1000000000000
			elseif ArkInventory.TooltipExtractValueSuffixCheck( 9, suffix ) then
				--ArkInventory.Output( "9: ", amount, " ", suffix, "]" )
				amount = amount * 1000000000
			elseif ArkInventory.TooltipExtractValueSuffixCheck( 6, suffix ) then
				--ArkInventory.Output( "6: ", amount, " ", suffix, "]" )
				amount = amount * 1000000
			elseif ArkInventory.TooltipExtractValueSuffixCheck( 3, suffix ) then
				--ArkInventory.Output( "3: ", amount, " ", suffix, "]" )
				amount = amount * 1000
			end
			
			return amount
			
		end
		
	end
	
	return 0
	
end

function ArkInventory.TooltipExtractValueAncientMana( h )
	
	ArkInventory.TooltipSetHyperlink( ArkInventory.Global.Tooltip.Scan, h )
	
	if not ArkInventory.TooltipFind( ArkInventory.Global.Tooltip.Scan, ArkInventory.Localise["WOW_TOOLTIP_ANCIENT_MANA"], false, true, false, 0, true ) then
		return 0
	end
	
	local _, _, amount, suffix = ArkInventory.TooltipFind( ArkInventory.Global.Tooltip.Scan, ArkInventory.Localise["WOW_TOOLTIP_ARTIFACT_POWER_AMOUNT"], false, true, true, 0, true )
	--local _, _, amount, suffix = ArkInventory.TooltipFind( ArkInventory.Global.Tooltip.Scan, "(%d+)(..)", false, true, true, 0, true )
	
	--ArkInventory.Output( h, " [", amount, "] [", suffix, "]" )
	--ArkInventory.Output( "[", string.byte( string.sub( suffix, 1, 1 ) ), "] [", string.byte( string.sub( suffix, 2, 2 ) ), "]" )
	
	if amount then
		
		amount = tonumber( amount )
		
		if amount then
			
			return amount
			
		end
		
	end
	
	return 0
	
end





local TooltipRebuildQueue = { }
local scanning = false

function ArkInventory.TooltipRebuildQueueAdd( search_id )
	
	if not ArkInventory.db.option.tooltip.show then return end
	if not ArkInventory.db.option.tooltip.add.count then return end
	if not search_id then return end
	
	--ArkInventory.Output( "adding ", search_id )
	TooltipRebuildQueue[search_id] = true
	
	ArkInventory:SendMessage( "EVENT_ARKINV_TOOLTIP_REBUILD_QUEUE_UPDATE_BUCKET", "START" )
	
end

local function Scan_Threaded( thread_id )
	
	--ArkInventory.Output( "rebuilding ", ArkInventory.Table.Elements( TooltipRebuildQueue ) )
	
	for search_id in pairs( TooltipRebuildQueue ) do
		
		--ArkInventory.Output( "rebuilding ", search_id )
		
		ArkInventory.TooltipObjectCountGet( search_id, thread_id )
		ArkInventory.ThreadYield( thread_id )
		
		TooltipRebuildQueue[search_id] = nil
		
	end
	
end

local function Scan( )
	
	local thread_id = ArkInventory.Global.Thread.Format.Tooltip
	
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

function ArkInventory:EVENT_ARKINV_TOOLTIP_REBUILD_QUEUE_UPDATE_BUCKET( events )
	
	if not ArkInventory:IsEnabled( ) then return end
	
	if ArkInventory.Global.Mode.Combat then
		return
	end
	
	if not scanning then
		scanning = true
		Scan( )
		scanning = false
	else
		ArkInventory:SendMessage( "EVENT_ARKINV_TOOLTIP_REBUILD_QUEUE_UPDATE_BUCKET", "RESCAN" )
	end
	
end

function ArkInventory:EVENT_ARKINV_TOOLTIP_REBUILD_QUEUE_UPDATE( event )
	ArkInventory:SendMessage( "EVENT_ARKINV_TOOLTIP_REBUILD_QUEUE_UPDATE_BUCKET", event )
end
