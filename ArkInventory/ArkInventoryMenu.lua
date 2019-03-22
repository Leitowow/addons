local _G = _G
local select = _G.select
local pairs = _G.pairs
local ipairs = _G.ipairs
local string = _G.string
local type = _G.type
local error = _G.error
local table = _G.table


function ArkInventory.MenuMainOpen( frame )
	
	assert( frame, "code error: frame argument is missing" )

	if ArkInventory.Lib.Dewdrop:IsOpen( frame ) then
		
		ArkInventory.Lib.Dewdrop:Close( )
		
	else

		local loc_id = frame:GetParent( ):GetParent( ).ARK_Data.loc_id
		local codex = ArkInventory.GetLocationCodex( loc_id )
		
		local anchorpoints = {
			[ArkInventory.Const.Anchor.TopRight] = ArkInventory.Localise["TOPRIGHT"],
			[ArkInventory.Const.Anchor.BottomRight] = ArkInventory.Localise["BOTTOMRIGHT"],
			[ArkInventory.Const.Anchor.BottomLeft] = ArkInventory.Localise["BOTTOMLEFT"],
			[ArkInventory.Const.Anchor.TopLeft] = ArkInventory.Localise["TOPLEFT"],
		}
		
		local x, p, rp
		x = frame:GetLeft( ) + ( frame:GetRight( ) - frame:GetLeft( ) ) / 2
		if ( x >= ( GetScreenWidth( ) / 2 ) ) then
			p = "TOPRIGHT"
			rp = "TOPLEFT"
		else
			p = "TOPLEFT"
			rp = "TOPRIGHT"
		end
		
		ArkInventory.Lib.Dewdrop:Open( frame,
			"point", p,
			"relativePoint", rp,
			"children", function( level, value )
				
				if level == 1 then
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Const.Program.Name,
						"isTitle", true
					)
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Global.Version,
						"notClickable", true
					)
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["CONFIG"],
						"closeWhenClicked", true,
						"func", function( )
							ArkInventory.Frame_Config_Show( )
						end
					)
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"icon", ArkInventory.Const.Actions[ArkInventory.Const.ActionID.Refresh].Texture,
						"text", ArkInventory.Const.Actions[ArkInventory.Const.ActionID.Refresh].Name,
						"closeWhenClicked", true,
						"func", function( )
							ArkInventory.Frame_Main_Generate( loc_id, ArkInventory.Const.Window.Draw.Recalculate )
						end
					)
					
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["RELOAD"],
						"tooltipTitle", ArkInventory.Localise["RELOAD"],
						"tooltipText", ArkInventory.Localise["MENU_ACTION_RELOAD_TEXT"],
						"closeWhenClicked", true,
						"func", function( )
							ArkInventory.ItemCacheClear( )
							ArkInventory.Frame_Main_Generate( loc_id, ArkInventory.Const.Window.Draw.Recalculate )
						end
					)
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"icon", ArkInventory.Const.Actions[ArkInventory.Const.ActionID.Restack].Texture,
						"text", ArkInventory.Const.Actions[ArkInventory.Const.ActionID.Restack].Name,
						"closeWhenClicked", true,
						"func", function( )
							ArkInventory.Restack( loc_id )
						end
					)
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"icon", ArkInventory.Const.Actions[ArkInventory.Const.ActionID.Search].Texture,
						"text", ArkInventory.Const.Actions[ArkInventory.Const.ActionID.Search].Name,
						"closeWhenClicked", true,
						"func", function( )
							ArkInventory.Search.Frame_Toggle( )
						end
					)
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"icon", ArkInventory.Const.Actions[ArkInventory.Const.ActionID.Rules].Texture,
						"text", ArkInventory.Const.Actions[ArkInventory.Const.ActionID.Rules].Name,
						"closeWhenClicked", true,
						"func", function( )
							ArkInventory.Frame_Rules_Toggle( )
						end
					)
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"icon", ArkInventory.Const.Actions[ArkInventory.Const.ActionID.EditMode].Texture,
						"text", ArkInventory.Const.Actions[ArkInventory.Const.ActionID.EditMode].Name,
						"closeWhenClicked", true,
						"checked", ArkInventory.Global.Mode.Edit,
						"func", function( )
							ArkInventory.ToggleEditMode( )
						end
					)
					
					if ( loc_id == ArkInventory.Const.Location.Mount ) or ( loc_id == ArkInventory.Const.Location.Pet ) then
						
						ArkInventory.Lib.Dewdrop:AddLine( )
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Global.Location[loc_id].Name,
							"hasArrow", true,
							"value", "INSERT_LOCATION_MENU"
						)
						
					end
					
				end
				
				
				if ( loc_id == ArkInventory.Const.Location.Mount ) then
					ArkInventory.MenuMounts( frame, level, value, 1 )
				end
				
				if ( loc_id == ArkInventory.Const.Location.Pet ) then
					ArkInventory.MenuPets( frame, level, value, 1 )
				end
				
				ArkInventory.Lib.Dewdrop:AddLine( )
				
				ArkInventory.Lib.Dewdrop:AddLine(
					"text", ArkInventory.Localise["CLOSE_MENU"],
					"closeWhenClicked", true
				)
				
			end
			
		)
	
	end
	
end

function ArkInventory.MenuBarOpen( frame )
	
	assert( frame, "code error: frame argument is missing" )
	
	if ArkInventory.Lib.Dewdrop:IsOpen( frame ) then

		ArkInventory.Lib.Dewdrop:Close( )
		
	else

		local loc_id = frame.ARK_Data.loc_id
		local bar_id = frame.ARK_Data.bar_id
		local codex = ArkInventory.GetLocationCodex( loc_id )
		local bar_name = codex.layout.bar.data[bar_id].name.text or ""
		
		local sid_def = codex.style.sort.method or 9999
		local sid = codex.layout.bar.data[bar_id].sort.method or sid_def
		
		if ArkInventory.db.option.sort.method.data[sid].used ~= "Y" then
			--ArkInventory.OutputWarning( "bar ", bar_id, " in location ", loc_id, " is using an invalid sort method.  resetting it to default" )
			codex.layout.bar.data[bar_id].sort.method = nil
			sid = sid_def
		end
		
		--ArkInventory.Output( "sid=[", sid, "] default=[", sid_def, "]" )
		
		local x, p, rp
		x = frame:GetLeft( ) + ( frame:GetRight( ) - frame:GetLeft( ) ) / 2
		if ( x >= ( GetScreenWidth( ) / 2 ) ) then
			p = "TOPRIGHT"
			rp = "TOPLEFT"
		else
			p = "TOPLEFT"
			rp = "TOPRIGHT"
		end
	
		local category = {
			["type"] = { "SYSTEM", "CONSUMABLE", "TRADEGOODS", "SKILL", "CLASS", "EMPTY", "CUSTOM", "RULE", },
		}
		
		ArkInventory.Lib.Dewdrop:Open( frame,
			"point", p,
			"relativePoint", rp,
			"children", function( level, value )
			
				if level == 1 then
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", string.format( ArkInventory.Localise["MENU_BAR_TITLE"], bar_id ),
						"isTitle", true
					)
					
					if codex.style.window.list then
						
						ArkInventory.Lib.Dewdrop:AddLine( )
						
						local text = string.format( "%s* %s *%s", RED_FONT_COLOR_CODE, ArkInventory.Localise["LOCKED"], FONT_COLOR_CODE_CLOSE )
						local desc = ArkInventory.Localise["MENU_LOCKED_LIST_TEXT"]
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", text,
							"tooltipTitle", text,
							"tooltipText", desc
						)
						
					else
					
					if codex.layout.system then
						
						local text = string.format( "%s* %s *%s", RED_FONT_COLOR_CODE, ArkInventory.Localise["LOCKED"], FONT_COLOR_CODE_CLOSE )
						local desc = string.format( ArkInventory.Localise["MENU_LOCKED_TEXT"], ArkInventory.Localise["CONFIG_LAYOUT"], ArkInventory.Localise["CONFIG"], ArkInventory.Localise["CONTROLS"] )
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", text,
							"tooltipTitle", text,
							"tooltipText", desc
						)
					
					else
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", string.format( "%s: %s%s%s", ArkInventory.Localise["NAME"], LIGHTYELLOW_FONT_COLOR_CODE, bar_name, FONT_COLOR_CODE_CLOSE ),
						"tooltipTitle", ArkInventory.Localise["NAME"],
						"tooltipText", string.format( ArkInventory.Localise["CONFIG_DESIGN_BAR_NAME_TEXT"], bar_id ),
						"hasArrow", true,
						"hasEditBox", true,
						"editBoxText", bar_name,
						"editBoxFunc", function( v )
							bar_name = string.trim( v )
							codex.layout.bar.data[bar_id].name.text = bar_name
							ArkInventory.Frame_Bar_Paint_All( )
						end
					)
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["COLOUR"],
						"hasArrow", true,
						"value", "BAR_COLOUR"
					)
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["ACTION"],
						"hasArrow", true,
						"value", "BAR_ACTION"
					)
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["WIDTH"],
						"hasArrow", true,
						"value", "BAR_WIDTH"
					)
					
					end
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", string.format( "%s:", ArkInventory.Localise["CONFIG_SORTING_METHOD"] ),
						"isTitle", true
					)
					
					if codex.layout.system then
						
						local text = string.format( "%s* %s *%s", RED_FONT_COLOR_CODE, ArkInventory.Localise["LOCKED"], FONT_COLOR_CODE_CLOSE )
						local desc = string.format( ArkInventory.Localise["MENU_LOCKED_TEXT"], ArkInventory.Localise["CONFIG_LAYOUT"], ArkInventory.Localise["CONFIG"], ArkInventory.Localise["CONTROLS"] )
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", text,
							"tooltipTitle", text,
							"tooltipText", desc
						)
					
					else
						
						if sid ~= sid_def then
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", string.format( "%s: %s%s%s", ArkInventory.Localise["CURRENT"], GREEN_FONT_COLOR_CODE, ArkInventory.db.option.sort.method.data[sid].name, FONT_COLOR_CODE_CLOSE ),
								"hasArrow", true,
								"value", "SORTING_METHOD"
							)
							
							--ArkInventory.Lib.Dewdrop:AddLine( )
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", string.format( "%s: %s%s%s", ArkInventory.Localise["DEFAULT"], LIGHTYELLOW_FONT_COLOR_CODE, ArkInventory.db.option.sort.method.data[sid_def].name, FONT_COLOR_CODE_CLOSE ),
								"tooltipTitle", ArkInventory.Localise["MENU_ITEM_DEFAULT_RESET"],
								"tooltipText", string.format( ArkInventory.Localise["MENU_BAR_SORTKEY_DEFAULT_RESET_TEXT"], bar_id ),
								"closeWhenClicked", true,
								"func", function( )
									codex.layout.bar.data[bar_id].sort.method = nil
									ArkInventory.ItemSortKeyClear( loc_id )
									ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Resort )
								end
							)
							
						else
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", string.format( "%s: %s%s%s", ArkInventory.Localise["DEFAULT"], LIGHTYELLOW_FONT_COLOR_CODE, ArkInventory.db.option.sort.method.data[sid_def].name, FONT_COLOR_CODE_CLOSE ),
								"hasArrow", true,
								"value", "SORTING_METHOD"
							)
							
						end
						
					end
					
					
					if codex.layout.system then
						
						
						
					else
						
						ArkInventory.Lib.Dewdrop:AddLine( )
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", string.format( "%s:", ArkInventory.Localise["MENU_BAR_CATEGORY_CURRENT"] ),
							"isTitle", true
						)
						
						local has_entries = false
						for _, v in ipairs( category.type ) do
							if ArkInventory.CategoryBarHasEntries( loc_id, bar_id, v ) then
								has_entries = true
								ArkInventory.Lib.Dewdrop:AddLine(
									"text", ArkInventory.Localise[string.format( "CATEGORY_%s", v )],
									"hasArrow", true,
									"value", string.format( "CATEGORY_CURRENT_%s", v )
								)
							end
						end
						
						for bag_id in pairs( ArkInventory.Global.Location[loc_id].Bags ) do
							if codex.layout.bag[bag_id].bar == bar_id then
								has_entries = true
								ArkInventory.Lib.Dewdrop:AddLine(
									"text", ArkInventory.Localise["BAG"],
									"hasArrow", true,
									"value", "BAG_CURRENT"
								)
							end
						end
						
						if not has_entries then
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", ArkInventory.Localise["NONE"],
								"disabled", true
							)
						end
						
					end
					
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", string.format( "%s:", ArkInventory.Localise["MENU_BAR_CATEGORY_ASSIGN"] ),
						"isTitle", true
					)
					
					if codex.layout.system then
						
						local text = string.format( "%s* %s *%s", RED_FONT_COLOR_CODE, ArkInventory.Localise["LOCKED"], FONT_COLOR_CODE_CLOSE )
						local desc = string.format( ArkInventory.Localise["MENU_LOCKED_TEXT"], ArkInventory.Localise["CONFIG_LAYOUT"], ArkInventory.Localise["CONFIG"], ArkInventory.Localise["CONTROLS"] )
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", text,
							"tooltipTitle", text,
							"tooltipText", desc
						)
					
					else
					
					for _, v in ipairs( category.type ) do
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise[string.format( "CATEGORY_%s", v )],
							"hasArrow", true,
							"value", string.format( "CATEGORY_ASSIGN_%s", v )
						)
					end
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["BAG"],
						"hasArrow", true,
						"hidden", codex.layout.system,
						"value", "BAG_ASSIGN"
					)
					
					end
					
					if not codex.layout.system then
						
						if ArkInventory.Global.Options.CategoryMoveLocation == loc_id and ArkInventory.Global.Options.CategoryMoveSource ~= bar_id then
							
							ArkInventory.Lib.Dewdrop:AddLine( )
							
							local cat = ArkInventory.Global.Category[ArkInventory.Global.Options.CategoryMoveCategory]
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", string.format( "%s: %s", ArkInventory.Localise["MOVE"], ArkInventory.Localise["COMPLETE"] ),
								"tooltipTitle", string.format( "%s: %s", ArkInventory.Localise["MOVE"], ArkInventory.Localise["COMPLETE"] ),
								"tooltipText", string.format( ArkInventory.Localise["MENU_BAR_CATEGORY_MOVE_COMPLETE_TEXT"], string.format( "%s%s%s", LIGHTYELLOW_FONT_COLOR_CODE, cat.fullname, FONT_COLOR_CODE_CLOSE ), ArkInventory.Global.Options.CategoryMoveSource, bar_id ),
								"closeWhenClicked", true,
								"func", function( )
									ArkInventory.CategoryLocationSet( loc_id, cat.id, bar_id )
									ArkInventory.Global.Options.CategoryMoveLocation = nil
									ArkInventory.Global.Options.CategoryMoveSource = nil
									ArkInventory.Global.Options.CategoryMoveCategory = nil
									ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Recalculate )
								end
							)
							
						end
					
					end
					
					end
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["CLOSE_MENU"],
						"closeWhenClicked", true
					)
					
				end
				
				
				if level == 2 and value then
					
					if value == "SORTING_METHOD" then
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["CONFIG_SORTING_METHOD"],
							"isTitle", true
						)
						
						ArkInventory.Lib.Dewdrop:AddLine( )
						
						local x = ArkInventory.db.option.sort.method.data
						for k, v in ArkInventory.spairs( x, function(a,b) return a < b end ) do
							
							if v.used == "Y" then
								local n = v.name
								if v.system then
									n = string.format( "* %s", n )
								end
								n = string.format( "[%04i] %s", k, n )
								ArkInventory.Lib.Dewdrop:AddLine(
									"text", n,
									"tooltipTitle", ArkInventory.Localise["CONFIG_SORTING_METHOD"],
									"tooltipText", string.format( ArkInventory.Localise["MENU_BAR_SORTKEY_TEXT"], v.name, bar_id ),
									"isRadio", true,
									"checked", k == sid,
									"disabled", k == sid,
									"closeWhenClicked", true,
									"func", function( )
										if k == sid_def then
											codex.layout.bar.data[bar_id].sort.method = nil
										else
											codex.layout.bar.data[bar_id].sort.method = k
										end
										ArkInventory.ItemSortKeyClear( loc_id )
										ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Resort )
									end
								)
							end
							
						end
						
						ArkInventory.Lib.Dewdrop:AddLine( )
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["CONFIG"],
							"closeWhenClicked", true,
							"func", function( )
								ArkInventory.Frame_Config_Show( "settings", "sortmethod" )
							end
						)
					
					end
					
					
					if strsub( value, 1, 9 ) == "CATEGORY_" then
						
						local int_type, cat_type = string.match( value, "^CATEGORY_(.+)_(.+)$" )
						
						if cat_type ~= nil then
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", ArkInventory.Localise[string.format( "CATEGORY_%s", cat_type )],
								"isTitle", true
							)

							ArkInventory.Lib.Dewdrop:AddLine( )
							
							for _, cat in ArkInventory.spairs( ArkInventory.Global.Category, function(a,b) return ArkInventory.Global.Category[a].sort_order < ArkInventory.Global.Category[b].sort_order end ) do
								
								local t = cat.type_code
								local cat_bar, def_bar = ArkInventory.CategoryLocationGet( loc_id, cat.id )
								local icon = ""
								
								if int_type == "ASSIGN" and abs( cat_bar ) == bar_id and not def_bar then
									t = "DO_NOT_DISPLAY"
								end
								
								if int_type == "CURRENT" and ( abs( cat_bar ) ~= bar_id or def_bar ) then
									t = "DO_NOT_DISPLAY"
								end
								
								if cat_type == t then
									
									local cat_z, cat_code = ArkInventory.CategoryCodeSplit( cat.id )
									
									local c1 = ""
									
									if not def_bar then
										c1 = LIGHTYELLOW_FONT_COLOR_CODE
									end
									
									if not codex.catset.category.active[cat_z][cat_code] then
										c1 = RED_FONT_COLOR_CODE
									end
									
									if codex.catset.category.junk[cat_z][cat_code] then
										icon = [[Interface\Icons\INV_Misc_Coin_02]]
									end
									
									local n = string.format( "%s%s", c1, cat.name )
									
									local c2 = GREEN_FONT_COLOR_CODE
									if cat_bar < 0 then
										c2 = RED_FONT_COLOR_CODE
									end
									if not def_bar then
										n = string.format( "%s %s[%s]", n, c2, abs( cat_bar ) )
									end
									
									if abs( cat_bar ) ~= bar_id then
										ArkInventory.Lib.Dewdrop:AddLine(
											"text", n,
											"tooltipTitle", ArkInventory.Localise["CATEGORY"],
											"tooltipText", string.format( ArkInventory.Localise["MENU_BAR_CATEGORY_TEXT"], string.format( "%s%s%s", LIGHTYELLOW_FONT_COLOR_CODE, cat.fullname, FONT_COLOR_CODE_CLOSE ), bar_id ),
											"icon", icon,
											"hasArrow", true,
											"value", string.format( "CATEGORY_OPTION_%s", cat.id ),
											"func", function( )
												ArkInventory.CategoryLocationSet( loc_id, cat.id, bar_id )
												ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Recalculate )
											end
										)
										
									else
									
										ArkInventory.Lib.Dewdrop:AddLine(
											"text", n,
											"tooltipTitle", ArkInventory.Localise["CATEGORY"],
											"tooltipText", string.format( ArkInventory.Localise["MENU_BAR_CATEGORY_REMOVE_TEXT"], string.format( "%s%s%s", LIGHTYELLOW_FONT_COLOR_CODE, cat.fullname, FONT_COLOR_CODE_CLOSE ), cat_bar ),
											"icon", icon,
											"hasArrow", true,
											"value", string.format( "CATEGORY_OPTION_%s", cat.id ),
											"func", function( )
												ArkInventory.CategoryLocationSet( loc_id, cat.id, nil )
												ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Recalculate )
											end
										)
										
									end
									
								end
	
							end
							
						end
						
					end
					
					
					if strsub( value, 1, 4 ) == "BAG_" then
						
						local int_type = string.match( value, "^BAG_(.+)$" )
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["BAG"],
							"isTitle", true
						)
						
						ArkInventory.Lib.Dewdrop:AddLine( )
						
						for bag_id in pairs( ArkInventory.Global.Location[loc_id].Bags ) do
							
							local cat_bar = codex.layout.bag[bag_id].bar
							
							if ( int_type == "ASSIGN" and bar_id ~= cat_bar ) or ( int_type == "CURRENT" and bar_id == cat_bar ) then
								
								local n = string.format( "%s", bag_id )
								
								if cat_bar then
									n = string.format( "%s%s%s [%s]%s", LIGHTYELLOW_FONT_COLOR_CODE, n, GREEN_FONT_COLOR_CODE, cat_bar, FONT_COLOR_CODE_CLOSE )
								end
								
								ArkInventory.Lib.Dewdrop:AddLine(
									"text", n,
									"tooltipTitle", ArkInventory.Localise["BAG"],
									"tooltipText", string.format( ArkInventory.Localise["MENU_BAR_BAG_ASSIGN_TEXT"], bag_id, bar_id ),
									"hasArrow", cat_bar,
									"value", string.format( "BAG_OPTION_%s", bag_id ),
									"func", function( )
										codex.layout.bag[bag_id].bar = bar_id
										ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Recalculate )
									end
								)
								
							end
							
						end
						
					end
					
					
					if value == "BAR_COLOUR" then
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["BORDER"],
							"isTitle", true
						)
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["DEFAULT"],
							"tooltipTitle", ArkInventory.Localise["DEFAULT"],
							"tooltipText", string.format( ArkInventory.Localise["MENU_BAR_COLOUR_BORDER_DEFAULT_TEXT"], bar_id ),
							"isRadio", true,
							"checked", codex.layout.bar.data[bar_id].border.custom == 1,
							"disabled", codex.layout.bar.data[bar_id].border.custom == 1,
							"func", function( )
								codex.layout.bar.data[bar_id].border.custom = 1
								ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Restart )
							end
						)
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["CUSTOM"],
							"tooltipTitle", ArkInventory.Localise["CUSTOM"],
							"tooltipText", string.format( ArkInventory.Localise["MENU_BAR_COLOUR_BORDER_CUSTOM_TEXT"], bar_id ),
							"isRadio", true,
							"checked", codex.layout.bar.data[bar_id].border.custom == 2,
							"disabled", codex.layout.bar.data[bar_id].border.custom == 2,
							"func", function( )
								codex.layout.bar.data[bar_id].border.custom = 2
								ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Restart )
							end
						)
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["COLOUR"],
							"tooltipTitle", ArkInventory.Localise["COLOUR"],
							"tooltipText", string.format( ArkInventory.Localise["MENU_BAR_COLOUR_BORDER_TEXT"], bar_id ),
							"hasColorSwatch", true,
							"hasOpacity", true,
							"disabled", codex.layout.bar.data[bar_id].border.custom ~= 2,
							"r", codex.layout.bar.data[bar_id].border.colour.r,
							"g", codex.layout.bar.data[bar_id].border.colour.g,
							"b", codex.layout.bar.data[bar_id].border.colour.b,
							"opacity", codex.layout.bar.data[bar_id].border.colour.a,
							"colorFunc", function( r, g, b, a )
								codex.layout.bar.data[bar_id].border.colour.r = r
								codex.layout.bar.data[bar_id].border.colour.g = g
								codex.layout.bar.data[bar_id].border.colour.b = b
								codex.layout.bar.data[bar_id].border.colour.a = a
								ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Restart )
							end
						)
						
						ArkInventory.Lib.Dewdrop:AddLine( )
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["BACKGROUND"],
							"isTitle", true
						)
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["DEFAULT"],
							"tooltipTitle", ArkInventory.Localise["DEFAULT"],
							"tooltipText", string.format( ArkInventory.Localise["MENU_BAR_COLOUR_BACKGROUND_DEFAULT_TEXT"], bar_id ),
							"isRadio", true,
							"checked", codex.layout.bar.data[bar_id].background.custom == 1,
							"disabled", codex.layout.bar.data[bar_id].background.custom == 1,
							"func", function( )
								codex.layout.bar.data[bar_id].background.custom = 1
								ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Restart )
							end
						)
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["CUSTOM"],
							"tooltipTitle", ArkInventory.Localise["CUSTOM"],
							"tooltipText", string.format( ArkInventory.Localise["MENU_BAR_COLOUR_BACKGROUND_CUSTOM_TEXT"], bar_id ),
							"isRadio", true,
							"checked", codex.layout.bar.data[bar_id].background.custom == 2,
							"disabled", codex.layout.bar.data[bar_id].background.custom == 2,
							"func", function( )
								codex.layout.bar.data[bar_id].background.custom = 2
								ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Restart )
							end
						)
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["COLOUR"],
							"tooltipTitle", ArkInventory.Localise["COLOUR"],
							"tooltipText", string.format( ArkInventory.Localise["MENU_BAR_COLOUR_BACKGROUND_TEXT"], bar_id ),
							"hasColorSwatch", true,
							"hasOpacity", true,
							"disabled", codex.layout.bar.data[bar_id].background.custom ~= 2,
							"r", codex.layout.bar.data[bar_id].background.colour.r,
							"g", codex.layout.bar.data[bar_id].background.colour.g,
							"b", codex.layout.bar.data[bar_id].background.colour.b,
							"opacity", codex.layout.bar.data[bar_id].background.colour.a,
							"colorFunc", function( r, g, b, a )
								codex.layout.bar.data[bar_id].background.colour.r = r
								codex.layout.bar.data[bar_id].background.colour.g = g
								codex.layout.bar.data[bar_id].background.colour.b = b
								codex.layout.bar.data[bar_id].background.colour.a = a
								ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Restart )
							end
						)
						
						ArkInventory.Lib.Dewdrop:AddLine( )
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["NAME"],
							"isTitle", true
						)
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["DEFAULT"],
							"tooltipTitle", ArkInventory.Localise["DEFAULT"],
							"tooltipText", string.format( ArkInventory.Localise["MENU_BAR_COLOUR_NAME_DEFAULT_TEXT"], bar_id ),
							"isRadio", true,
							"checked", codex.layout.bar.data[bar_id].name.custom == 1,
							"disabled", codex.layout.bar.data[bar_id].name.custom == 1,
							"func", function( )
								codex.layout.bar.data[bar_id].name.custom = 1
								ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Restart )
							end
						)
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["CUSTOM"],
							"tooltipTitle", ArkInventory.Localise["CUSTOM"],
							"tooltipText", string.format( ArkInventory.Localise["MENU_BAR_COLOUR_NAME_CUSTOM_TEXT"], bar_id ),
							"isRadio", true,
							"checked", codex.layout.bar.data[bar_id].name.custom == 2,
							"disabled", codex.layout.bar.data[bar_id].name.custom == 2,
							"func", function( )
								codex.layout.bar.data[bar_id].name.custom = 2
								ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Restart )
							end
						)
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["COLOUR"],
							"tooltipTitle", ArkInventory.Localise["COLOUR"],
							"tooltipText", string.format( ArkInventory.Localise["MENU_BAR_COLOUR_NAME_TEXT"], bar_id ),
							"hasColorSwatch", true,
							"disabled", codex.layout.bar.data[bar_id].name.custom ~= 2,
							"r", codex.layout.bar.data[bar_id].name.colour.r,
							"g", codex.layout.bar.data[bar_id].name.colour.g,
							"b", codex.layout.bar.data[bar_id].name.colour.b,
							"colorFunc", function( r, g, b, a )
								codex.layout.bar.data[bar_id].name.colour.r = r
								codex.layout.bar.data[bar_id].name.colour.g = g
								codex.layout.bar.data[bar_id].name.colour.b = b
								ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Restart )
							end
						)
						
					end
					
					
					if value == "BAR_ACTION" then
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["ACTION"],
							"isTitle", true
						)
						
						ArkInventory.Lib.Dewdrop:AddLine( )
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["RESET"],
							"tooltipTitle", ArkInventory.Localise["RESET"],
							"tooltipText", string.format( ArkInventory.Localise["MENU_BAR_RESET_TEXT"], bar_id ),
							"closeWhenClicked", true,
							"func", function( )
								ArkInventory.Frame_Bar_Clear( loc_id, bar_id )
								ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Recalculate )
							end
						)
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["INSERT"],
							"tooltipTitle", ArkInventory.Localise["INSERT"],
							"tooltipText", string.format( ArkInventory.Localise["MENU_BAR_INSERT_TEXT"], bar_id ),
							"closeWhenClicked", true,
							"func", function( )
								ArkInventory.Frame_Bar_Insert( loc_id, bar_id )
								ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Recalculate )
							end
						)
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["DELETE"],
							"tooltipTitle", ArkInventory.Localise["DELETE"],
							"tooltipText", string.format( ArkInventory.Localise["MENU_BAR_DELETE_TEXT"], bar_id ),
							"closeWhenClicked", true,
							"func", function( )
								ArkInventory.Frame_Bar_Remove( loc_id, bar_id )
								ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Recalculate )
							end
						)
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["MOVE"],
							"tooltipTitle", ArkInventory.Localise["MOVE"],
							"tooltipText", string.format( ArkInventory.Localise["MENU_BAR_MOVE_START_TEXT"], bar_id ),
							"disabled", ArkInventory.Global.Options.BarMoveLocation == loc_id and ArkInventory.Global.Options.BarMoveSource == bar_id,
							"closeWhenClicked", true,
							"func", function( )
								ArkInventory.Global.Options.BarMoveLocation = loc_id
								ArkInventory.Global.Options.BarMoveSource = bar_id
							end
						)
						
						if ArkInventory.Global.Options.BarMoveLocation == loc_id and ArkInventory.Global.Options.BarMoveSource ~= bar_id then
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", string.format( "%s: %s", ArkInventory.Localise["MOVE"], ArkInventory.Localise["COMPLETE"] ),
								"tooltipTitle", string.format( "%s: %s", ArkInventory.Localise["MOVE"], ArkInventory.Localise["COMPLETE"] ),
								"tooltipText", string.format( ArkInventory.Localise["MENU_BAR_MOVE_COMPLETE_TEXT"], ArkInventory.Global.Options.BarMoveSource ),
								"closeWhenClicked", true,
								"func", function( )
									ArkInventory.Frame_Bar_Move( loc_id, ArkInventory.Global.Options.BarMoveSource, bar_id )
									ArkInventory.Global.Options.BarMoveLocation = nil
									ArkInventory.Global.Options.BarMoveSource = nil
									ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Recalculate )
								end
							)
						end
						
					end
					
					
					if value == "BAR_WIDTH" then
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["WIDTH"],
							"isTitle", true
						)
						
						ArkInventory.Lib.Dewdrop:AddLine( )
						
						local c = codex.layout.bar.data[bar_id].width.min
						local text = c
						if not c then
							text = ArkInventory.Localise["AUTOMATIC"]
						end
						text = string.format( ArkInventory.Localise["MENU_BAR_WIDTH_MINIMUM"], ArkInventory.Localise["MINIMUM"], text )
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", text,
							"tooltipTitle", ArkInventory.Localise["MINIMUM"],
							"tooltipText", string.format( ArkInventory.Localise["MENU_BAR_WIDTH_MINIMUM_TEXT"], bar_id ),
							"hasArrow", true,
							"hasEditBox", true,
							"editBoxText", c,
							"editBoxFunc", function( v )
								local z = math.floor( tonumber( v ) or 0 )
								if z < 1 then z = nil end
								codex.layout.bar.data[bar_id].width.min = z
								ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Recalculate )
							end
						)
						
						local c = codex.layout.bar.data[bar_id].width.max
						local text = c
						if not c then
							text = ArkInventory.Localise["AUTOMATIC"]
						end
						text = string.format( ArkInventory.Localise["MENU_BAR_WIDTH_MAXIMUM"], ArkInventory.Localise["MAXIMUM"], text )
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", text,
							"tooltipTitle", ArkInventory.Localise["MAXIMUM"],
							"tooltipText", string.format( ArkInventory.Localise["MENU_BAR_WIDTH_MAXIMUM_TEXT"], bar_id ),
							"hasArrow", true,
							"hasEditBox", true,
							"editBoxText", c,
							"editBoxFunc", function( v )
								local z = math.floor( tonumber( v ) or 0 )
								if z < 1 then z = nil end
								codex.layout.bar.data[bar_id].width.max = z
								ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Recalculate )
							end
						)
					
					end
					
				end

				
				if level == 3 and value then
				
					if strsub( value, 1, 16 ) == "CATEGORY_OPTION_" then
					
						local cat_id = string.match( value, "^CATEGORY_OPTION_(.+)" )
				
						if cat_id ~= nil then
					
							local cat = ArkInventory.Global.Category[cat_id]
							local cat_z, cat_code = ArkInventory.CategoryCodeSplit( cat.id )
							
							local cat_bar, def_bar = ArkInventory.CategoryLocationGet( loc_id, cat.id )
							if cat_bar < 0 then
								cat_bar = abs( cat_bar )
							end
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", cat.fullname,
								"isTitle", true
							)
						
							ArkInventory.Lib.Dewdrop:AddLine( )
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", ArkInventory.Localise["ASSIGN"],
								"tooltipTitle", ArkInventory.Localise["ASSIGN"],
								"tooltipText", string.format( ArkInventory.Localise["MENU_BAR_CATEGORY_TEXT"], string.format( "%s%s%s", LIGHTYELLOW_FONT_COLOR_CODE, cat.fullname, FONT_COLOR_CODE_CLOSE ), bar_id ),
								"disabled", bar_id == cat_bar and not def_bar,
								"closeWhenClicked", true,
								"func", function( )
									ArkInventory.CategoryLocationSet( loc_id, cat.id, bar_id )
									ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Recalculate )
								end
							)
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", ArkInventory.Localise["MOVE"],
								"tooltipTitle", ArkInventory.Localise["MOVE"],
								"tooltipText", string.format( ArkInventory.Localise["MENU_BAR_CATEGORY_MOVE_START_TEXT"], string.format( "%s%s%s", LIGHTYELLOW_FONT_COLOR_CODE, cat.fullname, FONT_COLOR_CODE_CLOSE ) ),
								"disabled", def_bar or ( ArkInventory.Global.Options.CategoryMoveLocation == loc_id and ArkInventory.Global.Options.CategoryMoveSource == cat_bar ),
								"closeWhenClicked", true,
								"func", function( )
									ArkInventory.Global.Options.CategoryMoveLocation = loc_id
									ArkInventory.Global.Options.CategoryMoveSource = cat_bar
									ArkInventory.Global.Options.CategoryMoveCategory = cat.id
								end
							)
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", ArkInventory.Localise["REMOVE"],
								"tooltipTitle", ArkInventory.Localise["REMOVE"],
								"tooltipText", string.format( ArkInventory.Localise["MENU_BAR_CATEGORY_REMOVE_TEXT"], string.format( "%s%s%s", LIGHTYELLOW_FONT_COLOR_CODE, cat.fullname, FONT_COLOR_CODE_CLOSE ), cat_bar ),
								"disabled", def_bar,
								"func", function( )
									ArkInventory.CategoryLocationSet( loc_id, cat_id, nil )
									ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Recalculate )
								end
							)
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", ArkInventory.Localise["HIDE"],
								"tooltipTitle", ArkInventory.Localise["HIDE"],
								"tooltipText", ArkInventory.Localise["MENU_BAR_CATEGORY_HIDDEN_TEXT"],
								"disabled", def_bar,
								"checked", ArkInventory.CategoryHiddenCheck( loc_id, cat_id ),
								"func", function( )
									ArkInventory.CategoryHiddenToggle( loc_id, cat_id )
									ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Recalculate )
								end
							)
							
							ArkInventory.Lib.Dewdrop:AddLine( )
							
							local text = string.format( "%s* %s *%s", RED_FONT_COLOR_CODE, ArkInventory.Localise["LOCKED"], FONT_COLOR_CODE_CLOSE )
							local desc = string.format( ArkInventory.Localise["MENU_LOCKED_TEXT"], ArkInventory.Localise["CONFIG_CATEGORY_SET"], ArkInventory.Localise["CONFIG"], ArkInventory.Localise["CONTROLS"] )
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"hidden", not codex.catset.system,
								"text", text,
								"tooltipTitle", text,
								"tooltipText", desc
							)
							
							local text = ArkInventory.Localise["STATUS"]
							local desc = string.format( ArkInventory.Localise["MENU_BAR_CATEGORY_STATUS"], cat.fullname )
							
							if codex.catset.category.active[cat_z][cat_code] then
								text = string.format( "%s: %s%s", text, GREEN_FONT_COLOR_CODE, ArkInventory.Localise["ENABLED"] )
								if cat.type_code == "RULE" or cat.type_code == "CUSTOM" then
									desc = string.format( ArkInventory.Localise["MENU_BAR_CATEGORY_STATUS_TEXT"], desc, ArkInventory.Localise["DISABLE"] )
								end
							else
								text = string.format( "%s: %s%s", text, RED_FONT_COLOR_CODE, ArkInventory.Localise["DISABLED"] )
								if cat.type_code == "RULE" or cat.type_code == "CUSTOM" then
									desc = string.format( ArkInventory.Localise["MENU_BAR_CATEGORY_STATUS_TEXT"], desc, ArkInventory.Localise["ENABLE"] )
								end
							end
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"hidden", codex.catset.system,
								"text", text,
								"tooltipTitle", text,
								"tooltipText", desc,
								"disabled", not ( cat.type_code == "RULE" or cat.type_code == "CUSTOM" ),
								"func", function( )
									codex.catset.category.active[cat_z][cat_code] = not codex.catset.category.active[cat_z][cat_code]
									ArkInventory.ItemCacheClear( )
									ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Recalculate )
								end
							)
							
							local text = ArkInventory.Localise["CONFIG_JUNK_SELL"]
							local desc = string.format( ArkInventory.Localise["CONFIG_JUNK_CATEGORY_TEXT"], cat.fullname )
							
							if codex.catset.category.junk[cat_z][cat_code] then
								text = string.format( "%s: %s%s", text, GREEN_FONT_COLOR_CODE, ArkInventory.Localise["ENABLED"] )
								if cat.type_code == "RULE" or cat.type_code == "CUSTOM" then
									desc = string.format( ArkInventory.Localise["MENU_BAR_CATEGORY_JUNK_TEXT"], desc, ArkInventory.Localise["DISABLE"] )
								end
							else
								text = string.format( "%s: %s%s", text, RED_FONT_COLOR_CODE, ArkInventory.Localise["DISABLED"] )
								if cat.type_code == "RULE" or cat.type_code == "CUSTOM" then
									desc = string.format( ArkInventory.Localise["MENU_BAR_CATEGORY_JUNK_TEXT"], desc, ArkInventory.Localise["ENABLE"] )
								end
							end
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"hidden", codex.catset.system,
								"text", text,
								"tooltipTitle", text,
								"tooltipText", desc,
								"disabled", not ( cat.type_code == "RULE" or cat.type_code == "CUSTOM" ),
								"func", function( )
									codex.catset.category.junk[cat_z][cat_code] = not codex.catset.category.junk[cat_z][cat_code]
								end
							)
							
						end
						
					end

					if strsub( value, 1, 11 ) == "BAG_OPTION_" then
					
						local bag_id = tonumber( string.match( value, "^BAG_OPTION_(.+)" ) )
						
						if bag_id ~= nil then
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", string.format( "%s > %s", ArkInventory.Localise["BAG"], bag_id ),
								"isTitle", true
							)
							
							ArkInventory.Lib.Dewdrop:AddLine( )
							
							local cv = codex.layout.bag[bag_id].bar
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", ArkInventory.Localise["REMOVE"],
								"tooltipTitle", ArkInventory.Localise["REMOVE"],
--								"tooltipText", string.format( ArkInventory.Localise["MENU_BAR_CATEGORY_REMOVE_TEXT"], cat.fullname, bar_id ),
								"func", function( )
									codex.layout.bag[bag_id].bar = nil
									ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Recalculate )
								end
							)
							
						end
						
					end
					
				end
				
			end
			
		)
		
	end
	
end

function ArkInventory.MenuItemOpen( frame )
	
	assert( frame, "code error: frame argument is missing" )
	
	if ArkInventory.Global.Mode.Edit == false then
		return
	end
	
	if ArkInventory.Lib.Dewdrop:IsOpen( frame ) then
	
		ArkInventory.Lib.Dewdrop:Close( )
		
	else
		
		local loc_id = frame.ARK_Data.loc_id
		local bag_id = frame.ARK_Data.bag_id
		local blizzard_id = ArkInventory.InternalIdToBlizzardBagId( loc_id, bag_id )
		local slot_id = frame.ARK_Data.slot_id
		local codex = ArkInventory.GetLocationCodex( loc_id )
		local i = ArkInventory.Frame_Item_GetDB( frame )
		local info = ArkInventory.ObjectInfoArray( i.h, i )
		
		local isEmpty = false
		if not i or i.h == nil then
			isEmpty = true
		end
		
		
		local x, p, rp
		x = frame:GetLeft( ) + ( frame:GetRight( ) - frame:GetLeft( ) ) / 2
		if ( x >= ( GetScreenWidth( ) / 2 ) ) then
			p = "TOPRIGHT"
			rp = "TOPLEFT"
		else
			p = "TOPLEFT"
			rp = "TOPRIGHT"
		end
		
		local ic = select( 5, ArkInventory.GetItemQualityColor( i.q ) )
		local itemname = string.format( "%s%s%s", ic, info.name or "", FONT_COLOR_CODE_CLOSE )
		
		local cat0, cat1, cat2 = ArkInventory.ItemCategoryGet( i )
		local bar_id = abs( ArkInventory.CategoryLocationGet( loc_id, cat0 ) )
		
		local categories = { "SYSTEM", "CONSUMABLE", "TRADEGOODS", "SKILL", "CLASS", "EMPTY", "CUSTOM", }
		
		cat0 = ArkInventory.Global.Category[cat0] or cat0
		if type( cat0 ) ~= "table" then
			cat0 = { id = cat0, fullname = string.format( ArkInventory.Localise["CONFIG_OBJECT_DELETED"], ArkInventory.Localise["CONFIG_CATEGORY"], cat0 ) }
		end
		
		if cat1 then
			cat1 = ArkInventory.Global.Category[cat1] or cat1
			if type( cat1 ) ~= "table" then
				cat1 = { id = cat1, fullname = string.format( ArkInventory.Localise["CONFIG_OBJECT_DELETED"], ArkInventory.Localise["CONFIG_CATEGORY"], cat1 ) }
			end
		end
		
		cat2 = ArkInventory.Global.Category[cat2] or cat2
		if type( cat2 ) ~= "table" then
			cat2 = { id = cat2, fullname = string.format( ArkInventory.Localise["CONFIG_OBJECT_DELETED"], ArkInventory.Localise["CONFIG_CATEGORY"], cat2 ) }
		end
		
		ArkInventory.Lib.Dewdrop:Open( frame,
			"point", p,
			"relativePoint", rp,
			"children", function( level, value )
			
				if level == 1 then

					ArkInventory.Lib.Dewdrop:AddLine(
						"text", string.format( "%s:", ArkInventory.Localise["MENU_ITEM_TITLE"] ),
						"isTitle", true
					)
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", string.format( "%s: %s", ArkInventory.Localise["ITEM"], itemname )
					)
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					if cat1 then
					
						-- item has a category, that means it's been specifically assigned away from the default
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", string.format( "%s: %s%s%s", ArkInventory.Localise["CURRENT"], GREEN_FONT_COLOR_CODE, cat1.fullname, FONT_COLOR_CODE_CLOSE ),
							"notClickable", true
						)
						
						ArkInventory.Lib.Dewdrop:AddLine( )
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", string.format( "%s: %s%s%s", ArkInventory.Localise["DEFAULT"], LIGHTYELLOW_FONT_COLOR_CODE, cat2.fullname, FONT_COLOR_CODE_CLOSE ),
							"tooltipTitle", ArkInventory.Localise["MENU_ITEM_DEFAULT_RESET"],
							"tooltipText", ArkInventory.Localise["MENU_ITEM_DEFAULT_RESET_TEXT"],
							"closeWhenClicked", true,
							"func", function( )
								ArkInventory.ItemCategorySet( i, nil )
								ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Recalculate )
							end
						)
					
					else
					
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", string.format( "%s: %s%s%s", ArkInventory.Localise["DEFAULT"], LIGHTYELLOW_FONT_COLOR_CODE, cat2.fullname, FONT_COLOR_CODE_CLOSE ),
							"notClickable", true
						)
					
					end
					
					if not codex.style.window.list then
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", string.format( "%s:", ArkInventory.Localise["MENU_ITEM_ASSIGN_CHOICES"] ),
						"isTitle", true
					)
					
					if codex.catset.system then
						
						local text = string.format( "%s* %s *%s", RED_FONT_COLOR_CODE, ArkInventory.Localise["LOCKED"], FONT_COLOR_CODE_CLOSE )
						local desc = string.format( ArkInventory.Localise["MENU_LOCKED_TEXT"], ArkInventory.Localise["CONFIG_CATEGORY_SET"], ArkInventory.Localise["CONFIG"], ArkInventory.Localise["CONTROLS"] )
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", text,
							"tooltipTitle", text,
							"tooltipText", desc
						)
						
					else
						
						for _, v in ipairs( categories ) do
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", ArkInventory.Localise[string.format( "CATEGORY_%s", v )],
								"disabled", isEmpty,
								"hasArrow", true,
								"value", string.format( "CATEGORY_ASSIGN_%s", v )
							)
						end
						
					end
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					if codex.layout.system then
						
						local text = string.format( "%s* %s *%s", RED_FONT_COLOR_CODE, ArkInventory.Localise["LOCKED"], FONT_COLOR_CODE_CLOSE )
						local desc = string.format( ArkInventory.Localise["MENU_LOCKED_TEXT"], ArkInventory.Localise["CONFIG_LAYOUT"], ArkInventory.Localise["CONFIG"], ArkInventory.Localise["CONTROLS"] )
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", text,
							"tooltipTitle", text,
							"tooltipText", desc
						)
					
					else
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["MOVE"],
						"tooltipTitle", ArkInventory.Localise["MOVE"],
						"tooltipText", string.format( ArkInventory.Localise["MENU_BAR_CATEGORY_MOVE_START_TEXT"], string.format( "%s%s%s", LIGHTYELLOW_FONT_COLOR_CODE, cat0.fullname, FONT_COLOR_CODE_CLOSE ) ),
						"disabled", ArkInventory.Global.Options.CategoryMoveLocation == loc_id and ArkInventory.Global.Options.CategoryMoveSource ==  bar_id,
						"closeWhenClicked", true,
						"func", function( )
							ArkInventory.Global.Options.CategoryMoveLocation = loc_id
							ArkInventory.Global.Options.CategoryMoveSource = bar_id
							ArkInventory.Global.Options.CategoryMoveCategory = cat0.id
						end
					)
					
					if ArkInventory.Global.Options.CategoryMoveLocation == loc_id and ArkInventory.Global.Options.CategoryMoveSource ~= bar_id then
						
						local cat = ArkInventory.Global.Category[ArkInventory.Global.Options.CategoryMoveCategory]
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", string.format( "%s: %s", ArkInventory.Localise["MOVE"], ArkInventory.Localise["COMPLETE"] ),
							"tooltipTitle", string.format( "%s: %s", ArkInventory.Localise["MOVE"], ArkInventory.Localise["COMPLETE"] ),
							"tooltipText", string.format( ArkInventory.Localise["MENU_BAR_CATEGORY_MOVE_COMPLETE_TEXT"], string.format( "%s%s%s", LIGHTYELLOW_FONT_COLOR_CODE, cat.fullname, FONT_COLOR_CODE_CLOSE ), ArkInventory.Global.Options.CategoryMoveSource, bar_id ),
							"closeWhenClicked", true,
							"func", function( )
								ArkInventory.CategoryLocationSet( loc_id, cat.id, bar_id )
								ArkInventory.Global.Options.CategoryMoveLocation = nil
								ArkInventory.Global.Options.CategoryMoveSource = nil
								ArkInventory.Global.Options.CategoryMoveCategory = nil
								ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Recalculate )
							end
						)
						
					end
					
					end
					
					end
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["DEBUG"],
						"hasArrow", true,
						"value", "DEBUG_INFO"
					)
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["CLOSE_MENU"],
						"closeWhenClicked", true
					)
					
				end
				
				
				if level == 2 and value then
					
					if value == "DEBUG_INFO" then
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["DEBUG"],
							"isTitle", true
						)
						
						local bagtype = ArkInventory.Const.Slot.Data[ArkInventory.BagType( blizzard_id )].type
						
						ArkInventory.Lib.Dewdrop:AddLine( )
						
						ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s (%s)", ArkInventory.Localise["LOCATION"], LIGHTYELLOW_FONT_COLOR_CODE, loc_id, ArkInventory.Global.Location[loc_id].Name ) )
						ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s (%s)", ArkInventory.Localise["BAG"], LIGHTYELLOW_FONT_COLOR_CODE, bag_id, blizzard_id ) )
						ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s (%s)", ArkInventory.Localise["SLOT"], LIGHTYELLOW_FONT_COLOR_CODE, slot_id, bagtype ) )
						--ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s", "sort key", ArkInventory.ItemSortKeyGenerate( i, bar_id ) ) )
						
						ArkInventory.Lib.Dewdrop:AddLine( )
						
						ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s", ArkInventory.Localise["CATEGORY_CLASS"], LIGHTYELLOW_FONT_COLOR_CODE, info.class ) )
						
						ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s", ArkInventory.Localise["NAME"], LIGHTYELLOW_FONT_COLOR_CODE, info.name or "" ) )
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", string.format( "%s: %s%s", ArkInventory.Localise["MENU_ITEM_DEBUG_ITEMSTRING"], LIGHTYELLOW_FONT_COLOR_CODE, info.osd.h ),
							"hasArrow", true,
							"hasEditBox", true,
							"editBoxText", info.osd.h
						)
						
						if i.h then
							
							if info.class == "item" then
								
								ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s (%s)", ITEM_SOULBOUND, LIGHTYELLOW_FONT_COLOR_CODE, i.sb, ArkInventory.Localise[string.format( "ITEM_BIND%s", i.sb or ArkInventory.Const.Bind.Never )] ) )
								
								ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s (%s)", QUALITY, LIGHTYELLOW_FONT_COLOR_CODE, info.q, _G[string.format( "ITEM_QUALITY%s_DESC", info.q )] ) )
								
								ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s", ArkInventory.Localise["MENU_ITEM_DEBUG_LVL_ITEM"], LIGHTYELLOW_FONT_COLOR_CODE, info.ilvl ) )
								ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s", ArkInventory.Localise["MENU_ITEM_DEBUG_LVL_USE"], LIGHTYELLOW_FONT_COLOR_CODE, info.uselevel ) )
								
								if info.osd.sourceid > 0 then
									ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s", ArkInventory.Localise["MENU_ITEM_DEBUG_SOURCE"], LIGHTYELLOW_FONT_COLOR_CODE, info.osd.sourceid ) )
								end
								
								if info.osd.bonusids then
									local tmp = { }
									for k in pairs( info.osd.bonusids ) do
										table.insert( tmp, k )
									end
									ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s", ArkInventory.Localise["MENU_ITEM_DEBUG_BONUS"], LIGHTYELLOW_FONT_COLOR_CODE, table.concat( tmp, ", " ) ) )
								end
								
								ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s (%s)", ArkInventory.Localise["TYPE"], LIGHTYELLOW_FONT_COLOR_CODE, info.itemtypeid, info.itemtype ) )
								ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s (%s)", ArkInventory.Localise["MENU_ITEM_DEBUG_SUBTYPE"], LIGHTYELLOW_FONT_COLOR_CODE, info.itemsubtypeid, info.itemsubtype ) )
								

								if info.equiploc ~= "" then
									local iloc = _G[info.equiploc]
									if iloc then
										ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s", ArkInventory.Localise["EQUIP"], LIGHTYELLOW_FONT_COLOR_CODE, iloc ) )
									end
								end
								
								ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s", AUCTION_STACK_SIZE, LIGHTYELLOW_FONT_COLOR_CODE, info.stacksize ) )
								ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s", ArkInventory.Localise["TEXTURE"], LIGHTYELLOW_FONT_COLOR_CODE, info.texture ) )
								
								local ifam = GetItemFamily( i.h ) or 0
								ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s", ArkInventory.Localise["MENU_ITEM_DEBUG_FAMILY"], LIGHTYELLOW_FONT_COLOR_CODE, ifam ) )
								
								ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s (%s)", ArkInventory.Localise["EXPANSION"], LIGHTYELLOW_FONT_COLOR_CODE, info.expansion, _G[string.format( "EXPANSION_NAME%d", info.expansion )] ) )
								
							elseif info.class == "battlepet" then
								
								ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s (%s)", QUALITY, LIGHTYELLOW_FONT_COLOR_CODE, i.q, _G[string.format( "ITEM_QUALITY%s_DESC", i.q )] ) )
								
								ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s", ArkInventory.Localise["MENU_ITEM_DEBUG_LVL_ITEM"], LIGHTYELLOW_FONT_COLOR_CODE, info.ilvl ) )
								
								ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s (%s)", ArkInventory.Localise["TYPE"], LIGHTYELLOW_FONT_COLOR_CODE, info.itemsubtypeid, ArkInventory.Collection.Pet.PetTypeName( info.itemsubtypeid ) or ArkInventory.Localise["UNKNOWN"] ) )
								
								if i.guid then
									
									ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s", ArkInventory.Localise["MENU_ITEM_DEBUG_PET_ID"], LIGHTYELLOW_FONT_COLOR_CODE, i.guid ) )
									
									local pd = ArkInventory.Collection.Pet.GetPet( i.guid )
									if pd then
										ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s", ArkInventory.Localise["MENU_ITEM_DEBUG_PET_SPECIES"], LIGHTYELLOW_FONT_COLOR_CODE, pd.sd.speciesID ) )
										ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s", "IsRevoked", LIGHTYELLOW_FONT_COLOR_CODE, pd.IsRevoked and "true" or "false" ) )
										ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s", "isLockedForConvert", LIGHTYELLOW_FONT_COLOR_CODE, pd.isLockedForConvert and "true" or "false" ) )
									end
									
								end
								
							elseif info.class == "spell" then
								
								-- mounts
								
								local md = ArkInventory.Collection.Mount.GetMount( i.index )
								
								ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s", ArkInventory.Localise["TYPE"], LIGHTYELLOW_FONT_COLOR_CODE, md.mt or ArkInventory.Localise["UNKNOWN"] ) )
								
								ArkInventory.Lib.Dewdrop:AddLine( )
								
								ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s", ArkInventory.Localise["TEXTURE"], LIGHTYELLOW_FONT_COLOR_CODE, info.texture ) )
								
							end
							
						end
						
						ArkInventory.Lib.Dewdrop:AddLine( )
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", string.format( "%s: %s%s", ArkInventory.Localise["MENU_ITEM_DEBUG_AI_ID_SHORT"], LIGHTYELLOW_FONT_COLOR_CODE, info.id ),
							"hasArrow", true,
							"hasEditBox", true,
							"editBoxText", info.id
						)
						
						ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s", ArkInventory.Localise["CATEGORY"], LIGHTYELLOW_FONT_COLOR_CODE, cat0.id ) )
						
						local cid = ArkInventory.ObjectIDCategory( i )
						ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s (%s): %s%s", ArkInventory.Localise["MENU_ITEM_DEBUG_CACHE"], ArkInventory.Localise["CATEGORY"], LIGHTYELLOW_FONT_COLOR_CODE, cid ) )
						
						cid = ArkInventory.ObjectIDRule( i )
						ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s (%s): %s%s", ArkInventory.Localise["MENU_ITEM_DEBUG_CACHE"], ArkInventory.Localise["RULE"], LIGHTYELLOW_FONT_COLOR_CODE, cid ) )
						
						if i.h then
							if info.class == "item" then
								
								ArkInventory.Lib.Dewdrop:AddLine( )
								ArkInventory.Lib.Dewdrop:AddLine(
									"text", ArkInventory.Localise["MENU_ITEM_DEBUG_PT"],
									"hasArrow", true,
									"tooltipTitle", ArkInventory.Localise["MENU_ITEM_DEBUG_PT"],
									"tooltipText", ArkInventory.Localise["MENU_ITEM_DEBUG_PT_TEXT"],
									"value", "DEBUG_INFO_PT"
								)
								
							end
						end
						
					end
					
					if strsub( value, 1, 16 ) == "CATEGORY_ASSIGN_" then
						
						local k = string.match( value, "CATEGORY_ASSIGN_(.+)" )
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise[string.format( "CATEGORY_%s", k )],
							"isTitle", true
						)
						
						ArkInventory.Lib.Dewdrop:AddLine( )
					
						for _, cat in ArkInventory.spairs( ArkInventory.Global.Category, function(a,b) return ArkInventory.Global.Category[a].sort_order < ArkInventory.Global.Category[b].sort_order end ) do
				
							local t = cat.type_code
							local cat_bar, def_bar = ArkInventory.CategoryLocationGet( loc_id, cat.id )
							local icon = ""
							
							if cat.id == cat0.id then
								t = "DO_NOT_USE"
							end
							
							if k == t then
								
								local cat_z, cat_code = ArkInventory.CategoryCodeSplit( cat.id )
								
								local c1 = ""
								
								if not def_bar then
									c1 = LIGHTYELLOW_FONT_COLOR_CODE
								end
								
								if not codex.catset.category.active[cat_z][cat_code] then
									c1 = RED_FONT_COLOR_CODE
								end
								
								if codex.catset.category.junk[cat_z][cat_code] then
									icon = [[Interface\Icons\INV_Misc_Coin_02]]
								end
								
								local n = string.format( "%s%s", c1, cat.name )
								
								local c2 = GREEN_FONT_COLOR_CODE
								
								if cat_bar < 0 then
									c2 = RED_FONT_COLOR_CODE
								end
								
								if not def_bar then
									n = string.format( "%s %s[%s]", n, c2, abs( cat_bar ) )
								end
								
								ArkInventory.Lib.Dewdrop:AddLine(
									"text", n,
									"tooltipTitle", ArkInventory.Localise["MENU_ITEM_ASSIGN_THIS"],
									"tooltipText", string.format( ArkInventory.Localise["MENU_ITEM_ASSIGN_THIS_TEXT"], itemname, cat.fullname ),
									"icon", icon,
									"hasArrow", true,
									"value", string.format( "CATEGORY_CURRENT_OPTION_%s", cat.id ),
									"closeWhenClicked", true,
									"func", function( )
										ArkInventory.ItemCategorySet( i, cat.id )
										ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Recalculate )
									end
								)
							
							end
							
						end
						
						if k == "CUSTOM" then
						
							ArkInventory.Lib.Dewdrop:AddLine( )
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", ArkInventory.Localise["MENU_ITEM_CUSTOM_NEW"],
								"closeWhenClicked", true,
								"func", function( )
									ArkInventory.Frame_Config_Show( "category_custom" )
								end
							)
							
						end
						
					end
					
				end
				
				
				if level == 3 and value then
					
					if value == "DEBUG_INFO_PT" then
					
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", string.format( "%s: ", ArkInventory.Localise["MENU_ITEM_DEBUG_PT_TITLE"] ),
							"isTitle", true
						)
						
						ArkInventory.Lib.Dewdrop:AddLine( )
						
						--local pt_set = ArkInventory.Lib.PeriodicTable:ItemSearch( i.h )
						local pt_set = ArkInventory.PTItemSearch( i.h )
						
						if not pt_set then
						
							ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s%s", LIGHTYELLOW_FONT_COLOR_CODE, ArkInventory.Localise["MENU_ITEM_DEBUG_PT_NONE"] ) )
						
						else
						
							for k, v in pairs( pt_set ) do
								ArkInventory.Lib.Dewdrop:AddLine(
									"text", v,
									"hasArrow", true,
									"hasEditBox", true,
									"editBoxText", v
								)
							end
							
						end
						
					end
				
					if strsub( value, 1, 24 ) == "CATEGORY_CURRENT_OPTION_" then
					
						local cat_id = string.match( value, "^CATEGORY_CURRENT_OPTION_(.+)" )
				
						if cat_id ~= nil then
					
							local cat = ArkInventory.Global.Category[cat_id]
							local cat_z, cat_code = ArkInventory.CategoryCodeSplit( cat.id )
							
							local cat_bar, def_bar = ArkInventory.CategoryLocationGet( loc_id, cat.id )
							if cat_bar < 0 then
								cat_bar = abs( cat_bar )
							end
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", cat.fullname,
								"isTitle", true
							)
							
							ArkInventory.Lib.Dewdrop:AddLine( )
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", ArkInventory.Localise["ASSIGN"],
								"tooltipTitle", ArkInventory.Localise["ASSIGN"],
								"tooltipText", string.format( ArkInventory.Localise["MENU_ITEM_ASSIGN_THIS_TEXT"], itemname, cat.fullname ),
								"disabled", bar_id == cat_bar and not def_bar,
								"closeWhenClicked", true,
								"func", function( )
									ArkInventory.ItemCategorySet( i, cat.id )
									ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Recalculate )
								end
							)
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", ArkInventory.Localise["MOVE"],
								"tooltipTitle", ArkInventory.Localise["MOVE"],
								"tooltipText", string.format( ArkInventory.Localise["MENU_BAR_CATEGORY_MOVE_START_TEXT"], string.format( "%s%s%s", LIGHTYELLOW_FONT_COLOR_CODE, cat.fullname, FONT_COLOR_CODE_CLOSE ) ),
								"disabled", def_bar or ( ArkInventory.Global.Options.CategoryMoveLocation == loc_id and ArkInventory.Global.Options.CategoryMoveSource == cat_bar ),
								"closeWhenClicked", true,
								"func", function( )
									ArkInventory.Global.Options.CategoryMoveLocation = loc_id
									ArkInventory.Global.Options.CategoryMoveSource = cat_bar
									ArkInventory.Global.Options.CategoryMoveCategory = cat.id
								end
							)
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", ArkInventory.Localise["REMOVE"],
								"tooltipTitle", ArkInventory.Localise["REMOVE"],
								"tooltipText", string.format( ArkInventory.Localise["MENU_BAR_CATEGORY_REMOVE_TEXT"], cat.fullname, cat_bar ),
								"disabled", def_bar,
								"func", function( )
									ArkInventory.CategoryLocationSet( loc_id, cat_id, nil )
									ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Recalculate )
								end
							)
						
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", ArkInventory.Localise["HIDE"],
								"tooltipTitle", ArkInventory.Localise["HIDE"],
								"tooltipText", ArkInventory.Localise["MENU_BAR_CATEGORY_HIDDEN_TEXT"],
								"disabled", def_bar,
								"checked", ArkInventory.CategoryHiddenCheck( loc_id, cat_id ),
								"func", function( )
									ArkInventory.CategoryHiddenToggle( loc_id, cat_id )
									ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Recalculate )
								end
							)
							
							ArkInventory.Lib.Dewdrop:AddLine( )
							
							local text = ArkInventory.Localise["STATUS"]
							local desc = string.format( ArkInventory.Localise["MENU_BAR_CATEGORY_STATUS"], cat.fullname )
							
							if codex.catset.category.active[cat_z][cat_code] then
								text = string.format( "%s: %s%s", text, GREEN_FONT_COLOR_CODE, ArkInventory.Localise["ENABLED"] )
								if cat.type_code == "RULE" or cat.type_code == "CUSTOM" then
									desc = string.format( ArkInventory.Localise["MENU_BAR_CATEGORY_STATUS_TEXT"], desc, ArkInventory.Localise["DISABLE"] )
								end
							else
								text = string.format( "%s: %s%s", text, RED_FONT_COLOR_CODE, ArkInventory.Localise["DISABLED"] )
								if cat.type_code == "RULE" or cat.type_code == "CUSTOM" then
									desc = string.format( ArkInventory.Localise["MENU_BAR_CATEGORY_STATUS_TEXT"], desc, ArkInventory.Localise["ENABLE"] )
								end
							end
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"hidden", codex.catset.system,
								"text", text,
								"tooltipTitle", text,
								"tooltipText", desc,
								"disabled", not ( cat.type_code == "RULE" or cat.type_code == "CUSTOM" ),
								"func", function( )
									codex.catset.category.active[cat_z][cat_code] = not codex.catset.category.active[cat_z][cat_code]
									ArkInventory.ItemCacheClear( )
									ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Recalculate )
								end
							)
							
							local text = ArkInventory.Localise["CONFIG_JUNK_SELL"]
							local desc = string.format( ArkInventory.Localise["CONFIG_JUNK_CATEGORY_TEXT"], cat.fullname )
							
							if codex.catset.category.junk[cat_z][cat_code] then
								text = string.format( "%s: %s%s", text, GREEN_FONT_COLOR_CODE, ArkInventory.Localise["ENABLED"] )
								if cat.type_code == "RULE" or cat.type_code == "CUSTOM" then
									desc = string.format( ArkInventory.Localise["MENU_BAR_CATEGORY_JUNK_TEXT"], desc, ArkInventory.Localise["DISABLE"] )
								end
							else
								text = string.format( "%s: %s%s", text, RED_FONT_COLOR_CODE, ArkInventory.Localise["DISABLED"] )
								if cat.type_code == "RULE" or cat.type_code == "CUSTOM" then
									desc = string.format( ArkInventory.Localise["MENU_BAR_CATEGORY_JUNK_TEXT"], desc, ArkInventory.Localise["ENABLE"] )
								end
							end
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"hidden", codex.catset.system,
								"text", text,
								"tooltipTitle", text,
								"tooltipText", desc,
								"disabled", not ( cat.type_code == "RULE" or cat.type_code == "CUSTOM" ),
								"func", function( )
									codex.catset.category.junk[cat_z][cat_code] = not codex.catset.category.junk[cat_z][cat_code]
								end
							)
							
						end
						
					end

				end
				
			end
			
		)
		
	end
	
end


function ArkInventory.MenuBagOpen( frame )
	
	assert( frame, "code error: frame argument is missing" )
	
	if ArkInventory.Lib.Dewdrop:IsOpen( frame ) then
		
		ArkInventory.Lib.Dewdrop:Close( )
		
	else
		
		local loc_id = frame.ARK_Data.loc_id
		local bag_id = frame.ARK_Data.bag_id
		local blizzard_id = ArkInventory.InternalIdToBlizzardBagId( loc_id, bag_id )
		local codex = ArkInventory.GetLocationCodex( loc_id )
		local player_id = codex.player.data.info.player_id
		
		local i = ArkInventory.Frame_Item_GetDB( frame )
		local info = ArkInventory.ObjectInfoArray( i.h, i )
		
		local isEmpty = false
		if not ( blizzard_id == BACKPACK_CONTAINER or blizzard_id == BANK_CONTAINER ) then
			if not i or i.h == nil then
				isEmpty = true
			end
		end
		
		local bag = codex.player.data.location[loc_id].bag[bag_id]
		
		local x, p, rp
		x = frame:GetLeft( ) + ( frame:GetRight( ) - frame:GetLeft( ) ) / 2
		if ( x >= ( GetScreenWidth( ) / 2 ) ) then
			p = "BOTTOMRIGHT" -- TOPRIGHT
			rp = "TOPLEFT" -- BOTTOMLEFT
		else
			p = "BOTTOMLEFT" -- TOPLEFT
			rp = "TOPRIGHT" -- BOTTOMRIGHT
		end
		
		ArkInventory.Lib.Dewdrop:Open( frame,
			"point", p,
			"relativePoint", rp,
			"children", function( level, value )
				
				if level == 1 then
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["OPTIONS"],
						"icon", ArkInventory.Const.Actions[ArkInventory.Const.ActionID.EditMode].Texture,
						"isTitle", true
					)
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["MENU_BAG_SHOW"],
						"tooltipTitle", ArkInventory.Localise["MENU_BAG_SHOW"],
						"tooltipText", ArkInventory.Localise["MENU_BAG_SHOW_TEXT"],
						"checked", codex.player.data.option[loc_id].bag[bag_id].display,
						"closeWhenClicked", true,
						"func", function( )
							codex.player.data.option[loc_id].bag[bag_id].display = not codex.player.data.option[loc_id].bag[bag_id].display
							ArkInventory.Frame_Main_Generate( loc_id, ArkInventory.Const.Window.Draw.Recalculate )
						end
					)
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["MENU_BAG_ISOLATE"],
						"tooltipTitle", ArkInventory.Localise["MENU_BAG_ISOLATE"],
						"tooltipText", ArkInventory.Localise["MENU_BAG_ISOLATE_TEXT"],
						"closeWhenClicked", true,
						"func", function( )
							for x in pairs( ArkInventory.Global.Location[loc_id].Bags ) do
								if x == bag_id then
									codex.player.data.option[loc_id].bag[x].display = true
								else
									codex.player.data.option[loc_id].bag[x].display = false
								end
							end
							ArkInventory.Frame_Main_Generate( loc_id, ArkInventory.Const.Window.Draw.Recalculate )
						end
					)
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["MENU_BAG_SHOWALL"],
						"tooltipTitle", ArkInventory.Localise["MENU_BAG_SHOWALL"],
						"tooltipText", ArkInventory.Localise["MENU_BAG_SHOWALL_TEXT"],
						"closeWhenClicked", true,
						"func", function( )
							for x in pairs( ArkInventory.Global.Location[loc_id].Bags ) do
								codex.player.data.option[loc_id].bag[x].display = true
							end
							ArkInventory.Frame_Main_Generate( loc_id, ArkInventory.Const.Window.Draw.Recalculate )
						end
					)
					
					if not isEmpty then
						
						ArkInventory.Lib.Dewdrop:AddLine( )
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["EMPTY"],
							"tooltipTitle", ArkInventory.Localise["EMPTY"],
							"tooltipText", ArkInventory.Localise["MENU_BAG_EMPTY_TEXT"],
							"closeWhenClicked", true,
							"func", function( )
								ArkInventory.EmptyBag( loc_id, bag_id )
							end
						)
						
					end
					
					
					if not ArkInventory.Global.Mode.Edit and loc_id == ArkInventory.Const.Location.Bank and bag.status == ArkInventory.Const.Bag.Status.Purchase then
						
						if bag_id == ArkInventory.Global.Location[loc_id].tabReagent then
							
							local cost = GetReagentBankCost( )
							
							ArkInventory.Lib.Dewdrop:AddLine( )
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", BANKSLOTPURCHASE,
								"tooltipTitle", ArkInventory.Localise["REAGENTBANK"],
								"tooltipText", string.format( "%s\n\n%s %s", REAGENTBANK_PURCHASE_TEXT, COSTS_LABEL, ArkInventory.MoneyText( cost, true ) ),
								"closeWhenClicked", true,
								"func", function( )
									PlaySound( SOUNDKIT.IG_MAINMENU_OPTION )
									StaticPopup_Show( "CONFIRM_BUY_REAGENTBANK_TAB" )
								end
							)
							
						else
							
							local numSlots = GetNumBankSlots( )
							local cost = GetBankSlotCost( numSlots )
							
							ArkInventory.Lib.Dewdrop:AddLine( )
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", BANKSLOTPURCHASE,
								"tooltipTitle", BANK_BAG,
								"tooltipText", string.format( "%s\n\n%s %s", BANKSLOTPURCHASE_LABEL, COSTS_LABEL, ArkInventory.MoneyText( cost, true ) ),
								"closeWhenClicked", true,
								"func", function( )
									PlaySound( SOUNDKIT.IG_MAINMENU_OPTION )
									StaticPopup_Show( "CONFIRM_BUY_BANK_SLOT" )
								end
							)
							
						end
						
					elseif not ArkInventory.Global.Mode.Edit and loc_id == ArkInventory.Const.Location.Bank and bag_id == ArkInventory.Global.Location[loc_id].tabReagent then
						
						ArkInventory.Lib.Dewdrop:AddLine( )
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", REAGENTBANK_DEPOSIT,
							"tooltipTitle", REAGENTBANK_DEPOSIT,
							"closeWhenClicked", true,
							"func", function( )
								PlaySound( SOUNDKIT.IG_MAINMENU_OPTION )
								DepositReagentBank( )
							end
						)
						
					end
					
					if ArkInventory.Global.Mode.Edit and not isEmpty then
						
						ArkInventory.Lib.Dewdrop:AddLine( )
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["DEBUG"],
							"hasArrow", true,
							"value", "DEBUG_INFO"
						)
						
					end
					
					if loc_id == ArkInventory.Const.Location.Bag or loc_id == ArkInventory.Const.Location.Bank then
						
						if loc_id == ArkInventory.Const.Location.Bag then
							
							ArkInventory.Lib.Dewdrop:AddLine( )
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", REVERSE_NEW_LOOT_TEXT,
								"tooltipTitle", REVERSE_NEW_LOOT_TEXT,
								"tooltipText", OPTION_TOOLTIP_REVERSE_NEW_LOOT,
								"checked", GetInsertItemsLeftToRight( ),
								"closeWhenClicked", true,
								"func", function( )
									SetInsertItemsLeftToRight( not GetInsertItemsLeftToRight( ) )
									-- its a bit slow to update so close the menu?
								end
							)
							
						end
						
						if blizzard_id > 0 then
							
							ArkInventory.Lib.Dewdrop:AddLine( )
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", BAG_FILTER_ASSIGN_TO,
								"isTitle", true
							)
							
							for i = LE_BAG_FILTER_FLAG_EQUIPMENT, NUM_LE_BAG_FILTER_FLAGS do
								
								if ( i ~= LE_BAG_FILTER_FLAG_JUNK ) then
									
									local checked = false
									
									if loc_id == ArkInventory.Const.Location.Bag then
										
										checked = GetBagSlotFlag( blizzard_id, i )
										
									elseif loc_id == ArkInventory.Const.Location.Bank then
										
										if bag_id == 1 then
											checked = GetBankBagSlotFlag( blizzard_id - NUM_BAG_SLOTS, i )
										else
											checked = GetBagSlotFlag( blizzard_id, i )
										end
										
									end
									
									
									ArkInventory.Lib.Dewdrop:AddLine(
										"text", BAG_FILTER_LABELS[i],
										"tooltipTitle", BAG_FILTER_ASSIGN_TO,
										"tooltipText", BAG_FILTER_LABELS[i],
										"checked", checked,
										"closeWhenClicked", true,
										"func", function( )
											
											if loc_id == ArkInventory.Const.Location.Bag then
												
												SetBagSlotFlag( blizzard_id, i, not checked )
												
											elseif loc_id == ArkInventory.Const.Location.Bank then
												
												if bag_id == 1 then
													SetBankBagSlotFlag( blizzard_id - NUM_BAG_SLOTS, i, not checked )
												else
													SetBagSlotFlag( blizzard_id, i, not checked )
												end
												
											end
											
										end
									)
									
								end
								
							end
							
						end
						
						ArkInventory.Lib.Dewdrop:AddLine( )
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"icon", ArkInventory.Const.Actions[ArkInventory.Const.ActionID.Restack].Texture,
							"text", ArkInventory.Const.Actions[ArkInventory.Const.ActionID.Restack].Name,
							"isTitle", true
						)
						
						local checked = false
						
						if loc_id == ArkInventory.Const.Location.Bag then
							
							if bag_id == 1 then
								checked = GetBackpackAutosortDisabled( )
							else
								checked = GetBagSlotFlag( blizzard_id, LE_BAG_FILTER_FLAG_IGNORE_CLEANUP )
							end
							
						elseif loc_id == ArkInventory.Const.Location.Bank then
							
							if bag_id == 1 then
								checked = GetBankAutosortDisabled( )
							elseif bag_id == ArkInventory.Global.Location[loc_id].tabReagent then
								checked = codex.player.data.option[loc_id].bag[bag_id].restack.ignore
							else
								checked = GetBankBagSlotFlag( blizzard_id - NUM_BAG_SLOTS, LE_BAG_FILTER_FLAG_IGNORE_CLEANUP )
							end
							
						end
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", BAG_FILTER_IGNORE,
							"tooltipTitle", ArkInventory.Localise["RESTACK"],
							"tooltipText", BAG_FILTER_IGNORE,
							"checked", checked,
							"closeWhenClicked", true,
							"func", function( )
								
								if loc_id == ArkInventory.Const.Location.Bag then
									
									if bag_id == 1 then
										SetBackpackAutosortDisabled( not checked )
									else
										SetBagSlotFlag( blizzard_id, LE_BAG_FILTER_FLAG_IGNORE_CLEANUP, not checked )
									end
									
								elseif loc_id == ArkInventory.Const.Location.Bank then
									
									if bag_id == 1 then
										SetBankAutosortDisabled( not checked )
									elseif bag_id == ArkInventory.Global.Location[loc_id].tabReagent then
										codex.player.data.option[loc_id].bag[bag_id].restack.ignore = not checked
									else
										SetBankBagSlotFlag( blizzard_id - NUM_BAG_SLOTS, LE_BAG_FILTER_FLAG_IGNORE_CLEANUP, not checked )
									end
									
								end
								
							end
						)
						
						if loc_id == ArkInventory.Const.Location.Bag then
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", REVERSE_CLEAN_UP_BAGS_TEXT,
								"tooltipTitle", REVERSE_CLEAN_UP_BAGS_TEXT,
								"tooltipText", OPTION_TOOLTIP_REVERSE_CLEAN_UP_BAGS,
								"checked", ArkInventory.db.option.restack.reverse,
								"closeWhenClicked", true,
								"disabled", not ArkInventory.db.option.restack.blizzard,
								"func", function( )
									ArkInventory.db.option.restack.reverse = not ArkInventory.db.option.restack.reverse
									SetSortBagsRightToLeft( ArkInventory.db.option.restack.reverse )
								end
							)
							
						end
						
					end
					
				end
				
				if level == 2 and value then
					
					if value == "DEBUG_INFO" then
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["DEBUG"],
							"isTitle", true
						)
							
						
						ArkInventory.Lib.Dewdrop:AddLine( )
						
						ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s", ArkInventory.Localise["NAME"], LIGHTYELLOW_FONT_COLOR_CODE, info.name ) )
						
						ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s (%s)", ArkInventory.Localise["LOCATION"], LIGHTYELLOW_FONT_COLOR_CODE, loc_id, ArkInventory.Global.Location[loc_id].Name ) )
						
						ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s", ArkInventory.Localise["CATEGORY_CLASS"], LIGHTYELLOW_FONT_COLOR_CODE, info.class ) )

						ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s (%s)", QUALITY, LIGHTYELLOW_FONT_COLOR_CODE, info.q, _G[string.format( "ITEM_QUALITY%s_DESC", info.q )] ) )
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", string.format( "%s: %s%s", ArkInventory.Localise["MENU_ITEM_DEBUG_AI_ID_SHORT"], LIGHTYELLOW_FONT_COLOR_CODE, info.id ),
							"hasArrow", true,
							"hasEditBox", true,
							"editBoxText", info.id
						)
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", string.format( "%s: %s%s (%s)", ArkInventory.Localise["TYPE"], LIGHTYELLOW_FONT_COLOR_CODE, info.itemtypeid, info.itemtype ),
							"hasArrow", true,
							"hasEditBox", true,
							"editBoxText", info.itemtypeid
						)
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", string.format( "%s: %s%s (%s)", ArkInventory.Localise["MENU_ITEM_DEBUG_SUBTYPE"], LIGHTYELLOW_FONT_COLOR_CODE, info.itemsubtypeid, info.itemsubtype ),
							"hasArrow", true,
							"hasEditBox", true,
							"editBoxText", info.itemsubtypeid
						)
						
						ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s", ArkInventory.Localise["TEXTURE"], LIGHTYELLOW_FONT_COLOR_CODE, info.texture ) )
						
						local ifam = GetItemFamily( i.h ) or 0
						ArkInventory.Lib.Dewdrop:AddLine( "text", string.format( "%s: %s%s", ArkInventory.Localise["MENU_ITEM_DEBUG_FAMILY"], LIGHTYELLOW_FONT_COLOR_CODE, ifam ) )
						
					end

				end

			end
			
		)
		
	end
	
end

function ArkInventory.MenuChangerVaultTabOpen( frame )

	assert( frame, "code error: frame argument is missing" )

	if ArkInventory.Lib.Dewdrop:IsOpen( frame ) then
	
		ArkInventory.Lib.Dewdrop:Close( )
		
	else

		local loc_id = frame.ARK_Data.loc_id
		local bag_id = frame.ARK_Data.bag_id
		local codex = ArkInventory.GetLocationCodex( loc_id )
		local bag = codex.player.data.location[loc_id].bag[bag_id]
		local button = _G[string.format( "%s%s%sWindowBag%s", ArkInventory.Const.Frame.Main.Name, loc_id, ArkInventory.Const.Frame.Changer.Name, bag_id )]

		
		local x, p, rp
		x = frame:GetLeft( ) + ( frame:GetRight( ) - frame:GetLeft( ) ) / 2
		if ( x >= ( GetScreenWidth( ) / 2 ) ) then
			p = "TOPRIGHT"
			rp = "TOPLEFT"
		else
			p = "TOPLEFT"
			rp = "TOPRIGHT"
		end
	
		ArkInventory.Lib.Dewdrop:Open( frame,
			"point", p,
			"relativePoint", rp,
			"children", function( level, value )
			
				if level == 1 then
				
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", string.format( "%s: %s", ArkInventory.Localise["VAULT"], string.format( GUILDBANK_TAB_NUMBER, bag_id ) ),
						"icon", bag.texture,
						"isTitle", true
					)
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", bag.name,
						"isTitle", true
					)
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					if not ArkInventory.Global.Location[loc_id].isOffline then
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", "request tab data",
							"closeWhenClicked", true,
							"func", function( )
								QueryGuildBankTab( GetCurrentGuildBankTab( ) or 1 )
							end
						)
						
						ArkInventory.Lib.Dewdrop:AddLine( )
						
					end
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", string.format( "mode: %s", ArkInventory.Localise["VAULT"] ),
						"closeWhenClicked", true,
						"disabled", GuildBankFrame.mode == "bank",
						"func", function( )
							--ArkInventory.Frame_Changer_Vault_Tab_OnClick( button, "LeftButton", "bank" )
							GuildBankFrameTab_OnClick( bag_id, 1 )
							ArkInventory.Frame_Main_Generate( loc_id, ArkInventory.Const.Window.Draw.Recalculate )
						end
					)
					
					if not ArkInventory.Global.Location[loc_id].isOffline then
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", string.format( "mode: %s", GUILD_BANK_LOG ),
							"closeWhenClicked", true,
							"disabled", GuildBankFrame.mode == "log",
							"func", function( )
								ArkInventory.Frame_Main_DrawStatus( loc_id, ArkInventory.Const.Window.Draw.Recalculate )
								--ArkInventory.Frame_Changer_Vault_Tab_OnClick( button, "LeftButton", "log" )
								GuildBankFrameTab_OnClick( bag_id, 2 )
							end
						)
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", string.format( "mode: %s", GUILD_BANK_MONEY_LOG ),
							"closeWhenClicked", true,
							"disabled", GuildBankFrame.mode == "moneylog",
							"func", function( )
								ArkInventory.Frame_Main_DrawStatus( loc_id, ArkInventory.Const.Window.Draw.Recalculate )
								--ArkInventory.Frame_Changer_Vault_Tab_OnClick( button, "LeftButton", "moneylog" )
								GuildBankFrameTab_OnClick( bag_id, 3 )
							end
						)
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", string.format( "mode: %s", GUILD_BANK_TAB_INFO ),
							"closeWhenClicked", true,
							"disabled", GuildBankFrame.mode == "tabinfo",
							"func", function( )
								ArkInventory.Frame_Main_DrawStatus( loc_id, ArkInventory.Const.Window.Draw.Recalculate )
								--ArkInventory.Frame_Changer_Vault_Tab_OnClick( button, "LeftButton", "tabinfo" )
								GuildBankFrameTab_OnClick( bag_id, 4 )
							end
						)
						
						if IsGuildLeader( ) then
						
							ArkInventory.Lib.Dewdrop:AddLine( )
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", "change name or icon",
								"closeWhenClicked", true,
								"func", function( )
									SetCurrentGuildBankTab( bag_id )
									GuildBankPopupFrame:Show( )
									GuildBankPopupFrame_Update( bag_id )
								end
							)
							
						end
						
					end
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["CLOSE_MENU"],
						"closeWhenClicked", true
					)
					
				end
			
			end
			
		)
		
	end
	
end

function ArkInventory.MenuChangerVaultActionOpen( frame )
	
	assert( frame, "code error: frame argument is missing" )
	
	if ArkInventory.Lib.Dewdrop:IsOpen( frame ) then
		
		ArkInventory.Lib.Dewdrop:Close( )
		
	else
		
		local loc_id = ArkInventory.Const.Location.Vault
		local codex = ArkInventory.GetLocationCodex( loc_id )
		local bag_id = ArkInventory.Global.Location[loc_id].view_tab
		local mode = ArkInventory.Global.Location[loc_id].view_mode
		local bag = codex.player.data.location[loc_id].bag[bag_id]
		
		local x, p, rp
		x = frame:GetLeft( ) + ( frame:GetRight( ) - frame:GetLeft( ) ) / 2
		if ( x >= ( GetScreenWidth( ) / 2 ) ) then
			p = "TOPRIGHT"
			rp = "TOPLEFT"
		else
			p = "TOPLEFT"
			rp = "TOPRIGHT"
		end
	
		ArkInventory.Lib.Dewdrop:Open( frame,
			"point", p,
			"relativePoint", rp,
			"children", function( level, value )
				
				local ok = false
				local amount = 0
				local tt = ""
				
				if level == 1 then
				
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["VAULT"],
						"icon", ArkInventory.Global.Location[loc_id].Texture,
						"isTitle", true
					)
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", DEPOSIT,
						"closeWhenClicked", true,
						"func", function( )
							PlaySound( SOUNDKIT.IG_MAINMENU_OPTION )
							StaticPopup_Hide( "GUILDBANK_WITHDRAW" )
							if StaticPopup_Visible( "GUILDBANK_DEPOSIT") then
								StaticPopup_Hide( "GUILDBANK_DEPOSIT" )
							else
								StaticPopup_Show( "GUILDBANK_DEPOSIT" )
							end
						end
					)
					
					
					ok = false
					amount = 0
					tt = ""
					
					amount = GetGuildBankWithdrawMoney( )
					if amount >= 0 then
						
						if ( ( not CanGuildBankRepair( ) and not CanWithdrawGuildBankMoney( ) ) or ( CanGuildBankRepair( ) and not CanWithdrawGuildBankMoney( ) ) ) then
							amount = 0
						else
							amount = min( amount, GetGuildBankMoney( ) )
						end
						
						if amount > 0 then
							ok = true
						end
						
					else
						
						amount = 0
						
					end
					
					if amount > 0 then
						tt = string.format( "%s %s", GUILDBANK_AVAILABLE_MONEY, ArkInventory.MoneyText( amount, true ) )
					end
					
					if ok and ( not CanWithdrawGuildBankMoney( ) ) then
						tt = string.format( "%s%s (%s)", tt, REPAIR_ITEMS )
					end
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", WITHDRAW,
						"tooltipTitle", WITHDRAW,
						"tooltipText", tt,
						"closeWhenClicked", true,
						"disabled", not ok,
						"func", function( )
							PlaySound( SOUNDKIT.IG_MAINMENU_OPTION )
							StaticPopup_Hide( "GUILDBANK_DEPOSIT" )
							if StaticPopup_Visible( "GUILDBANK_WITHDRAW" ) then
								StaticPopup_Hide( "GUILDBANK_WITHDRAW" )
							else
								StaticPopup_Show( "GUILDBANK_WITHDRAW" )
							end
						end
					)
					
					
					ok = nil
					amount = 0
					tt = ""
					
					if IsGuildLeader( ) then
						
						local numSlots = GetNumGuildBankTabs( )
						amount = GetGuildBankTabCost( )
						
						if not amount or amount == 0 or numSlots >= MAX_BUY_GUILDBANK_TABS then
							
							amount = 0
							ok = false
							
						else
							
							if GetMoney( ) >= amount then
								ok = true
							else
								ok = false
							end
							
						end
						
						if amount > 0 then
							tt = string.format( "%s %s", COSTS_LABEL, ArkInventory.MoneyText( amount, true ) )
						end
						
					end
					
					if ok ~= nil then
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", BANKSLOTPURCHASE,
							"tooltipTitle", BANKSLOTPURCHASE,
							"tooltipText", tt,
							"closeWhenClicked", true,
							"disabled", not ok,
							"func", function( )
								PlaySound( SOUNDKIT.IG_MAINMENU_OPTION )
								StaticPopup_Show( "CONFIRM_BUY_GUILDBANK_TAB" )
							end
						)
					end
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", string.format( "%s: %s", string.format( GUILDBANK_TAB_NUMBER, bag_id ), bag.name or "" ),
						"icon", bag.texture,
						"isTitle", true
					)
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", string.format( "%s: %s", DISPLAY, ArkInventory.Localise["VAULT"] ),
						"closeWhenClicked", true,
						"disabled", mode == "bank",
						"func", function( )
							--ArkInventory.Output( "bank" )
							ArkInventory.Global.Location[loc_id].view_mode = "bank"
							ArkInventory.VaultTabClick( bag_id, ArkInventory.Global.Location[loc_id].view_mode )
						end
					)
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", string.format( "%s: %s", DISPLAY, GUILD_BANK_LOG ),
						"closeWhenClicked", true,
						"disabled", mode == "log",
						"func", function( )
							--ArkInventory.Output( "log" )
							ArkInventory.Global.Location[loc_id].view_mode = "log"
							ArkInventory.VaultTabClick( bag_id, ArkInventory.Global.Location[loc_id].view_mode )
						end
					)
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", string.format( "%s: %s", DISPLAY, GUILD_BANK_MONEY_LOG ),
						"closeWhenClicked", true,
						"disabled", mode == "moneylog",
						"func", function( )
							--ArkInventory.Output( "moneylog" )
							ArkInventory.Global.Location[loc_id].view_mode = "moneylog"
							ArkInventory.VaultTabClick( bag_id, ArkInventory.Global.Location[loc_id].view_mode )
						end
					)
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", string.format( "%s: %s", DISPLAY, GUILD_BANK_TAB_INFO ),
						"closeWhenClicked", true,
						"disabled", GuildBankFrame.mode == "tabinfo",
						"func", function( )
							--ArkInventory.Output( "info" )
							ArkInventory.Global.Location[loc_id].view_mode = "tabinfo"
							ArkInventory.VaultTabClick( bag_id, ArkInventory.Global.Location[loc_id].view_mode )
						end
					)
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					if IsGuildLeader( ) then
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", "change name or icon",
							"closeWhenClicked", true,
							"func", function( )
								SetCurrentGuildBankTab( bag_id )
								GuildBankPopupFrame:Show( )
								GuildBankPopupFrame_Update( bag_id )
							end
						)
						
						ArkInventory.Lib.Dewdrop:AddLine( )
						
					end
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", "rescan data",
						"closeWhenClicked", true,
						"func", function( )
							QueryGuildBankTab( GetCurrentGuildBankTab( ) or 1 )
						end
					)
						
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["CLOSE_MENU"],
						"closeWhenClicked", true
					)
					
				end
			
			end
			
		)
		
	end
	
end


function ArkInventory.MenuSwitchLocation( frame, level, value, offset )
	
	assert( frame, "code error: frame argument is missing" )
	
	ArkInventory.Lib.Dewdrop:AddLine(
		"icon", ArkInventory.Const.Actions[ArkInventory.Const.ActionID.SwitchLocation].Texture,
		"text", ArkInventory.Const.Actions[ArkInventory.Const.ActionID.SwitchLocation].Name,
		"isTitle", true
	)
	
	ArkInventory.Lib.Dewdrop:AddLine( )
	
	if level == offset + 1 then
	
		for loc_id, loc_data in ArkInventory.spairs( ArkInventory.Global.Location ) do
			if loc_data.canView then
				ArkInventory.Lib.Dewdrop:AddLine(
					"text", loc_data.Name,
					"tooltipTitle", loc_data.Name,
					"tooltipText", string.format( ArkInventory.Localise["MENU_LOCATION_SWITCH_TEXT"], loc_data.Name ),
					"icon", loc_data.Texture,
					"closeWhenClicked", true,
					"func", function( )
						ArkInventory.Frame_Main_Toggle( loc_id )
					end
				)
			end
		end
		
	end
	
end

function ArkInventory.MenuSwitchLocationOpen( frame )

	assert( frame, "code error: frame argument is missing" )

	if ArkInventory.Lib.Dewdrop:IsOpen( frame ) then
	
		ArkInventory.Lib.Dewdrop:Close( )
	
	else

		local x, p, rp
		x = frame:GetLeft( ) + ( frame:GetRight( ) - frame:GetLeft( ) ) / 2
		if ( x >= ( GetScreenWidth( ) / 2 ) ) then
			p = "TOPRIGHT"
			rp = "BOTTOMLEFT"
		else
			p = "TOPLEFT"
			rp = "BOTTOMRIGHT"
		end
	
		ArkInventory.Lib.Dewdrop:Open( frame,
			"point", p,
			"relativePoint", rp,
			"children", function( level, value )
			
				ArkInventory.MenuSwitchLocation( frame, level, value, 0 )
				
				if level == 1 then
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["CLOSE_MENU"],
						"closeWhenClicked", true
					)
					
				end
				
			end
		)

	end
	
end

function ArkInventory.MenuSwitchCharacter( frame, level, value, offset )
	
	assert( frame, "code error: frame argument is missing" )
	
	local loc_id = frame:GetParent( ):GetParent( ).ARK_Data.loc_id
	local codex = ArkInventory.GetLocationCodex( loc_id )
	
	if level == offset + 1 then
		
		local count = 0
		local realms = { }
		
		ArkInventory.Lib.Dewdrop:AddLine(
			"icon", ArkInventory.Const.Actions[ArkInventory.Const.ActionID.SwitchCharacter].Texture,
			"text", ArkInventory.Const.Actions[ArkInventory.Const.ActionID.SwitchCharacter].Name,
			"isTitle", true
		)
		
		ArkInventory.Lib.Dewdrop:AddLine( )
		
		ArkInventory.Lib.Dewdrop:AddLine(
			"text", codex.player.data.info.realm,
			"notClickable", true
		)
		
		local show
		
		for n, tp in ArkInventory.spairs( ArkInventory.db.player.data, function( a, b ) return ( a < b ) end ) do
			
			show = true
			
			if ( loc_id == ArkInventory.Const.Location.Vault ) and ( tp.info.class ~= "GUILD" ) then
				show = false
			elseif ( loc_id == ArkInventory.Const.Location.Pet ) and ( tp.info.class ~= "ACCOUNT" ) then
				show = false
			elseif ( loc_id == ArkInventory.Const.Location.Mount ) and ( tp.info.class ~= "ACCOUNT" ) then
				show = false
			elseif tp.location[loc_id].slot_count == 0 then
				show = false
			elseif tp.info.realm ~= codex.player.data.info.realm then
				show = false
				realms[tp.info.realm] = true
			end
			
			if show then
				
				count = count + 1
				ArkInventory.Lib.Dewdrop:AddLine(
					"text", ArkInventory.DisplayName4( tp.info, codex.player.data.info.faction ),
					--"tooltipTitle", "",
					--"tooltipText", "",
					"hasArrow", true,
					"isRadio", true,
					"checked", codex.player.data.info.player_id == tp.info.player_id,
					"closeWhenClicked", true,
					"func", function( )
						ArkInventory.Frame_Main_Show( loc_id, tp.info.player_id )
					end,
					"value", string.format( "SWITCH_CHARACTER_ERASE_%s", tp.info.player_id )
				)
				
			end
			
		end
		
		if count == 0 then
			
			ArkInventory.Lib.Dewdrop:AddLine(
				"text", "no data availale",
				"disabled", true
			)
			
		end

		if not ArkInventory.Table.IsEmpty( realms ) then
			
			table.sort( realms )
			
			ArkInventory.Lib.Dewdrop:AddLine( )
			
			for k in ArkInventory.spairs( realms, function( a, b ) return ( a < b ) end ) do
			
				ArkInventory.Lib.Dewdrop:AddLine(
					"text", k,
					--"tooltipTitle", "",
					--"tooltipText", "",
					"hasArrow", true,
					--"isRadio", true,
					--"checked", codex.player.data.info.player_id == tp.info.player_id,
					--"notClickable", codex.player.data.info.player_id == tp.info.player_id,
					--"closeWhenClicked", true,
					"value", string.format( "SWITCH_CHARACTER_REALM_%s", k )
				)
				
			end
			
		end
		
	end
	
	
	if level > offset + 1 and value then
		
		local realm = string.match( value, "^SWITCH_CHARACTER_REALM_(.+)" )
		if realm then
			
			local count = 0
			
			for n, tp in ArkInventory.spairs( ArkInventory.db.player.data, function( a, b ) return a < b end ) do
				
				local show = true
				
				if ( loc_id == ArkInventory.Const.Location.Vault ) and ( tp.info.class ~= "GUILD" ) then
					show = false
				end
				
				if ( loc_id == ArkInventory.Const.Location.Pet ) and ( tp.info.class ~= "ACCOUNT" ) then
					show = false
				end
				
				if ( loc_id == ArkInventory.Const.Location.Mount ) and ( tp.info.class ~= "ACCOUNT" ) then
					show = false
				end
				
				if tp.location[loc_id].slot_count == 0 or tp.info.realm ~= realm then
					show = false
				end
				
				if show then
					
					count = count + 1
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.DisplayName4( tp.info, codex.player.data.info.faction ),
						--"tooltipTitle", "",
						--"tooltipText", "",
						"hasArrow", true,
						"isRadio", true,
						"checked", codex.player.data.info.player_id == tp.info.player_id,
						--"notClickable", codex.player.data.info.player_id == tp.info.player_id,
						"closeWhenClicked", true,
						"func", function( )
							ArkInventory.Frame_Main_Show( loc_id, tp.info.player_id )
						end,
						"value", string.format( "SWITCH_CHARACTER_ERASE_%s", tp.info.player_id )
					)
					
				end
				
			end
			
			
			if count == 0 then
			
				ArkInventory.Lib.Dewdrop:AddLine(
					"text", "no data availale",
					"disabled", true
				)
				
			end
			
		end
		
		local player_id = string.match( value, "^SWITCH_CHARACTER_ERASE_(.+)" )
		if player_id then
			
			local tp = ArkInventory.GetPlayerStorage( player_id )
			
			ArkInventory.Lib.Dewdrop:AddLine(
				"text", ArkInventory.DisplayName4( tp.data.info, codex.player.data.info.faction ),
				"isTitle", true
			)
			
			ArkInventory.Lib.Dewdrop:AddLine( )
			
			if loc_id ~= ArkInventory.Const.Location.Vault then
				ArkInventory.Lib.Dewdrop:AddLine(
					"text", string.format( ArkInventory.Localise["MENU_CHARACTER_SWITCH_ERASE"], ArkInventory.Global.Location[loc_id].Name ),
					"tooltipTitle", string.format( ArkInventory.Localise["MENU_CHARACTER_SWITCH_ERASE"], ArkInventory.Global.Location[loc_id].Name ),
					"tooltipText", string.format( "%s%s", RED_FONT_COLOR_CODE, string.format( ArkInventory.Localise["MENU_CHARACTER_SWITCH_ERASE_TEXT"], ArkInventory.Global.Location[loc_id].Name, ArkInventory.DisplayName1( tp.data.info ) ) ),
					"closeWhenClicked", true,
					"func", function( )
						ArkInventory.Frame_Main_Hide( loc_id )
						ArkInventory.EraseSavedData( tp.data.info.player_id, loc_id )
					end
				)
			end
			
			ArkInventory.Lib.Dewdrop:AddLine(
				"text", string.format( ArkInventory.Localise["MENU_CHARACTER_SWITCH_ERASE"], ArkInventory.Localise["ALL"] ),
				"tooltipTitle", string.format( ArkInventory.Localise["MENU_CHARACTER_SWITCH_ERASE"], ArkInventory.Localise["ALL"] ),
				"tooltipText", string.format( "%s%s", RED_FONT_COLOR_CODE, string.format( ArkInventory.Localise["MENU_CHARACTER_SWITCH_ERASE_TEXT"], ArkInventory.Localise["ALL"], ArkInventory.DisplayName1( tp.data.info ) ) ),
				"closeWhenClicked", true,
				"func", function( )
					ArkInventory.Frame_Main_Hide( )
					ArkInventory.EraseSavedData( tp.data.info.player_id )
				end
			)
		
		end
		
	end

end

function ArkInventory.MenuSwitchCharacterOpen( frame )
	
	assert( frame, "code error: frame argument is missing" )
	
	if ArkInventory.Lib.Dewdrop:IsOpen( frame ) then
		
		ArkInventory.Lib.Dewdrop:Close( )
		
	else
		
		local x, p, rp
		x = frame:GetLeft( ) + ( frame:GetRight( ) - frame:GetLeft( ) ) / 2
		if ( x >= ( GetScreenWidth( ) / 2 ) ) then
			p = "TOPRIGHT"
			rp = "BOTTOMLEFT"
		else
			p = "TOPLEFT"
			rp = "BOTTOMRIGHT"
		end
		
		ArkInventory.Lib.Dewdrop:Open( frame,
			"point", p,
			"relativePoint", rp,
			"children", function( level, value )
				
				ArkInventory.MenuSwitchCharacter( frame, level, value, 0 )
				
				if level == 1 then
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["CLOSE_MENU"],
						"closeWhenClicked", true
					)
					
				end
				
			end
			
		)
		
	end
	
end

function ArkInventory.MenuLDBBagsOpen( frame )
	
	assert( frame, "code error: frame argument is missing" )
	
	local codex = ArkInventory.GetPlayerCodex( )
	
	if ArkInventory.Lib.Dewdrop:IsOpen( frame ) then
	
		ArkInventory.Lib.Dewdrop:Close( )
	
	else
		
		local x, p, rp
		x = frame:GetBottom( ) + ( frame:GetTop( ) - frame:GetBottom( ) ) / 2
		if ( x >= ( GetScreenHeight( ) / 2 ) ) then
			p = "TOPLEFT"
			rp = "BOTTOMLEFT"
		else
			p = "BOTTOMLEFT"
			rp = "TOPLEFT"
		end
		
		ArkInventory.Lib.Dewdrop:Open( frame,
			"point", p,
			"relativePoint", rp,
			"children", function( level, value )
				
				if level == 1 then
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Const.Program.Name,
						"isTitle", true
					)
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Global.Version,
						"notClickable", true
					)
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["CONFIG"],
						"closeWhenClicked", true,
						"func", function( )
							ArkInventory.Frame_Config_Show( )
						end
					)
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["MENU_ACTION"],
						"hasArrow", true,
						"value", "ACTIONS"
					)
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["MENU_LOCATION_SWITCH"],
						"hasArrow", true,
						"value", "LOCATION"
					)
						
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["FONT"],
						"hasArrow", true,
						"value", "FONT"
					)
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["LDB"],
						"hasArrow", true,
						"value", "LDB"
					)
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["CLOSE_MENU"],
						"closeWhenClicked", true
					)
					
				end
				
				
				if level == 2 and value then
				
					if value == "LOCATION" then
						ArkInventory.MenuSwitchLocation( frame, level, value, 1 )
					end
					
					if value == "FONT" then
					
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["FONT"],
							"isTitle", true
						)
						
						for _, face in pairs( ArkInventory.Lib.SharedMedia:List( "font" ) ) do
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", face,
								"tooltipTitle", ArkInventory.Localise["FONT"],
								"tooltipText", string.format( ArkInventory.Localise["CONFIG_GENERAL_FONT_TEXT"], face ),
								"checked", face == ArkInventory.db.option.font.face,
								"func", function( )
									ArkInventory.db.option.font.face = face
									ArkInventory.MediaAllFontSet( face )
								end
							)
						end
						
					end
					
					if value == "ACTIONS" then
					
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["MENU_ACTION"],
							"isTitle", true
						)
						
						for k, v in pairs( ArkInventory.Const.Actions ) do
							if v.LDB then
								ArkInventory.Lib.Dewdrop:AddLine(
									"text", v.Name,
									"closeWhenClicked", true,
									"icon", v.Texture,
									"func", function( )
										v.Scripts.OnClick( nil, nil )
									end
								)
							end
						end
						
					end
					
					if value == "LDB" then
					
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["LDB"],
							"isTitle", true
						)
						
						ArkInventory.Lib.Dewdrop:AddLine( )
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["LDB_BAGS_COLOUR_USE"],
							"tooltipTitle", ArkInventory.Localise["LDB_BAGS_COLOUR_USE"],
							"tooltipText", ArkInventory.Localise["LDB_BAGS_COLOUR_USE_TEXT"],
							"checked", codex.player.data.ldb.bags.colour,
							"func", function( )
								codex.player.data.ldb.bags.colour = not codex.player.data.ldb.bags.colour
								ArkInventory.LDB.Bags:Update( )
							end
						)
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["LDB_BAGS_STYLE"],
							"tooltipTitle", ArkInventory.Localise["LDB_BAGS_STYLE"],
							"tooltipText", ArkInventory.Localise["LDB_BAGS_STYLE_TEXT"],
							"checked", codex.player.data.ldb.bags.full,
							"func", function( )
								codex.player.data.ldb.bags.full = not codex.player.data.ldb.bags.full
								ArkInventory.LDB.Bags:Update( )
							end
						)
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["LDB_BAGS_INCLUDE_TYPE"],
							"tooltipTitle", ArkInventory.Localise["LDB_BAGS_INCLUDE_TYPE"],
							"tooltipText", ArkInventory.Localise["LDB_BAGS_INCLUDE_TYPE_TEXT"],
							"checked", codex.player.data.ldb.bags.includetype,
							"func", function( )
								codex.player.data.ldb.bags.includetype = not codex.player.data.ldb.bags.includetype
								ArkInventory.LDB.Bags:Update( )
							end
						)
						
					end
					
					
				end
				
			end
			
		)
	
	end
	
end

function ArkInventory.MenuLDBTrackingCurrencyOpen( frame )
	
	assert( frame, "code error: frame argument is missing" )
	
	local codex = ArkInventory.GetPlayerCodex( )
	
	if ArkInventory.Lib.Dewdrop:IsOpen( frame ) then
	
		ArkInventory.Lib.Dewdrop:Close( )
	
	else

		local x, p, rp
		x = frame:GetBottom( ) + ( frame:GetTop( ) - frame:GetBottom( ) ) / 2
		if ( x >= ( GetScreenHeight( ) / 2 ) ) then
			p = "TOPLEFT"
			rp = "BOTTOMLEFT"
		else
			p = "BOTTOMLEFT"
			rp = "TOPLEFT"
		end
	
		ArkInventory.Lib.Dewdrop:Open( frame,
			"point", p,
			"relativePoint", rp,
			"children", function( level, value )
				
				if level == 1 then
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.LDB.Tracking_Currency.name,
						"isTitle", true
					)
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Global.Version,
						"notClickable", true
					)
					
					if ArkInventory.Collection.Currency.GetCount( ) == 0 then
						
						ArkInventory.Lib.Dewdrop:AddLine( )
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", "no known currencies",
							"notClickable", true
						)
						
					else
						
						for _, object in ArkInventory.Collection.Currency.IterateList( ) do
							
							--ArkInventory.Output( object )
							
							if object.isHeader then
								
								ArkInventory.Lib.Dewdrop:AddLine( )
								ArkInventory.Lib.Dewdrop:AddLine(
									"text", object.name,
									"isTitle", true
								)
								
							else
								
								local id = object.id
								local info = ArkInventory.Collection.Currency.GetCurrency( id )
								local checked = codex.player.data.ldb.tracking.currency.tracked[id]
								
								local t1 = object.name
								local t2 = ArkInventory.Localise["CLICK_TO_SELECT"]
								if checked then
									t1 = string.format( "%s%s", GREEN_FONT_COLOR_CODE, info.name )
									t2 = ArkInventory.Localise["CLICK_TO_DESELECT"]
								end
								
								ArkInventory.Lib.Dewdrop:AddLine(
									"icon", info.icon,
									"text", t1,
									"tooltipLink", info.link,
									"checked", checked,
									"func", function( )
										codex.player.data.ldb.tracking.currency.tracked[id] = not codex.player.data.ldb.tracking.currency.tracked[id]
										ArkInventory.LDB.Tracking_Currency:Update( )
									end
								)
								
							end
							
						end
						
					end
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["CLOSE_MENU"],
						"closeWhenClicked", true
					)
					
				end
				
			end
			
		)
	
	end
	
end

function ArkInventory.MenuLDBTrackingReputationOpen( frame )
	
	assert( frame, "code error: frame argument is missing" )
	
	local codex = ArkInventory.GetPlayerCodex( )
	
	if ArkInventory.Lib.Dewdrop:IsOpen( frame ) then
	
		ArkInventory.Lib.Dewdrop:Close( )
	
	else

		local x, p, rp
		x = frame:GetBottom( ) + ( frame:GetTop( ) - frame:GetBottom( ) ) / 2
		if ( x >= ( GetScreenHeight( ) / 2 ) ) then
			p = "TOPLEFT"
			rp = "BOTTOMLEFT"
		else
			p = "BOTTOMLEFT"
			rp = "TOPLEFT"
		end
	
		ArkInventory.Lib.Dewdrop:Open( frame,
			"point", p,
			"relativePoint", rp,
			"children", function( level, value )
				
				if level == 1 then
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.LDB.Tracking_Reputation.name,
						"isTitle", true
					)
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Global.Version,
						"notClickable", true
					)
					
					if ArkInventory.Collection.Reputation.GetCount( ) == 0 then
						
						ArkInventory.Lib.Dewdrop:AddLine( )
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", "no known reputations",
							"notClickable", true
						)
						
					else
						
						for _, object in ArkInventory.Collection.Reputation.IterateList( ) do
							
							if object.active then
								
								local canClick = true
								
								if object.isHeader then
									canClick = object.hasRep
								end
								
								if object.isHeader and not object.isChild then
									
									ArkInventory.Lib.Dewdrop:AddLine( )
									
									ArkInventory.Lib.Dewdrop:AddLine(
										"text", object.name,
										"isTitle", true
									)
									
								else
									
									local id = object.id
									local checked = codex.player.data.ldb.tracking.reputation.tracked[id]
									
									local t1 = object.name
									
									if checked then
										t1 = string.format( "%s%s", GREEN_FONT_COLOR_CODE, object.name )
									elseif object.isHeader then
										t1 = string.format( "%s%s|r", NORMAL_FONT_COLOR_CODE, t1 )
									end
									
--									local style_default = "*pv*"
--									local style = style_default
--									if ArkInventory.db.option.tracking.reputation.custom ~= ArkInventory.Const.Reputation.Custom.Default then
--										style = ArkInventory.db.option.tracking.reputation.style.ldb
--										if string.trim( style ) == "" then
--											style = style_default
--										end
--									end
									
									local t2 = ArkInventory.Collection.Reputation.LevelText( id, "*st*" )
									
									ArkInventory.Lib.Dewdrop:AddLine(
										"notClickable", not canClick,
										"icon", not object.isHeader and info and info.icon,
										"text", string.format( "%s  |cff7f7f7f(%s)|r", t1, t2 ),
										"tooltipTitle", t1,
										"tooltipText", t2,
										--"tooltipLink", info.link,
										"checked", checked,
										"func", function( )
											codex.player.data.ldb.tracking.reputation.tracked[id] = not codex.player.data.ldb.tracking.reputation.tracked[id]
											ArkInventory.LDB.Tracking_Reputation:Update( )
										end,
										"hasArrow", canClick,
										"value", id
									)
									
								end
								
							end
							
						end
						
					end
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["CLOSE_MENU"],
						"closeWhenClicked", true
					)
					
				end
				
				if level == 2 and value and value > 0 then
					
					local id = tonumber( value )
					
					local txt1 = ArkInventory.Localise["SHOW"]
					if codex.player.data.ldb.tracking.reputation.watched == id then
						txt1 = ArkInventory.Localise["HIDE"]
					end
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", txt1,
						"func", function( )
							if codex.player.data.ldb.tracking.reputation.watched == id then
								codex.player.data.ldb.tracking.reputation.watched = nil
							else
								codex.player.data.ldb.tracking.reputation.watched = id
							end
							ArkInventory.LDB.Tracking_Reputation:Update( )
						end
					)
					
				end

				
				
			end
			
		)
	
	end
	
end

function ArkInventory.MenuLDBTrackingItemOpen( frame )
	
	assert( frame, "code error: frame argument is missing" )
	
	local codex = ArkInventory.GetPlayerCodex( )
	
	if ArkInventory.Lib.Dewdrop:IsOpen( frame ) then
		
		ArkInventory.Lib.Dewdrop:Close( )
		
	else
		
		local x, p, rp
		x = frame:GetBottom( ) + ( frame:GetTop( ) - frame:GetBottom( ) ) / 2
		if ( x >= ( GetScreenHeight( ) / 2 ) ) then
			p = "TOPLEFT"
			rp = "BOTTOMLEFT"
		else
			p = "BOTTOMLEFT"
			rp = "TOPLEFT"
		end
		
		ArkInventory.Lib.Dewdrop:Open( frame,
			"point", p,
			"relativePoint", rp,
			"children", function( level, value )
				
				if level == 1 then
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.LDB.Tracking_Item.name,
						"isTitle", true
					)
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Global.Version,
						"notClickable", true
					)
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					local numTokenTypes = 0
					
					for k in ArkInventory.spairs( ArkInventory.db.option.tracking.items )  do
						
						numTokenTypes = numTokenTypes + 1
						
						local count = GetItemCount( k )
						local name, h, _, _, _, _, _, _, _, icon = GetItemInfo( k )
						local checked = codex.player.data.ldb.tracking.item.tracked[k]
						local t1 = name
						local t2 = ArkInventory.Localise["CLICK_TO_SELECT"]
						
						if checked then
							t1 = string.format( "%s%s", GREEN_FONT_COLOR_CODE, name )
							t2 = ArkInventory.Localise["CLICK_TO_DESELECT"]
						end
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"icon", icon,
							"text", t1,
							--"tooltipTitle", name,
							--"tooltipText", t2,
							"tooltipLink", h,
							"checked", checked,
							"func", function( )
								codex.player.data.ldb.tracking.item.tracked[k] = not codex.player.data.ldb.tracking.item.tracked[k]
								ArkInventory.LDB.Tracking_Item:Update( )
							end,
							"hasArrow", true,
							"value", k
						)
						
					end
					
					if numTokenTypes == 0 then
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["NONE"],
							"disabled", true
						)
						
					end
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["CLOSE_MENU"],
						"closeWhenClicked", true
					)
					
				end
				
				
				if level == 2 and value and value > 0 then
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", string.format( "%s%s%s", RED_FONT_COLOR_CODE, ArkInventory.Localise["REMOVE"], FONT_COLOR_CODE_CLOSE ),
						"tooltipTitle", ArkInventory.Localise["REMOVE"],
						--"tooltipText", "",
						"func", function( )
							ArkInventory.db.option.tracking.items[value] = nil
							codex.player.data.ldb.tracking.item.tracked[value] = false
							ArkInventory.LDB.Tracking_Item:Update( )
						end
					)

				end
				
			end
			
		)
	
	end
	
end

function ArkInventory.MenuMounts( frame, level, value, offset )
	
	assert( frame, "code error: frame argument is missing" )
	
	local codex = ArkInventory.GetPlayerCodex( )
	local icon = ""
	
	if ( level == 1 + offset ) and ( ( offset == 0 ) or ( value and ( value == "INSERT_LOCATION_MENU" ) ) ) then
		
--		ArkInventory.Lib.Dewdrop:AddLine(
--			"text", ArkInventory.Global.Location[ArkInventory.Const.Location.Mount].Name,
--			"isTitle", true
--		)
		
		for mountType in pairs( ArkInventory.Const.MountTypes ) do
			if mountType ~= "x" then
			
				local mode = ArkInventory.Localise[string.upper( string.format( "LDB_MOUNTS_TYPE_%s", mountType ) )]
				ArkInventory.Lib.Dewdrop:AddLine(
					"text", mode,
					"tooltipTitle", mode,
					"hasArrow", true,
					"value", mountType
				)
				
			end
		end
		
		
		ArkInventory.Lib.Dewdrop:AddLine( )
		
		ArkInventory.Lib.Dewdrop:AddLine(
			"text", ArkInventory.Localise["CONFIG"],
			"closeWhenClicked", true,
			"func", function( )
				ArkInventory.Frame_Config_Show( "companion" )
			end
		)
		
	end
	
	
	if ( level == 2 + offset ) and value then
		
		local mountType = value
		local header = ArkInventory.Localise[string.upper( string.format( "LDB_MOUNTS_TYPE_%s", mountType ) )]
		local selected = codex.player.data.ldb.mounts.type[mountType].selected
		
		ArkInventory.Lib.Dewdrop:AddLine(
			"text", header,
			"isTitle", true
		)
		
		ArkInventory.Lib.Dewdrop:AddLine( )
		
		local companionCount = 0
		
		for _, md in ArkInventory.Collection.Mount.Iterate( mountType ) do
			
			companionCount = companionCount + 1
			
			icon = ""
			local text = md.name
			
			if selected[md.spellID] == true then
				icon = ArkInventory.Const.Texture.Yes
				text = string.format( "%s%s%s", GREEN_FONT_COLOR_CODE, text, FONT_COLOR_CODE_CLOSE )
			elseif selected[md.spellID] == false then
				icon = ArkInventory.Const.Texture.No
				text = string.format( "%s%s%s", RED_FONT_COLOR_CODE, text, FONT_COLOR_CODE_CLOSE )
			end
			
			ArkInventory.Lib.Dewdrop:AddLine(
				"icon", icon,
				"text", text,
				"tooltipTitle", md.name,
				"tooltipText", md.desc,
				"hasArrow", true,
				"value", string.format( "%s:%s", mountType, md.index )
			)
			
		end
		
		if companionCount == 0 then
			
			ArkInventory.Lib.Dewdrop:AddLine(
				"text", ArkInventory.Localise["LDB_COMPANION_NONE"],
				"disabled", true
			)
			
		end
		
		ArkInventory.Lib.Dewdrop:AddLine( )
		ArkInventory.Lib.Dewdrop:AddLine(
			"text", ArkInventory.Localise["USE_ALL"],
			"tooltipTitle", ArkInventory.Localise["USE_ALL"],
			"tooltipText", string.format( ArkInventory.Localise["LDB_COMPANION_USEALL_TEXT"], ArkInventory.Localise["MOUNTS"] ),
			"checked", codex.player.data.ldb.mounts.type[mountType].useall,
			"func", function( )
				codex.player.data.ldb.mounts.type[mountType].useall = not codex.player.data.ldb.mounts.type[mountType].useall
				ArkInventory.LDB.Mounts:Update( )
			end
		)
		
		if mountType == "a" then
			
			ArkInventory.Lib.Dewdrop:AddLine( )
			ArkInventory.Lib.Dewdrop:AddLine(
				"text", string.format( ArkInventory.Localise["LDB_MOUNTS_USEFORLAND"], ArkInventory.Localise["LDB_MOUNTS_TYPE_L"] ),
				"tooltipTitle", string.format( ArkInventory.Localise["LDB_MOUNTS_USEFORLAND"], ArkInventory.Localise["LDB_MOUNTS_TYPE_L"] ),
				"tooltipText", string.format( ArkInventory.Localise["LDB_MOUNTS_USEFORLAND_TEXT"], ArkInventory.Localise["LDB_MOUNTS_TYPE_A"], ArkInventory.Localise["LDB_MOUNTS_TYPE_L"] ),
				"checked", codex.player.data.ldb.mounts.type.l.useflying,
				"func", function( )
					codex.player.data.ldb.mounts.type.l.useflying = not codex.player.data.ldb.mounts.type.l.useflying
				end
			)
			
		end
		
		if mountType == "s" then
			
			ArkInventory.Lib.Dewdrop:AddLine( )
			ArkInventory.Lib.Dewdrop:AddLine(
				"text", string.format( ArkInventory.Localise["LDB_MOUNTS_USEFORLAND"], ArkInventory.Localise["LDB_MOUNTS_TYPE_L"] ),
				"tooltipTitle", string.format( ArkInventory.Localise["LDB_MOUNTS_USEFORLAND"], ArkInventory.Localise["LDB_MOUNTS_TYPE_L"] ),
				"tooltipText", string.format( ArkInventory.Localise["LDB_MOUNTS_USEFORLAND_TEXT"], ArkInventory.Localise["LDB_MOUNTS_TYPE_S"], ArkInventory.Localise["LDB_MOUNTS_TYPE_L"] ),
				"checked", codex.player.data.ldb.mounts.type.l.usesurface,
				"func", function( )
					codex.player.data.ldb.mounts.type.l.usesurface = not codex.player.data.ldb.mounts.type.l.usesurface
				end
			)
			
		end
		
		
		
		if mountType == "a" then
			
			ArkInventory.Lib.Dewdrop:AddLine( )
			ArkInventory.Lib.Dewdrop:AddLine(
				"text", ArkInventory.Localise["LDB_MOUNTS_FLYING_DISMOUNT"],
				"tooltipTitle", ArkInventory.Localise["LDB_MOUNTS_FLYING_DISMOUNT"],
				"tooltipText", ArkInventory.Localise["LDB_MOUNTS_FLYING_DISMOUNT_TEXT"],
				"checked", codex.player.data.ldb.mounts.type.a.dismount,
				"func", function( )
					codex.player.data.ldb.mounts.type.a.dismount = not codex.player.data.ldb.mounts.type.a.dismount
				end
			)
			
		end
		
		ArkInventory.Lib.Dewdrop:AddLine( )
		ArkInventory.Lib.Dewdrop:AddLine(
			"text", string.format( ArkInventory.Localise["LDB_MOUNTS_TRAVEL_FORM"], ArkInventory.Localise["SPELL_DRUID_TRAVEL_FORM"] ),
			"tooltipTitle", string.format( ArkInventory.Localise["LDB_MOUNTS_TRAVEL_FORM"], ArkInventory.Localise["SPELL_DRUID_TRAVEL_FORM"] ),
			"tooltipText", string.format( ArkInventory.Localise["LDB_MOUNTS_TRAVEL_FORM_TEXT"], ArkInventory.Localise["SPELL_DRUID_TRAVEL_FORM"] ),
			"checked", codex.player.data.ldb.travelform,
			"disabled", codex.player.data.info.class ~= "DRUID",
			"func", function( )
				codex.player.data.ldb.travelform = not codex.player.data.ldb.travelform
			end
		)
		
	end
	
	if ( level == 3 + offset ) and value then
		
		local mountType, index = string.match( value, "^(.-):(.-)$" )
		index = tonumber( index )
		
		local md = ArkInventory.Collection.Mount.GetMount( index )
		local usable = ArkInventory.Collection.Mount.IsUsable( md.index )
		local selected = codex.player.data.ldb.mounts.type[mountType].selected
		
		ArkInventory.Lib.Dewdrop:AddLine(
			"icon", md.icon,
			"text", md.name,
			"isTitle", true
		)
		
		ArkInventory.Lib.Dewdrop:AddLine( )
		
		ArkInventory.Lib.Dewdrop:AddLine(
			"text", string.format( "%s%s%s", GREEN_FONT_COLOR_CODE, ArkInventory.Localise["CLICK_TO_SELECT"], FONT_COLOR_CODE_CLOSE ),
			"tooltipTitle", md.name,
			"tooltipText", string.format( ArkInventory.Localise["LDB_COMPANION_SELECT"], md.name ),
			"checked", selected[md.spellID] == true,
			"disabled", selected[md.spellID] == true,
			"isRadio", true,
			"func", function( )
				selected[md.spellID] = true
				ArkInventory.LDB.Mounts:Update( )
			end
		)

		ArkInventory.Lib.Dewdrop:AddLine(
			"text", string.format( "%s%s%s", RED_FONT_COLOR_CODE, ArkInventory.Localise["CLICK_TO_IGNORE"], FONT_COLOR_CODE_CLOSE ),
			"tooltipTitle", md.name,
			"tooltipText", string.format( ArkInventory.Localise["LDB_COMPANION_IGNORE"], md.name ),
			"checked", selected[md.spellID] == false,
			"disabled", selected[md.spellID] == false,
			"isRadio", true,
			"func", function( )
				selected[md.spellID] = false
				ArkInventory.LDB.Mounts:Update( )
			end
		)

		if selected[md.spellID] ~= nil then
			ArkInventory.Lib.Dewdrop:AddLine(
				"text", string.format( "%s%s%s", HIGHLIGHT_FONT_COLOR_CODE, ArkInventory.Localise["CLICK_TO_DESELECT"], FONT_COLOR_CODE_CLOSE ),
				"tooltipTitle", md.name,
				"tooltipText", string.format( ArkInventory.Localise["LDB_COMPANION_DESELECT"], md.name ),
				"checked", selected[md.spellID] == nil,
				"disabled", selected[md.spellID] == nil,
				"isRadio", true,
				"func", function( )
					selected[md.spellID] = nil
					ArkInventory.LDB.Mounts:Update( )
				end
			)
		end
		
		ArkInventory.Lib.Dewdrop:AddLine( )
		
		ArkInventory.Lib.Dewdrop:AddLine(
			"text", ArkInventory.Localise["LDB_MOUNTS_SUMMON"],
			"tooltipTitle", md.name,
			"tooltipText", ArkInventory.Localise["LDB_MOUNTS_SUMMON"],
			"disabled", not usable,
			"func", function( )
				ArkInventory.Collection.Mount.Summon( index )
			end
		)
		
	end
	
end

function ArkInventory.MenuLDBMountsOpen( frame )
	
	assert( frame, "code error: frame argument is missing" )
	
	local codex = ArkInventory.GetPlayerCodex( )
	
	if ArkInventory.Lib.Dewdrop:IsOpen( frame ) then
	
		ArkInventory.Lib.Dewdrop:Close( )
	
	else
		
		local x, p, rp
		x = frame:GetLeft( ) + ( frame:GetRight( ) - frame:GetLeft( ) ) / 2
		if ( x >= ( GetScreenWidth( ) / 2 ) ) then
			p = "TOPRIGHT"
			rp = "BOTTOMLEFT"
		else
			p = "TOPLEFT"
			rp = "BOTTOMRIGHT"
		end
	
		ArkInventory.Lib.Dewdrop:Open( frame,
			"point", p,
			"relativePoint", rp,
			"children", function( level, value )
				
				if ( level == 1 ) then
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.LDB.Mounts.name,
						"isTitle", true
					)
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Global.Version,
						"notClickable", true
					)
					
					ArkInventory.Lib.Dewdrop:AddLine( )
				
				end
				
				ArkInventory.MenuMounts( frame, level, value, 0 )
				
				if level == 1 then
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["CLOSE_MENU"],
						"closeWhenClicked", true
					)
					
				end
				
			end
		)

	end
	
end

function ArkInventory.MenuPets( frame, level, value, offset )
	
	assert( frame, "code error: frame argument is missing" )
	
	local codex = ArkInventory.GetPlayerCodex( )
	local selected = codex.player.data.ldb.pets.selected
	
	--ArkInventory.Output( level, " / ", offset, " / ", value )
	
	if ( level == offset + 1 ) and ( ( offset == 0 ) or ( value and ( value == "INSERT_LOCATION_MENU" ) ) ) then
		
		local n = ArkInventory.Collection.Pet.GetCount( )
		
		if n > 0 then
			
			for i = 1, C_PetJournal.GetNumPetTypes( ) do
				ArkInventory.Lib.Dewdrop:AddLine(
					"text", ArkInventory.Collection.Pet.PetTypeName( i ),
					"hasArrow", true,
					"value", string.format( "PETTYPE_%s", i )
				)
			end
			
			ArkInventory.Lib.Dewdrop:AddLine( )
			
			ArkInventory.Lib.Dewdrop:AddLine(
				"text", ArkInventory.Localise["USE_ALL"],
				"tooltipTitle", ArkInventory.Localise["USE_ALL"],
				"tooltipText", string.format( ArkInventory.Localise["LDB_COMPANION_USEALL_TEXT"], ArkInventory.Localise["PETS"] ),
				"checked", codex.player.data.ldb.pets.useall,
				"func", function( )
					codex.player.data.ldb.pets.useall = not codex.player.data.ldb.pets.useall
					ArkInventory.LDB.Pets:Update( )
				end
			)
			
		else
			
			ArkInventory.Lib.Dewdrop:AddLine(
				"text", ArkInventory.Localise["LDB_COMPANION_NONE"],
				"disabled", true
			)
			
		end
		
		ArkInventory.Lib.Dewdrop:AddLine( )
		
		ArkInventory.Lib.Dewdrop:AddLine(
			"text", ArkInventory.Localise["CONFIG"],
			"closeWhenClicked", true,
			"func", function( )
				ArkInventory.Frame_Config_Show( "companion" )
			end
		)
		
	end
	
	if ( level == offset + 2 ) and value then
		
		local petType0 = string.match( value, "^PETTYPE_(.+)$" )
		
		if petType0 then
			
			petType0 = tonumber( petType0 )
			local species = -1
			
			ArkInventory.Lib.Dewdrop:AddLine(
				"text", ArkInventory.Collection.Pet.PetTypeName( petType0 ),
				"isTitle", true
			)
			
			ArkInventory.Lib.Dewdrop:AddLine( )
			
			for _, pd in ArkInventory.Collection.Pet.Iterate( ) do
				
				if ( pd.sd.petType == petType0 ) and ( species ~= pd.sd.speciesID ) then
					
					species = pd.sd.speciesID
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", pd.sd.name,
						"hasArrow", true,
						"value", string.format( "PETSPECIES_%s", pd.sd.speciesID )
					)
				
				end
				
			end
		
		end
		
	end
		
	if ( level == offset + 3 ) and value then
		
		local speciesID = string.match( value, "^PETSPECIES_(.+)$" )
		
		if speciesID then
			
			speciesID = tonumber( speciesID )
			local sd = ArkInventory.Collection.Pet.GetSpeciesInfo( speciesID )
			
			if sd then
				
				ArkInventory.Lib.Dewdrop:AddLine(
					"icon", sd.icon,
					"text", sd.name,
					"isTitle", true
				)
				
				ArkInventory.Lib.Dewdrop:AddLine( )
				
				for _, pd in ArkInventory.Collection.Pet.Iterate( ) do
					
					if ( pd.sd.speciesID == sd.speciesID ) then
						
						local c = select( 5, ArkInventory.GetItemQualityColor( pd.rarity ) )
						local name = string.format( "%s%s|r", c, sd.name )
						
						if pd.cn and pd.cn ~= "" then
							name = string.format( "%s (%s)", name, pd.cn )
						end
						
						name = string.format( "%s [%s]", name, pd.level )
						
						local icon = ""
						
						if selected[pd.guid] == true then
							icon = ArkInventory.Const.Texture.Yes
						elseif selected[pd.guid] == false then
							icon = ArkInventory.Const.Texture.No
						end
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"icon", icon,
							"text", name,
							"tooltipTitle", name,
							"hasArrow", true,
							"value", string.format( "PETID_%s", pd.guid )
						)
					
					end
					
				end
				
			end
		
		end
		
	end
		
	if ( level == offset + 4 ) and value then
		
		local petID = string.match( value, "^PETID_(.+)$" )
		
		if petID then
			
			local pd = ArkInventory.Collection.Pet.GetPet( petID )
			
			local selected = codex.player.data.ldb.pets.selected
			
			ArkInventory.Lib.Dewdrop:AddLine(
				"text", pd.fullname,
				"isTitle", true
			)
			
			ArkInventory.Lib.Dewdrop:AddLine( )
			
			ArkInventory.Lib.Dewdrop:AddLine(
				"text", string.format( "%s%s%s", GREEN_FONT_COLOR_CODE, ArkInventory.Localise["CLICK_TO_SELECT"], FONT_COLOR_CODE_CLOSE ),
				"tooltipTitle", pd.fullname,
				"tooltipText", string.format( ArkInventory.Localise["LDB_COMPANION_SELECT"], pd.fullname ),
				"checked", selected[pd.guid] == true,
				"disabled", selected[pd.guid] == true,
				"isRadio", true,
				"func", function( )
					selected[pd.guid] = true
					ArkInventory.LDB.Pets:Update( )
				end
			)
	
			ArkInventory.Lib.Dewdrop:AddLine(
				"text", string.format( "%s%s%s", RED_FONT_COLOR_CODE, ArkInventory.Localise["CLICK_TO_IGNORE"], FONT_COLOR_CODE_CLOSE ),
				"tooltipTitle", pd.fullname,
				"tooltipText", string.format( ArkInventory.Localise["LDB_COMPANION_IGNORE"], pd.fullname ),
				"checked", selected[pd.guid] == false,
				"disabled", selected[pd.guid] == false,
				"isRadio", true,
				"func", function( )
					selected[pd.guid] = false
					ArkInventory.LDB.Pets:Update( )
				end
			)
			
			if selected[pd.guid] ~= nil then
				ArkInventory.Lib.Dewdrop:AddLine(
					"text", string.format( "%s%s%s", HIGHLIGHT_FONT_COLOR_CODE, ArkInventory.Localise["CLICK_TO_DESELECT"], FONT_COLOR_CODE_CLOSE ),
					"tooltipTitle", pd.fullname,
					"tooltipText", string.format( ArkInventory.Localise["LDB_COMPANION_DESELECT"], pd.fullname ),
					"isRadio", true,
					"func", function( )
						selected[pd.guid] = nil
						ArkInventory.LDB.Pets:Update( )
					end
				)
			end
			
			ArkInventory.Lib.Dewdrop:AddLine( )
			
			local txt = BATTLE_PET_SUMMON
			local active = ArkInventory.Collection.Pet.GetCurrent( )
			if active and active == pd.guid then
				txt = PET_ACTION_DISMISS
			end
			
			ArkInventory.Lib.Dewdrop:AddLine(
				"text", txt,
				"tooltipTitle", pd.fullname,
				"tooltipText", BATTLE_PETS_SUMMON_TOOLTIP,
				"disabled", not ArkInventory.Collection.Pet.CanSummon( pd.guid ),
				"func", function( )
					ArkInventory.Collection.Pet.Summon( pd.guid )
				end
			)
			
		end
		
	end
	
end

function ArkInventory.MenuLDBPetsOpen( frame )
	
	assert( frame, "code error: frame argument is missing" )
	
	local codex = ArkInventory.GetPlayerCodex( )
	
	if ArkInventory.Lib.Dewdrop:IsOpen( frame ) then
		
		ArkInventory.Lib.Dewdrop:Close( )
		
	else
		
		local x, p, rp
		x = frame:GetLeft( ) + ( frame:GetRight( ) - frame:GetLeft( ) ) / 2
		if ( x >= ( GetScreenWidth( ) / 2 ) ) then
			p = "TOPRIGHT"
			rp = "BOTTOMLEFT"
		else
			p = "TOPLEFT"
			rp = "BOTTOMRIGHT"
		end
		
		ArkInventory.Lib.Dewdrop:Open( frame,
			"point", p,
			"relativePoint", rp,
			"children", function( level, value )
				
				if ( level == 1 ) then
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.LDB.Pets.name,
						"isTitle", true
					)
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Global.Version,
						"notClickable", true
					)
					
					ArkInventory.Lib.Dewdrop:AddLine( )
				
				end
				
				ArkInventory.MenuPets( frame, level, value, 0 )
				
				if level == 1 then
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["CLOSE_MENU"],
						"closeWhenClicked", true
					)
					
				end
				
			end
		)

	end
	
end

function ArkInventory.MenuItemPetJournal( frame, index )
	
	assert( frame, "code error: frame argument is missing" )
	assert( index, "code error: index argument is missing" )

	if ArkInventory.Lib.Dewdrop:IsOpen( frame ) then
	
		ArkInventory.Lib.Dewdrop:Close( )
	
	else

		local x, p, rp
		x = frame:GetLeft( ) + ( frame:GetRight( ) - frame:GetLeft( ) ) / 2
		if ( x >= ( GetScreenWidth( ) / 2 ) ) then
			p = "TOPRIGHT"
			rp = "BOTTOMLEFT"
		else
			p = "TOPLEFT"
			rp = "BOTTOMRIGHT"
		end
		
		ArkInventory.Lib.Dewdrop:Open( frame,
			"point", p,
			"relativePoint", rp,
			"children", function( level, value )
				
				local pd = ArkInventory.Collection.Pet.GetPet( index )
				
				if pd then
					
					--ArkInventory.Output( pd.fullname, " / ", pd.rarity, " / ", pd.link )

				if ( level == 1 ) then
					
					--name = string.format( "%s%s|r", select( 5, ArkInventory.GetItemQualityColor( pd.rarity ) ), pd.fullname )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", pd.fullname,
						"icon", pd.sd.icon,
						"isTitle", true
					)
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					local isRevoked = ArkInventory.Collection.Pet.IsRevoked( pd.guid )
					local isLockedForConvert = ArkInventory.Collection.Pet.IsLockedForConvert( pd.guid )
					
					if ( not isRevoked ) and ( not isLockedForConvert ) then
						
						local txt = BATTLE_PET_SUMMON
						if ( ArkInventory.Collection.Pet.GetCurrent( ) == pd.guid ) then
							txt = PET_DISMISS
						end
						
						-- summon / dismiss
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", txt,
							"disabled", not ArkInventory.Collection.Pet.CanSummon( pd.guid ),
							"closeWhenClicked", true,
							"func", function( info )
								ArkInventory.Collection.Pet.Summon( pd.guid )
							end
						)
						
						-- rename
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", BATTLE_PET_RENAME,
							"disabled", not ArkInventory.Collection.Pet.IsReady( ),
							"closeWhenClicked", true,
							"func", function( info )
								ArkInventory.Lib.StaticDialog:Spawn( "BATTLE_PET_RENAME", pd.guid )
							end
						)
						
						-- enable / disable favourite
						if pd.fav then
							txt = BATTLE_PET_UNFAVORITE
						else
							txt = BATTLE_PET_FAVORITE
						end
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", txt,
							"disabled", not ArkInventory.Collection.Pet.IsReady( ),
							"closeWhenClicked", true,
							"func", function( info )
								if pd.fav then
									ArkInventory.Collection.Pet.SetFavorite( pd.guid, 0 )
								else
									ArkInventory.Collection.Pet.SetFavorite( pd.guid, 1 )
								end
							end
						)
						
						-- release
						if ArkInventory.Collection.Pet.CanRelease( pd.guid ) then
							
							txt = nil
							if ArkInventory.Collection.Pet.InBattle( ) then
								txt2 = "in battle"
							elseif ArkInventory.Collection.Pet.IsSlotted( pd.guid ) then
								txt = "slotted"
							end
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", BATTLE_PET_RELEASE,
								"tooltipTitle", BATTLE_PET_RELEASE,
								"tooltipText", txt,
								"disabled", ArkInventory.Collection.Pet.InBattle( ) or ArkInventory.Collection.Pet.IsSlotted( pd.guid ),
								"closeWhenClicked", true,
								"func", function( info )
									ArkInventory.Lib.StaticDialog:Spawn( "BATTLE_PET_RELEASE", pd.guid )
								end
							)
						end
						
						-- cage
						if ArkInventory.Collection.Pet.CanTrade( pd.guid ) then
							
							txt = BATTLE_PET_PUT_IN_CAGE
							
							if ArkInventory.Collection.Pet.IsSlotted( pd.guid ) then
								txt = BATTLE_PET_PUT_IN_CAGE_SLOTTED
							elseif ArkInventory.Collection.Pet.IsHurt( pd.guid ) then
								txt = BATTLE_PET_PUT_IN_CAGE_HEALTH
							end
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", txt,
								"disabled", ArkInventory.Collection.Pet.IsSlotted( pd.guid ) or ArkInventory.Collection.Pet.IsHurt( pd.guid ),
								"closeWhenClicked", true,
								"func", function( info )
									ArkInventory.Lib.StaticDialog:Spawn( "BATTLE_PET_PUT_IN_CAGE", pd.guid )
								end
							)
						end
						
					end
					
				end
				
				else
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", "pet data not found",
						"tooltipTitle", "error",
						"tooltipText", "pet data not found",
						"disabled", true
					)

				end
				
				if ( level == 1 ) then
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["CLOSE_MENU"],
						"closeWhenClicked", true
					)
					
				end
				
			end
		)

	end
	
end

function ArkInventory.MenuItemMountJournal( frame, index )
	
	assert( frame, "code error: frame argument is missing" )
	assert( index, "code error: index argument is missing" )
	
	if ArkInventory.Lib.Dewdrop:IsOpen( frame ) then
	
		ArkInventory.Lib.Dewdrop:Close( )
	
	else

		local x, p, rp
		x = frame:GetLeft( ) + ( frame:GetRight( ) - frame:GetLeft( ) ) / 2
		if ( x >= ( GetScreenWidth( ) / 2 ) ) then
			p = "TOPRIGHT"
			rp = "BOTTOMLEFT"
		else
			p = "TOPLEFT"
			rp = "BOTTOMRIGHT"
		end
		
		ArkInventory.Lib.Dewdrop:Open( frame,
			"point", p,
			"relativePoint", rp,
			"children", function( level, value )
				
				local md = ArkInventory.Collection.Mount.GetMount( index )
				
				if md then
					
					if ( level == 1 ) then
						
						--name = string.format( "%s%s|r", select( 5, ArkInventory.GetItemQualityColor( pd.rarity ) ), pd.fullname )
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", md.name,
							"icon", md.icon,
							"isTitle", true
						)
						
						ArkInventory.Lib.Dewdrop:AddLine( )
						
						-- enable / disable favourite
						if md.fav then
							txt = BATTLE_PET_UNFAVORITE
						else
							txt = BATTLE_PET_FAVORITE
						end
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", txt,
							"disabled", not ArkInventory.Collection.Pet.IsReady( ),
							"closeWhenClicked", true,
							"func", function( info )
								if md.fav then
									ArkInventory.Collection.Mount.SetFavorite( index, false )
								else
									ArkInventory.Collection.Mount.SetFavorite( index, true )
								end
							end
						)
						
					end
					
				else
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", "mount data not found",
						"tooltipTitle", "error",
						"tooltipText", "mount data not found",
						"disabled", true
					)

				end
				
				if ( level == 1 ) then
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["CLOSE_MENU"],
						"closeWhenClicked", true
					)
					
				end
				
			end
		)

	end
	
end

function ArkInventory.MenuRestackOpen( frame )
	
	assert( frame, "code error: frame argument is missing" )

	if ArkInventory.Lib.Dewdrop:IsOpen( frame ) then
		
		ArkInventory.Lib.Dewdrop:Close( )
		
	else
		
		local x, p, rp
		x = frame:GetBottom( ) + ( frame:GetTop( ) - frame:GetBottom( ) ) / 2
		if ( x >= ( GetScreenHeight( ) / 2 ) ) then
			p = "TOPLEFT"
			rp = "BOTTOMLEFT"
		else
			p = "BOTTOMLEFT"
			rp = "TOPLEFT"
		end
	
		ArkInventory.Lib.Dewdrop:Open( frame,
			"point", p,
			"relativePoint", rp,
			"children", function( level, value )
				
				if level == 1 then
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"icon", ArkInventory.Const.Actions[ArkInventory.Const.ActionID.Restack].Texture,
						"text", ArkInventory.Const.Actions[ArkInventory.Const.ActionID.Restack].Name,
						"isTitle", true
					)
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["TYPE"],
						"hasArrow", true,
						"value", "TYPE"
					)
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["OPTIONS"],
						"hasArrow", true,
						"value", "OPTIONS"
					)
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", REAGENTBANK_DEPOSIT,
						"tooltipTitle", REAGENTBANK_DEPOSIT,
						"closeWhenClicked", true,
						"disabled", ArkInventory.Global.Mode.Edit or not ArkInventory.Global.Mode.Bank,
						"func", function( )
							PlaySound( SOUNDKIT.IG_MAINMENU_OPTION )
							DepositReagentBank( )
						end
					)
					
				elseif level == 2 then
					
					if value == "TYPE" then
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", ArkInventory.Localise["TYPE"],
							"isTitle", true
						)
						
						ArkInventory.Lib.Dewdrop:AddLine( )
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", string.format( "%s: %s", ArkInventory.Localise["BLIZZARD"], ArkInventory.Localise["CLEANUP"] ),
							"tooltipTitle", ArkInventory.Localise["BLIZZARD"],
							"tooltipText", ArkInventory.Localise["RESTACK_TYPE"],
							"isRadio", true,
							"checked", ArkInventory.db.option.restack.blizzard,
							--"closeWhenClicked", true,
							"func", function( )
								ArkInventory.db.option.restack.blizzard = true
							end
						)
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", string.format( "%s: %s", ArkInventory.Const.Program.Name, ArkInventory.Localise["RESTACK"] ),
							"tooltipTitle", ArkInventory.Const.Program.Name,
							"tooltipText", ArkInventory.Localise["RESTACK_TYPE"],
							"isRadio", true,
							"checked", not ArkInventory.db.option.restack.blizzard,
							--"closeWhenClicked", true,
							"func", function( )
								ArkInventory.db.option.restack.blizzard = false
							end
						)
						
					end
					
					if value == "OPTIONS" then
						
						local txt = ""
						if ArkInventory.db.option.restack.blizzard then
							txt = string.format( "%s: %s", ArkInventory.Localise["BLIZZARD"], ArkInventory.Localise["CLEANUP"] )
						else
							txt = string.format( "%s: %s", ArkInventory.Const.Program.Name, ArkInventory.Localise["RESTACK"] )
						end
						txt = string.format( "%s - %s", ArkInventory.Localise["OPTIONS"], txt )
						
						ArkInventory.Lib.Dewdrop:AddLine(
							"text", txt,
							"isTitle", true
						)
						
						ArkInventory.Lib.Dewdrop:AddLine( )
						
						if ArkInventory.db.option.restack.blizzard then
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", REAGENTBANK_DEPOSIT,
								"tooltipTitle", REAGENTBANK_DEPOSIT,
								"tooltipText", ArkInventory.Localise["RESTACK_CLEANUP_DEPOSIT"],
								"checked", ArkInventory.db.option.restack.deposit,
								--"closeWhenClicked", true,
								"func", function( )
									ArkInventory.db.option.restack.deposit = not ArkInventory.db.option.restack.deposit
								end
							)
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", REVERSE_CLEAN_UP_BAGS_TEXT,
								"tooltipTitle", REVERSE_CLEAN_UP_BAGS_TEXT,
								"tooltipText", OPTION_TOOLTIP_REVERSE_CLEAN_UP_BAGS,
								"checked", ArkInventory.db.option.restack.reverse,
								--"closeWhenClicked", true,
								"func", function( )
									ArkInventory.db.option.restack.reverse = not ArkInventory.db.option.restack.reverse
									SetSortBagsRightToLeft( ArkInventory.db.option.restack.reverse )
								end
							)
							
						else
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", ArkInventory.Localise["RESTACK_TOPUP_FROM_BAGS"],
								"tooltipTitle", ArkInventory.Localise["RESTACK_TOPUP_FROM_BAGS"],
								"tooltipText", ArkInventory.Localise["RESTACK_TOPUP_FROM_BAGS_TEXT"],
								"checked", ArkInventory.db.option.restack.topup,
								--"closeWhenClicked", true,
								"func", function( )
									ArkInventory.db.option.restack.topup = not ArkInventory.db.option.restack.topup
								end
							)
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", string.format( "%s (%s)", REAGENTBANK_DEPOSIT, ArkInventory.Localise["REAGENTBANK"] ),
								"tooltipTitle", string.format( "%s (%s)", REAGENTBANK_DEPOSIT, ArkInventory.Localise["REAGENTBANK"] ),
								"tooltipText", string.format( ArkInventory.Localise["RESTACK_FILL_FROM_BAGS_TEXT"], ArkInventory.Localise["REAGENTBANK"], ArkInventory.Localise["BACKPACK"] ),
								"checked", ArkInventory.db.option.restack.deposit,
								--"closeWhenClicked", true,
								"func", function( )
									ArkInventory.db.option.restack.deposit = not ArkInventory.db.option.restack.deposit
								end
							)
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", string.format( "%s (%s)", REAGENTBANK_DEPOSIT, ArkInventory.Localise["BANK"] ),
								"tooltipTitle", string.format( "%s (%s)", REAGENTBANK_DEPOSIT, ArkInventory.Localise["BANK"] ),
								"tooltipText", string.format( ArkInventory.Localise["RESTACK_FILL_FROM_BAGS_TEXT"], ArkInventory.Localise["BANK"], ArkInventory.Localise["BACKPACK"] ),
								"checked", ArkInventory.db.option.restack.bank,
								--"closeWhenClicked", true,
								"func", function( )
									ArkInventory.db.option.restack.bank = not ArkInventory.db.option.restack.bank
								end
							)
							
--[[
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", ArkInventory.Localise["RESTACK_REFRESH_WHEN_COMPLETE"],
								"tooltipTitle", ArkInventory.Localise["RESTACK_REFRESH_WHEN_COMPLETE"],
								--"tooltipText", ArkInventory.Localise["RESTACK_REFRESH_WHEN_COMPLETE_TEXT"],
								"checked", ArkInventory.db.option.restack.refresh,
								--"closeWhenClicked", true,
								"func", function( )
									ArkInventory.db.option.restack.refresh = not ArkInventory.db.option.restack.refresh
								end
							)
]]--
							ArkInventory.Lib.Dewdrop:AddLine( )
							
							local txt = ArkInventory.Localise["REAGENTBANK"]
							if not ArkInventory.db.option.restack.priority then
								txt = ArkInventory.Localise["RESTACK_FILL_PRIORITY_PROFESSION"]
							end
							
							ArkInventory.Lib.Dewdrop:AddLine(
								"text", string.format( "%s: %s", ArkInventory.Localise["RESTACK_FILL_PRIORITY"], txt ),
								"tooltipTitle", ArkInventory.Localise["RESTACK_FILL_PRIORITY"],
								"tooltipText", string.format( ArkInventory.Localise["RESTACK_FILL_PRIORITY_TEXT"], ArkInventory.Localise["REAGENTBANK"], ArkInventory.Localise["RESTACK_FILL_PRIORITY_PROFESSION"] ),
								--"checked", ArkInventory.db.option.restack.priority,
								--"closeWhenClicked", true,
								"func", function( )
									ArkInventory.db.option.restack.priority = not ArkInventory.db.option.restack.priority
								end
							)
							
						end
						
					end
					
				end
				
				ArkInventory.Lib.Dewdrop:AddLine( )
				
				ArkInventory.Lib.Dewdrop:AddLine(
					"text", ArkInventory.Localise["CLOSE_MENU"],
					"closeWhenClicked", true
				)
				
			end
			
		)
	
	end
	
end

function ArkInventory.MenuRefreshOpen( frame )
	
	assert( frame, "code error: frame argument is missing" )

	local loc_id = frame:GetParent( ):GetParent( ).ARK_Data.loc_id
	local codex = ArkInventory.GetLocationCodex( loc_id )
	
	if ArkInventory.Lib.Dewdrop:IsOpen( frame ) then
		
		ArkInventory.Lib.Dewdrop:Close( )
		
	else
		
		local x, p, rp
		x = frame:GetBottom( ) + ( frame:GetTop( ) - frame:GetBottom( ) ) / 2
		if ( x >= ( GetScreenHeight( ) / 2 ) ) then
			p = "TOPLEFT"
			rp = "BOTTOMLEFT"
		else
			p = "BOTTOMLEFT"
			rp = "TOPLEFT"
		end
	
		ArkInventory.Lib.Dewdrop:Open( frame,
			"point", p,
			"relativePoint", rp,
			"children", function( level, value )
				
				if level == 1 then
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"icon", ArkInventory.Const.Actions[ArkInventory.Const.ActionID.Refresh].Texture,
						"text", ArkInventory.Const.Actions[ArkInventory.Const.ActionID.Refresh].Name,
						"isTitle", true
					)
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", string.format( "%s: %s", ArkInventory.Localise["CONFIG_DESIGN_ITEM_NEW"], ArkInventory.Localise["RESET"] ),
						"tooltipTitle", ArkInventory.Localise["CONFIG_DESIGN_ITEM_NEW_RESET_TEXT"],
						"closeWhenClicked", true,
						"func", function( )
							ArkInventory.Global.NewItemResetTime = ArkInventory.TimeAsMinutes( )
							ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Recalculate )
						end
					)
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", string.format( "%s: %s", ArkInventory.Localise["ITEMS"], ArkInventory.Localise["CONFIG_DESIGN_ITEM_HIDDEN"] ),
						"tooltipTitle", ArkInventory.Localise["CONFIG_DESIGN_ITEM_HIDDEN_TEXT"],
						"closeWhenClicked", true,
						"checked", ArkInventory.Global.Options.ShowHiddenItems,
						"func", function( )
							ArkInventory.ToggleShowHiddenItems( )
						end
					)
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", string.format( "%s: %s", ArkInventory.Localise["ITEMS"], ArkInventory.Localise["MENU_ACTION_REFRESH_CLEAR_CACHE"] ),
						"tooltipTitle", ArkInventory.Localise["MENU_ACTION_REFRESH_CLEAR_CACHE_TEXT"],
						"closeWhenClicked", true,
						"func", function( )
							ArkInventory.ItemCacheClear( )
						end
					)
					
					
					
					
					
					ArkInventory.Lib.Dewdrop:AddLine( )
					
					ArkInventory.Lib.Dewdrop:AddLine(
						"text", ArkInventory.Localise["CLOSE_MENU"],
						"closeWhenClicked", true
					)
					
				end
				
			end
			
		)
	
	end
	
end
