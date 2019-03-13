--[[

License: All Rights Reserved, (c) 2006-2018

$Revision: 2304 $
$Date: 2019-01-23 21:21:31 +1100 (Wed, 23 Jan 2019) $

]]--

local _G = _G
local select = _G.select
local pairs = _G.pairs
local ipairs = _G.ipairs
local string = _G.string
local type = _G.type
local error = _G.error
local table = _G.table


ArkInventory.Localise = LibStub( "AceLocale-3.0" ):GetLocale( "ArkInventory" )

ArkInventory.Const.Bindings = {
	All = { ITEM_BIND_ON_USE, ITEM_BIND_ON_EQUIP, ITEM_BIND_ON_PICKUP, ITEM_SOULBOUND, ITEM_ACCOUNTBOUND, ITEM_BIND_TO_ACCOUNT, ITEM_BIND_TO_BNETACCOUNT, ITEM_BNETACCOUNTBOUND },
	Use = { ArkInventory.Localise["WOW_TOOLTIP_ITEM_BIND_ON_USE"] },
	Equip = { ArkInventory.Localise["WOW_TOOLTIP_ITEM_BIND_ON_EQUIP"] },
	Pickup = { ArkInventory.Localise["WOW_TOOLTIP_ITEM_BIND_ON_PICKUP"], ArkInventory.Localise["WOW_TOOLTIP_ITEM_SOULBOUND"] },
	Account = { ArkInventory.Localise["WOW_TOOLTIP_ITEM_ACCOUNTBOUND"], ArkInventory.Localise["WOW_TOOLTIP_ITEM_BIND_TO_ACCOUNT"], ArkInventory.Localise["WOW_TOOLTIP_ITEM_BIND_TO_BNETACCOUNT"], ArkInventory.Localise["WOW_TOOLTIP_ITEM_BNETACCOUNTBOUND"] },
}

ArkInventory.Const.Category = {
	
	Min = 1000,
	Max = 8999,
	
	Type = {
		System = 1,
		Custom = 2,
		Rule = 3,
	},
	
	Code = {
		System = { -- do NOT change the indicies - if you have to then see the DatabaseUpgradePostLoad( ) function to remap it
			[401] = {
				["id"] = "SYSTEM_DEFAULT",
				["text"] = ArkInventory.Localise["DEFAULT"],
			},
			[402] = {
				["id"] = "SYSTEM_TRASH",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_MISC_JUNK"],
			},
			[403] = {
				["id"] = "SYSTEM_SOULBOUND",
				["text"] = ArkInventory.Localise["CATEGORY_SYSTEM_SOULBOUND"],
			},
			[405] = {
				["id"] = "SYSTEM_CONTAINER",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_CONTAINER"],
			},
			--[406] = { keys },
			[407] = {
				["id"] = "SYSTEM_MISC",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_MISC"],
			},
			[408] = {
				["id"] = "SYSTEM_REAGENT",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_MISC_REAGENT"],
			},
			[409] = {
				["id"] = "SYSTEM_RECIPE",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_RECIPE"],
			},
			[411] = {
				["id"] = "SYSTEM_QUEST",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_QUEST"],
			},
			[414] = {
				["id"] = "SYSTEM_EQUIPMENT",
				["text"] = ArkInventory.Localise["CATEGORY_SYSTEM_EQUIPMENT"],
			},
			[415] = {
				["id"] = "SYSTEM_MOUNT",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_MISC_MOUNT"],
			},
			[416] = {
				["id"] = "SYSTEM_EQUIPMENT_SOULBOUND",
				["text"] = ArkInventory.Localise["CATEGORY_SYSTEM_EQUIPMENT_SOULBOUND"],
			},
			--[421] = { SYSTEM_PROJECTILE_ARROW }
			--[422] = { SYSTEM_PROJECTILE_BULLET }
			[444] = {
				["id"] = "SYSTEM_EQUIPMENT_ACCOUNTBOUND",
				["text"] = ArkInventory.Localise["CATEGORY_SYSTEM_EQUIPMENT_ACCOUNTBOUND"],
			},
			[423] = {
				["id"] = "SYSTEM_PET_COMPANION_BOUND",
				["text"] = ArkInventory.Localise["PET_COMPANION_BOUND"],
			},
			[443] = {
				["id"] = "SYSTEM_PET_COMPANION_TRADE",
				["text"] = ArkInventory.Localise["PET"],
			},
			[441] = {
				["id"] = "SYSTEM_PET_BATTLE_TRADE",
				["text"] = ArkInventory.Localise["BATTLEPET"],
			},
			[442] = {
				["id"] = "SYSTEM_PET_BATTLE_BOUND",
				["text"] = ArkInventory.Localise["PET_BATTLE_BOUND"],
			},
			[428] = {
				["id"] = "SYSTEM_REPUTATION",
				["text"] = ArkInventory.Localise["REPUTATION"],
			},
			[429] = {
				["id"] = "SYSTEM_UNKNOWN",
				["text"] = ArkInventory.Localise["UNKNOWN"],
			},
			[434] = {
				["id"] = "SYSTEM_GEM",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_GEM"],
			},
			[438] = {
				["id"] = "SYSTEM_CURRENCY",
				["text"] = ArkInventory.Localise["CURRENCY"],
			},
			[439] = {
				["id"] = "SYSTEM_GLYPH",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_GLYPH"],
			},
			[445] = {
				["id"] = "SYSTEM_TOY",
				["text"] = ArkInventory.Localise["TOY"],
			},
			[446] = {
				["id"] = "SYSTEM_NEW",
				["text"] = ArkInventory.Localise["CONFIG_DESIGN_ITEM_NEW"],
			},
			[447] = {
				["id"] = "SYSTEM_HEIRLOOM",
				["text"] = ArkInventory.Localise["HEIRLOOM"],
			},
			[448] = {
				["id"] = "SYSTEM_ARTIFACT_RELIC",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_GEM_ARTIFACT_RELIC"],
			},
			--[510] = TRADEGOODS_ENCHANTMENT
			--[440] = CONSUMABLE_ITEM_ENHANCEMENT
			[440] = {
				["id"] = "SYSTEM_ITEM_ENHANCEMENT",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_ITEM_ENHANCEMENT"],
			},
			[451] = {
				["id"] = "SYSTEM_MYTHIC_KEYSTONE",
				["text"] = ArkInventory.Localise["CATEGORY_SYSTEM_MYTHIC_KEYSTONE"],
			},
			[452] = {
				["id"] = "SYSTEM_CRAFTING_REAGENT",
				["text"] = ArkInventory.Localise["CRAFTING_REAGENT"],
			},
		},
		Consumable = {
			[404] = {
				["id"] = "CONSUMABLE_OTHER",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_CONSUMABLE_OTHER"],
			},
			[417] = {
				["id"] = "CONSUMABLE_FOOD",
				["text"] = ArkInventory.Localise["CATEGORY_CONSUMABLE_FOOD"],
			},
			[418] = {
				["id"] = "CONSUMABLE_DRINK",
				["text"] = ArkInventory.Localise["CATEGORY_CONSUMABLE_DRINK"],
			},
			[419] = {
				["id"] = "CONSUMABLE_POTION_MANA",
				["text"] = ArkInventory.Localise["CATEGORY_CONSUMABLE_POTION_MANA"],
			},
			[420] = {
				["id"] = "CONSUMABLE_POTION_HEAL",
				["text"] = ArkInventory.Localise["CATEGORY_CONSUMABLE_POTION_HEAL"],
			},
			[424] = {
				["id"] = "CONSUMABLE_POTION",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_CONSUMABLE_POTION"],
			},
			[430] = {
				["id"] = "CONSUMABLE_ELIXIR",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_CONSUMABLE_ELIXIR"],
			},
			[431] = {
				["id"] = "CONSUMABLE_FLASK",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_CONSUMABLE_FLASK"],
			},
			[432] = {
				["id"] = "CONSUMABLE_BANDAGE",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_CONSUMABLE_BANDAGE"],
			},
			--[433] = CONSUMABLE_SCROLL
			[435] = {
				["id"] = "CONSUMABLE_ELIXIR_BATTLE",
				["text"] = ArkInventory.Localise["CATEGORY_CONSUMABLE_ELIXIR_BATTLE"],
			},
			[436] = {
				["id"] = "CONSUMABLE_ELIXIR_GUARDIAN",
				["text"] = ArkInventory.Localise["CATEGORY_CONSUMABLE_ELIXIR_GUARDIAN"],
			},
			[437] = {
				["id"] = "CONSUMABLE_FOOD_AND_DRINK",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_CONSUMABLE_FOOD_AND_DRINK"],
			},
			--[425] = TRADEGOODS_DEVICES
			--[426] = TRADEGOODS_EXPLOSIVES
			[426] = {
				["id"] = "CONSUMABLE_EXPLOSIVES_AND_DEVICES",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_CONSUMABLE_EXPLOSIVES_AND_DEVICES"],
			},
			[449] = {
				["id"] = "CONSUMABLE_VANTUSRUNE",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_CONSUMABLE_VANTUSRUNE"],
			},
			[450] = {
				["id"] = "CONSUMABLE_ARTIFACT_POWER",
				["text"] = ArkInventory.Localise["ARTIFACT_POWER"],
			},
		},
		Trade = {
			[412] = {
				["id"] = "TRADEGOODS_OTHER",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_TRADEGOODS_OTHER"],
			},
			[427] = {
				["id"] = "TRADEGOODS_PARTS",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_TRADEGOODS_PARTS"],
			},
			[501] = {
				["id"] = "TRADEGOODS_HERB",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_TRADEGOODS_HERB"],
			},
			[502] = {
				["id"] = "TRADEGOODS_CLOTH",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_TRADEGOODS_CLOTH"],
			},
			[503] = {
				["id"] = "TRADEGOODS_ELEMENTAL",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_TRADEGOODS_ELEMENTAL"],
			},
			[504] = {
				["id"] = "TRADEGOODS_LEATHER",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_TRADEGOODS_LEATHER"],
			},
			[505] = {
				["id"] = "TRADEGOODS_COOKING",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_TRADEGOODS_COOKING"],
			},
			[506] = {
				["id"] = "TRADEGOODS_METAL_AND_STONE",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_TRADEGOODS_METAL_AND_STONE"],
			},
			--[507] = TRADEGOODS_MATERIALS
			[512] = {
				["id"] = "TRADEGOODS_ENCHANTING",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_TRADEGOODS_ENCHANTING"],
			},
			[513] = {
				["id"] = "TRADEGOODS_JEWELCRAFTING",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_TRADEGOODS_JEWELCRAFTING"],
			},
		},
		Skill = { -- do NOT change the indicies
			[101] = {
				["id"] = "SKILL_ALCHEMY",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_RECIPE_ALCHEMY"],
			},
			[102] = {
				["id"] = "SKILL_BLACKSMITHING",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_RECIPE_BLACKSMITHING"],
			},
			[103] = {
				["id"] = "SKILL_COOKING",
				["text"] = ArkInventory.Localise["WOW_SKILL_COOKING"],
			},
			[104] = {
				["id"] = "SKILL_ENGINEERING",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_RECIPE_ENGINEERING"],
			},
			[105] = {
				["id"] = "SKILL_ENCHANTING",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_TRADEGOODS_ENCHANTING"],
			},
			[106] = {
				["id"] = "SKILL_FIRST_AID",
				["text"] = ArkInventory.Localise["WOW_SKILL_FIRSTAID"],
			},
			[107] = {
				["id"] = "SKILL_FISHING",
				["text"] = ArkInventory.Localise["WOW_SKILL_FISHING"],
			},
			[108] = {
				["id"] = "SKILL_HERBALISM",
				["text"] = ArkInventory.Localise["WOW_SKILL_HERBALISM"],
			},
			[109] = {
				["id"] = "SKILL_JEWELCRAFTING",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_TRADEGOODS_JEWELCRAFTING"],
			},
			[110] = {
				["id"] = "SKILL_LEATHERWORKING",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_RECIPE_LEATHERWORKING"],
			},
			[111] = {
				["id"] = "SKILL_MINING",
				["text"] = ArkInventory.Localise["WOW_SKILL_MINING"],
			},
			[112] = {
				["id"] = "SKILL_SKINNING",
				["text"] = ArkInventory.Localise["WOW_SKILL_SKINNING"],
			},
			[113] = {
				["id"] = "SKILL_TAILORING",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_RECIPE_TAILORING"],
			},
			[115] = {
				["id"] = "SKILL_INSCRIPTION",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_RECIPE_INSCRIPTION"],
			},
			[116] = {
				["id"] = "SKILL_ARCHAEOLOGY",
				["text"] = ArkInventory.Localise["WOW_SKILL_ARCHAEOLOGY"],
			},
		},
		Class = {
			[201] = {
				["id"] = "CLASS_DRUID",
				["text"] = ArkInventory.Localise["WOW_CLASS_DRUID"],
			},
			[202] = {
				["id"] = "CLASS_HUNTER",
				["text"] = ArkInventory.Localise["WOW_CLASS_HUNTER"],
			},
			[203] = {
				["id"] = "CLASS_MAGE",
				["text"] = ArkInventory.Localise["WOW_CLASS_MAGE"],
			},
			[204] = {
				["id"] = "CLASS_PALADIN",
				["text"] = ArkInventory.Localise["WOW_CLASS_PALADIN"],
			},
			[205] = {
				["id"] = "CLASS_PRIEST",
				["text"] = ArkInventory.Localise["WOW_CLASS_PRIEST"],
			},
			[206] = {
				["id"] = "CLASS_ROGUE",
				["text"] = ArkInventory.Localise["WOW_CLASS_ROGUE"],
			},
			[207] = {
				["id"] = "CLASS_SHAMAN",
				["text"] = ArkInventory.Localise["WOW_CLASS_SHAMAN"],
			},
			[208] = {
				["id"] = "CLASS_WARLOCK",
				["text"] = ArkInventory.Localise["WOW_CLASS_WARLOCK"],
			},
			[209] = {
				["id"] = "CLASS_WARRIOR",
				["text"] = ArkInventory.Localise["WOW_CLASS_WARRIOR"],
			},
			[210] = {
				["id"] = "CLASS_DEATHKNIGHT",
				["text"] = ArkInventory.Localise["WOW_CLASS_DEATHKNIGHT"],
			},
			[211] = {
				["id"] = "CLASS_MONK",
				["text"] = ArkInventory.Localise["WOW_CLASS_MONK"],
			},
			[212] = {
				["id"] = "CLASS_DEMONHUNTER",
				["text"] = ArkInventory.Localise["WOW_CLASS_DEMONHUNTER"],
			},
		},
		Empty = {
			[300] = {
				["id"] = "EMPTY_UNKNOWN",
				["text"] = ArkInventory.Localise["UNKNOWN"],
			},
			[301] = {
				["id"] = "EMPTY",
				["text"] = ArkInventory.Localise["CATEGORY_EMPTY"],
			},
			[302] = {
				["id"] = "EMPTY_BAG",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_CONTAINER_BAG"],
			},
			--[303] = { empty key },
			[305] = {
				["id"] = "EMPTY_HERB",
				["text"] = ArkInventory.Localise["WOW_SKILL_HERBALISM"],
			},
			[306] = {
				["id"] = "EMPTY_ENCHANTING",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_TRADEGOODS_ENCHANTING"],
			},
			[307] = {
				["id"] = "EMPTY_ENGINEERING",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_RECIPE_ENGINEERING"],
			},
			[308] = {
				["id"] = "EMPTY_GEM",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_GEM"],
			},
			[309] = {
				["id"] = "EMPTY_MINING",
				["text"] = ArkInventory.Localise["WOW_SKILL_MINING"],
			},
			[312] = {
				["id"] = "EMPTY_LEATHERWORKING",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_RECIPE_LEATHERWORKING"],
			},
			[313] = {
				["id"] = "EMPTY_INSCRIPTION",
				["text"] = ArkInventory.Localise["WOW_ITEM_CLASS_RECIPE_INSCRIPTION"],
			},
			[314] = {
				["id"] = "EMPTY_TACKLE",
				["text"] = ArkInventory.Localise["WOW_SKILL_FISHING"],
			},
			--[315] = { empty void storage },
			[316] = {
				["id"] = "EMPTY_COOKING",
				["text"] = ArkInventory.Localise["WOW_SKILL_COOKING"],
			},
			[317] = {
				["id"] = "EMPTY_REAGENTBANK",
				["text"] = ArkInventory.Localise["REAGENTBANK"],
			},
		},
		Other = { -- do NOT change the indicies - if you have to then see the DatabaseUpgradePostLoad( ) function to remap it
			[901] = {
				["id"] = "SYSTEM_CORE_MATS",
				["text"] = ArkInventory.Localise["CATEGORY_SYSTEM_CORE_MATS"],
			},
			[902] = {
				["id"] = "CONSUMABLE_FOOD_PET",
				["text"] = ArkInventory.Localise["CATEGORY_CONSUMABLE_FOOD_PET"],
			},
		},
	},

}

ArkInventory.Const.Actions = {
		[ArkInventory.Const.ActionID.MainMenu] = {
			Texture = nil,
			Name = ArkInventory.Localise["MENU"],
			Scripts = {
				OnClick = function( self, button )
					if not self then return end
					ArkInventory.MenuMainOpen( self )
				end,
				OnEnter = function( self )
					ArkInventory.GameTooltipSetText( self, ArkInventory.Localise["MENU"] )
				end,
			},
		},
		[ArkInventory.Const.ActionID.Close] = {
			Texture = [[Interface\RAIDFRAME\ReadyCheck-NotReady]],
			Name = ArkInventory.Localise["CLOSE"],
			Scripts = {
				OnClick = function( self, button )
					if not self then return end
					local loc_id = self:GetParent( ):GetParent( ):GetID( )
					ArkInventory.Frame_Main_Hide( loc_id )
				end,
				OnEnter = function( self )
					ArkInventory.GameTooltipSetText( self, ArkInventory.Localise["CLOSE"] )
				end,
			},
		},
		[ArkInventory.Const.ActionID.EditMode] = {
			Texture = [[Interface\Icons\Trade_Engineering]],
			Name = ArkInventory.Localise["MENU_ACTION_EDITMODE"],
			Scripts = {
				OnClick = function( self, button )
					if not self then return end
					ArkInventory.Frame_Main_Level( self:GetParent( ):GetParent( ) )
					ArkInventory.ToggleEditMode( )
				end,
				OnEnter = function( self )
					ArkInventory.GameTooltipSetText( self, ArkInventory.Localise["MENU_ACTION_EDITMODE"] )
				end,
			},
		},
		[ArkInventory.Const.ActionID.Rules] = {
			--Texture = [[Interface\Icons\INV_Misc_Note_05]],
			--Texture = [[Interface\Icons\Interface\Icons\INV_Gizmo_02]],
			Texture = [[Interface\Icons\INV_Misc_Book_10]],
			Name = ArkInventory.Localise["CONFIG_RULE_PLURAL"],
			LDB = true,
			Scripts = {
				OnClick = function( self, button )
					if not self then return end
					ArkInventory.Frame_Main_Level( self:GetParent( ):GetParent( ) )
					ArkInventory.Frame_Rules_Toggle( )
				end,
				OnEnter = function( self )
					ArkInventory.GameTooltipSetText( self, ArkInventory.Localise["CONFIG_RULE_PLURAL"] )
				end,
			},
		},
		[ArkInventory.Const.ActionID.Search] = {
			--Texture = [[Interface\Icons\INV_Misc_EngGizmos_20]],
			Texture = [[Interface\Minimap\Tracking\None]],
			Name = ArkInventory.Localise["SEARCH"],
			LDB = true,
			Scripts = {
				OnClick = function( self, button )
					if not self then return end
					if button == "RightButton" then
						ArkInventory.Frame_Main_Level( self:GetParent( ):GetParent( ) )
						local loc_id = self:GetParent( ):GetParent( ):GetID( )
						if ArkInventory.Global.Location[loc_id].canSearch then
							ArkInventory.Global.Location[loc_id].filter = ""
							local me = ArkInventory.GetPlayerCodex( loc_id )
							me.style.search.hide = not me.style.search.hide
							ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Refresh )
						end
					else
						ArkInventory.Search.Frame_Toggle( )
					end
				end,
				OnEnter = function( self )
					ArkInventory.GameTooltipSetText( self, ArkInventory.Localise["SEARCH"] )
				end,
			},
		},
		[ArkInventory.Const.ActionID.SwitchCharacter] = {
			Texture = [[Interface\Icons\INV_Misc_GroupLooking]],
			Name = ArkInventory.Localise["MENU_CHARACTER_SWITCH"],
			Scripts = {
				OnClick = function( self, button )
					if not self then return end
					ArkInventory.Frame_Main_Level( self:GetParent( ):GetParent( ) )
					ArkInventory.MenuSwitchCharacterOpen( self )
				end,
				OnEnter = function( self )
					ArkInventory.GameTooltipSetText( self, ArkInventory.Localise["MENU_CHARACTER_SWITCH"] )
				end,
			},
		},
		[ArkInventory.Const.ActionID.SwitchLocation] = {
			Texture = [[Interface\Icons\INV_Helmet_47]],
			Name = ArkInventory.Localise["MENU_LOCATION_SWITCH"],
			Scripts = {
				OnClick = function( self, button )
					if not self then return end
					ArkInventory.Frame_Main_Level( self:GetParent( ):GetParent( ) )
					ArkInventory.MenuSwitchLocationOpen( self )
				end,
				OnEnter = function( self )
					ArkInventory.GameTooltipSetText( self, ArkInventory.Localise["MENU_LOCATION_SWITCH"] )
				end,
			},
		},
		[ArkInventory.Const.ActionID.Restack] = {
			Texture = [[Interface\Icons\Spell_Shadow_DestructiveSoul]], -- find texture used by bags-button-autosort-up
			Name = ArkInventory.Localise["RESTACK"],
			Scripts = {
				OnClick = function( self, button )
					if not self then return end
					if button == "RightButton" then
						ArkInventory.MenuRestackOpen( self )
					else
						local loc_id = self:GetParent( ):GetParent( ):GetID( )
						ArkInventory.Restack( loc_id )
					end
				end,
				OnEnter = function( self )
					ArkInventory.GameTooltipSetText( self, ArkInventory.Localise["RESTACK"] )
				end,
			},
		},
		[ArkInventory.Const.ActionID.Changer] = {
			Texture = [[Interface\Icons\INV_Misc_EngGizmos_17]],
			Name = ArkInventory.Localise["MENU_ACTION_BAGCHANGER"],
			Scripts = {
				OnClick = function( self, button )
					if not self then return end
					ArkInventory.Frame_Main_Level( self:GetParent( ):GetParent( ) )
					ArkInventory.ToggleChanger( self:GetParent( ):GetParent( ):GetID( ) )
				end,
				OnEnter = function( self )
					ArkInventory.GameTooltipSetText( self, ArkInventory.Localise["MENU_ACTION_BAGCHANGER"] )
				end,
			},
		},
		[ArkInventory.Const.ActionID.Refresh] = {
			Texture = [[Interface\Icons\Spell_Frost_Stun]],
			Name = ArkInventory.Localise["REFRESH"],
			Scripts = {
				OnClick = function( self, button )
					if not self then return end
					ArkInventory.Frame_Main_Level( self:GetParent( ):GetParent( ) )
					if button == "RightButton" then
						ArkInventory.MenuRefreshOpen( self )
					else
						local loc_id = self:GetParent( ):GetParent( ):GetID( )
						--ArkInventory.OutputWarning( "refresh action - .Recalculate" )
						ArkInventory.Frame_Main_Generate( loc_id, ArkInventory.Const.Window.Draw.Recalculate )
					end
				end,
				OnEnter = function( self )
					ArkInventory.GameTooltipSetText( self, ArkInventory.Localise["REFRESH"] )
				end,
			},
		},
}
	
ArkInventory.Const.Skills = {
		Primary = 2,
		Secondary = 4,
		Data = {
			-- primary crafting
			[171] = {
				id = "SKILL_ALCHEMY",
				pt = "TradeskillResultMats.Reverse.Alchemy,Tradeskill.Tool.Alchemy",
				text = ArkInventory.Localise["WOW_ITEM_CLASS_RECIPE_ALCHEMY"],
			},
			[164] = {
				id = "SKILL_BLACKSMITHING",
				pt = "TradeskillResultMats.Reverse.Blacksmithing,Tradeskill.Tool.Blacksmithing",
				text = ArkInventory.Localise["WOW_ITEM_CLASS_RECIPE_BLACKSMITHING"],
			},
			[333] = {
				id = "SKILL_ENCHANTING",
				pt = "TradeskillResultMats.Reverse.Enchanting,Tradeskill.Tool.Enchanting",
				text = ArkInventory.Localise["WOW_ITEM_CLASS_TRADEGOODS_ENCHANTING"],
			},
			[202] = {
				id = "SKILL_ENGINEERING",
				pt = "TradeskillResultMats.Reverse.Engineering,Tradeskill.Tool.Engineering",
				text = ArkInventory.Localise["WOW_ITEM_CLASS_RECIPE_ENGINEERING"],
			},
			[773] = {
				id = "SKILL_INSCRIPTION",
				pt = "TradeskillResultMats.Reverse.Inscription,Tradeskill.Tool.Inscription",
				text = ArkInventory.Localise["WOW_ITEM_CLASS_RECIPE_INSCRIPTION"],
			},
			[755] = {
				id = "SKILL_JEWELCRAFTING",
				pt = "TradeskillResultMats.Reverse.Jewelcrafting,Tradeskill.Tool.Jewelcrafting",
				text = ArkInventory.Localise["WOW_ITEM_CLASS_TRADEGOODS_JEWELCRAFTING"],
			},
			[165] = {
				id = "SKILL_LEATHERWORKING",
				pt = "TradeskillResultMats.Reverse.Leatherworking,Tradeskill.Tool.Leatherworking",
				text = ArkInventory.Localise["WOW_ITEM_CLASS_RECIPE_LEATHERWORKING"],
			},
			[197] = {
				id = "SKILL_TAILORING",
				pt = "TradeskillResultMats.Reverse.Tailoring,Tradeskill.Tool.Tailoring",
				text = ArkInventory.Localise["WOW_ITEM_CLASS_RECIPE_TAILORING"],
			},
			-- primary collecting
			[182] = {
				id = "SKILL_HERBALISM",
				pt = "Tradeskill.Mat.ByType.Herb",
				text = ArkInventory.Localise["WOW_SKILL_HERBALISM"],
			},
			[186] = {
				id = "SKILL_MINING",
				pt = "Tradeskill.Tool.Mining,TradeskillResultMats.Forward.Smelting,TradeskillResultMats.Reverse.Smelting",
				text = ArkInventory.Localise["WOW_SKILL_MINING"],
			},
			[393] = {
				id = "SKILL_SKINNING",
				pt = "Tradeskill.Tool.Skinning,Tradeskill.Mat.ByType.Leather",
				text = ArkInventory.Localise["WOW_SKILL_SKINNING"],
			},
			-- secondary
			[794] = {
				id = "SKILL_ARCHAEOLOGY",
				pt = "Tradeskill.Mat.ByType.Keystone",
				text = ArkInventory.Localise["WOW_SKILL_ARCHAEOLOGY"],
			},
			[185] = {
				id = "SKILL_COOKING",
				pr = "TradeskillResultMats.Reverse.Cooking",
				text = ArkInventory.Localise["WOW_SKILL_COOKING"],
			},
			[129] = {
				id = "FIRST_AID",
				pt = "TradeskillResultMats.Forward.First Aid",
				text = ArkInventory.Localise["WOW_SKILL_FIRSTAID"],
			},
			[356] = {
				id = "SKILL_FISHING",
				pt = "Tradeskill.Tool.Fishing",
				text = ArkInventory.Localise["WOW_SKILL_FISHING"],
			},
		},
}

ArkInventory.Const.Slot.Data = {
	[ArkInventory.Const.Slot.Type.Unknown] = {
		["name"] = ArkInventory.Localise["UNKNOWN"],
		["long"] = ArkInventory.Localise["UNKNOWN"],
		["type"] = ArkInventory.Localise["UNKNOWN"],
	},
	[ArkInventory.Const.Slot.Type.Bag] = {
		["name"] = ArkInventory.Localise["STATUS_SHORTNAME_BAG"],
		["long"] = ArkInventory.Localise["WOW_ITEM_CLASS_CONTAINER_BAG"],
		["type"] = ArkInventory.Localise["WOW_ITEM_CLASS_CONTAINER_BAG"],
	},
	[ArkInventory.Const.Slot.Type.Herb] = {
		["name"] = ArkInventory.Localise["STATUS_SHORTNAME_HERB"],
		["long"] = ArkInventory.Localise["WOW_SKILL_HERBALISM"],
		["type"] = ArkInventory.Localise["WOW_ITEM_CLASS_CONTAINER_HERB"],
	},
	[ArkInventory.Const.Slot.Type.Enchanting] = {
		["name"] = ArkInventory.Localise["STATUS_SHORTNAME_ENCHANTING"],
		["long"] = ArkInventory.Localise["WOW_ITEM_CLASS_TRADEGOODS_ENCHANTING"],
		["type"] = ArkInventory.Localise["WOW_ITEM_CLASS_CONTAINER_ENCHANTING"],
	},
	[ArkInventory.Const.Slot.Type.Engineering] = {
		["name"] = ArkInventory.Localise["STATUS_SHORTNAME_ENGINEERING"],
		["long"] = ArkInventory.Localise["WOW_ITEM_CLASS_RECIPE_ENGINEERING"],
		["type"] = ArkInventory.Localise["WOW_ITEM_CLASS_CONTAINER_ENGINEERING"],
	},
	[ArkInventory.Const.Slot.Type.Gem] = {
		["name"] = ArkInventory.Localise["STATUS_SHORTNAME_GEM"],
		["long"] = ArkInventory.Localise["WOW_ITEM_CLASS_GEM"],
		["type"] = ArkInventory.Localise["WOW_ITEM_CLASS_CONTAINER_GEM"],
	},
	[ArkInventory.Const.Slot.Type.Mining] = {
		["name"] = ArkInventory.Localise["STATUS_SHORTNAME_MINING"],
		["long"] = ArkInventory.Localise["WOW_SKILL_MINING"],
		["type"] = ArkInventory.Localise["WOW_ITEM_CLASS_CONTAINER_MINING"],
	},
	[ArkInventory.Const.Slot.Type.Leatherworking] = {
		["name"] = ArkInventory.Localise["STATUS_SHORTNAME_LEATHERWORKING"],
		["long"] = ArkInventory.Localise["WOW_ITEM_CLASS_RECIPE_LEATHERWORKING"],
		["type"] = ArkInventory.Localise["WOW_ITEM_CLASS_CONTAINER_LEATHERWORKING"],
	},
	[ArkInventory.Const.Slot.Type.Inscription] = {
		["name"] = ArkInventory.Localise["STATUS_SHORTNAME_INSCRIPTION"],
		["long"] = ArkInventory.Localise["WOW_ITEM_CLASS_RECIPE_INSCRIPTION"],
		["type"] = ArkInventory.Localise["WOW_ITEM_CLASS_CONTAINER_INSCRIPTION"],
	},
	[ArkInventory.Const.Slot.Type.Wearing] = {
		["name"] = ArkInventory.Localise["STATUS_SHORTNAME_GEAR"],
		["long"] = ArkInventory.Localise["WOW_ITEM_CLASS_CONTAINER_BAG"],
		["type"] = ArkInventory.Localise["WOW_ITEM_CLASS_CONTAINER_BAG"],
		["hide"] = true,
	},
	[ArkInventory.Const.Slot.Type.Mail] = {
		["name"] = ArkInventory.Localise["STATUS_SHORTNAME_MAIL"],
		["long"] = ArkInventory.Localise["WOW_ITEM_CLASS_CONTAINER_BAG"],
		["type"] = ArkInventory.Localise["WOW_ITEM_CLASS_CONTAINER_BAG"],
		["hide"] = true,
	},
	[ArkInventory.Const.Slot.Type.Critter] = {
		["name"] = ArkInventory.Localise["STATUS_SHORTNAME_CRITTER"],
		["long"] = ArkInventory.Localise["WOW_ITEM_CLASS_CONTAINER_BAG"],
		["type"] = ArkInventory.Localise["PET"],
		["hide"] = true,
	},
	[ArkInventory.Const.Slot.Type.Mount] = {
		["name"] = ArkInventory.Localise["STATUS_SHORTNAME_MOUNT"],
		["long"] = ArkInventory.Localise["WOW_ITEM_CLASS_CONTAINER_BAG"],
		["type"] = ArkInventory.Localise["WOW_ITEM_CLASS_MISC_MOUNT"],
		["hide"] = true,
	},
	[ArkInventory.Const.Slot.Type.Toybox] = {
		["name"] = ArkInventory.Localise["STATUS_SHORTNAME_TOY"],
		["long"] = ArkInventory.Localise["WOW_ITEM_CLASS_CONTAINER_BAG"],
		["type"] = ArkInventory.Localise["TOY"],
		["hide"] = true,
	},
	[ArkInventory.Const.Slot.Type.Heirloom] = {
		["name"] = ArkInventory.Localise["STATUS_SHORTNAME_HEIRLOOM"],
		["long"] = ArkInventory.Localise["WOW_ITEM_CLASS_CONTAINER_BAG"],
		["type"] = ArkInventory.Localise["HEIRLOOM"],
		["hide"] = true,
	},
	[ArkInventory.Const.Slot.Type.Token] = {
		["name"] = ArkInventory.Localise["STATUS_SHORTNAME_TOKEN"],
		["long"] = ArkInventory.Localise["WOW_ITEM_CLASS_CONTAINER_BAG"],
		["type"] = ArkInventory.Localise["CURRENCY"],
		["hide"] = true,
	},
	[ArkInventory.Const.Slot.Type.Auction] = {
		["name"] = AUCTIONS,
		["long"] = AUCTIONS,
		["type"] = AUCTIONS,
		["hide"] = true,
	},
	[ArkInventory.Const.Slot.Type.Tackle] = {
		["name"] = ArkInventory.Localise["STATUS_SHORTNAME_TACKLE"],
		["long"] = ArkInventory.Localise["WOW_ITEM_CLASS_CONTAINER_FISHING"],
		["type"] = ArkInventory.Localise["WOW_ITEM_CLASS_CONTAINER_FISHING"],
	},
	[ArkInventory.Const.Slot.Type.Void] = {
		["name"] = ArkInventory.Localise["VOIDSTORAGE"],
		["long"] = ArkInventory.Localise["VOIDSTORAGE"],
		["type"] = ArkInventory.Localise["VOIDSTORAGE"],
		["texture"] = [[Interface\AddOns\ArkInventory\Images\VoidStorageSlot.tga]],
	},
	[ArkInventory.Const.Slot.Type.Cooking] = {
		["name"] = ArkInventory.Localise["STATUS_SHORTNAME_COOKING"],
		["long"] = ArkInventory.Localise["WOW_SKILL_COOKING"],
		["type"] = ArkInventory.Localise["WOW_SKILL_COOKING"],
	},
	[ArkInventory.Const.Slot.Type.ReagentBank] = {
		["name"] = ArkInventory.Localise["STATUS_SHORTNAME_REAGENTBANK"],
		["long"] = ArkInventory.Localise["REAGENTBANK"],
		["type"] = ArkInventory.Localise["REAGENTBANK"],
		--["texture"] = [[Interface\Paperdoll\UI-PaperDoll-Slot-Relic]],
	},
	[ArkInventory.Const.Slot.Type.Reputation] = {
		["name"] = ArkInventory.Localise["STATUS_SHORTNAME_REPUTATION"],
		["long"] = ArkInventory.Localise["REPUTATION"],
		["type"] = ArkInventory.Localise["REPUTATION"],
	},
}

ArkInventory.Const.AnchorText = {
	
}

ArkInventory.Global = { -- globals
	
	Enabled = false,
	
	Version = "", --calculated
	
	Me = {
		-- this will always point to the current characters data
		data = nil,
	},
	
	Mode = {
		Bank = false,
		Vault = false,
		Mail = false,
		Merchant = false,
		Auction = false,
		Void = false,
		
		Edit = false,
		Combat = false,
	},
	
	LeaveCombatRun = { }, -- [loc_id] = true
	
	Tooltip = {
		Scan = nil,
		WOW = {
			GameTooltip,
			ShoppingTooltip1,
			ShoppingTooltip2,
			ItemRefTooltip,
			ItemRefShoppingTooltip1,
			ItemRefShoppingTooltip2,
			WorldMapTooltip,
			WorldMapTooltip.ItemTooltip.Tooltip,
			WorldMapCompareTooltip1,
			WorldMapCompareTooltip2,
		},
	},
	
	Category = { }, -- see CategoryGenerate( ) for how this gets populated

	Location = {
		
		[ArkInventory.Const.Location.Bag] = {
			id = ArkInventory.Const.Location.Bag,
			isActive = true,
			Internal = "bag",
			Name = ArkInventory.Localise["BACKPACK"],
			Texture = [[Interface\Icons\INV_Misc_Bag_07_Green]],
			bagCount = 1, -- actual value set in OnLoad
			Bags = { },
			canRestack = true,
			hasChanger = true,
			canSearch = true,
			
			maxBar = 0,
			maxSlot = { },
			
			isOffline = false,
			canView = true,
			canOverride = true,
			
			template = "ARKINV_TemplateButtonItem",
			
			drawState = ArkInventory.Const.Window.Draw.Init,
		},
		
		[ArkInventory.Const.Location.Bank] = {
			id = ArkInventory.Const.Location.Bank,
			isActive = true,
			Internal = "bank",
			Name = ArkInventory.Localise["BANK"],
			Texture = [[Interface\Icons\INV_Box_02]],
			bagCount = 1, -- set in OnLoad
			Bags = { },
			canRestack = true,
			hasChanger = true,
			canSearch = true,
			
			maxBar = 0,
			maxSlot = { },
			
			isOffline = true,
			canView = true,
			canOverride = true,
			canPurge = true,
			
			tabReagent = nil, -- set in OnLoad
			
			template = "ARKINV_TemplateButtonItem",
			
			drawState = ArkInventory.Const.Window.Draw.Init,
		},
		
		[ArkInventory.Const.Location.Vault] = {
			id = ArkInventory.Const.Location.Vault,
			isActive = true,
			Internal = "vault",
			Name = ArkInventory.Localise["VAULT"],
			--Texture = [[Interface\Icons\INV_Misc_Coin_02]],
			--Texture = [[Interface\ICONS\INV_Misc_Gem_Topaz_01]],
			Texture = [[Interface\ICONS\INV_Trinket_80_Titan02d]],
			bagCount = 1, -- actual value set in OnLoad
			Bags = { },
			canRestack = true,
			hasChanger = true,
			canSearch = true,
			isVault = true,
			
			maxBar = 0,
			maxSlot = { },
			
			isOffline = true,
			canView = true,
			canOverride = true,
			canPurge = true,
			
			template = "ARKINV_TemplateButtonVaultItem",
			
			drawState = ArkInventory.Const.Window.Draw.Init,
			
			view_tab = 1,
			view_mode = "bank",
			view_load = true,
			
		},
		
		[ArkInventory.Const.Location.Mail] = {
			id = ArkInventory.Const.Location.Mail,
			isActive = true,
			Internal = "mail",
			Name = ArkInventory.Localise["MAILBOX"],
			--Texture = [[Interface\Icons\INV_Letter_01]]
			Texture = [[Interface\Minimap\Tracking\Mailbox]],
			bagCount = 1,
			Bags = { },
			canRestack = nil,
			hasChanger = nil,
			canSearch = true,
			
			maxBar = 0,
			maxSlot = { },
			
			isOffline = true,
			canView = true,
			canOverride = nil,
			canPurge = true,
			
			template = "ARKINV_TemplateButtonMailItem",
			
			drawState = ArkInventory.Const.Window.Draw.Init,
		},
		
		[ArkInventory.Const.Location.Wearing] = {
			id = ArkInventory.Const.Location.Wearing,
			isActive = true,
			Internal = "wearing",
			Name = ArkInventory.Localise["LOCATION_WEARING"],
			--Texture = [[Interface\Icons\INV_Boots_05]],
			Texture = [[Interface\ICONS\INV_OrderHall_ArmamentupgradeBlue]],
			bagCount = 1,
			Bags = { },
			canRestack = nil,
			hasChanger = nil,
			canSearch = true,
			
			maxBar = 0,
			maxSlot = { },
			
			isOffline = false,
			canView = true,
			canOverride = nil,

			drawState = ArkInventory.Const.Window.Draw.Init,
		},
		
		[ArkInventory.Const.Location.Pet] = {
			id = ArkInventory.Const.Location.Pet,
			isAccount = true,
			isActive = true,
			Internal = "pet",
			Name = ArkInventory.Localise["PET"],
			--Texture = [[Interface\Icons\PetJournalPortrait]],
			Texture = [[Interface\ICONS\INV_Misc_FireKitty]],
			bagCount = 1,
			Bags = { },
			canRestack = nil,
			hasChanger = nil,
			canSearch = true,
			
			maxBar = 0,
			maxSlot = { },
			
			isOffline = false,
			canView = true,
			canOverride = nil,
			canPurge = true,
			
			template = "ARKINV_TemplateButtonBattlepetItem",
			
			drawState = ArkInventory.Const.Window.Draw.Init,
			
		},
		
		[ArkInventory.Const.Location.Mount] = {
			id = ArkInventory.Const.Location.Mount,
			isAccount = true,
			isActive = true,
			Internal = "mount",
			Name = ArkInventory.Localise["MOUNT"],
			Texture = [[Interface\Icons\MountJournalPortrait]],
			bagCount = 1,
			Bags = { },
			canRestack = nil,
			hasChanger = nil,
			canSearch = true,
			
			maxBar = 0,
			maxSlot = { },
			
			isOffline = false,
			canView = true,
			canOverride = nil,
			canPurge = true,
			
			template = "ARKINV_TemplateButtonMountItem",
			
			drawState = ArkInventory.Const.Window.Draw.Init,
			
		},
		
		[ArkInventory.Const.Location.Toybox] = {
			id = ArkInventory.Const.Location.Toybox,
			isAccount = true,
			isActive = true,
			Internal = "toybox",
			Name = ArkInventory.Localise["TOYBOX"],
			--Texture = [[Interface\Icons\Trade_Archaeology_ChestofTinyGlassAnimals]],
			Texture = [[Interface\ICONS\INV_Misc_Toy_02]],
			bagCount = 1,
			Bags = { },
			canRestack = nil,
			hasChanger = nil,
			canSearch = true,
			
			maxBar = 0,
			maxSlot = { },
			
			isOffline = false,
			canView = true,
			canOverride = nil,
			canPurge = true,
			
			template = "ARKINV_TemplateButtonToyboxItem",
			
			drawState = ArkInventory.Const.Window.Draw.Init,
			
		},
		
		[ArkInventory.Const.Location.Heirloom] = {
			id = ArkInventory.Const.Location.Heirloom,
			isAccount = true,
			isActive = true,
			Internal = "heirloom",
			Name = ArkInventory.Localise["HEIRLOOM"],
			Texture = [[Interface\Icons\inv_misc_enggizmos_19]],
			--Texture = [[Interface\ICONS\Spell_Shadow_LastingAfflictions]],
			bagCount = 1,
			Bags = { },
			canRestack = nil,
			hasChanger = nil,
			canSearch = true,
			
			maxBar = 0,
			maxSlot = { },
			
			isOffline = false,
			canView = true,
			canOverride = nil,
			
			--template = "ARKINV_TemplateButtonHeirloomItem",
			
			drawState = ArkInventory.Const.Window.Draw.Init,
			
		},
		
		[ArkInventory.Const.Location.Token] = {
			id = ArkInventory.Const.Location.Token,
			isActive = true,
			Internal = "token",
			Name = ArkInventory.Localise["CURRENCY"],
			--Texture = [[Interface\ICONS\Spell_Holy_ChampionsBond]],
			--Texture = [[Interface\ICONS\ABILITY_Rogue_RollTheBones05]],
			Texture = [[Interface\ICONS\inv_misc_coinbag_special]],
			bagCount = 1,
			Bags = { },
			canRestack = nil,
			hasChanger = nil,
			canSearch = true,
			
			maxBar = 0,
			maxSlot = { },
			
			isOffline = false,
			canView = true,
			canOverride = nil,
			
			drawState = ArkInventory.Const.Window.Draw.Init,
		},
		
		[ArkInventory.Const.Location.Auction] = {
			id = ArkInventory.Const.Location.Auction,
			isActive = false,
			Internal = "auction",
			Name = AUCTIONS,
			--Texture = [[Interface\Minimap\Tracking\Auctioneer]],
			Texture = [[Interface\ICONS\INV_Misc_Coin_04]],
			bagCount = 1,
			Bags = { },
			canRestack = nil,
			hasChanger = nil,
			canSearch = true,
			
			maxBar = 0,
			maxSlot = { },
			
			isOffline = true,
			canView = true,
			canOverride = nil,
			canPurge = true,
			
			drawState = ArkInventory.Const.Window.Draw.Init,
		},
		
		[ArkInventory.Const.Location.Void] = {
			id = ArkInventory.Const.Location.Void,
			isActive = true,
			Internal = "void",
			Name = ArkInventory.Localise["VOIDSTORAGE"],
			Texture = [[Interface\Icons\Spell_Nature_AstralRecalGroup]],
			bagCount = 1,
			Bags = { },
			canRestack = nil,
			hasChanger = nil,
			canSearch = true,
			
			maxBar = 0,
			maxSlot = { },
			
			isOffline = true,
			canView = true,
			canOverride = nil,
			canPurge = true,
			
			drawState = ArkInventory.Const.Window.Draw.Init,
		},
		
		[ArkInventory.Const.Location.Reputation] = {
			id = ArkInventory.Const.Location.Reputation,
			isActive = true,
			Internal = "reputation",
			Name = ArkInventory.Localise["REPUTATION"],
			Texture = [[Interface\ICONS\Raf-Icon]], --Ability_PVP_DefenderoftheWeak
			bagCount = 1,
			Bags = { },
			canRestack = nil,
			hasChanger = nil,
			canSearch = true,
			
			maxBar = 0,
			maxSlot = { },
			
			isOffline = false,
			canView = true,
			canOverride = nil,
			canPurge = true,
			
			drawState = ArkInventory.Const.Window.Draw.Init,
			
		},
	},
	
	Cache = {
		
		ItemCountRaw = { }, -- key generated via ObjectIDCount( )
		ItemCountTooltip = { }, -- key generated via ObjectIDCount( )
		ItemSearchData = { }, -- key generated via ObjectIDCount( )
		StackCompress = { }, -- key generated via ObjectIDCount( )
		
		SentMail = { }, -- keeps track of any sent mail to other characters you have
		
		BlizzardBagIdToInternalId = { },
		
	},
	
	Thread = {
--		Use = false, -- !!! comment out when done testing
		Use = true,
		WindowState = { },
		data = { },
		Format = {
			Force = "*",
			--Restack = "p1-restack-%s",
			Restack = "p1-restack",
			Collection = "p2-scan-%s",
			Scan = "p3-scan-%s-%s",
			Window = "p4-draw-%s",
			LDB = "p5-ldb-%s",
			Tooltip = "p9-tooltip",
			JunkSell = "p9-junksell",
		},
	},
	
	Options = {
		
		Location = ArkInventory.Const.Location.Bag,
		ShowHiddenItems = false,
		
		ConfigSortMethodListSort = 1,
		ConfigSortMethodListShow = 1,
		ConfigCategoryCustomListSort = 1,
		ConfigCategoryCustomListShow = 1,
		ConfigCategoryRuleListSort = 1,
		ConfigCategoryRuleListShow = 1,
		ConfigCategoryRuleListSet = 9999,
		ConfigCategorysetListSort = 1,
		ConfigCategorysetListShow = 1,
		ConfigDesignListSort = 1,
		ConfigDesignListShow = 1,
		ConfigProfileListSort = 1,
		ConfigProfileListShow = 1,
		
		SortKeyBagAssignmentSort = true,
		BarMoveSource = nil,
		BarMoveDestination = nil,
		
	},
	
	Rules = {
		Enabled = false, -- change this to module check
	},
	
	NewItemResetTime = nil,
	
	Junk = {
		run = false,
		sold = 0,
		destroyed = 0,
		money = 0,
	},
	
}

ArkInventory.Config = {
	Internal = {
		type = "group",
		childGroups = "tree",
		name = ArkInventory.Const.Program.Name,
	},
	Blizzard = {
		type = "group",
		childGroups = "tree",
		name = ArkInventory.Const.Program.Name,
	},
}

ArkInventory.Collection = { }


-- Binding Variables
BINDING_HEADER_ARKINV = ArkInventory.Const.Program.Name
BINDING_NAME_ARKINV_TOGGLE_BAG = ArkInventory.Localise["BACKPACK"]
BINDING_NAME_ARKINV_TOGGLE_BANK = ArkInventory.Localise["BANK"]
BINDING_NAME_ARKINV_TOGGLE_VAULT = ArkInventory.Localise["VAULT"]
BINDING_NAME_ARKINV_TOGGLE_MAIL = ArkInventory.Localise["MAILBOX"]
BINDING_NAME_ARKINV_TOGGLE_WEARING = ArkInventory.Localise["LOCATION_WEARING"]
BINDING_NAME_ARKINV_TOGGLE_PET = ArkInventory.Localise["PET"]
BINDING_NAME_ARKINV_TOGGLE_MOUNT = ArkInventory.Localise["MOUNT"]
BINDING_NAME_ARKINV_TOGGLE_TOYBOX = ArkInventory.Localise["TOYBOX"]
BINDING_NAME_ARKINV_TOGGLE_HEIRLOOM = ArkInventory.Localise["HEIRLOOM"]
BINDING_NAME_ARKINV_TOGGLE_TOKEN = ArkInventory.Localise["CURRENCY"]
BINDING_NAME_ARKINV_TOGGLE_VOID = ArkInventory.Localise["VOIDSTORAGE"]
BINDING_NAME_ARKINV_TOGGLE_EDIT = ArkInventory.Localise["MENU_ACTION_EDITMODE"]
BINDING_NAME_ARKINV_TOGGLE_RULES = ArkInventory.Localise["CONFIG_RULE_PLURAL"]
BINDING_NAME_ARKINV_TOGGLE_SEARCH = ArkInventory.Localise["SEARCH"]
BINDING_NAME_ARKINV_REFRESH = ArkInventory.Localise["REFRESH"]
BINDING_NAME_ARKINV_RELOAD = ArkInventory.Localise["RELOAD"]
BINDING_NAME_ARKINV_RESTACK = ArkInventory.Localise["RESTACK"]
BINDING_NAME_ARKINV_MENU = ArkInventory.Localise["MENU"]
BINDING_NAME_ARKINV_CONFIG = ArkInventory.Localise["CONFIG_TEXT"]
BINDING_NAME_ARKINV_LDB_PETS_SUMMON = ArkInventory.Localise["LDB_PETS_SUMMON"]
_G["BINDING_NAME_CLICK ARKINV_MountToggle:LeftButton"] = ArkInventory.Localise["LDB_MOUNTS_SUMMON"]


ArkInventory.Const.DatabaseDefaults.global = {
	["option"] = {
		["version"] = 0,
		["auto"] = {
			["open"] = {
				["*"] = true,
			},
			["close"] = {
				["*"] = true,
			},
			["reposition"] = true,
		},
		["design"] = { -- layout and style data
			["data"] = {
				["**"] = {
					["system"] = false,
					["used"] = "N", -- Y(es) | N(o) | D(eleted)
					["name"] = "",
					
					-- ** style **
					["font"] = {
						["custom"] = false,
						["face"] = ArkInventory.Const.Font.Face,
						["height"] = ArkInventory.Const.Font.Height,
					},
					["window"] = {
						["scale"] = 1,
						["width"] = 16,
						["height"] = 800,
						["border"] = {
							["style"] = ArkInventory.Const.Texture.BorderDefault,
							["size"] = nil,
							["offset"] = nil,
							["scale"] = 1,
							["colour"] = {
								["r"] = 1,
								["g"] = 1,
								["b"] = 1,
							},
						},
						["pad"] = 8,
						["background"] = {
							["style"] = ArkInventory.Const.Texture.BackgroundDefault,
							["colour"] = {
								["r"] = 0,
								["g"] = 0,
								["b"] = 0,
								["a"] = 0.75,
							},
						},
						["strata"] = "MEDIUM",
						["list"] = false,
					},
					["bar"] = {
						["per"] = 5,
						["pad"] = {
							["internal"] = 8,
							["external"] = 8,
						},
						["border"] = {
							["style"] = ArkInventory.Const.Texture.BorderDefault,
							["size"] = nil,
							["offset"] = nil,
							["scale"] = 1,
							["colour"] = {
								["r"] = 0.3,
								["g"] = 0.3,
								["b"] = 0.3,
							},
						},
						["background"] = {
							["colour"] = {
								["r"] = 0,
								["g"] = 0,
								["b"] = 0.4,
								["a"] = 0.4,
							},
						},
						["showempty"] = false,
						["anchor"] = ArkInventory.Const.Anchor.BottomRight,
						["compact"] = false,
						["hide"] = false,
						["name"] = {
							["show"] = false,
							["colour"] = {
								["r"] = 1,
								["b"] = 1,
								["g"] = 1,
							},
							["height"] = ArkInventory.Const.Font.Height,
							["justify"] = ArkInventory.Const.Anchor.Left,
							["anchor"] = ArkInventory.Const.Anchor.Default,
						},
						["data"] = { -- ** layout **
							["*"] = {
								["sort"] = {
									["method"] = nil,
								},
								["border"] = {
									["custom"] = 1, -- 1 = default, 2 = custom
									["colour"] = {
										["r"] = 0.3,
										["g"] = 0.3,
										["b"] = 0.3,
									},
								},
								["background"] = {
									["custom"] = 1, -- 1 = default, 2 = custom, 3 = border
									["colour"] = {
										["r"] = 0,
										["g"] = 0,
										["b"] = 0.4,
										["a"] = 0.4,
									},
								},
								["name"] = {
									["text"] = "",
									["custom"] = 1, -- 1 = default, 2 = custom
									["colour"] = {
										["r"] = 1,
										["g"] = 1,
										["b"] = 1,
									},
								},
								["width"] = {
									["min"] = nil,
									["max"] = nil,
								},
							},
						},
					},
					["slot"] = {
						["empty"] = {
							["alpha"] = 1,
							["icon"] = true,
							["border"] = true,
							["first"] = 0,
							["clump"] = false,
							["position"] = true,
						},
						["data"] = { -- slot type data
							["**"] = {
								["colour"] = { r = 0.30, g = 0.30, b = 0.30 },
							},
							[ArkInventory.Const.Slot.Type.Unknown] = {
								["colour"] = { r = 1.00, g = 0.00, b = 0.00 },
							},
							[ArkInventory.Const.Slot.Type.Herb] = {
								["colour"] = { r = 0.00, g = 1.00, b = 0.00 },
							},
							[ArkInventory.Const.Slot.Type.Enchanting] = {
								["colour"] = { r = 0.06, g = 0.88, b = 0.93 },
							},
							[ArkInventory.Const.Slot.Type.Engineering] = {
								["colour"] = { r = 0.61, g = 0.74, b = 0.29 },
							},
							[ArkInventory.Const.Slot.Type.Gem] = {
								["colour"] = { r = 0.63, g = 0.00, b = 0.56 },
							},
							[ArkInventory.Const.Slot.Type.Mining] = {
								["colour"] = { r = 0.79, g = 0.79, b = 0.00 },
							},
							[ArkInventory.Const.Slot.Type.Leatherworking] = {
								["colour"] = { r = 0.63, g = 0.45, b = 0.10 },
							},
							[ArkInventory.Const.Slot.Type.Inscription] = {
								["colour"] = { r = 0.46, g = 0.67, b = 0.63 },
							},
							[ArkInventory.Const.Slot.Type.Tackle] = {
								["colour"] = { r = 0.12, g = 0.56, b = 0.42 },
							},
							[ArkInventory.Const.Slot.Type.ReagentBank] = {
								["colour"] = { r = 0.10, g = 0.30, b = 1.00 },
							},
						},
						["pad"] = 4,
						["border"] = {
							["style"] = ArkInventory.Const.Texture.BorderDefault,
							["size"] = nil,
							["offset"] = nil,
							["scale"] = 1,
							["rarity"] = true,
							["raritycutoff"] = LE_ITEM_QUALITY_POOR,
						},
						["anchor"] = ArkInventory.Const.Anchor.BottomRight,
						["age"] = {
							["show"] = false,
							["colour"] = {
								["r"] = 1,
								["g"] = 1,
								["b"] = 1,
							},
							["cutoff"] = 0,
							["font"] = {
								["height"] = ArkInventory.Const.Font.Height,
							},
						},
						["offline"] = {
							["fade"] = true,
						},
						["unusable"] = {
							["tint"] = false,
						},
						["cooldown"] = {
							["show"] = true,
							["global"] = false,
							["combat"] = true,
						},
						["scale"] = 1,
						["itemlevel"] = {
							["show"] = false,
							["anchor"] = ArkInventory.Const.Anchor.Default,
							["min"] = 1,
							["colour"] = {
								["r"] = 1,
								["g"] = 0.82,
								["b"] = 0,
							},
							["font"] = {
								["height"] = ArkInventory.Const.Font.Height,
							},
						},
						["itemcount"] = {
							["show"] = true,
							["anchor"] = ArkInventory.Const.Anchor.Default,
							["colour"] = {
								["r"] = 1,
								["g"] = 1,
								["b"] = 1,
							},
							["font"] = {
								["height"] = ArkInventory.Const.Font.Height,
							},
						},
						["new"] = {
							["enable"] = false,
							["cutoff"] = 2,
						},
						["compress"] = {
							["count"] = 0,
							["identify"] = false,
							["position"] = 1,
						},
--						["upgrade"] = true, -- need to remove from saved data
						["upgradeicon"] = {
							["show"] = true,
							["anchor"] = ArkInventory.Const.Anchor.Default,
						},
						["junkicon"] = {
							["show"] = false,
							["anchor"] = ArkInventory.Const.Anchor.Default,
							["merchant"] = true,
						},
						["transmogicon"] = {
							["show"] = true,
							["anchor"] = ArkInventory.Const.Anchor.Default,
							["alternative"] = true,
						},
						["size"] = ArkInventory.Const.SLOT_SIZE,
						["quest"] = {
							["bang"] = true,
							["border"] = true,
						},
					},
					["title"] = {
						["hide"] = false,
						["size"] = 1,
						["colour"] = {
							["online"] = {
								["r"] = 0,
								["g"] = 1,
								["b"] = 0,
							},
							["offline"] = {
								["r"] = 1,
								["g"] = 0,
								["b"] = 0,
							},
						},
						["font"] = {
							["height"] = 20,
						},
					},
					["search"] = {
						["hide"] = false,
						["label"] = {
							["colour"] = {
								["r"] = 0,
								["g"] = 1,
								["b"] = 0,
							},
						},
						["text"] = {
							["colour"] = {
								["r"] = 1,
								["g"] = 1,
								["b"] = 1,
							},
						},
						["font"] = {
							["height"] = 12,
						},
					},
					["changer"] = {
						["hide"] = false,
						["highlight"] = {
							["show"] = true,
							["colour"] = {
								["r"] = 0,
								["g"] = 1,
								["b"] = 0,
							},
						},
						["freespace"] = {
							["show"] = true,
							["colour"] = {
								["r"] = 1,
								["g"] = 1,
								["b"] = 1,
							},
						},
						["font"] = {
							["height"] = 20,
						},
					},
					["status"] = {
						["hide"] = false,
						["emptytext"] = {   -- slot>empty>display
							["show"] = true,
							["colour"] = false,
							["full"] = true,
							["includetype"] = true,
						},
						["font"] = {
							["height"] = 16,
						},
					},
					["sort"] = {
						["when"] = ArkInventory.Const.SortWhen.Open,
						["method"] = 9999,  -- the default sort method for this layout
					},
					
					-- ** layout **
					["bag"] = {
						["*"] = { -- [bag_id]
							["bar"] = nil, -- bar number to put all bag slots on
						},
					},
					["category"] = {
						["*"] = nil, -- [category number] = bar number to put it on
					},
				},
				[9999] = {
					["system"] = true,
					["used"] = "Y",
					["name"] = ArkInventory.Localise["DEFAULT"],
				},
				[9998] = {
					["system"] = true,
					["used"] = "Y",
					["name"] = ArkInventory.Localise["VAULT"],
					["window"] = {
						["width"] = NUM_SLOTS_PER_GUILDBANK_GROUP,
					},
					["sort"] = {
						["method"] = 9995,
					},
				},
				[9997] = {
					["system"] = true,
					["used"] = "Y",
					["name"] = "List",
					["window"] = {
						["list"] = true,
						["width"] = 10,
					},
					["bar"] = {
						["per"] = 1,
						["data"] = {
							[1] = {
								["width"] = {
									["max"] = 1,
								},
							},
						},
					},
					["slot"] = {
						["anchor"] = ArkInventory.Const.Anchor.BottomLeft,
					},
					["changer"] = {
						["hide"] = true,
					},
					["status"] = {
						["hide"] = true,
					},
					["sort"] = {
						["method"] = 9993,
					},
				},
				[1000] = {
					["system"] = false,
					["used"] = "Y",
					["name"] = ArkInventory.Localise["DEFAULT"],
				},
			},
			["min"] = 1000,
			["next"] = 1000,
			["max"] = 8999,
		},
		["category"] = {
			["**"] = {
--[[
				see ArkInventory.Const.Category.Type
				--	System = 1,
				--	Custom = 2,
				--	Rule = 3,
]]--
				["data"] = {
					["**"] = {  -- [number] = { data }
						["system"] = false,
						["used"] = "N", -- Y(es) | N(o) | D(eleted)
						["name"] = "",
						-- rules
						["order"] = 1000,
						["formula"] = "false",
						["damaged"] = false,
					},
				},
				["min"] = 1000,
				["next"] = 1000,
				["max"] = 8999,
			},
		},
		["catset"] = { -- category sets
			["data"] = {
				["**"] = {
					["system"] = false,
					["used"] = "N", -- Y(es) | N(o) | D(eleted)
					["name"] = "",
					["category"] = {
						["assign"] = {
							["*"] = nil, -- item id = category number to assign the item to
						},
						["active"] = {
							["*"] = { -- category type
								["*"] = false, -- category id = enabled
							},
							[ArkInventory.Const.Category.Type.System] = {
								["*"] = true,
							},
						},
						["junk"] = {
							["*"] = { -- category type
								["*"] = false, -- true = autosell
							},
							[ArkInventory.Const.Category.Type.System] = {
								["*"] = false,
								[402] = true,
							},
						},
					},
				},
				[9999] = {
					["system"] = true,
					["used"] = "Y",
					["name"] = ArkInventory.Localise["DEFAULT"],
				},
				[1000] = {
					["system"] = false,
					["used"] = "Y",
					["name"] = ArkInventory.Localise["DEFAULT"],
				},
			},
			["min"] = 1000,
			["next"] = 1000,
			["max"] = 8999,
		},
		["profile"] = {
			["data"] = {
				["**"] = { -- id
					["system"] = false,
					["used"] = "N", -- Y(es) | N(o) | D(eleted)
					["name"] = "",
					["location"] = {
						["**"] = { -- loc_id
							["monitor"] = true,
							["save"] = true,
							["override"] = false,
							["special"] = true,
							["notify"] = false,
							["anchor"] = {
								["point"] = ArkInventory.Const.Anchor.TopRight,
								["locked"] = false,
								["t"] = nil,
								["b"] = nil,
								["l"] = nil,
								["r"] = nil,
							},
							["style"] = 1000,
							["layout"] = 1000,
							["catset"] = 1000,
							["container"] = {
								["width"] = 400,
								["height"] = 400,
							},
						},
						[ArkInventory.Const.Location.Bag] = {
							["notify"] = true,
							["override"] = true,
						},
						[ArkInventory.Const.Location.Bank] = {
							["notify"] = true,
							["override"] = true,
						},
						[ArkInventory.Const.Location.Vault] = {
							["notify"] = true,
							["override"] = true,
						},
					},
				},
				[1000] = {
					["system"] = false,
					["used"] = "Y",
					["name"] = ArkInventory.Localise["DEFAULT"],
				},
				[9999] = {
					["system"] = true,
					["used"] = "Y",
					["name"] = ArkInventory.Localise["DEFAULT"],
				},
			},
			["min"] = 1000,
			["next"] = 1000,
			["max"] = 8999,
		},
		["sort"] = {
			["method"] = {
				["data"] = {
					["**"] = {
						["system"] = false,
						["used"] = "N", -- Y(es) | N(o) | D(eleted)
						["name"] = "",
						["bagslot"] = true,
						["ascending"] = true,
						["reversed"] = false,
						["active"] = { },
						["order"] = { },
					},
					[9999] = {
						["system"] = true,
						["used"] = "Y",
						["name"] = ArkInventory.Localise["CONFIG_SORTING_METHOD_BAGSLOT"],
					},
					[9998] = {
						["system"] = true,
						["used"] = "Y",
						["name"] = "Rarity > Category > Location > Name",
						["bagslot"] = false,
						["active"] = {
							["quality"] = true,
							["category"] = true,
							["location"] = true,
							["name"] = true,
						},
						["order"] = {
							[1] = "quality",
							[2] = "category",
							[3] = "location",
							[4] = "name",
						},
					},
					[9997] = {
						["system"] = true,
						["used"] = "Y",
						["name"] = "Name (Ascending)",
						["bagslot"] = false,
						["active"] = {
							["name"] = true,
						},
						["order"] = {
							[1] = "name",
						},
					},
					[9996] = {
						["system"] = true,
						["used"] = "Y",
						["name"] = "Vendor Price",
						["bagslot"] = false,
						["active"] = {
							["vendorprice"] = true,
						},
						["order"] = {
							[1] = "vendorprice",
						},
					},
					[9995] = {
						["system"] = true,
						["used"] = "Y",
						["name"] = string.format( "%s / %s", ArkInventory.Localise["VAULT"], ArkInventory.Localise["VOIDSTORAGE"] ),
					},
					[9994] = {
						["system"] = true,
						["used"] = "Y",
						["name"] = "Name (Descending)",
						["bagslot"] = false,
						["ascending"] = false,
						["active"] = {
							["name"] = true,
						},
						["order"] = {
							[1] = "name",
						},
					},
					[9993] = {
						["system"] = true,
						["used"] = "Y",
						["name"] = string.format( "%s (%s)", ArkInventory.Localise["CONFIG_SORTING_METHOD_BAGSLOT"], "Descending" ),
						["ascending"] = false,
					},
				},
				["min"] = 1000,
				["next"] = 1000,
				["max"] = 8999,
			},
		},
		["showdisabled"] = true,
		["restack"] = {
			["blizzard"] = true, -- use blizzard cleanup function
			-- cleanup options
			["reverse"] = false,
			["deposit"] = false, -- blizzard - run deposit all items
			-- restack options
			["refresh"] = false, -- do a refresh when the restack is finished
			["topup"] = true, -- top up stacks in the bank (and reagent bank) with items from bags
			["bank"] = false, -- fill up empty bank slots from bag
		},
		["bucket"] = {	
			["*"] = nil
		},
		["bugfix"] = {
			["framelevel"] = {
				["enable"] = true,
				["alert"] = 0,
			},
			["zerosizebag"] = {
				["enable"] = true,
				["alert"] = true,
			},
		},
		["tooltip"] = {
			["show"] = true, -- show tooltips for items
			["scale"] = {
				["enabled"] = false,
				["amount"] = 1,
			},
			["me"] = false, -- only show my data
			["highlight"] = "", -- highlight my data
			["faction"] = true, -- only show my faction
			["realm"] = true, -- only show my realm
			["crossrealm"] = false, -- show connected realms
			["add"] = { -- things to add to the tooltip
				["empty"] = false, -- empty line / seperator
				["count"] = true, -- item count
				["vendor"] = false, -- vendor price (deprecated)
				["ilvl"] = false, -- item level (deprecated)
				["vault"] = true,
				["tabs"] = true,
			},
			["colour"] = {
				["count"] =  {
					["r"] = 1,
					["g"] = 0.5,
					["b"] = 0.15,
				},
				["vendor"] =  {
					["r"] = 0.5,
					["g"] = 0.5,
					["b"] = 0.5,
				},
				["class"] = false,
			},
			["battlepet"] = {
				["enable"] = true,
				["source"] = true,
				["description"] = true,
				["mouseover"] = {
					["enable"] = true,
					["detailed"] = true,
				},
			},
			["reputation"] = { -- need to add this to the config at some point
				["enable"] = true,
				["description"] = true,
				["custom"] = 1, -- 1 = default, 2 = custom
				["style"] = {
					["normal"] = "",
					["count"] = "",
				},
			},
			["precalc"] = false,
			["refresh"] = true,
		},
		["tracking"] = {
			["items"] = { },
			["reputation"] = {
				["custom"] = 1, -- 1 = default, 2 = custom
				["style"] = {
					["ldb"] = "",
					["tooltip"] = "",
				},
			},
		},
		["message"] = {
			["translation"] = {
				["interim"] = true,
				["final"] = true,
			},
			["restack"] = {
				["*"] = true,
			},
			["battlepet"] = {
				["opponent"] = true,
			},
			["mount"] = {
				["warnings"] = true,
			},
			["bag"] = {
				["unknown"] = true,
			},
			["rules"] = {
				["hooked"] = true,
				["registration"] = true,
			},
		},
		["mount"] = {
			["correction"] = { }, -- [spell] = mountType
		},
		["junk"] = {
			["sell"] = false,
			["limit"] = true,
			["delete"] = false,
			["notify"] = true,
			["raritycutoff"] = LE_ITEM_QUALITY_POOR, -- max quality to sell/destroy
			["list"] = true,
			["test"] = true,
		},
		["font"] = {
			["face"] = ArkInventory.Const.Font.Face,
			["height"] = ArkInventory.Const.Font.Height,
		},
		["menu"] = {
			["font"] = {
				["face"] = ArkInventory.Const.Font.Face,
				["height"] = ArkInventory.Const.Font.Height,
			},
		},
		["newitemglow"] = {
			["enable"] = true,
			["colour"] = { r = 0.7, g = 0.7, b = 0.7, a = 0.5 },
			["clearonclose"] = false,
		},
		["transmog"] = {
			["enable"] = true,
			["anchor"] = ArkInventory.Const.Anchor.Default,
			["secondary"] = false,
			["icon"] = {
				[ArkInventory.Const.Transmog.State.CanLearnMyself] = { 
					["style"] = ArkInventory.Const.Transmog.StyleDefault,
					["colour"] = { r = 0.00, g = 1.00, b = 0.00, a = 1 }, -- green
				},
				[ArkInventory.Const.Transmog.State.CanLearnMyselfSecondary] = {
					["style"] = ArkInventory.Const.Transmog.StyleDefault,
					["colour"] = { r = 0.08, g = 0.76, b = 0.94, a = 1 },
				},
				[ArkInventory.Const.Transmog.State.CanLearnOther] = {
					["style"] = ArkInventory.Const.Transmog.StyleDefault,
					["colour"] = { r = 1.00, g = 1.00, b = 0.00, a = 1 },
				},
				[ArkInventory.Const.Transmog.State.CanLearnOtherSecondary] = {
					["style"] = ArkInventory.Const.Transmog.StyleDefault,
					["colour"] = { r = 1.00, g = 0.78, b = 1.00, a = 1 },
				},
			},
		},
		["conflict"] = {
			["tsm"] = {
				["mailbox"] = false,
				["merchant"] = false,
			},
		},
		["ui"] = {
			["search"] = {
				["scale"] = 1,
				["background"] = {
					["style"] = ArkInventory.Const.Texture.BackgroundDefault,
					["colour"] = {
						["r"] = 0,
						["g"] = 0,
						["b"] = 0,
						["a"] = 0.75,
					},
				},
				["border"] = {
					["style"] = ArkInventory.Const.Texture.BorderDefault,
					["size"] = nil,
					["offset"] = nil,
					["scale"] = 1,
					["colour"] = {
						["r"] = 1,
						["g"] = 1,
						["b"] = 1,
					},
				},
				["font"] = {
					["height"] = ArkInventory.Const.Font.Height,
				},
				["strata"] = "MEDIUM"
			},
			["rules"] = {
				["scale"] = 1,
				["background"] = {
					["style"] = ArkInventory.Const.Texture.BackgroundDefault,
					["colour"] = {
						["r"] = 0,
						["g"] = 0,
						["b"] = 0,
						["a"] = 0.75,
					},
				},
				["border"] = {
					["style"] = ArkInventory.Const.Texture.BorderDefault,
					["size"] = nil,
					["offset"] = nil,
					["scale"] = 1,
					["colour"] = {
						["r"] = 1,
						["g"] = 1,
						["b"] = 1,
					},
				},
				["font"] = {
					["height"] = ArkInventory.Const.Font.Height,
				},
				["strata"] = "MEDIUM"
			},
		},
		["thread"] = {
			["debug"] = false,
			["timeout"] = {
				["normal"] = 25,
				["combat"] = 100, -- 200ms appears to be the actual limit
				["tooltip"] = 50, -- tooltip generation queue
				["junksell"] = 75, -- this is a minimum duration timer, not a timeout, must be above 50 (will occasionally fail when that low)
			},
		},
	},
	["player"] = {
		["version"] = 0,
		["data"] = {
			["*"] = { -- player or guild name
				
				["erasesilent"] = false,
				
				["ldb"] = {
					["bags"] = {
						["colour"] = false,
						["full"] = true,
						["includetype"] = true,
					},
					["pets"] = {
						["randomise"] = true,
						["useall"] = true,
						["selected"] = {
							["*"] = nil,
						},
					},
					["mounts"] = {
						["randomise"] = true,
						["type"] = {
							["l"] = { -- land (ground)
								["useflying"] = false,
								["usesurface"] = false,
								["useall"] = true,
								["selected"] = {
									["*"] = nil,
								},
							},
							["a"] = { -- air (flying)
								["dismount"] = false,
								["useall"] = true,
								["selected"] = {
									["*"] = nil,
								},
							},
							["u"] = { -- underwater
								["useall"] = true,
								["selected"] = {
									["*"] = nil,
								},
							},
							["s"] = { -- surface (water)
								["useall"] = true,
								["selected"] = {
									["*"] = nil,
								},
							},
							["x"] = { -- unknown
								["useall"] = true,
								["selected"] = {
									["*"] = nil,
								},
							},
						},
					},
					["tracking"] = {
						["currency"] = {
							["tracked"] = {
								["*"] = false,
							},
						},
						["item"] = {
							["tracked"] = {
								["*"] = false,
							},
						},
						["reputation"] = {
							["tracked"] = {
								["*"] = false,
							},
							["watched"] = nil,
						},
					},
					["travelform"] = false,
				},
				
				["option"] = { -- mostly moved to profile
					["**"] = { -- loc_id
						["bag"] = {
							["*"] = { -- bag_id
								["display"] = true,
								["restack"] = {
									["ignore"] = false,
								},
							},
						},
					},
				},
				
				["info"] = {
					["*"] = nil,
					["money"] = 0,
					
				},
				
				["location"] = {
					["*"] = {
						["slot_count"] = 0,
						["bag"] = {
							["*"] = {
								["status"] = ArkInventory.Const.Bag.Status.Unknown,
--								["texture"] = nil,
--								["h"] = nil,
--								["q"] = nil,
								["type"] = ArkInventory.Const.Slot.Type.Unknown,
								["count"] = 0,
								["empty"] = 0,
								["slot"] = {
--									stuff
								},
							},
						},
					},
				},
				
				["profile"] = 1000,
				
			},
		},
	},
	["cache"] = {
		["version"] = 0,
		["default"] = {
			["*"] = nil, -- key generated via ObjectIDCategory( )
		},
		["rule"] = {
			["*"] = nil, -- key generated via ObjectIDRule( )
		},
	},
}

ArkInventory.Const.DatabaseDefaults.profile = {
	["option"] = {
		["version"] = 0,
	},
}


function ArkInventory.TOCVersionFail( quiet )
	
	if true then return false end
	
	--ArkInventory.Output( ArkInventory.Const.TOC, " / ", ArkInventory.Const.TOC_Min, " / ", ArkInventory.Const.TOC_Name )
	if ArkInventory.Const.TOC < ArkInventory.Const.TOC_Min then
		if not quiet then
			ArkInventory.Output( ArkInventory.Global.Version, ArkInventory.Localise["DISABLED"] )
			ArkInventory.OutputError( ArkInventory.Const.TOC_Name, " (Alpha/Beta) Server required.  Do not run this version on the Live servers.")
			ArkInventory:Disable( )
		end
		return true
	end
end

function ArkInventory.OnLoad( )
	
	-- called via hidden frame in xml
	
	ArkInventory.Const.Program.Version = 0 + GetAddOnMetadata( ArkInventory.Const.Program.Name, "Version" )
	
	ArkInventory.Global.Version = string.format( "v%s", string.gsub( ArkInventory.Const.Program.Version, "(%d-)(%d%d)(%d%d)$", "%1.%2.%3" ) )
	
	local releasetype = GetAddOnMetadata( ArkInventory.Const.Program.Name, "X-ReleaseType" )
	if releasetype ~= "" then
		ArkInventory.Global.Version = string.format( "%s %s(%s)%s", ArkInventory.Global.Version, RED_FONT_COLOR_CODE, releasetype, FONT_COLOR_CODE_CLOSE )
	end
	
	
	local loc_id = 0
	local bags
	
	
	-- bags
	loc_id = ArkInventory.Const.Location.Bag
	bags = ArkInventory.Global.Location[loc_id].Bags
	
	bags[#bags + 1] = BACKPACK_CONTAINER
	for x = 1, NUM_BAG_SLOTS do
		bags[#bags + 1] = x
	end
	ArkInventory.Global.Location[loc_id].bagCount = #bags
	
	
	-- bank
	loc_id = ArkInventory.Const.Location.Bank
	bags = ArkInventory.Global.Location[loc_id].Bags
	
	bags[#bags + 1] = BANK_CONTAINER
	for x = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
		bags[#bags + 1] = x
		--ArkInventory.Output( "added bag ", x, " to ", ArkInventory.Global.Location[loc_id].Name )
	end
	bags[#bags + 1] = REAGENTBANK_CONTAINER
	ArkInventory.Global.Location[loc_id].tabReagent = #bags
	ArkInventory.Global.Location[loc_id].bagCount = #bags
	
	
	-- vault
	loc_id = ArkInventory.Const.Location.Vault
	bags = ArkInventory.Global.Location[loc_id].Bags
	
	for x = 1, MAX_GUILDBANK_TABS do
		bags[#bags + 1] = ArkInventory.Const.Offset.Vault + x
	end
	ArkInventory.Global.Location[loc_id].bagCount = #bags
	
	
	-- mail
	loc_id = ArkInventory.Const.Location.Mail
	bags = ArkInventory.Global.Location[loc_id].Bags
	for x = 1, 2 do
		bags[#bags + 1] = ArkInventory.Const.Offset.Mail + x
	end
	ArkInventory.Global.Location[loc_id].bagCount = #bags
	
	-- wearing
	table.insert( ArkInventory.Global.Location[ArkInventory.Const.Location.Wearing].Bags, ArkInventory.Const.Offset.Wearing + 1 )
	
	-- pet
	table.insert( ArkInventory.Global.Location[ArkInventory.Const.Location.Pet].Bags, ArkInventory.Const.Offset.Pet + 1 )
	
	-- mount
	table.insert( ArkInventory.Global.Location[ArkInventory.Const.Location.Mount].Bags, ArkInventory.Const.Offset.Mount + 1 )
	
	-- toybox
	table.insert( ArkInventory.Global.Location[ArkInventory.Const.Location.Toybox].Bags, ArkInventory.Const.Offset.Toybox + 1 )
	
	-- heirloom
	table.insert( ArkInventory.Global.Location[ArkInventory.Const.Location.Heirloom].Bags, ArkInventory.Const.Offset.Heirloom + 1 )
	
	-- currency
	table.insert( ArkInventory.Global.Location[ArkInventory.Const.Location.Token].Bags, ArkInventory.Const.Offset.Token + 1 )
	table.insert( ArkInventory.Global.Location[ArkInventory.Const.Location.Token].Bags, -4 )
	
	-- auctions
	table.insert( ArkInventory.Global.Location[ArkInventory.Const.Location.Auction].Bags, ArkInventory.Const.Offset.Auction + 1 )
	
	-- void storage
	for x = 1, ArkInventory.Const.VOID_STORAGE_PAGES do
		table.insert( ArkInventory.Global.Location[ArkInventory.Const.Location.Void].Bags, ArkInventory.Const.Offset.Void + x )
	end
	
	-- reputation
	table.insert( ArkInventory.Global.Location[ArkInventory.Const.Location.Reputation].Bags, ArkInventory.Const.Offset.Reputation + 1 )

	-- setup reverse lookup cache
	for loc_id, loc_data in pairs( ArkInventory.Global.Location ) do
		for bag_id, v in pairs( loc_data.Bags ) do
			ArkInventory.Global.Cache.BlizzardBagIdToInternalId[v] = { loc_id=loc_id, bag_id=bag_id }
		end
	end
	
end

function ArkInventory.OnInitialize( )
	
	-- pre acedb load, the database is just a table
	ArkInventory.DatabaseUpgradePreLoad( )
	
	-- load database, use default profile as we dont need them, metatables now active
	ArkInventory.acedb = LibStub( "AceDB-3.0" ):New( "ARKINVDB", ArkInventory.Const.DatabaseDefaults, true )
	ArkInventory.db = ArkInventory.acedb.global
	
	ArkInventory.StartupChecks( )
	
	-- config menu (internal)
	ArkInventory.Lib.Config:RegisterOptionsTable( ArkInventory.Const.Frame.Config.Internal, ArkInventory.Config.Internal )
	ArkInventory.Lib.Dialog:SetDefaultSize( ArkInventory.Const.Frame.Config.Internal, 1250, 650 )
	
	-- config menu (blizzard)
	ArkInventory.ConfigBlizzard( )
	ArkInventory.Lib.Config:RegisterOptionsTable( ArkInventory.Const.Frame.Config.Blizzard, ArkInventory.Config.Blizzard, { "arkinventory", "arkinv", "ai" } )
	ArkInventory.Lib.Dialog:AddToBlizOptions( ArkInventory.Const.Frame.Config.Blizzard, ArkInventory.Const.Program.Name )
	
	
	-- tooltip
	ArkInventory.Global.Tooltip.Scan = ArkInventory.TooltipScanInit( "ARKINV_ScanTooltip" )	
	
	ArkInventory.PlayerInfoSet( )
	ArkInventory.MediaRegister( )
	
	local me = ArkInventory.GetPlayerCodex( )
	
	for loc_id, loc_data in pairs( ArkInventory.Global.Location ) do
		if loc_data.canView then
			if me.profile.location[loc_id].special then
				local frame = ArkInventory.Frame_Main_Get( loc_id )
				table.insert( UISpecialFrames, frame:GetName( ) )
			end
		end
	end
	
	
	if not ARKINV_MountToggle then
		
		-- secure mount button to be able to cancel shapeshift forms
		local btn = CreateFrame( "Button", "ARKINV_MountToggle", UIParent, "SecureActionButtonTemplate" )
		
		local macrotext = "/dismount [combat, mounted, noflying]\n" -- dismount if in combat and mounted and not flying
		macrotext = macrotext .. "/stopmacro [combat]\n" -- abort if in combat
		
		if ( me.player.data.info.class == "DRUID" ) or ( me.player.data.info.class == "WARLOCK" ) or ( me.player.data.info.class == "SHAMAN" ) then
			macrotext = macrotext .. "/cancelform [noform:0]\n" -- cancel any form
		end
		
		-- class shapeshifts
		if me.player.data.ldb.travelform then
			if me.player.data.info.class == "DRUID" then
				local cat_form = GetSpellInfo( 768 )
				local travel_form = GetSpellInfo( 783 )
				macrotext = macrotext .. "/cast [indoors] " .. cat_form .. "; " .. travel_form .. "\n"
			end
			-- shaman ghost wolf?
		else
			macrotext = macrotext .. "/run ArkInventory.LDB.Mounts:OnClick( )\n"
		end
		
		--ArkInventory.Output( macrotext )
		
		btn:SetAttribute( "type", "macro" )
		btn:SetAttribute( "macrotext", macrotext )
		
		btn:SetPoint( "CENTER" )
		btn:Hide( )
		
	end
	
end

function ArkInventory.OnEnable( )
	
	-- Called when the addon is enabled
	
	--ArkInventory.Output( "OnEnable" )
	
	if ArkInventory.TOCVersionFail( ) then return end
	
	ArkInventory.PlayerInfoSet( )
	
	ArkInventory.BlizzardAPIHook( )
	
	ArkInventory.DatabaseUpgradePostLoad( )
	
	ArkInventory.CategoryGenerate( )
	
	-- tag all locations as changed
	ArkInventory.LocationSetValue( nil, "changed", true )
	
	-- tag all locations to be rebuilt from scratch
	--ArkInventory.OutputWarning( "OnEnable - .restart window draw" )
	ArkInventory.Frame_Main_DrawStatus( nil, ArkInventory.Const.Window.Draw.Restart )
	
	-- init location player id
	ArkInventory.LocationSetValue( nil, "player_id", ArkInventory.PlayerIDSelf( ) )
	
	-- fix companion data
	ArkInventory.CompanionDataUpdate( )
	
	-- register events
	--ArkInventory:RegisterMessage( "EVENT_ARKINV_STORAGE" )
	
	ArkInventory:RegisterEvent( "PLAYER_ENTERING_WORLD", "EVENT_ARKINV_PLAYER_ENTER" ) -- not really needed but seems to fix a bug where ace doesnt seem to init again
	ArkInventory:RegisterEvent( "PLAYER_LEAVING_WORLD", "EVENT_ARKINV_PLAYER_LEAVE" ) -- when the player logs out or the UI is reloaded.
	
	ArkInventory:RegisterBucketMessage( "EVENT_ARKINV_PLAYER_MONEY_BUCKET", 1 )
	ArkInventory:RegisterEvent( "PLAYER_MONEY", "EVENT_ARKINV_PLAYER_MONEY" )
	
	ArkInventory:RegisterEvent( "SKILL_LINES_CHANGED", "EVENT_ARKINV_PLAYER_SKILLS" ) -- triggered when you gain or lose a skill, skillup, collapse/expand a skill header
	
	ArkInventory:RegisterEvent( "PLAYER_REGEN_DISABLED", "EVENT_ARKINV_COMBAT_ENTER" ) -- player entered combat
	ArkInventory:RegisterEvent( "PLAYER_REGEN_ENABLED", "EVENT_ARKINV_COMBAT_LEAVE" ) -- player left combat
	
	local bucket1 = ArkInventory.db.option.bucket[ArkInventory.Const.Location.Bag] or 0.5
	
	ArkInventory:RegisterBucketMessage( "EVENT_ARKINV_TOOLTIP_REBUILD_QUEUE_UPDATE_BUCKET", bucket1 )
	ArkInventory:RegisterBucketMessage( "EVENT_ARKINV_BAG_RESCAN_BUCKET", 5 )
	ArkInventory:RegisterBucketMessage( "EVENT_ARKINV_BAG_UPDATE_BUCKET", bucket1 )
	ArkInventory:RegisterBucketMessage( "EVENT_ARKINV_LOCATION_SCANNED_BUCKET", bucket1 * 2 )
	ArkInventory:RegisterEvent( "BAG_UPDATE", "EVENT_ARKINV_BAG_UPDATE" )
	ArkInventory:RegisterEvent( "ITEM_LOCK_CHANGED", "EVENT_ARKINV_BAG_LOCK" )
--	ArkInventory:RegisterEvent( "BAG_NEW_ITEMS_UPDATED", "EVENT_ARKINV_BAG_UPDATE" ) -- fix me : do something with it?
--	ArkInventory:RegisterEvent( "BAG_SLOT_FLAGS_UPDATED", "EVENT_ARKINV_BAG_UPDATE" ) -- fix me : do something with it?
	
	ArkInventory:RegisterBucketMessage( "EVENT_ARKINV_BAG_UPDATE_COOLDOWN_BUCKET", bucket1 )
	ArkInventory:RegisterEvent( "BAG_UPDATE_COOLDOWN", "EVENT_ARKINV_BAG_UPDATE_COOLDOWN" )
	
	ArkInventory:RegisterBucketMessage( "EVENT_ARKINV_CHANGER_UPDATE_BUCKET", 1 )
	
	ArkInventory:RegisterEvent( "ACTIVE_TALENT_GROUP_CHANGED", "EVENT_ARKINV_TALENT_CHANGED" )
	
	ArkInventory:RegisterEvent( "BANKFRAME_OPENED", "EVENT_ARKINV_BANK_ENTER" )
	ArkInventory:RegisterBucketMessage( "EVENT_ARKINV_BANK_LEAVE_BUCKET", 0.3 )
	ArkInventory:RegisterEvent( "BANKFRAME_CLOSED", "EVENT_ARKINV_BANK_LEAVE" )
	ArkInventory:RegisterEvent( "PLAYERBANKSLOTS_CHANGED", "EVENT_ARKINV_BANK_UPDATE" ) -- a bag_update event for the bank (-1)
	ArkInventory:RegisterEvent( "PLAYERBANKBAGSLOTS_CHANGED", "EVENT_ARKINV_BANK_SLOT" ) -- triggered when you purchase a new bank bag slot
	--ArkInventory:RegisterEvent( "BANK_BAG_SLOT_FLAGS_UPDATED", "EVENT_ARKINV_BANK_UPDATE" )
	
	ArkInventory:RegisterEvent( "REAGENTBANK_PURCHASED", "EVENT_ARKINV_BANK_TAB" ) -- triggered when you purchase a bank tab (reagent bank)
	ArkInventory:RegisterEvent( "PLAYERREAGENTBANKSLOTS_CHANGED", "EVENT_ARKINV_REAGENTBANK_UPDATE" ) -- a bag_update event for the reagent bank (-3)
	ArkInventory:RegisterEvent( "REAGENTBANK_UPDATE", "EVENT_ARKINV_REAGENTBANK_UPDATE" )
	
	ArkInventory:RegisterEvent( "GUILDBANKFRAME_OPENED", "EVENT_ARKINV_VAULT_ENTER" )
	ArkInventory:RegisterBucketMessage( "EVENT_ARKINV_VAULT_LEAVE_BUCKET", 0.3 )
	ArkInventory:RegisterEvent( "GUILDBANKFRAME_CLOSED", "EVENT_ARKINV_VAULT_LEAVE" )
	ArkInventory:RegisterBucketMessage( "EVENT_ARKINV_VAULT_UPDATE_BUCKET", ArkInventory.db.option.bucket[ArkInventory.Const.Location.Vault] or 1.5 )
	ArkInventory:RegisterEvent( "GUILDBANKBAGSLOTS_CHANGED", "EVENT_ARKINV_VAULT_UPDATE" )
	ArkInventory:RegisterEvent( "GUILDBANK_ITEM_LOCK_CHANGED", "EVENT_ARKINV_VAULT_LOCK" )
	ArkInventory:RegisterEvent( "GUILDBANK_UPDATE_MONEY", "EVENT_ARKINV_VAULT_MONEY" )
	ArkInventory:RegisterEvent( "GUILDBANK_UPDATE_TABS", "EVENT_ARKINV_VAULT_TABS" )
	ArkInventory:RegisterEvent( "GUILDBANKLOG_UPDATE", "EVENT_ARKINV_VAULT_LOG" )
	ArkInventory:RegisterEvent( "GUILDBANK_UPDATE_TEXT", "EVENT_ARKINV_VAULT_INFO" )
	
	ArkInventory:RegisterBucketMessage( "EVENT_ARKINV_VOID_UPDATE_BUCKET", 0.5 )
	ArkInventory:RegisterEvent( "VOID_STORAGE_UPDATE", "EVENT_ARKINV_VOID_UPDATE" )
	--ArkInventory:RegisterEvent( "VOID_TRANSFER_DONE", "EVENT_ARKINV_VOID_UPDATE" )
	--ArkInventory:RegisterEvent( "VOID_STORAGE_DEPOSIT_UPDATE", "EVENT_ARKINV_VOID_UPDATE" )
	ArkInventory:RegisterEvent( "VOID_STORAGE_CONTENTS_UPDATE", "EVENT_ARKINV_VOID_UPDATE" )
	--ArkInventory:RegisterEvent( "VOID_DEPOSIT_WARNING", "EVENT_ARKINV_VOID_UPDATE" )
	
	ArkInventory:RegisterBucketMessage( "EVENT_ARKINV_INVENTORY_CHANGE_BUCKET", bucket1 )
	ArkInventory:RegisterEvent( "UNIT_INVENTORY_CHANGED", "EVENT_ARKINV_INVENTORY_CHANGE" )
	
	ArkInventory:RegisterEvent( "MAIL_SHOW", "EVENT_ARKINV_MAIL_ENTER" )
	ArkInventory:RegisterBucketMessage( "EVENT_ARKINV_MAIL_LEAVE_BUCKET", 0.3 )
	ArkInventory:RegisterEvent( "MAIL_CLOSED", "EVENT_ARKINV_MAIL_LEAVE" )
	ArkInventory:RegisterBucketMessage( "EVENT_ARKINV_MAIL_UPDATE_BUCKET", ArkInventory.db.option.bucket[ArkInventory.Const.Location.Mail] or 2 )
	ArkInventory:RegisterEvent( "MAIL_INBOX_UPDATE", "EVENT_ARKINV_MAIL_UPDATE" )
	ArkInventory:RegisterEvent( "MAIL_SEND_SUCCESS", "EVENT_ARKINV_MAIL_SEND_SUCCESS" )

	ArkInventory:RegisterEvent( "TRADE_SHOW", "EVENT_ARKINV_TRADE_ENTER" )
	ArkInventory:RegisterEvent( "TRADE_CLOSED", "EVENT_ARKINV_TRADE_LEAVE" )
	
	ArkInventory:RegisterEvent( "AUCTION_HOUSE_SHOW", "EVENT_ARKINV_AUCTION_ENTER" )
	ArkInventory:RegisterBucketMessage( "EVENT_ARKINV_AUCTION_LEAVE_BUCKET", 0.3 )
	ArkInventory:RegisterEvent( "AUCTION_HOUSE_CLOSED", "EVENT_ARKINV_AUCTION_LEAVE" )
	ArkInventory:RegisterBucketMessage( "EVENT_ARKINV_AUCTION_UPDATE_MASSIVE_BUCKET", 60 )
	ArkInventory:RegisterBucketMessage( "EVENT_ARKINV_AUCTION_UPDATE_BUCKET", 2 )
	ArkInventory:RegisterEvent( "AUCTION_OWNED_LIST_UPDATE", "EVENT_ARKINV_AUCTION_UPDATE" )
	
	ArkInventory:RegisterBucketMessage( "EVENT_ARKINV_MERCHANT_LEAVE_BUCKET", 0.3 )
	ArkInventory:RegisterEvent( "MERCHANT_SHOW", "EVENT_ARKINV_MERCHANT_ENTER" )
	ArkInventory:RegisterEvent( "MERCHANT_CLOSED", "EVENT_ARKINV_MERCHANT_LEAVE" )
	ArkInventory:RegisterEvent( "TRANSMOGRIFY_OPEN", "EVENT_ARKINV_TRANSMOG_ENTER" )
	ArkInventory:RegisterEvent( "TRANSMOGRIFY_CLOSE", "EVENT_ARKINV_MERCHANT_LEAVE" )
	
	ArkInventory:RegisterBucketMessage( "EVENT_ARKINV_COLLECTION_MOUNT_UPDATE_BUCKET", 1 )
--	ArkInventory:RegisterEvent( "COMPANION_UPDATE", "EVENT_ARKINV_COLLECTION_COMPANION_UPDATE" ) -- do i really need this? it triggers when other people mount/dismount as well
	ArkInventory:RegisterEvent( "COMPANION_LEARNED", "EVENT_ARKINV_COLLECTION_COMPANION_UPDATE" )
	ArkInventory:RegisterEvent( "COMPANION_UNLEARNED", "EVENT_ARKINV_COLLECTION_COMPANION_UPDATE" )
	
	ArkInventory:RegisterBucketMessage( "EVENT_ARKINV_COLLECTION_PET_UPDATE_BUCKET", 1 )
	ArkInventory:RegisterEvent( "NEW_PET_ADDED", "EVENT_ARKINV_COLLECTION_PET_UPDATE" )
	ArkInventory:RegisterEvent( "PET_JOURNAL_LIST_UPDATE", "EVENT_ARKINV_COLLECTION_PET_UPDATE" )
	ArkInventory:RegisterEvent( "PET_JOURNAL_PET_DELETED", "EVENT_ARKINV_COLLECTION_PET_UPDATE" )
	ArkInventory:RegisterEvent( "PET_JOURNAL_PET_RESTORED", "EVENT_ARKINV_COLLECTION_PET_UPDATE" )
	ArkInventory:RegisterEvent( "PET_JOURNAL_PET_REVOKED", "EVENT_ARKINV_COLLECTION_PET_UPDATE" )
	ArkInventory:RegisterEvent( "PET_JOURNAL_PETS_HEALED", "EVENT_ARKINV_COLLECTION_PET_UPDATE" )
	ArkInventory:RegisterEvent( "BATTLE_PET_CURSOR_CLEAR", "EVENT_ARKINV_COLLECTION_PET_UPDATE" )
	ArkInventory:RegisterEvent( "PET_BATTLE_LEVEL_CHANGED", "EVENT_ARKINV_COLLECTION_PET_UPDATE" )
	ArkInventory:RegisterEvent( "PET_BATTLE_QUEUE_STATUS", "EVENT_ARKINV_COLLECTION_PET_UPDATE" )
	ArkInventory:RegisterEvent( "PET_BATTLE_CLOSE", "EVENT_ARKINV_COLLECTION_PET_UPDATE" )
	ArkInventory:RegisterEvent( "PET_BATTLE_OPENING_DONE", "EVENT_ARKINV_BATTLEPET_OPENING_DONE" )
	--ArkInventory:RegisterEvent( "CHAT_MSG_PET_BATTLE_COMBAT_LOG", "EVENT_ARKINV_COLLECTION_PET_UPDATE" )
	--ArkInventory:RegisterEvent( "CHAT_MSG_PET_INFO", "EVENT_ARKINV_COLLECTION_PET_UPDATE" )
	--ArkInventory:RegisterEvent( "CHAT_MSG_PET_BATTLE_INFO", "EVENT_ARKINV_COLLECTION_PET_UPDATE" )
	--ArkInventory:RegisterEvent( "PET_BATTLE_PET_CHANGED", "EVENT_ARKINV_COLLECTION_PET_UPDATE" )
	--ArkInventory:RegisterEvent( "PET_BATTLE_PET_ROUND_RESULTS", "EVENT_ARKINV_COLLECTION_PET_UPDATE" )
	--ArkInventory:RegisterEvent( "PET_BATTLE_XP_CHANGED", "EVENT_ARKINV_COLLECTION_PET_UPDATE" )
	--ArkInventory:RegisterEvent( "PET_BATTLE_OVER", "EVENT_ARKINV_COLLECTION_PET_UPDATE" )
	
	ArkInventory:RegisterBucketMessage( "EVENT_ARKINV_COLLECTION_TOYBOX_UPDATE_BUCKET", 1 )
	ArkInventory:RegisterEvent( "TOYS_UPDATED", "EVENT_ARKINV_COLLECTION_TOYBOX_UPDATE" )
	
	ArkInventory:RegisterBucketMessage( "EVENT_ARKINV_COLLECTION_HEIRLOOM_UPDATE_BUCKET", 1 )
	ArkInventory:RegisterEvent( "HEIRLOOMS_UPDATED", "EVENT_ARKINV_COLLECTION_HEIRLOOM_UPDATE" )
	
	ArkInventory:RegisterBucketMessage( "EVENT_ARKINV_COLLECTION_REPUTATION_UPDATE_BUCKET", 1 )
	ArkInventory:RegisterEvent( "UPDATE_FACTION", "EVENT_ARKINV_COLLECTION_REPUTATION_UPDATE" )
	ArkInventory:RegisterEvent( "LFG_BONUS_FACTION_ID_UPDATED", "EVENT_ARKINV_COLLECTION_REPUTATION_UPDATE" )
	--ArkInventory:RegisterEvent( "QUEST_LOG_UPDATE", "" ) -- triggers too often to be usable
	
	ArkInventory:RegisterEvent( "EQUIPMENT_SETS_CHANGED", "EVENT_ARKINV_EQUIPMENT_SETS_CHANGED" )
	
	ArkInventory:RegisterBucketMessage( "EVENT_ARKINV_COLLECTION_CURRENCY_UPDATE_BUCKET", 1 )
	ArkInventory:RegisterEvent( "CURRENCY_DISPLAY_UPDATE", "EVENT_ARKINV_COLLECTION_CURRENCY_UPDATE" )
	
	ArkInventory:RegisterBucketMessage( "EVENT_ARKINV_QUEST_UPDATE_BUCKET", 3 ) -- update quest item glows.  not super urgent just get them there eventually
	ArkInventory:RegisterEvent( "QUEST_ACCEPTED", "EVENT_ARKINV_QUEST_UPDATE" )
--	ArkInventory:RegisterEvent( "QUEST_ITEM_UPDATED", "EVENT_ARKINV_QUEST_UPDATE" ) -- no longer valid in BFA
	ArkInventory:RegisterEvent( "QUEST_FINISHED", "EVENT_ARKINV_QUEST_UPDATE" )
	ArkInventory:RegisterEvent( "UNIT_QUEST_LOG_CHANGED", "EVENT_ARKINV_QUEST_UPDATE" )
	
	ArkInventory:RegisterEvent( "CVAR_UPDATE", "EVENT_ARKINV_CVAR_UPDATE" )
	
--	ArkInventory:RegisterBucketMessage( "EVENT_ARKINV_ZONE_CHANGED_BUCKET", 5 )
--	ArkInventory:RegisterEvent( "ZONE_CHANGED", "EVENT_ARKINV_ZONE_CHANGED" )
--	ArkInventory:RegisterEvent( "ZONE_CHANGED_INDOORS", "EVENT_ARKINV_ZONE_CHANGED" )
--	ArkInventory:RegisterEvent( "ZONE_CHANGED_NEW_AREA", "EVENT_ARKINV_ZONE_CHANGED" )
	
	-- ldb mount/pet updates
	ArkInventory:RegisterBucketMessage( "EVENT_ARKINV_ACTIONBAR_UPDATE_USABLE_BUCKET", 1 )
	ArkInventory:RegisterEvent( "ACTIONBAR_UPDATE_USABLE", "EVENT_ARKINV_ACTIONBAR_UPDATE_USABLE" )
	
	--soul shards
	--ArkInventory:RegisterBucketMessage( "EVENT_ARKINV_UNIT_POWER_BUCKET", 1 )
	--ArkInventory:RegisterEvent( "UNIT_POWER", "EVENT_ARKINV_UNIT_POWER" )
	
	-- scrapping
	ArkInventory:RegisterEvent( "SCRAPPING_MACHINE_SHOW", "EVENT_ARKINV_SCRAP_ENTER" )
	ArkInventory:RegisterEvent( "SCRAPPING_MACHINE_CLOSE", "EVENT_ARKINV_SCRAP_LEAVE" )
	
	
	for loc_id, loc_data in pairs( ArkInventory.Global.Location ) do
		-- initialise codex for each location
		ArkInventory.GetLocationCodex( loc_id )
	end
	
	ArkInventory.ScanProfessions( )
	ArkInventory.ScanLocation( )
	
	ArkInventory.LDB.Money:Update( )
	ArkInventory.LDB.Bags:Update( )
	ArkInventory.LDB.Tracking_Currency:Update( )
	ArkInventory.LDB.Tracking_Item:Update( )
	ArkInventory.LDB.Tracking_Reputation:Update( )
	
	ArkInventory.ScanAuctionExpire( )
	
	ArkInventory.Output( ArkInventory.Global.Version, " ", ArkInventory.Localise["ENABLED"] )
	
	ArkInventory.MediaMenuFontSet( ArkInventory.db.option.font.face, ArkInventory.db.option.menu.font.height )
	
	if not ArkInventory.Global.Thread.Use then
		-- should be set to true by default so if its not then i forgot to put it back
		ArkInventory.OutputWarning( "Thread.Use is disabled (this may be deliberate if this is an Alpha/Beta version)" )
	end
	
	
	SetSortBagsRightToLeft( ArkInventory.db.option.restack.reverse )
	
end

function ArkInventory.OnDisable( )
	
	--ArkInventory.Frame_Main_Hide( )
	
	if ArkInventory.TOCVersionFail( true ) then return end
	
	ArkInventory.BlizzardAPIHook( true )
	
	ArkInventory.Output( ArkInventory.Global.Version, " ", ArkInventory.Localise["DISABLED"] )
	
end

function ArkInventory.ObjectLockChanged( loc_id, bag_id, slot_id )
	
	if slot_id == nil then
		
		ArkInventory.Frame_Changer_Slot_Update_Lock( loc_id, bag_id )
		
	else
		
		local framename, frame = ArkInventory.ContainerItemNameGet( loc_id, bag_id, slot_id )
		ArkInventory.Frame_Item_Update_Lock( frame )
		ArkInventory.Frame_Item_Update_Border( frame )
		
	end
	
end

function ArkInventory.ItemSortKeyClear( loc_id )
	
	-- clear sort keys
	
	local codex = ArkInventory.GetLocationCodex( loc_id )
	
	if not codex.workpad.bar then return end
	
	for _, bar in pairs( codex.workpad.bar ) do
		for _, item in pairs( bar.item ) do
			item.sortkey = nil
		end
	end
	
end

function ArkInventory.ItemSortKeyGenerate( i, bar_id, codex )
	
	if not i then return nil end
	
	local codex = codex or ArkInventory.GetLocationCodex( i.loc_id )
	
	local sid = codex.style.sort.method
	
	if bar_id then
		sid = codex.layout.bar.data[bar_id].sort.method or sid
	end
	
	local sorting = ArkInventory.ConfigInternalSortMethodGet( sid )
	
	local s = { }
	local sx = ""
	
	if sid == 9995 then
		-- vault layout / void storage layout
		s["!bagslot"] = string.format( "%04i %04i", i.bag_id or 0, i.did or i.slot_id or 0 )
	else
		-- all other bag/slot
		s["!bagslot"] = string.format( "%04i %04i", i.bag_id or 0, i.slot_id or 0 )
	end
	
	if sorting.used and not sorting.bagslot then
		
		local t
		local info = ArkInventory.ObjectInfoArray( i.h, i )
		
		-- slot type
		t = 0
		if sorting.active.slottype then
			t = info.osd.slottype
		end
		s["!slottype"] = string.format( "%04i", t or 0 )
		
		
		-- item count (system)
		t = i.count
		s["!count"] = string.format( "%010i", t or 1 )
		
		
		-- item name
		t = "!"
		if sorting.active.name then
			
			if i.h then
				
				t = info.name
				if t and type( i.cn ) == "string" and i.cn ~= "" then
					t = string.format( "%s %s", t, i.cn )
				end
				t = t or "!"
				
				if sorting.reversed then
					t = ArkInventory.ReverseName( t )
				end
				
			else
				
				if codex.style.slot.empty.position then
					-- first alphabetically (default)
					t = "!"
				else
					-- last alphabetically
					t = "_"
				end
				
			end
			
		end
		s["name"] = t or "!"
		
		
		-- item quality
		t = 0
		if i.q and sorting.active.quality then
			t = i.q
		end
		s["quality"] = string.format( "%02i", t or 0 )
		
		
		-- equip location
		t = "!"
		if i.h and info.class == "item" and sorting.active.location then
			if type( info.equiploc ) == "string" and info.equiploc ~= "" and _G[info.equiploc] then
				t = _G[info.equiploc]
			end
		end
		s["location"] = string.format( "%s", t or "!" )
		
		
		-- item type / subtype
		local item_type = 0
		local item_subtype = 0
		
		if sorting.active.itemtype then
			item_type = info.itemtypeid
			item_subtype = info.itemsubtypeid
		end
		s["itemtype"] = string.format( "%04i %04i", item_type or 0, item_subtype or 0 )
		
		
		-- item (use) level
		t = 0
		if i.h and sorting.active.itemuselevel then
			t = info.uselevel
		end
		s["itemuselevel"] = string.format( "%04i", t or 0 )
		
		
		-- item (stat) level
		t = 0
		if i.h and sorting.active.itemstatlevel then
			t = info.ilvl
		end
		s["itemstatlevel"] = string.format( "%04i", t or 0 )
		
		
		-- item age
		t = 0
		if i.h and sorting.active.itemage then
			t = i.age
		end
		s["itemage"] = string.format( "%010i", t or 0 )
		
		
		-- vendor price
		t = 0
		if i.h and sorting.active.vendorprice then
			t = ( info.vendorprice or 0 ) * ( i.count or 1 )
		end
		s["vendorprice"] = string.format( "%010i", t or 0 )
		
		
		-- expansion
		t = 0
		if i.h and sorting.active.expansion then
			t = ( info.expansion or 0 )
		end
		s["expansion"] = string.format( "%03i", t or 0 )

		
		-- category
		local cat_type = 0
		local cat_code = 0
		local cat_order = 0
		
		if i.h and sorting.active.category then
			
			local cat_id = ArkInventory.ItemCategoryGet( i )
			
			cat_type, cat_code = ArkInventory.CategoryCodeSplit( cat_id )
			
			if cat_type == ArkInventory.Const.Category.Type.Rule then
				local cat = ArkInventory.db.option.category[cat_type].data[cat_code]
				if cat.used then
					cat_order = cat.order
				end
			end
			
		end
		s["category"] = string.format( "%02i %04i %04i", cat_type or 0, cat_order or 0, cat_code or 0 )
		
		
		-- id
		local t = 0
		if i.h and sorting.active.id then
			t = info.id
		end
		s["id"] = string.format( "%s:%010i:%02i", info.class or "error", t or 0, info.sb or ArkInventory.Const.Bind.Never )
		
		
		-- build key
		for k, v in ipairs( sorting.order ) do
			if type( s[v] ) == "string" then
				sx = string.format( "%s %s", sx, s[v] )
			end
		end
		
		sx = string.format( "%s%s", sx, s["!count"] )
		sx = string.format( "%s%s", sx, s["!bagslot"] )
		
	else
		
		sx = s["!bagslot"]
		
	end
	
	return sx
	
end


function ArkInventory.LocationSetValue( l, k, v )
	for loc_id, loc_data in pairs( ArkInventory.Global.Location ) do
		if l == nil or l == loc_id then
			loc_data[k] = v
		end
	end
end

function ArkInventory.CategoryLocationSet( loc_id, cat_id, bar_id )
	
	assert( cat_id ~= nil , "category is nil" )
	
	local cat_def = ArkInventory.CategoryGetSystemID( "SYSTEM_DEFAULT" )
	
	if ( cat_id ~= cat_def ) or ( bar_id ~= nil ) then
		local codex = ArkInventory.GetLocationCodex( loc_id )
		codex.layout.category[cat_id] = bar_id
	end
	
end

function ArkInventory.CategoryLocationGet( loc_id, cat_id )
	
	-- return 1: which bar a category is located on
	-- return 2: is it the default bar
	
	local cat_id = cat_id or ArkInventory.CategoryGetSystemID( "SYSTEM_UNKNOWN" )
	
	local codex = ArkInventory.GetLocationCodex( loc_id )
	local bar_id = codex.layout.category[cat_id]
	--ArkInventory.Output( "loc=[", loc_id, "], cat=[", cat_id, "], bar=[", bar, "]" )
	
	local cat_def = ArkInventory.CategoryGetSystemID( "SYSTEM_DEFAULT" )
	local bar_def = codex.layout.category[cat_def] or 1
	
	if not bar_id then
		-- if this category hasn't been assigned to a bar then return the bar that DEFAULT is using
		return bar_def, true
	else
		return bar_id, false
	end
	
end

function ArkInventory.CategoryHiddenCheck( loc_id, cat_id )
	
	-- hidden categories have a negative bar number
	
	local bar_id = ArkInventory.CategoryLocationGet( loc_id, cat_id )
	
	if bar_id < 0 then
		return true
	else
		return false
	end
	
end

function ArkInventory.CategoryHiddenToggle( loc_id, cat_id )
	ArkInventory.CategoryLocationSet( loc_id, cat_id, 0 - ArkInventory.CategoryLocationGet( loc_id, cat_id ) )
end

function ArkInventory.CategoryGenerate( )
	
	local categories = {
		["SYSTEM"] = ArkInventory.Const.Category.Code.System, -- CATEGORY_SYSTEM
		["CONSUMABLE"] = ArkInventory.Const.Category.Code.Consumable, -- CATEGORY_CONSUMABLE
		["TRADEGOODS"] = ArkInventory.Const.Category.Code.Trade,  -- CATEGORY_TRADEGOODS
		["SKILL"] = ArkInventory.Const.Category.Code.Skill, -- CATEGORY_SKILL
		["CLASS"] = ArkInventory.Const.Category.Code.Class, -- CATEGORY_CLASS
		["EMPTY"] = ArkInventory.Const.Category.Code.Empty, -- CATEGORY_EMPTY
		["RULE"] = ArkInventory.db.option.category[ArkInventory.Const.Category.Type.Rule].data, -- CATEGORY_RULE
		["CUSTOM"] = ArkInventory.db.option.category[ArkInventory.Const.Category.Type.Custom].data, -- CATEGORY_CUSTOM
	}
	
	table.wipe( ArkInventory.Global.Category )
	
	for tn, d in pairs( categories ) do
		
		for k, v in pairs( d ) do
			
			--ArkInventory.Output( k, " - ", v )
			
			local system, order, sort_order, name, cat_id, cat_type, cat_code
			
			if tn == "RULE" then
				
				if v.used == "Y" then
					
					cat_type = ArkInventory.Const.Category.Type.Rule
					cat_code = k
					
					system = nil
					name = string.format( "[%04i] %s", k, v.name )
					order = ( v.order or 99999 ) + ( k / 10000 )
					sort_order = string.lower( v.name )
					
				end
				
			elseif tn == "CUSTOM" then
				
				if v.used == "Y" then
					
					cat_type = ArkInventory.Const.Category.Type.Custom
					cat_code = k
					
					system = nil
					name = string.format( "[%04i] %s", k, v.name )
					order = k
					sort_order = string.lower( v.name )
				
				end
				
			else
				
				cat_type = ArkInventory.Const.Category.Type.System
				cat_code = k
				
				system = string.upper( v.id )
				
				name = v.text
				if type( name ) == "function" then
					name = name( )
				end
				sort_order = string.lower( name )
				name = string.format( "[%04i] %s", k, name or system )
				
			end
			
			if name then
				
				cat_id = ArkInventory.CategoryCodeJoin( cat_type, cat_code )
				
				assert( not ArkInventory.Global.Category[cat_id], string.format( "duplicate category: %s [%s] ", tn, cat_id ) )
				
				ArkInventory.Global.Category[cat_id] = {
					["id"] = cat_id,
					["system"] = system,
					["name"] = name or string.format( "%s %04i %s", tn, k, "<no name>"  ),
					["fullname"] = string.format( "%s > %s", ArkInventory.Localise[string.format( "CATEGORY_%s", tn )], name ),
					["order"] = order or 0,
					["sort_order"] = string.lower( sort_order ) or "!",
					["type_code"] = tn,
					["type"] = ArkInventory.Localise[string.format( "CATEGORY_%s", tn )],
				}
				
			end
			
		end
		
	end
	
end

function ArkInventory.CategoryCodeSplit( id )
	local cat_type, cat_code = string.match( id, "(%d+)!(%d+)" )
	return tonumber( cat_type ), tonumber( cat_code )
end

function ArkInventory.CategoryCodeJoin( cat_type, cat_code )
	return string.format( "%i!%i", cat_type, cat_code )
end

function ArkInventory.CategoryGetNext( v )
	
	if not v.next then
		v.next = v.min
	else
		if v.next < v.min then
			v.next = v.min
		end
	end
	
	local c = 0
	
	while true do
		
		v.next = v.next + 1
		
		if v.next > v.max then
			c = c + 1
			v.next = v.min
		end
		
		if c > 1 then
			return -1
		end
		
		if not v.data[v.next] then
			return -2
		end
		
		if v.data[v.next].used == "N" then
			return v.next, v.data[v.next]
		end
		
	end
	
end

function ArkInventory.CategoryBarHasEntries( loc_id, bar_id, cat_type )
	
	for _, cat in ArkInventory.spairs( ArkInventory.Global.Category ) do
		
		local t = cat.type_code
		local cat_bar, def_bar = ArkInventory.CategoryLocationGet( loc_id, cat.id )
		
		if abs( cat_bar ) == bar_id and not def_bar then
			if cat_type == t then
				return true
			end
		end
		
	end
	
end


function ArkInventory.CategoryGetSystemID( cat_name )

	-- internal system category names only, if it doesnt exist you'll get the default instead

	--ArkInventory.Output( "search=[", cat_name, "]" )
	
	local cat_name = string.upper( cat_name )
	local cat_def
	
	for _, v in pairs( ArkInventory.Global.Category ) do
		
		--ArkInventory.Output( "checking=[", v.system, "]" )
		
		if cat_name == v.system then
			--ArkInventory.Output( "found=[", cat_name, " = ", v.name, "] = [", v.id, "]" )
			return v.id
			
		elseif v.system == "SYSTEM_DEFAULT" then
			--ArkInventory.Output( "default found=[", v.name, "] = [", v.id, "]" )
			cat_def = v.id
		end
		
	end
	
	--ArkInventory.Output( "not found=[", cat_name, "] = using default[", cat_def, "]" )
	return cat_def
	
end


function ArkInventory.ItemCategoryGetDefaultActual( i )
	
	-- local debuginfo = { ["m"]=gcinfo( ), ["t"]=GetTime( ) }
	
	-- pet journal pets
	if i.loc_id == ArkInventory.Const.Location.Pet then
		
		if i.bp then
			if i.sb == ArkInventory.Const.Bind.Pickup or i.sb == ArkInventory.Const.Bind.Account then
				return ArkInventory.CategoryGetSystemID( "SYSTEM_PET_BATTLE_BOUND" )
			else
				return ArkInventory.CategoryGetSystemID( "SYSTEM_PET_BATTLE_TRADE" )
			end
		else
			if i.sb == ArkInventory.Const.Bind.Pickup or i.sb == ArkInventory.Const.Bind.Account then
				return ArkInventory.CategoryGetSystemID( "SYSTEM_PET_COMPANION_BOUND" )
			else
				return ArkInventory.CategoryGetSystemID( "SYSTEM_PET_COMPANION_TRADE" )
			end
		end
		
	end
	
	-- mounts
	if i.loc_id == ArkInventory.Const.Location.Mount then
		return ArkInventory.CategoryGetSystemID( "SYSTEM_MOUNT" )
	end
	
	-- currencies
	if i.loc_id == ArkInventory.Const.Location.Token then
		return ArkInventory.CategoryGetSystemID( "SYSTEM_CURRENCY" )
	end
	
	-- toybox
	if i.loc_id == ArkInventory.Const.Location.Toybox then
		return ArkInventory.CategoryGetSystemID( "SYSTEM_TOY" )
	end
	
	-- heirloom
	if i.loc_id == ArkInventory.Const.Location.Heirloom then
		return ArkInventory.CategoryGetSystemID( "SYSTEM_HEIRLOOM" )
	end
	
	-- reputation
	if i.loc_id == ArkInventory.Const.Location.Reputation then
		return ArkInventory.CategoryGetSystemID( "SYSTEM_REPUTATION" )
	end
	
	
	-- everything else
	local info = ArkInventory.ObjectInfoArray( i.h, i )
	
	
	-- mythic keystone
	if info.class == "keystone" then
		return ArkInventory.CategoryGetSystemID( "SYSTEM_MYTHIC_KEYSTONE" )
	end
	
	-- caged battle pets
	if info.class == "battlepet" then
		if i.sb == ArkInventory.Const.Bind.Pickup or i.sb == ArkInventory.Const.Bind.Account then
			return ArkInventory.CategoryGetSystemID( "SYSTEM_PET_BATTLE_BOUND" )
		else
			return ArkInventory.CategoryGetSystemID( "SYSTEM_PET_BATTLE_TRADE" )
		end
	end
	
	
	-- items only from here on
	if info.class ~= "item" then return end
	
	
	if info.q == LE_ITEM_QUALITY_HEIRLOOM then
		return ArkInventory.CategoryGetSystemID( "SYSTEM_HEIRLOOM" )
	end
	
	--ArkInventory.Output( "bag[", i.bag_id, "], slot[", i.slot_id, "] = ", itemType )
	
	-- no item info
	if info.name == nil then
		return ArkInventory.CategoryGetSystemID( "SYSTEM_UNKNOWN" )
	end
	
	-- unknown items
	if info.itemtypeid == ArkInventory.Const.ItemClass.UNKNOWN then
		return ArkInventory.CategoryGetSystemID( "SYSTEM_UNKNOWN" )
	end
	
	-- starlight rose dust
	if info.id == 129158 then
		return ArkInventory.CategoryGetSystemID( "SYSTEM_QUEST" )
	end
	
	-- trash
	if info.q == LE_ITEM_QUALITY_POOR then
		return ArkInventory.CategoryGetSystemID( "SYSTEM_TRASH" )
	end
	
	-- quest items
	if info.itemtypeid == ArkInventory.Const.ItemClass.QUEST then
		return ArkInventory.CategoryGetSystemID( "SYSTEM_QUEST" )
	end
	
	-- bags / containers
	if info.itemtypeid == ArkInventory.Const.ItemClass.CONTAINER then	
		return ArkInventory.CategoryGetSystemID( "SYSTEM_CONTAINER" )
	end
	
	-- gems
	if info.itemtypeid == ArkInventory.Const.ItemClass.GEM then
		if info.itemsubtypeid == ArkInventory.Const.ItemClass.GEM_ARTIFACT_RELIC then
			return ArkInventory.CategoryGetSystemID( "SYSTEM_ARTIFACT_RELIC" )
		else
			return ArkInventory.CategoryGetSystemID( "SYSTEM_GEM" )
		end
	end
	
	-- glyphs
	if info.itemtypeid == ArkInventory.Const.ItemClass.GLYPH then
		return ArkInventory.CategoryGetSystemID( "SYSTEM_GLYPH" )
	end
	
	-- battle pet as an item
	if info.itemtypeid == ArkInventory.Const.ItemClass.BATTLEPET then
		if i.sb == ArkInventory.Const.Bind.Pickup or i.sb == ArkInventory.Const.Bind.Account then
			return ArkInventory.CategoryGetSystemID( "SYSTEM_PET_BATTLE_BOUND" )
		else
			return ArkInventory.CategoryGetSystemID( "SYSTEM_PET_BATTLE_TRADE" )
		end
	end
	
	-- misc
	if info.itemtypeid == ArkInventory.Const.ItemClass.MISC then
		
		if info.itemsubtypeid == ArkInventory.Const.ItemClass.MISC_PET or ArkInventory.PT_ItemInSets( i.h, ArkInventory.Localise["PT_CATEGORY_PET"] ) then
			if i.sb == ArkInventory.Const.Bind.Pickup or i.sb == ArkInventory.Const.Bind.Account then
				return ArkInventory.CategoryGetSystemID( "SYSTEM_PET_COMPANION_BOUND" )
			else
				return ArkInventory.CategoryGetSystemID( "SYSTEM_PET_COMPANION_TRADE" )
			end
		end
		
		if info.itemsubtypeid == ArkInventory.Const.ItemClass.MISC_MOUNT or ArkInventory.PT_ItemInSets( i.h, ArkInventory.Localise["PT_CATEGORY_MOUNT"] ) then
			return ArkInventory.CategoryGetSystemID( "SYSTEM_MOUNT" )
		end
		
	end
	
	-- item enhancements
	if info.itemtypeid == ArkInventory.Const.ItemClass.ITEM_ENHANCEMENT then
		return ArkInventory.CategoryGetSystemID( "SYSTEM_ITEM_ENHANCEMENT" )
	end
	
	-- artifact power.  tooltip check is lower down
	if IsArtifactPowerItem( info.id ) or ArkInventory.PT_ItemInSets( i.h, ArkInventory.Localise["PT_CATEGORY_ARTIFACT_POWER"] ) then
		return ArkInventory.CategoryGetSystemID( "CONSUMABLE_ARTIFACT_POWER" )
	end
	

	
	-- setup tooltip for scanning
	if ArkInventory.Global.Location[i.loc_id].isOffline then
		ArkInventory.TooltipSetHyperlink( ArkInventory.Global.Tooltip.Scan, i.h )
	else
		local blizzard_id = ArkInventory.InternalIdToBlizzardBagId( i.loc_id, i.bag_id )
		ArkInventory.TooltipSetItem( ArkInventory.Global.Tooltip.Scan, blizzard_id, i.slot_id )
	end
	
	-- tooltip not ready, set to unknown so it will try again next time
	if not ArkInventory.TooltipIsReady( ArkInventory.Global.Tooltip.Scan ) then
		ArkInventory.OutputError( i.h, " not ready" )
		return ArkInventory.CategoryGetSystemID( "SYSTEM_UNKNOWN" )
	end
	
	
	-- unusable soulbound items are also trash (if enabled)
	if i.loc_id == ArkInventory.Const.Location.Bag then
		if false then -- add config option first
			if i.sb == ArkInventory.Const.Bind.Pickup then
				local usable = ArkInventory.TooltipCanUse( ArkInventory.Global.Tooltip.Scan )
				if not usable then
					return ArkInventory.CategoryGetSystemID( "SYSTEM_TRASH" )
				end
			end
		end
	end
	
	
	-- equipable items
	if info.equiploc ~= "" or info.itemtypeid == ArkInventory.Const.ItemClass.WEAPON or info.itemtypeid == ArkInventory.Const.ItemClass.ARMOR then
		
--		if not ( info.itemtypeid == ArkInventory.Const.ItemClass.WEAPON or info.itemtypeid == ArkInventory.Const.ItemClass.ARMOR ) then
--			ArkInventory.Output( i.h, " / ", info.equiploc )
--		end
		
		if i.sb == ArkInventory.Const.Bind.Account then
			return ArkInventory.CategoryGetSystemID( "SYSTEM_EQUIPMENT_ACCOUNTBOUND" )
		elseif i.sb == ArkInventory.Const.Bind.Pickup then
			return ArkInventory.CategoryGetSystemID( "SYSTEM_EQUIPMENT_SOULBOUND" )
		else
			return ArkInventory.CategoryGetSystemID( "SYSTEM_EQUIPMENT" )
		end
		
	end
	
	
	-- recipe
	if info.itemtypeid == ArkInventory.Const.ItemClass.RECIPE then
		return ArkInventory.CategoryGetSystemID( "SYSTEM_RECIPE" )
	end
	
	-- toys
	if ArkInventory.TooltipContains( ArkInventory.Global.Tooltip.Scan, ITEM_TOY_ONUSE, false, true, true, true ) then
		if ( i.sb == ArkInventory.Const.Bind.Pickup or i.sb == ArkInventory.Const.Bind.Account ) and ArkInventory.TooltipContains( ArkInventory.Global.Tooltip.Scan, ArkInventory.Localise["ALREADY_KNOWN"], false, true, true, true ) then
			return ArkInventory.CategoryGetSystemID( "SYSTEM_TRASH" )
		else
			return ArkInventory.CategoryGetSystemID( "SYSTEM_TOY" )
		end
	end
	
	
	local codex = ArkInventory.GetLocationCodex( i.loc_id )
	
	-- only check these if its the player (not the account)
	if codex.player.data.info.isplayer then
		
		-- class requirement (via tooltip)
		local _, _, req = ArkInventory.TooltipFind( ArkInventory.Global.Tooltip.Scan, ArkInventory.Localise["WOW_TOOLTIP_REQUIRES_CLASS"], false, true, true, 0, true )
		if req and string.find( req, codex.player.data.info.class_local ) then
			return ArkInventory.CategoryGetSystemID( string.format( "CLASS_%s", codex.player.data.info.class ) )
		end
		
		-- class requirement (via PT)
		local key = string.format( "PT_CLASS_%s", codex.player.data.info.class )
		if ArkInventory.PT_ItemInSets( i.h, ArkInventory.Localise[key] ) then
			return ArkInventory.CategoryGetSystemID( string.format( "CLASS_%s", codex.player.data.info.class ) )
		end
		
	end
	
	
	-- artifact power (tooltip)
	if ArkInventory.TooltipFind( ArkInventory.Global.Tooltip.Scan, ArkInventory.Localise["WOW_TOOLTIP_ARTIFACT_POWER"], false, true, false, 0, true ) then
		return ArkInventory.CategoryGetSystemID( "CONSUMABLE_ARTIFACT_POWER" )
	end
	
	-- ancient mana (tooltip)
	if ArkInventory.TooltipFind( ArkInventory.Global.Tooltip.Scan, ArkInventory.Localise["WOW_TOOLTIP_ANCIENT_MANA"], false, true, false, 0, true ) then
		return ArkInventory.CategoryGetSystemID( "SYSTEM_CURRENCY" )
	end
	
	
	if info.itemtypeid == ArkInventory.Const.ItemClass.TRADEGOODS then
		
		local t = { "ELEMENTAL", "CLOTH", "LEATHER", "METAL_AND_STONE", "COOKING", "HERB", "ENCHANTING", "JEWELCRAFTING", "ENCHANTMENT" }
		
		for _, w in pairs( t ) do
			if info.itemsubtypeid == ArkInventory.Const.ItemClass[string.format( "TRADEGOODS_%s", w )] then
				return ArkInventory.CategoryGetSystemID( string.format( "TRADEGOODS_%s", w ) )
			end
		end
		
	end
	
	if info.itemtypeid == ArkInventory.Const.ItemClass.CONSUMABLE then
		
		if info.itemsubtypeid == ArkInventory.Const.ItemClass.CONSUMABLE_FOOD_AND_DRINK then
			
			if ArkInventory.TooltipContains( ArkInventory.Global.Tooltip.Scan, ArkInventory.Localise["WOW_ITEM_TOOLTIP_FOOD"] ) then
				return ArkInventory.CategoryGetSystemID( "CONSUMABLE_FOOD" )
			end
			
			if ArkInventory.TooltipContains( ArkInventory.Global.Tooltip.Scan, ArkInventory.Localise["WOW_ITEM_TOOLTIP_DRINK"] ) then
				return ArkInventory.CategoryGetSystemID( "CONSUMABLE_DRINK" )
			end
			
			if ArkInventory.PT_ItemInSets( i.h, ArkInventory.Localise["PT_CATEGORY_CONSUMABLE_FOOD"] ) then
				return ArkInventory.CategoryGetSystemID( "CONSUMABLE_FOOD" )
			end
			
			if ArkInventory.PT_ItemInSets( i.h, ArkInventory.Localise["PT_CATEGORY_CONSUMABLE_DRINK"] ) then
				return ArkInventory.CategoryGetSystemID( "CONSUMABLE_DRINK" )
			end
			
			return ArkInventory.CategoryGetSystemID( "CONSUMABLE_FOOD_AND_DRINK" )
			
		end
		
		if info.itemsubtypeid == ArkInventory.Const.ItemClass.CONSUMABLE_POTION then
			
			if ArkInventory.TooltipContains( ArkInventory.Global.Tooltip.Scan, ArkInventory.Localise["WOW_ITEM_TOOLTIP_POTION_HEAL"] ) or ArkInventory.PT_ItemInSets( i.h, ArkInventory.Localise["PT_CATEGORY_POTION_HEAL"] ) then
				return ArkInventory.CategoryGetSystemID( "CONSUMABLE_POTION_HEAL" )
			end
			
			if ArkInventory.TooltipContains( ArkInventory.Global.Tooltip.Scan, ArkInventory.Localise["WOW_ITEM_TOOLTIP_POTION_MANA"] ) or ArkInventory.PT_ItemInSets( i.h, ArkInventory.Localise["PT_CATEGORY_POTION_MANA"] ) then
				return ArkInventory.CategoryGetSystemID( "CONSUMABLE_POTION_MANA" )
			end
			
			return ArkInventory.CategoryGetSystemID( "CONSUMABLE_POTION" )
			
		end
		
		if info.itemsubtypeid == ArkInventory.Const.ItemClass.CONSUMABLE_ELIXIR then
			
			if ArkInventory.TooltipContains( ArkInventory.Global.Tooltip.Scan, ArkInventory.Localise["WOW_ITEM_TOOLTIP_ELIXIR_BATTLE"] ) then
				return ArkInventory.CategoryGetSystemID( "CONSUMABLE_ELIXIR_BATTLE" )
			end
			
			if ArkInventory.TooltipContains( ArkInventory.Global.Tooltip.Scan, ArkInventory.Localise["WOW_ITEM_TOOLTIP_ELIXIR_GUARDIAN"] ) then
				return ArkInventory.CategoryGetSystemID( "CONSUMABLE_ELIXIR_GUARDIAN" )
			end
			
			return ArkInventory.CategoryGetSystemID( "CONSUMABLE_ELIXIR" )
			
		end
		
		if info.itemsubtypeid == ArkInventory.Const.ItemClass.CONSUMABLE_FLASK then
			return ArkInventory.CategoryGetSystemID( "CONSUMABLE_FLASK" )
		end
		
		if info.itemsubtypeid == ArkInventory.Const.ItemClass.CONSUMABLE_BANDAGE then
			return ArkInventory.CategoryGetSystemID( "CONSUMABLE_BANDAGE" )
		end
		
		if info.itemsubtypeid == ArkInventory.Const.ItemClass.CONSUMABLE_EXPLOSIVES_AND_DEVICES then
			return ArkInventory.CategoryGetSystemID( "CONSUMABLE_EXPLOSIVES_AND_DEVICES" )
		end
		
		if info.itemsubtypeid == ArkInventory.Const.ItemClass.CONSUMABLE_OTHER then
			
			if ArkInventory.TooltipContains( ArkInventory.Global.Tooltip.Scan, ArkInventory.Localise["BATTLEPET"] ) then
				if i.sb == ArkInventory.Const.Bind.Pickup or i.sb == ArkInventory.Const.Bind.Account then
					return ArkInventory.CategoryGetSystemID( "SYSTEM_PET_COMPANION_BOUND" )
				else
					return ArkInventory.CategoryGetSystemID( "SYSTEM_PET_COMPANION_TRADE" )
				end
			end
			
		end
		
	end
	
	
	-- primary professions
	if codex.player.data.info.skills then
		
		local _, _, req = ArkInventory.TooltipFind( ArkInventory.Global.Tooltip.Scan, ArkInventory.Localise["WOW_TOOLTIP_REQUIRES_SKILL"], false, true, true, 0, true )
		
		for x = 1, ArkInventory.Const.Skills.Primary do
			
			if codex.player.data.info.skills[x] then
				
				local skill = ArkInventory.Const.Skills.Data[codex.player.data.info.skills[x]]
				
				if skill then
					
					if ArkInventory.PT_ItemInSets( i.h, skill.pt ) then
						return ArkInventory.CategoryGetSystemID( skill.id )
					end
					
					if req and string.find( req, skill.text ) then
						return ArkInventory.CategoryGetSystemID( skill.id )
					end
					
				end
				
			end
			
		end
		
	end
	
	
	-- crafting reagents
	if info.craft then
		return ArkInventory.CategoryGetSystemID( "SYSTEM_CRAFTING_REAGENT" )
		--return ArkInventory.CategoryGetSystemID( "SYSTEM_REAGENT" )
	end
	
	
	-- misc
	if info.itemtypeid == ArkInventory.Const.ItemClass.MISC then
		
		if info.itemsubtypeid == ArkInventory.Const.ItemClass.MISC_REAGENT then
			return ArkInventory.CategoryGetSystemID( "SYSTEM_REAGENT" )
		end
		
		if info.itemsubtypeid == ArkInventory.Const.ItemClass.MISC_OTHER then
			
			if ArkInventory.TooltipContains( ArkInventory.Global.Tooltip.Scan, ArkInventory.Localise["BATTLEPET"] ) then
				if i.sb == ArkInventory.Const.Bind.Pickup or i.sb == ArkInventory.Const.Bind.Account then
					return ArkInventory.CategoryGetSystemID( "SYSTEM_PET_COMPANION_BOUND" )
				else
					return ArkInventory.CategoryGetSystemID( "SYSTEM_PET_COMPANION_TRADE" )
				end
			end
			
		end

	end
	
	if info.itemtypeid == ArkInventory.Const.ItemClass.TRADEGOODS then
		
		if info.itemsubtypeid == ArkInventory.Const.ItemClass.TRADEGOODS_PARTS then
			return ArkInventory.CategoryGetSystemID( "TRADEGOODS_PARTS" )
		end
		
	end
	
	-- archeology
	if ArkInventory.PT_ItemInSets( i.h, ArkInventory.Const.Skills.Data[794].pt ) then
		return ArkInventory.CategoryGetSystemID( ArkInventory.Const.Skills.Data[794].id )
	end
	
	-- quest items (via tooltip)
	if ArkInventory.TooltipContains( ArkInventory.Global.Tooltip.Scan, ITEM_BIND_QUEST, false, true, true ) then
		return ArkInventory.CategoryGetSystemID( "SYSTEM_QUEST" )
	end
	
	-- quest items (via PT)
	if ArkInventory.PT_ItemInSets( i.h, ArkInventory.Localise["PT_CATEGORY_QUEST"] ) then
		return ArkInventory.CategoryGetSystemID( "SYSTEM_QUEST" )
	end
	
	-- reputation (via PT)
	if ArkInventory.PT_ItemInSets( i.h, ArkInventory.Localise["PT_CATEGORY_REPUTATION"] ) then
		return ArkInventory.CategoryGetSystemID( "SYSTEM_REPUTATION" )
	end
	
	
	
	-- left overs
	
	if i.sb == ArkInventory.Const.Bind.Pickup or i.sb == ArkInventory.Const.Bind.Account then
		return ArkInventory.CategoryGetSystemID( "SYSTEM_SOULBOUND" )
	end
	
	if info.itemtypeid == ArkInventory.Const.ItemClass.TRADEGOODS then
		return ArkInventory.CategoryGetSystemID( "TRADEGOODS_OTHER" )
	end

	if info.itemtypeid == ArkInventory.Const.ItemClass.CONSUMABLE then
		return ArkInventory.CategoryGetSystemID( "CONSUMABLE_OTHER" )
	end

	if info.itemtypeid == ArkInventory.Const.ItemClass.MISC then
		return ArkInventory.CategoryGetSystemID( "SYSTEM_MISC" )
	end

	if info.itemtypeid == ArkInventory.Const.ItemClass.REAGENT then
		return ArkInventory.CategoryGetSystemID( "SYSTEM_REAGENT" )
	end
	
	
	return ArkInventory.CategoryGetSystemID( "SYSTEM_DEFAULT" )
	
end

function ArkInventory.ItemCategoryGetDefaultEmpty( loc_id, bag_id )
	
	local codex = ArkInventory.GetLocationCodex( loc_id )
	local clump = codex.style.slot.empty.clump
	
	local blizzard_id = ArkInventory.InternalIdToBlizzardBagId( loc_id, bag_id )
	local bt = ArkInventory.BagType( blizzard_id )
	
	--ArkInventory.Output( "loc[", loc_id, "] bag[", bag_id, " / ", blizzard_id, "] type[", bt, "]" )
	
	if bt == ArkInventory.Const.Slot.Type.Bag then
		if clump then
			return ArkInventory.CategoryGetSystemID( "EMPTY" )
		else
			return ArkInventory.CategoryGetSystemID( "EMPTY_BAG" )
		end
	end
	
	if bt == ArkInventory.Const.Slot.Type.Enchanting then
		if clump then
			return ArkInventory.CategoryGetSystemID( "SKILL_ENCHANTING" )
		else
			return ArkInventory.CategoryGetSystemID( "EMPTY_ENCHANTING" )
		end
	end
	
	if bt == ArkInventory.Const.Slot.Type.Engineering then
		if clump then
			return ArkInventory.CategoryGetSystemID( "SKILL_ENGINEERING" )
		else
			return ArkInventory.CategoryGetSystemID( "EMPTY_ENGINEERING" )
		end
	end
	
	if bt == ArkInventory.Const.Slot.Type.Gem then
		if clump then
			return ArkInventory.CategoryGetSystemID( "SKILL_JEWELCRAFTING" )
		else
			return ArkInventory.CategoryGetSystemID( "EMPTY_GEM" )
		end
	end
	
	if bt == ArkInventory.Const.Slot.Type.Herb then
		if clump then
			return ArkInventory.CategoryGetSystemID( "SKILL_HERBALISM" )
		else
			return ArkInventory.CategoryGetSystemID( "EMPTY_HERB" )
		end
	end
	
	if bt == ArkInventory.Const.Slot.Type.Inscription then
		if clump then
			return ArkInventory.CategoryGetSystemID( "SKILL_INSCRIPTION" )
		else
			return ArkInventory.CategoryGetSystemID( "EMPTY_INSCRIPTION" )
		end
	end

	if bt == ArkInventory.Const.Slot.Type.Leatherworking then
		if clump then
			return ArkInventory.CategoryGetSystemID( "SKILL_LEATHERWORKING" )
		else
			return ArkInventory.CategoryGetSystemID( "EMPTY_LEATHERWORKING" )
		end
	end

	if bt == ArkInventory.Const.Slot.Type.Mining then
		if clump then
			return ArkInventory.CategoryGetSystemID( "SKILL_MINING" )
		else
			return ArkInventory.CategoryGetSystemID( "EMPTY_MINING" )
		end
	end
	
	if bt == ArkInventory.Const.Slot.Type.Tackle then
		if clump then
			return ArkInventory.CategoryGetSystemID( "SKILL_FISHING" )
		else
			return ArkInventory.CategoryGetSystemID( "EMPTY_TACKLE" )
		end
	end
	
	if bt == ArkInventory.Const.Slot.Type.Cooking then
		if clump then
			return ArkInventory.CategoryGetSystemID( "SKILL_COOKING" )
		else
			return ArkInventory.CategoryGetSystemID( "EMPTY_COOKING" )
		end
	end
	
	if bt == ArkInventory.Const.Slot.Type.ReagentBank then
		if clump then
			return ArkInventory.CategoryGetSystemID( "EMPTY" )
		else
			return ArkInventory.CategoryGetSystemID( "EMPTY_REAGENTBANK" )
		end
	end
	
	if clump then
		return ArkInventory.CategoryGetSystemID( "EMPTY" )
	else
		return ArkInventory.CategoryGetSystemID( "EMPTY_UNKNOWN" )
	end
	
	ArkInventory.Output( "code failure, should never get here" )
	
end

function ArkInventory.ItemCategoryGetDefault( i )
	
	-- items cache id
	local cid = ArkInventory.ObjectIDCategory( i )
	
	if ArkInventory.TranslationsLoaded then
		
		if ArkInventory.db.cache.default[cid] then
			
			-- if the value has been cached then use it
			return ArkInventory.db.cache.default[cid]
			
		else
			
			local cat
			
			if i.h then
				
				cat = ArkInventory.ItemCategoryGetDefaultActual( i )
				
				if cat ~= ArkInventory.CategoryGetSystemID( "SYSTEM_UNKNOWN" ) then
					ArkInventory.db.cache.default[cid] = cat
				end
				
			else
				
				cat = ArkInventory.ItemCategoryGetDefaultEmpty( i.loc_id, i.bag_id )
				
				if cat ~= ArkInventory.CategoryGetSystemID( "EMPTY_UNKNOWN" ) then
					ArkInventory.db.cache.default[cid] = cat
				end
				
			end
			
			return cat
			
		end
		
	else
		
		return ArkInventory.CategoryGetSystemID( "SYSTEM_UNKNOWN" )
		
	end
	
end


function ArkInventory.ItemCategoryGetRule( i )
	
	-- local debuginfo = { ["m"]=gcinfo( ), ["t"]=GetTime( ) }
	
	if not ArkInventory.Global.Rules.Enabled then
		return false
	end
	
	return ArkInventoryRules.AppliesToItem( i )
	
	-- ArkInventory.Output( "ItemCategoryGetRule( ) end", debuginfo )
	
end

function ArkInventory.ItemCategoryGetPrimary( i )
	
	if i.h then -- only items can have a category, empty slots can only be used by rules
		
		-- items category cache id
		local cid, id, codex = ArkInventory.ObjectIDCategory( i )
		
		local cat_id = codex.catset.category.assign[id]
		if cat_id then
			-- manually assigned item to a category?
			local cat_type, cat_code = ArkInventory.CategoryCodeSplit( cat_id )
			if cat_type == 1 then
				return cat_id
			elseif codex.catset.category.active[cat_type][cat_code] then -- category is active in this categoryset?
				if ArkInventory.db.option.category[cat_type].data[cat_code].used == "Y" then -- category is enabled?
					return cat_id
				end
			end
		end
		
	end
	
	if ArkInventory.Global.Rules.Enabled then
		
		-- items rule cache id
		local cid = ArkInventory.ObjectIDRule( i )
		
		-- if the value has already been cached then use it
		if ArkInventory.db.cache.rule[cid] == nil then
			-- check for any rule that applies to the item, cache the result, use false for no match (default)
			ArkInventory.db.cache.rule[cid] = ArkInventory.ItemCategoryGetRule( i )
		end
		
		return ArkInventory.db.cache.rule[cid]
		
	end
	
	return false
	
end

function ArkInventory.ItemCategorySet( i, cat_id )
	
	-- set cat_id to nil to reset back to default
	
	local cid, id, codex = ArkInventory.ObjectIDCategory( i )
	--ArkInventory.Output( cid, " / ", id, " / ", cat_id, " / ", codex.player.data.info.name )
	codex.catset.category.assign[id] = cat_id
	
end

function ArkInventory.ItemCategoryGet( i )
	
	local unknown = ArkInventory.CategoryGetSystemID( "SYSTEM_UNKNOWN" )
	
	local default = ArkInventory.CategoryGetSystemID( "SYSTEM_DEFAULT" )
	default = ( i and ArkInventory.ItemCategoryGetDefault( i ) ) or default
	
	local cat = ArkInventory.ItemCategoryGetPrimary( i )
	
	return cat or default or unknown, cat, default or unknown
	
end

function ArkInventory.ReverseName( n )
	
	if n and type( n ) == "string" then
		
		local s = { }
		
		for w in string.gmatch( n, "%S+" ) do
			table.insert( s, 1, w )
		end
		
		return table.concat( s, " " )
		
	end
	
end

function ArkInventory.ItemCacheClear( h )
	
	--ArkInventory.Output( "ItemCacheClear( )" )
	
	if not h then
		
		--ArkInventory.Output( "clearing cache - all" )
		
		ArkInventory.Table.Clean( ArkInventory.db.cache.rule )
		ArkInventory.Table.Clean( ArkInventory.db.cache.default )
		
	else
		
		local cid
		local i = { h = h }
		
		--ArkInventory.Output( "clearing cache - ", h )
		
		for loc_id, loc_data in pairs( ArkInventory.Global.Location ) do
			i.loc_id = loc_id
			for bag_id in pairs( ArkInventory.Global.Location[loc_id].Bags ) do
				i.bag_id = bag_id
				for k, v in ipairs( ArkInventory.Const.Bind ) do
					
					i.sb = v
					
					cid = ArkInventory.ObjectIDRule( i )
					ArkInventory.db.cache.rule[cid] = nil
					
					cid = ArkInventory.ObjectIDCategory( i )
					ArkInventory.db.cache.default[cid] = nil
					
				end
			end
		end
		
	end
	
	ArkInventory.CategoryGenerate( )
	--ArkInventory.OutputWarning( "ItemCacheClear - .Recalculate" )
	ArkInventory.Frame_Main_DrawStatus( nil, ArkInventory.Const.Window.Draw.Recalculate )
	
end

function ArkInventory.Frame_Main_DrawStatus( loc_id, level )
	
	local level = level or ArkInventory.Const.Window.Draw.None
	
	if ArkInventory.Global.Location[loc_id] and ArkInventory.Global.Location[loc_id].canView then
		if level < ArkInventory.Global.Location[loc_id].drawState then
			ArkInventory.Global.Location[loc_id].drawState = level
		end
	end
	
end

function ArkInventory.Frame_Main_Generate( location, drawstatus )
	
--	if drawstatus and drawstatus < 4 then
--		ArkInventory.OutputWarning( "Frame_Main_Generate( ", location, ", ", drawstatus, " )" )
--	end
	
	for loc_id, loc_data in pairs( ArkInventory.Global.Location ) do
		if loc_data.canView and ( not location or loc_id == location ) then
			ArkInventory.Frame_Main_DrawStatus( loc_id, drawstatus )
			ArkInventory.Frame_Main_DrawLocation( loc_id )
		end
	end
	
end

function ArkInventory.Frame_Main_DrawLocation( loc_id )
	local frame = ArkInventory.Frame_Main_Get( loc_id )
	ArkInventory.Frame_Main_Draw( frame )
end

function ArkInventory.PutItemInBank( )
	
	-- item dropped on bank "bag"
	
	if CursorHasItem( ) then
		
		for x = 1, GetContainerNumSlots( BANK_CONTAINER ) do
			h = GetContainerItemLink( BANK_CONTAINER, x )
			if not h then
				if not PickupContainerItem( BANK_CONTAINER, x ) then
					ClearCursor( )
				end
				return
			end
		end
		
		UIErrorsFrame:AddMessage( ERR_BAG_FULL, 1.0, 0.1, 0.1, 1.0 )
		ClearCursor( )
		
	end
	
end

function ArkInventory.PutItemInReagentBank( )
	
	-- item dropped on reagentbank "bag"
	
	if CursorHasItem( ) then
		
		for x = 1, GetContainerNumSlots( REAGENTBANK_CONTAINER ) do
			h = GetContainerItemLink( REAGENTBANK_CONTAINER, x )
			if not h then
				if not PickupContainerItem( REAGENTBANK_CONTAINER, x ) then
					ClearCursor( )
				end
				return
			end
		end
		
		UIErrorsFrame:AddMessage( ERR_BAG_FULL, 1.0, 0.1, 0.1, 1.0 )
		ClearCursor( )
		
	end
	
end

function ArkInventory.PutItemInGuildBank( tab_id )
	
	local ctab = GetCurrentGuildBankTab( )
	local tab_id = tab_id or ctab
	
	if CursorHasItem( ) then
		
		local loc_id = ArkInventory.Const.Location.Vault
		local _, _, _, canDeposit = GetGuildBankTabInfo( tab_id )

		if canDeposit then
		
			--ArkInventory.Output( "PutItemInGuildBank( ", tab_id, " )" )
			
			if tab_id ~= ctab then
				SetCurrentGuildBankTab( tab_id )
				ArkInventory.QueryVault( tab_id )
			end

			for x = 1, MAX_GUILDBANK_SLOTS_PER_TAB do
				h = GetGuildBankItemLink( tab_id, x )
				if not h then
					if not PickupGuildBankItem( tab_id, x ) then --AutoStoreGuildBankItem
						ClearCursor( )
					end
					return
				end
			end
			
			UIErrorsFrame:AddMessage( ERR_BAG_FULL, 1.0, 0.1, 0.1, 1.0 )
			ClearCursor( )
			
		end
		
	end
	
end

function ArkInventory.SetItemButtonStock( frame, count, status )
	
	-- used to show the number of empty slots on bags in the changer window
	
	if not frame then
		return
	end
	
	local obj = _G[string.format( "%s%s", frame:GetName( ), "Stock" )]
	if not obj then
		return
	end
	
	local count = count or 0
	
	local loc_id = frame.ARK_Data.loc_id
	
	local codex = ArkInventory.GetLocationCodex( loc_id )
	
	if codex.style.changer.freespace.show then
		
		if status then
			
			if status == ArkInventory.Const.Bag.Status.Purchase then
				obj:SetText( ArkInventory.Localise["STATUS_PURCHASE"] )
			elseif status == ArkInventory.Const.Bag.Status.Unknown then
				obj:SetText( ArkInventory.Localise["STATUS_NO_DATA"] )
			elseif status == ArkInventory.Const.Bag.Status.NoAccess then
				obj:SetText( ArkInventory.Localise["VAULT_TAB_ACCESS_NONE"] )
			else
				obj:SetText( "" )
			end
			
		else
			
			if count > 0 then
				obj:SetText( count )
				obj.numInStock = count
			else
				obj:SetText( ArkInventory.Localise["FULL"] )
				obj.numInStock = 0
			end
			
		end
		
		local colour = codex.style.changer.freespace.colour
		obj:SetTextColor( colour.r, colour.g, colour.b )
		
		obj:Show( )
		
	else
		
		obj:SetText( "" )
		obj.numInStock = 0
		obj:Hide( )
		
	end
	
end

function ArkInventory.ValidFrame( frame, visible, db )
	
	if frame and frame.ARK_Data and frame.ARK_Data.loc_id then
		return true
	end
	
--[[
	if frame and frame.ARK_Data and frame.ARK_Data.loc_id then
		
		local r1 = true
		if db then
			local i = ArkInventory.Frame_Item_GetDB( frame )
			if i == nil then
				r1 = false
			end
		end
		
		local r2 = true
		if visible and not frame:IsVisible( ) then
			r2 = false
		end

		return r1 and r2
		
	end
	
	return false
]]--
	
end

function ArkInventory.Frame_Main_Get( loc_id )
	
	local framename = string.format( "%s%s", ArkInventory.Const.Frame.Main.Name, loc_id )
	local frame = _G[framename]
	assert( frame, string.format( "xml element '%s' could not be found",  framename ) )
	
	return frame
	
end
	
function ArkInventory.Frame_Main_Scale( loc_id )
	
	local frame = ArkInventory.Frame_Main_Get( loc_id )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local loc_id = frame.ARK_Data.loc_id
	
	local codex = ArkInventory.GetLocationCodex( loc_id )
	
	local old_scale = frame:GetScale( )
	local new_scale = codex.style.window.scale
	
	if old_scale ~= new_scale then
		frame:SetScale( new_scale )
	end
	
	if ArkInventory.Global.Location[loc_id].drawState <= ArkInventory.Const.Window.Draw.Init then
		
		old_scale = nil
		
		if ArkInventory.db.option.auto.reposition then
			ArkInventory.Frame_Main_Reposition( loc_id )
		end
		
	end
	
	ArkInventory.Frame_Main_Anchor_Set( loc_id, old_scale )
	
end
	
function ArkInventory.Frame_Main_Scale_All( )
	for loc_id, loc_data in pairs( ArkInventory.Global.Location ) do
		if loc_data.canView then
			ArkInventory.Frame_Main_Scale( loc_id )
		end
	end
end

function ArkInventory.Frame_Main_Reposition( loc_id )
	
	local frame = ArkInventory.Frame_Main_Get( loc_id )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	if not frame.ARK_Data.loaded then
		--ArkInventory.Output( "cant reposition ", frame:GetName( ), " until its been built, the frame has no size" )
		--return
	end
	
	local codex = ArkInventory.GetLocationCodex( loc_id )
	local f_scale = frame:GetScale( )
	local a, x
	
	a = codex.profile.location[loc_id].anchor.t
	x = UIParent:GetTop( ) / f_scale
	if not a or a > x then
		--ArkInventory.Output( loc_id, " top = ", a, " / ", x )
		codex.profile.location[loc_id].anchor.t = x
		codex.profile.location[loc_id].anchor.b = x - frame:GetHeight( )
	end
	
	a = codex.profile.location[loc_id].anchor.b
	x = UIParent:GetBottom( ) / f_scale
	if not a or a < x then
		--ArkInventory.Output( loc_id, " bottom = ", a, " / ", x )
		codex.profile.location[loc_id].anchor.b = x
		codex.profile.location[loc_id].anchor.t = x + frame:GetHeight( )
	end
	
	a = codex.profile.location[loc_id].anchor.r
	x = UIParent:GetRight( ) / f_scale
	if not a or a > x then
		--ArkInventory.Output( loc_id, " right = ", a, " / ", x )
		codex.profile.location[loc_id].anchor.r = x
		codex.profile.location[loc_id].anchor.l = x - frame:GetWidth( )
	end
	
	a = codex.profile.location[loc_id].anchor.l
	x = UIParent:GetLeft( ) / f_scale
	if not a or a < x then
		--ArkInventory.Output( loc_id, " left = ", a, " / ", x )
		codex.profile.location[loc_id].anchor.l = x
		codex.profile.location[loc_id].anchor.r = x + frame:GetWidth( )
	end
	
	ArkInventory.Frame_Main_Anchor_Set( loc_id )
	
end

function ArkInventory.Frame_Main_Reposition_All( )
	for loc_id, loc_data in pairs( ArkInventory.Global.Location ) do
		if loc_data.canView then
			ArkInventory.Frame_Main_Reposition( loc_id )
		end
	end
end


function ArkInventory.Frame_Main_Offline( frame )
	
	local loc_id = frame.ARK_Data.loc_id
	local me = ArkInventory.GetPlayerCodex( )
	local codex = ArkInventory.GetLocationCodex( loc_id )
	
	--ArkInventory.Output( "loc_playerid=[", ArkInventory.Global.Location[loc_id].player_id, "] player_id=[", codex.player.data.info.player_id, "] guild_id=[", codex.player.data.info.guild_id, "]" )
	
	if codex.player.current == me.player.data.info.player_id or codex.player.current == me.player.data.info.guild_id or ArkInventory.Global.Location[loc_id].isAccount then
		
		ArkInventory.Global.Location[loc_id].isOffline = false
		
		if loc_id == ArkInventory.Const.Location.Bank and ArkInventory.Global.Mode.Bank == false then
			ArkInventory.Global.Location[loc_id].isOffline = true
		end
		
		if loc_id == ArkInventory.Const.Location.Vault and ArkInventory.Global.Mode.Vault == false then
			ArkInventory.Global.Location[loc_id].isOffline = true
		end
		
		if loc_id == ArkInventory.Const.Location.Mail and ArkInventory.Global.Mode.Mail == false then
			ArkInventory.Global.Location[loc_id].isOffline = true
		end
		
		if loc_id == ArkInventory.Const.Location.Void and ArkInventory.Global.Mode.Void == false then
			ArkInventory.Global.Location[loc_id].isOffline = true
		end
		
	else
		
		ArkInventory.Global.Location[loc_id].isOffline = true
		
	end
	
end

function ArkInventory.Frame_Main_Anchor_Save( frame )
	
	if not ArkInventory.ValidFrame( frame, true ) then return end
	
	local loc_id = frame.ARK_Data.loc_id
	local codex = ArkInventory.GetLocationCodex( loc_id )
	
	codex.profile.location[loc_id].anchor.t = frame:GetTop( )
	codex.profile.location[loc_id].anchor.b = frame:GetBottom( )
	codex.profile.location[loc_id].anchor.l = frame:GetLeft( )
	codex.profile.location[loc_id].anchor.r = frame:GetRight( )
	
end

function ArkInventory.Frame_Main_Anchor_Set( loc_id, old_scale )
	
	local frame = ArkInventory.Frame_Main_Get( loc_id )
	local codex = ArkInventory.GetLocationCodex( loc_id )
	local anchor = codex.profile.location[loc_id].anchor.point
	
	local f_scale = frame:GetScale( )
	local p_scale = UIParent:GetScale( )
	
	local t = codex.profile.location[loc_id].anchor.t
	if not t then
		t = UIParent:GetTop( ) / f_scale
	elseif old_scale then
		t = t / f_scale * old_scale
	end
	
	local b = codex.profile.location[loc_id].anchor.b
	if not b then
		b = UIParent:GetBottom( ) / f_scale
	elseif old_scale then
		b = b / f_scale * old_scale
	end
	
	local l = codex.profile.location[loc_id].anchor.l
	if not l then
		l = UIParent:GetLeft( ) / f_scale
	elseif old_scale then
		l = l / f_scale * old_scale
	end
	
	local r = codex.profile.location[loc_id].anchor.r
	if not r then
		r = UIParent:GetRight( ) / f_scale
	elseif old_scale then
		r = r / f_scale * old_scale
	end
	
	local h = l + ( ( r - l ) / 2 )
	local v = b + ( ( t - b ) / 2 )
	
	frame:ClearAllPoints( )
	if anchor == ArkInventory.Const.Anchor.BottomRight then
		frame:SetPoint( "BOTTOMRIGHT", nil, "BOTTOMLEFT", r, b )
	elseif anchor == ArkInventory.Const.Anchor.BottomLeft then
		frame:SetPoint( "BOTTOMLEFT", nil, "BOTTOMLEFT", l, b )
	elseif anchor == ArkInventory.Const.Anchor.TopLeft then
		frame:SetPoint( "TOPLEFT", nil, "BOTTOMLEFT", l, t )
	elseif anchor == ArkInventory.Const.Anchor.Top then
		frame:SetPoint( "TOP", nil, "BOTTOMLEFT", h, t )
	elseif anchor == ArkInventory.Const.Anchor.Bottom then
		frame:SetPoint( "BOTTOM", nil, "BOTTOMLEFT", h, b )
	elseif anchor == ArkInventory.Const.Anchor.Left then
		frame:SetPoint( "LEFT", nil, "BOTTOMLEFT", l, v )
	elseif anchor == ArkInventory.Const.Anchor.Right then
		frame:SetPoint( "RIGHT", nil, "BOTTOMLEFT", r, v )
	else
		frame:SetPoint( "TOPRIGHT", nil, "BOTTOMLEFT", r, t )
	end
	
	if codex.profile.location[loc_id].anchor.locked then
		frame:RegisterForDrag( )
	else
		frame:RegisterForDrag( "LeftButton" )
	end
	
	ArkInventory.Frame_Main_Anchor_Save( frame )
	
end

function ArkInventory.Frame_Main_Paint( frame )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local loc_id = frame.ARK_Data.loc_id
	local codex = ArkInventory.GetLocationCodex( loc_id )
	
	for _, z in pairs( { frame:GetChildren( ) } ) do
		
		local framename = z:GetName( )
		if framename then -- only process objects with a name (other addons can add frames without names, we don't want to deal with them)
			
			-- background
			local obj = _G[string.format( "%s%s", framename, "Background" )]
			if obj then
				local background = codex.style.window.background.style or ArkInventory.Const.Texture.BackgroundDefault
				if background == ArkInventory.Const.Texture.BackgroundDefault then
					local colour = codex.style.window.background.colour
					ArkInventory.SetTexture( obj, true, colour.r, colour.g, colour.b, colour.a )
				else
					local file = ArkInventory.Lib.SharedMedia:Fetch( ArkInventory.Lib.SharedMedia.MediaType.BACKGROUND, background )
					ArkInventory.SetTexture( obj, file )
				end
			end
			
			-- border
			--local obj = _G[string.format( "%s%s", framename, "ArkBorder" )]
			local obj = z.ArkBorder
			if obj then
				
				if codex.style.window.border.style == ArkInventory.Const.Texture.BorderNone then
					
					obj:Hide( )
					
				else
					
					local border = codex.style.window.border.style or ArkInventory.Const.Texture.BorderDefault
					local file = ArkInventory.Lib.SharedMedia:Fetch( ArkInventory.Lib.SharedMedia.MediaType.BORDER, border )
					local size = codex.style.window.border.size or ArkInventory.Const.Texture.Border[ArkInventory.Const.Texture.BorderDefault].size
					local offset = codex.style.window.border.offset or ArkInventory.Const.Texture.Border[ArkInventory.Const.Texture.BorderDefault].offsetdefault.window
					local scale = codex.style.window.border.scale or 1
					local colour = codex.style.window.border.colour
					ArkInventory.Frame_Border_Paint( obj, file, size, offset, scale, colour.r, colour.g, colour.b, 1 )
					
					obj:Show( )
					
				end
				
			end
			
		end
		
	end
	
end

function ArkInventory.Frame_Main_Paint_All( )
	
	for loc_id, loc_data in pairs( ArkInventory.Global.Location ) do
		if loc_data.canView then
			local frame = ArkInventory.Frame_Main_Get( loc_id )
			ArkInventory.Frame_Main_Paint( frame )
		end
	end
	
end

function ArkInventory.Frame_Border_Paint( obj, file, size, offset, scale, r, g, b, a )
	
	if not obj then return end
	
	local edgeSize = ( size or 1 ) * ( scale or 1 )
	local info = obj:GetBackdrop( )
	if not info or info.edgeFile ~= file then
		obj:SetBackdrop( { edgeFile = file, edgeSize = edgeSize } )
	end
	obj:SetBackdropBorderColor( r or 0, g or 0, b or 0, a or 1 )
	
	local parent = obj:GetParent( )
	local offset = ( offset or 0 ) * ( scale or 1 )
	
	obj:ClearAllPoints( )
	obj:SetPoint( "TOPLEFT", parent, 0 - offset, offset )
	obj:SetPoint( "BOTTOMRIGHT", parent, offset, 0 - offset )
	
end

function ArkInventory.Frame_Main_Resize( frame )
	
	--ArkInventory.Output( "Frame_Main_Resize" )
	
	if not ArkInventory.ValidFrame( frame, true ) then return end
	
	local loc_id = frame.ARK_Data.loc_id
	local codex = ArkInventory.GetLocationCodex( loc_id )
	
	local width = codex.profile.location[loc_id].container.width
	local height = codex.profile.location[loc_id].container.height
	
	local f1 = _G[string.format( "%s%s", frame:GetName( ), ArkInventory.Const.Frame.Title.Name )]
	if not codex.style.title.hide then
		height = height + f1:GetHeight( )
	end
	
	local f2 = _G[string.format( "%s%s", frame:GetName( ), ArkInventory.Const.Frame.Search.Name )]
	if not codex.style.search.hide then
		height = height + f2:GetHeight( )
	end
	
	local f5 = _G[string.format( "%s%s", frame:GetName( ), ArkInventory.Const.Frame.Status.Name )]
	if not codex.style.status.hide then
		height = height + f5:GetHeight( )
	end
	
	local f4 = _G[string.format( "%s%s", frame:GetName( ), ArkInventory.Const.Frame.Changer.Name )]
	if not codex.style.changer.hide then
		height = height + f4:GetHeight( )
	end
	
--	local f3 = _G[string.format( "%s%s", frame:GetName( ), ArkInventory.Const.Frame.Scroll.Name )]
	
	
	-- set the size of the window
	frame:SetWidth( width )
	frame:SetHeight( height )
	
	--ArkInventory.Output( string.format( "set window %i size %i x %i", loc_id, width, height ) )
	
	ArkInventory.Frame_Main_Scale( loc_id )
	
end

function ArkInventory.Frame_Main_Update_Cooldown( loc_id )
	
	if loc_id and ArkInventory.Global.Location[loc_id] and not ArkInventory.Global.Location[loc_id].isOffline then
		
		--ArkInventory.Output( "Frame_Main_Update_Cooldown( ", loc_id, " )" )
		
		for bag_id in pairs( ArkInventory.Global.Location[loc_id].Bags ) do
			for slot_id = 1, ArkInventory.Global.Location[loc_id].maxSlot[bag_id] or 0 do
				
				local objname, obj = ArkInventory.ContainerItemNameGet( loc_id, bag_id, slot_id )
				ArkInventory.Frame_Item_Update_Cooldown( obj )
				
			end
		end
		
	end
	
end

function ArkInventory.Frame_Main_Draw( frame )
	
	local loc_id = frame.ARK_Data.loc_id
	local thread_id = string.format( ArkInventory.Global.Thread.Format.Window, loc_id )
	
	if not frame:IsVisible( ) then
		ArkInventory.OutputThread( thread_id, " aborting, not visible" )
		return
	end
	
	if not ArkInventory.Global.Thread.Use then
		local tz = debugprofilestop( )
		ArkInventory.OutputThread( thread_id, " starting" )
		ArkInventory.Frame_Main_Draw_Threaded( frame )
		tz = debugprofilestop( ) - tz
		ArkInventory.OutputThread( string.format( "%s dead after %0.0fms", thread_id, tz ) )
		return
	end
	
	if ArkInventory.ThreadRunning( thread_id ) then
		
		-- already in progress, find highest drawstate and start again
		
		--ArkInventory.Output( "draw", " [", loc_id, "] existing thread, old=", ArkInventory.Global.Thread.WindowState[loc_id], ", new=", ArkInventory.Global.Location[loc_id].drawState )
		
		if ArkInventory.Global.Thread.WindowState[loc_id] >= ArkInventory.Global.Location[loc_id].drawState then
			ArkInventory.Global.Thread.WindowState[loc_id] = ArkInventory.Global.Location[loc_id].drawState
		end
		
	else
		
		-- nothing in progress so just kick it off
		
		--ArkInventory.Output( "draw [", loc_id, "] new thread, state=", ArkInventory.Global.Location[loc_id].drawState )
		
		ArkInventory.Global.Thread.WindowState[loc_id] = ArkInventory.Global.Location[loc_id].drawState
		
	end
	
	-- load the co-routine, overwite existing, the garbage collector will sort it out
	local tf = function ( )
		ArkInventory.Frame_Main_Draw_Threaded( frame )
	end
	
	ArkInventory.ThreadStart( thread_id, tf )
	
	--ArkInventory.Output( "draw location ", loc_id, " complete" )
	
end

function ArkInventory.Frame_Main_Draw_Threaded( frame )
	
	local loc_id = frame.ARK_Data.loc_id
	--ArkInventory.Output( "Frame_Main_Draw_Threaded( ", frame:GetName( ), " ) drawstate[", ArkInventory.Global.Location[loc_id].drawState, "]" ) --, framelevel[", frame:GetFrameLevel( ), "]" )
	
	if not ArkInventory.Global.Location[loc_id].canView then
		-- not a controllable window (for scanning only)
		-- shouldnt ever get here, but just in case
		frame:Hide( )
		return
	end
	
	local codex = ArkInventory.GetLocationCodex( loc_id )
	--ArkInventory.Output( "draw = ", loc_id, " / ", codex.player.data.info.player_id )
	
	ArkInventory.ThreadYield_Window( loc_id )
	
	-- is the window online or offline?
	ArkInventory.Frame_Main_Offline( frame )
	
	
	if loc_id == ArkInventory.Const.Location.Vault then
		
		-- force vault back to item display when offline
		if ArkInventory.Global.Location[loc_id].isOffline then
			ArkInventory.Global.Location[loc_id].view_mode = "bank"
		end
		
		obj = _G[string.format( "%s%s", frame:GetName( ), ArkInventory.Const.Frame.Container.Name )]
		obj:Hide( )
		
		obj = _G[string.format( "%s%s", frame:GetName( ), ArkInventory.Const.Frame.Info.Name )]
		obj:Hide( )
		
		obj = _G[string.format( "%s%s", frame:GetName( ), ArkInventory.Const.Frame.Log.Name )]
		obj:Hide( )
		
		if ArkInventory.Global.Location[loc_id].view_mode == "log" or ArkInventory.Global.Location[loc_id].view_mode == "moneylog" then
			obj = _G[string.format( "%s%s", frame:GetName( ), ArkInventory.Const.Frame.Log.Name )]
			obj:Show( )
		elseif ArkInventory.Global.Location[loc_id].view_mode == "tabinfo" then
			obj = _G[string.format( "%s%s", frame:GetName( ), ArkInventory.Const.Frame.Info.Name )]
			obj:Show( )
		elseif ArkInventory.Global.Location[loc_id].view_mode == "bank" then
			obj = _G[string.format( "%s%s", frame:GetName( ), ArkInventory.Const.Frame.Container.Name )]
			obj:Show( )
		end
		
	end
	
	
	-- edit mode
	if ArkInventory.Global.Mode.Edit then
		ArkInventory.Frame_Main_DrawStatus( loc_id, ArkInventory.Const.Window.Draw.Recalculate )
	end
	
	
	-- do we still need to draw the window?
	if ArkInventory.Global.Location[loc_id].drawState < ArkInventory.Const.Window.Draw.None then
		obj = _G[string.format( "%s%s", frame:GetName( ), ArkInventory.Const.Frame.Container.Name )]
		ArkInventory.OutputThread( loc_id, " Frame_Container_Draw" )
		ArkInventory.Frame_Container_Draw( obj )
		ArkInventory.ThreadYield_Window( loc_id )
	end
	
	if ArkInventory.Global.Location[loc_id].drawState <= ArkInventory.Const.Window.Draw.Restart then
		
		ArkInventory.OutputThread( loc_id, " MediaFrameDefaultFontSet" )
		ArkInventory.MediaFrameDefaultFontSet( frame )
		ArkInventory.ThreadYield_Window( loc_id )
		
		ArkInventory.OutputThread( loc_id, " Frame_Main_Paint" )
		ArkInventory.Frame_Main_Paint( frame )
		ArkInventory.ThreadYield_Window( loc_id )
		
	end
	
	if ArkInventory.Global.Location[loc_id].drawState <= ArkInventory.Const.Window.Draw.Refresh then
		
		-- title frame
		
		-- hide the title window if it's not needed
		local subframe1 = _G[string.format( "%s%s", frame:GetName( ), ArkInventory.Const.Frame.Title.Name )]
		local obj = subframe1
		if codex.style.title.hide then
			
			-- show mini action buttons
			for k, v in pairs( ArkInventory.Const.Actions ) do
				local obj = _G[string.format( "%s%s%s%s", frame:GetName( ), ArkInventory.Const.Frame.Scroll.Name, "ActionButton", k )]
				if obj then
					obj:Show( )
				end
			end
	
			obj:Hide( )
			obj:SetHeight( 1 )
			
		else
			
			-- hide mini action buttons
			for k, v in pairs( ArkInventory.Const.Actions ) do
				local obj = _G[string.format( "%s%s%s%s", frame:GetName( ), ArkInventory.Const.Frame.Scroll.Name, "ActionButton", k )]
				if obj then
					obj:Hide( )
				end
			end
			
			local height = codex.style.title.font.height
			ArkInventory.MediaFrameFontSet( obj, nil, height )
			
			-- window title text
			local who = _G[string.format( "%s%s%s", frame:GetName( ), ArkInventory.Const.Frame.Title.Name, "Who" )]
			local t = ""
	
			if codex.style.title.size == ArkInventory.Const.Window.Title.SizeThin then
				
				-- thin size
				t = ArkInventory.DisplayName5( codex.player.data.info )
				
				-- one line of action buttons
--				z = _G[string.format( "%s%s", obj:GetName( ), "ActionButton21" )]
--				z:ClearAllPoints( )
--				z:SetPoint( "RIGHT", _G[string.format( "%s%s", obj:GetName( ), "ActionButton14" )], "LEFT", -3, 0 )
				
				who:SetMaxLines( 1 )
				
			else
				
				-- normal size
				t = ArkInventory.DisplayName1( codex.player.data.info )
				height = height * 2
				
				-- two lines of action buttons
--				z = _G[string.format( "%s%s", obj:GetName( ), "ActionButton21" )]
--				z:ClearAllPoints( )
--				z:SetPoint( "TOP", _G[string.format( "%s%s", obj:GetName( ), "ActionButton11" )], "BOTTOM", 0, -2 )
				
				who:SetMaxLines( 2 )
				
			end
			
			-- online/offline colouring
			if ArkInventory.Global.Location[loc_id].isOffline then
				local colour = codex.style.title.colour.offline
				who:SetTextColor( colour.r, colour.g, colour.b )
				t = string.format( "%s [%s]", t, PLAYER_OFFLINE )
			else
				local colour = codex.style.title.colour.online
				who:SetTextColor( colour.r, colour.g, colour.b )
			end
			
			if height < ArkInventory.Const.Frame.Title.MinHeight then
				height = ArkInventory.Const.Frame.Title.MinHeight
			end
			
			-- set icon to match height
			local z = _G[string.format( "%s%s", obj:GetName( ), "ActionButton0" )]
			z:SetWidth( height )
			z:SetHeight( height )
			
			who:SetHeight( height )
			who:SetText( t )
			
			height = height + ArkInventory.Const.Frame.Title.Height
			obj:SetHeight( height )
			
			obj:Show( )
			
			ArkInventory.ThreadYield_Window( loc_id )
			
		end
		
		ArkInventory.ThreadYield_Window( loc_id )
		
		
		-- hide the search window if it's not needed
		local subframe2 = _G[string.format( "%s%s", frame:GetName( ), ArkInventory.Const.Frame.Search.Name )]
		local obj = subframe2
		if codex.style.search.hide then
			
			obj:Hide( )
			obj:SetHeight( 1 )
			
			obj:SetPoint( "TOPLEFT", subframe1, "BOTTOMLEFT", 0, 1 )
			
			obj.filterText:SetText( "" )
			
		else
			
			local height = codex.style.search.font.height
			ArkInventory.MediaFrameFontSet( obj, nil, height )
			
			local obj2 = _G[string.format( "%s%s", obj:GetName( ), "FilterLabel" )]
			local colour = codex.style.search.label.colour
			obj2:SetTextColor( colour.r, colour.g, colour.b )
			local width = obj2:GetStringWidth( )
			
			local colour = codex.style.search.text.colour
			obj.filterText:SetTextColor( colour.r, colour.g, colour.b )
			obj.filterText:SetPoint( "LEFT", obj, "LEFT", width + 20, 0 )
			
			if height < ArkInventory.Const.Frame.Search.MinHeight then
				height = ArkInventory.Const.Frame.Search.MinHeight
			end
			
			obj:SetHeight( height + ArkInventory.Const.Frame.Search.Height )
			obj:Show( )
			
			obj:SetPoint( "TOPLEFT", subframe1, "BOTTOMLEFT" )
			
		end
		
		ArkInventory.ThreadYield_Window( loc_id )
		
		
		-- hide the changer frame if it can't be used
		local subframe5 = _G[string.format( "%s%s", frame:GetName( ), ArkInventory.Const.Frame.Status.Name )]
		local subframe4 = _G[string.format( "%s%s", frame:GetName( ), ArkInventory.Const.Frame.Changer.Name )]
		local obj = subframe4
		
		if codex.style.changer.hide or not ArkInventory.Global.Location[loc_id].hasChanger then
			obj:SetHeight( 1 )
			obj:Hide( )
			obj:SetPoint( "BOTTOMLEFT", subframe5, "TOPLEFT", 0, -1 )
		else
			ArkInventory.Frame_Changer_Update( loc_id )
			ArkInventory.ThreadYield_Window( loc_id )
			obj:SetHeight( ArkInventory.Const.Frame.Changer.Height )
			obj:Show( )
			obj:SetPoint( "BOTTOMLEFT", subframe5, "TOPLEFT" )
		end
		
		
		ArkInventory.Frame_Status_Update( frame )
		
		ArkInventory.Frame_Main_Resize( frame )
		
		ArkInventory.ThreadYield_Window( loc_id )
		
	end
	
	ArkInventory.Global.Location[loc_id].drawState = ArkInventory.Const.Window.Draw.None
	
--	if ArkInventory.Global.Location[loc_id].show then
--		ArkInventory.Global.Location[loc_id].show = nil
--		frame:Show( )
--	end
	
end

function ArkInventory.FrameLevelReset( frame, level )
	
	if type( frame ) == "string" then
		frame = _G[frame]
	end
	
	if frame == nil then
		return
	end
	
	if frame:GetFrameLevel( ) ~= level then
		frame:SetFrameLevel( level )
	end
	
	for _, z in pairs( { frame:GetChildren( ) } ) do
		ArkInventory.FrameLevelReset( z, level + 1 )
	end

end	

local function FrameLevelGetMaxRecurse( frame, level )	
	
	if frame:GetFrameLevel( ) > level then
		level = frame:GetFrameLevel( )
	end
	
	for _, z in pairs( { frame:GetChildren( ) } ) do
		level = FrameLevelGetMaxRecurse( z, level )
	end
	
	return level
	
end	

function ArkInventory.FrameLevelGetMax( frame )
	
	local level = frame:GetFrameLevel( )
	
	for loc_id, loc_data in pairs( ArkInventory.Global.Location ) do
		if loc_data.canView then
			
			local f2 = ArkInventory.Frame_Main_Get( loc_id )
			
			if f2 and f2:IsVisible( ) and frame ~= f2 then
				level = FrameLevelGetMaxRecurse( f2, level )
			end
			
		end
	end
	
	return level
	
end

function ArkInventory.Frame_Main_Level( frame )
	
	local level = ArkInventory.FrameLevelGetMax( frame )
	--ArkInventory.Output( frame:GetName( ), " before: ", frame:GetFrameLevel( ), ":", level )
	
	if frame:GetFrameLevel( ) < level then
		ArkInventory.FrameLevelReset( frame, level + 10 )
		
		--level = ArkInventory.FrameLevelGetMax( frame )
		--ArkInventory.Output( frame:GetName( ), " after: ", frame:GetFrameLevel( ), ":", level )
	end
	
end

function ArkInventory.Frame_Main_Toggle( loc_id )
	
	local frame = ArkInventory.Frame_Main_Get( loc_id )
	
	if frame then
		if frame:IsVisible( ) then
			ArkInventory.Frame_Main_Hide( loc_id )
		else
			ArkInventory.Frame_Main_Show( loc_id )
		end
	end
	
end

function ArkInventory.Frame_Main_Show( loc_id, player_id )
	
	assert( loc_id, "invalid location: nil" )
	
	local frame = ArkInventory.Frame_Main_Get( loc_id )
	
	if loc_id == ArkInventory.Const.Location.Bank or loc_id == ArkInventory.Const.Location.Vault then
		if frame:IsVisible( ) then
			-- covers shifting from offline to online
			ArkInventory.Frame_Main_DrawStatus( loc_id, ArkInventory.Const.Window.Draw.Recalculate )
		end
	end
	
	--ArkInventory.Output( "show: ", loc_id, ", ", player_id )
	local codex = ArkInventory.SetLocationCodex( loc_id, player_id )
	--ArkInventory.Output( "player=", codex.player.data.info.player_id )
	--ArkInventory.Output( "layout=", codex.layout_id, ", style=", codex.style_id, ", catset=", codex.catset_id )
	
	if codex.style.sort.when == ArkInventory.Const.SortWhen.Open or codex.style.sort.when == ArkInventory.Const.SortWhen.Instant then
		--ArkInventory.OutputWarning( "Frame_Main_Show - .Recalculate" )
		ArkInventory.Frame_Main_DrawStatus( loc_id, ArkInventory.Const.Window.Draw.Recalculate )
	end
	
	frame:Show( )
	
--	ArkInventory.Global.Location[loc_id].show = true
	
	ArkInventory.Frame_Main_Generate( loc_id )
	
end

function ArkInventory.Frame_Main_OnShow( frame )
	
--	ArkInventory.Output( "Frame_Main_OnShow" )
	
	local loc_id = frame.ARK_Data.loc_id
	local codex = ArkInventory.GetLocationCodex( loc_id )
	
	if ArkInventory.Global.Location[loc_id].drawState <= ArkInventory.Const.Window.Draw.Init then
		ArkInventory.Frame_Main_Resize( frame )
	end
	
	-- frame strata
	if frame:GetFrameStrata( ) ~= codex.style.window.strata then
		frame:SetFrameStrata( codex.style.window.strata )
	end
	
	ArkInventory.Frame_Main_Level( frame )
	
	if ArkInventory.db.option.auto.reposition then
		ArkInventory.Frame_Main_Reposition( loc_id )
	end

	if loc_id == ArkInventory.Const.Location.Bag then
		PlaySound( SOUNDKIT.IG_BACKPACK_OPEN )
	elseif loc_id == ArkInventory.Const.Location.Bank then
		PlaySound( SOUNDKIT.IG_CHARACTER_INFO_OPEN )
	elseif loc_id == ArkInventory.Const.Location.Vault then
		PlaySound( SOUNDKIT.GUILD_VAULT_OPEN )
	elseif loc_id == ArkInventory.Const.Location.Wearing then
		PlaySound( SOUNDKIT.IG_CHARACTER_INFO_OPEN )
	elseif loc_id == ArkInventory.Const.Location.Auction then
		PlaySound( SOUNDKIT.IG_CHARACTER_INFO_OPEN )		
	elseif loc_id == ArkInventory.Const.Location.Void then
		PlaySound( SOUNDKIT.UI_ETHEREAL_WINDOW_OPEN )
	elseif loc_id == ArkInventory.Const.Location.Token then
		PlaySound( SOUNDKIT.IG_CHARACTER_INFO_OPEN )
	elseif loc_id == ArkInventory.Const.Location.Reputation then
		PlaySound( SOUNDKIT.IG_CHARACTER_INFO_OPEN )
	else
		PlaySound( SOUNDKIT.IG_SPELLBOOK_OPEN )
	end
	
end

function ArkInventory.Frame_Main_Search( frame )
	
	local loc_id = frame.ARK_Data.loc_id
	local filter = _G[string.format( "%s%s", frame:GetName( ), "SearchFilter" )]
	if not filter then
		ArkInventory.OutputError( "code failure: searchfilter object not found" )
		return
	end
	
	filter = filter:GetText( )
	local cf = ArkInventory.Global.Location[loc_id].filter or ""
	
	if cf ~= filter then
		--ArkInventory.Output( "search [", loc_id, "] [", cf, "] [", filter, "]" )
		ArkInventory.Global.Location[loc_id].filter = filter
		ArkInventory.Frame_Main_Generate( loc_id, ArkInventory.Const.Window.Draw.Refresh )
	end
	
end

function ArkInventory.Frame_Main_Hide( w )
	
	for loc_id, loc_data in pairs( ArkInventory.Global.Location ) do
		if loc_data.canView then
			if not w or w == loc_id then
				local frame = ArkInventory.Frame_Main_Get( loc_id )
				frame:Hide( )
			end
		end
	end
	
end

function ArkInventory.Frame_Main_OnHide( frame )
	
	ArkInventory.Lib.Dewdrop:Close( )
	
	local loc_id = frame.ARK_Data.loc_id
	
	if loc_id == ArkInventory.Const.Location.Bag then
		
		PlaySound( SOUNDKIT.IG_BACKPACK_CLOSE )
		ArkInventory.Frame_Main_Clear_NewItemGlow( loc_id )
		
	elseif loc_id == ArkInventory.Const.Location.Bank then
		
		PlaySound( SOUNDKIT.IG_CHARACTER_INFO_CLOSE )
		
		if ArkInventory.Global.Mode.Bank and ArkInventory.LocationIsControlled( ArkInventory.Const.Location.Bank ) then
			-- close blizzards bank frame if we're hiding blizzard frames, we're at the bank, and the bank window was closed
			CloseBankFrame( )
		end
		
	elseif loc_id == ArkInventory.Const.Location.Vault then
		
		PlaySound( SOUNDKIT.GUILD_VAULT_CLOSE )
		
		if ArkInventory.Global.Mode.Vault and ArkInventory.LocationIsControlled( ArkInventory.Const.Location.Vault ) then
			
			-- close blizzards vault frame if we're hiding blizzard frames, we're at the vault, and the vault window was closed
			
			GuildBankPopupFrame:Hide( )
			StaticPopup_Hide( "GUILDBANK_WITHDRAW" )
			StaticPopup_Hide( "GUILDBANK_DEPOSIT" )
			StaticPopup_Hide( "CONFIRM_BUY_GUILDBANK_TAB" )
			
			CloseGuildBankFrame( )
			
		end
		
	elseif loc_id == ArkInventory.Const.Location.Wearing then
		
		PlaySound( SOUNDKIT.IG_CHARACTER_INFO_CLOSE )
		
	elseif loc_id == ArkInventory.Const.Location.Auction then
		
		PlaySound( SOUNDKIT.IG_CHARACTER_INFO_CLOSE )
		
	elseif loc_id == ArkInventory.Const.Location.Void then
		
		PlaySound( SOUNDKIT.UI_ETHEREAL_WINDOW_CLOSE )
		
	elseif loc_id == ArkInventory.Const.Location.Token then
		
		PlaySound( SOUNDKIT.IG_CHARACTER_INFO_CLOSE )
		
	elseif loc_id == ArkInventory.Const.Location.Reputation then
		
		PlaySound( SOUNDKIT.IG_CHARACTER_INFO_CLOSE )
		
	else
		
		PlaySound( SOUNDKIT.IG_SPELLBOOK_CLOSE )
		
	end
	
	if ArkInventory.Global.Mode.Edit then
		-- if the edit mode is active then disable edit mode and flag for rebuild when next opened
		ArkInventory.Global.Mode.Edit = false
		--ArkInventory.OutputWarning( "Frame_Main_OnHide - .Recalculate" )
		ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Recalculate )
	end
	
	ArkInventory.FrameLevelReset( frame, 1 )
	
end

function ArkInventory.Frame_Main_OnLoad( frame )
	
	assert( frame, "frame is nil" )
	
	local framename = frame:GetName( )
	local loc_id = string.match( framename, "^.-(%d+)" )
	
	assert( loc_id ~= nil, string.format( "xml element '%s' is not an %s frame", framename, ArkInventory.Const.Program.Name ) )
	
	loc_id = tonumber( loc_id )
	
	frame.ARK_Data = {
		loc_id = loc_id,
	}
	
	local tex
	
	frame:SetDontSavePosition( true )
	frame:SetUserPlaced( false )
	
	-- setup title frame action buttons
	for k, v in pairs( ArkInventory.Const.Actions ) do
		
		local obj = _G[string.format( "%s%s%s%s", frame:GetName( ), ArkInventory.Const.Frame.Title.Name, "ActionButton", k )]
		
		if obj then
			
			tex = obj:GetNormalTexture( )
			ArkInventory.SetTexture( tex, v.Texture or ArkInventory.Global.Location[loc_id].Texture )
			tex:SetTexCoord( 0.075, 0.925, 0.075, 0.925 )
			
			tex = obj:GetPushedTexture( )
			ArkInventory.SetTexture( tex, v.Texture or ArkInventory.Global.Location[loc_id].Texture )
			tex:SetTexCoord( 0.075, 0.925, 0.075, 0.925 )
			
			tex = obj:GetHighlightTexture( )
			ArkInventory.SetTexture( tex, v.Texture or ArkInventory.Global.Location[loc_id].Texture )
			tex:SetTexCoord( 0.075, 0.925, 0.075, 0.925 )
			
			for s, f in pairs( v.Scripts ) do
				obj:SetScript( s, f )
			end
			
		end
		
	end
	
	-- setup main frame mini action buttons
	for k, v in pairs( ArkInventory.Const.Actions ) do
		
		local obj = _G[string.format( "%s%s%s%s", frame:GetName( ), ArkInventory.Const.Frame.Scroll.Name, "ActionButton", k )]
		
		if obj then
			
			tex = obj:GetNormalTexture( )
			ArkInventory.SetTexture( tex, v.Texture or ArkInventory.Global.Location[loc_id].Texture )
			tex:SetTexCoord( 0.075, 0.925, 0.075, 0.925 )
			
			tex = obj:GetPushedTexture( )
			ArkInventory.SetTexture( tex, v.Texture or ArkInventory.Global.Location[loc_id].Texture )
			tex:SetTexCoord( 0.075, 0.925, 0.075, 0.925 )
			
			tex = obj:GetHighlightTexture( )
			ArkInventory.SetTexture( tex, v.Texture or ArkInventory.Global.Location[loc_id].Texture )
			tex:SetTexCoord( 0.075, 0.925, 0.075, 0.925 )
			
			for s, f in pairs( v.Scripts ) do
				obj:SetScript( s, f )
			end
			
		end
		
	end
	
end

function ArkInventory.Frame_Container_Calculate( frame )
	
	--ArkInventory.Output( "Frame_Container_Calculate( ", frame:GetName( ), " )" )
	
	local loc_id = frame.ARK_Data.loc_id
	local codex = ArkInventory.GetLocationCodex( loc_id )
	
	ArkInventory.Table.Clean( codex.workpad, nil, true )
--	table.wipe( codex.workpad )
	
	-- break the inventory up into it's respective bars
	ArkInventory.Frame_Container_CalculateBars( frame )
	
	-- calculate what the container should look like with those bars
	ArkInventory.Frame_Container_CalculateContainer( frame )
	
end

function ArkInventory.Frame_Container_CalculateBars( frame )
	
	-- loads the inventory into their respective bars
	
	local loc_id = frame.ARK_Data.loc_id
	local codex = ArkInventory.GetLocationCodex( loc_id )
	
	ArkInventory.ThreadYield_Window( loc_id )
	
	local firstempty = codex.style.slot.empty.first or 0
--	ArkInventory.Output( "show ", firstempty, " empty slots" )
	local firstemptyshown = { }
	
	--ArkInventory.Output( GREEN_FONT_COLOR_CODE, "Frame_Container_CalculateBars( ", frame:GetName( ), " ) for [", codex.player.data.info.name, "] start" )

	codex.workpad.bar = codex.workpad.bar or { }
	table.wipe( codex.workpad.bar )
	codex.workpad.bar_count = 1
	
	local bag
	local cat_id
	local bar_id
	local ignore = false
	local hidden = false
	local show_all = false
	local stack_compress = codex.style.slot.compress.count
	
	if ArkInventory.Global.Mode.Edit or ArkInventory.Global.Options.ShowHiddenItems or codex.style.window.list then
		-- show everything if in edit mode or the user wants us to ignore the hidden flag
		show_all = true
	end
	
	local new_shift = codex.style.slot.new.enable
	local new_cutoff = ArkInventory.TimeAsMinutes( ) - codex.style.slot.new.cutoff
	local new_reset = ArkInventory.Global.NewItemResetTime or new_cutoff
	
	if stack_compress > 0 then  -- stack compression
		
		if not ArkInventory.Global.Cache.StackCompress[loc_id] then
			ArkInventory.Global.Cache.StackCompress[loc_id] = { }
		else
			table.wipe( ArkInventory.Global.Cache.StackCompress[loc_id] )
		end
		
	end
	
	
	-- the basics, just stick the items into their appropriate bars (cpu intensive)
	for bag_id in pairs( ArkInventory.Global.Location[loc_id].Bags ) do
		
		bag = codex.player.data.location[loc_id].bag[bag_id]
		
		for slot_id = 1, bag.count do
			
			local i = bag.slot[slot_id]
			ignore = false
			
			if loc_id == ArkInventory.Const.Location.Vault and not codex.player.data.option[loc_id].bag[bag_id].display then
				ignore = true
			end
			
			if i and not ignore then
				
				if codex.style.window.list then
					
					cat_id = ArkInventory.CategoryGetSystemID( "SYSTEM_DEFAULT" )
					
				else
					
					if i.h and new_shift and i.age and i.age > new_reset and i.age > new_cutoff then
						cat_id = ArkInventory.CategoryGetSystemID( "SYSTEM_NEW" )
					else
						cat_id = ArkInventory.ItemCategoryGet( i )
					end
					
				end
				
				bar_id = codex.layout.bag[bag_id].bar or ArkInventory.CategoryLocationGet( loc_id, cat_id )
				--ArkInventory.Output( "loc=[", loc_id, "], bag=[", bag_id, "], slot=[", slot_id, "], cat=[", cat_id, "], bar_id=[", bar_id, "]" )
				
				if not show_all then
					
					-- no point doing this if show all is enabled
					
					if firstempty > 0 and not i.h and bar_id > 0 then
						
						if not firstemptyshown[bag.type] then
							firstemptyshown[bag.type] = 0
						end
						
						if firstemptyshown[bag.type] < firstempty then
							firstemptyshown[bag.type] = firstemptyshown[bag.type] + 1
						else
							bar_id = 0 - bar_id
						end
						
					end
					
					if stack_compress > 0 and i.h and bar_id > 0 then
						
						local info = ArkInventory.ObjectInfoArray( i.h, i )
						
						if info.stacksize > 1 then
							
							local key = ArkInventory.ObjectIDCount( i.h, i )
							
							if not ArkInventory.Global.Cache.StackCompress[loc_id][key] then
								ArkInventory.Global.Cache.StackCompress[loc_id][key] = 0
							end
							
							if ArkInventory.Global.Cache.StackCompress[loc_id][key] < stack_compress then
								ArkInventory.Global.Cache.StackCompress[loc_id][key] = ArkInventory.Global.Cache.StackCompress[loc_id][key] + 1
							else
								bar_id = 0 - bar_id
							end
							
						end
					
					end
					
				end
				
				
				hidden = false
				
				if not codex.player.data.option[loc_id].bag[bag_id].display then
					-- isoalted bags do not get shown
					hidden = true
				elseif bar_id < 0 then
					-- hidden categories (reside on negative bar numbers) do not get shown
					hidden = true
				end
				
				if show_all or not hidden then
					
					bar_id = abs( bar_id )
					
					-- create the bar
					if not codex.workpad.bar[bar_id] then
						codex.workpad.bar[bar_id] = { ["id"] = bar_id, ["item"] = { }, ["count"] = 0, ["width"] = 0, ["height"] = 0, ["ghost"] = false, ["frame"] = 0 }
					end
					
					-- add the item to the bar
					codex.workpad.bar[bar_id].item[#codex.workpad.bar[bar_id].item + 1] = { ["bag"] = bag_id, ["slot"] = slot_id }
					
					-- increment the bars item count
					codex.workpad.bar[bar_id].count = codex.workpad.bar[bar_id].count + 1
					
					-- keep track of the last bar used
					if bar_id > codex.workpad.bar_count then
						codex.workpad.bar_count = bar_id
					end
					
					--ArkInventory.Output( "bag[", bag_id, "], slot[", slot_id, "], cat[", cat_id, "], bar[", bar_id, "], id=[", codex.workpad.bar[bar_id].id, "]" )
					
				end
				
			end
			
			ArkInventory.ThreadYield_Window( loc_id )
			
		end
		
		--ArkInventory.Output( "bag = ", bag_id, ", count = ", bag.count, " / ", ArkInventory.Table.Elements( bag.slot ) )
		
	end
	
	
	-- get highest used bar
	local cats = codex.layout.category
	for _, bar_id in pairs( cats ) do
		if bar_id > codex.workpad.bar_count then
			codex.workpad.bar_count = bar_id
		end
	end
	
	-- round up to a full number of bars per row
	local bpr = codex.style.window.list and 1 or codex.style.bar.per or 1
	codex.workpad.bar_count = ceil( codex.workpad.bar_count / bpr ) * bpr
	
	if ArkInventory.Global.Mode.Edit then
		-- and add an entire extra row for easy bar/category movement when in edit mode
		codex.workpad.bar_count = codex.workpad.bar_count + bpr
	end
	
	-- update the maximum number of bar frames used so far
	if codex.workpad.bar_count > ArkInventory.Global.Location[loc_id].maxBar then
		ArkInventory.Global.Location[loc_id].maxBar = codex.workpad.bar_count
	end

	-- if we're in edit mode then create all missing bars and add a ghost item to every bar
	-- ghost items allow for the bar menu icon
	if ArkInventory.Global.Mode.Edit or codex.style.bar.showempty then
		
		--ArkInventory.Output( "edit mode - adding ghost bars" )
		for bar_id = 1, codex.workpad.bar_count do
			
			if not codex.workpad.bar[bar_id] then
				
				-- create a ghost bar
				codex.workpad.bar[bar_id] = { ["id"] = bar_id, ["item"] = { }, ["count"] = 1, ["width"] = 0, ["height"] = 0, ["ghost"] = true, ["frame"] = 0 }
				
			else
				
				-- add a ghost item to the bar by incrementing the bars item count
				codex.workpad.bar[bar_id].count = codex.workpad.bar[bar_id].count + 1
				
			end
			
		end
		
	end
	
	--ArkInventory.Output( GREEN_FONT_COLOR_CODE, "Frame_Container_CalculateBars( ", frame:GetName( ), " ) end" )
	
	ArkInventory.ThreadYield_Window( loc_id )
	
end

function ArkInventory.Frame_Container_CalculateContainer( frame )
	
	-- calculate what the bars look like in the conatiner
	
	--ArkInventory.Output( GREEN_FONT_COLOR_CODE, "Frame_Container_Calculate( ", frame:GetName( ), " ) start" )
	
	local loc_id = frame.ARK_Data.loc_id
	local codex = ArkInventory.GetLocationCodex( loc_id )
	
	ArkInventory.ThreadYield_Window( loc_id )
	
	codex.workpad.container = { row = { } }
	
	local bpr = codex.style.window.list and 1 or codex.style.bar.per or 1
	local rownum = 0
	local bf = 1 -- bar frame, allocated to each bar as it's calculated (uses less frames this way)
	
	--ArkInventory.Output( "container ", loc_id, " has ", codex.workpad.bar_count, " bars" )
	--ArkInventory.Output( "container ", loc_id, " set for ", bpr, " bars per row" )
	
	
	if ArkInventory.Global.Mode.Edit == false and codex.style.bar.compact then
		
		--ArkInventory.Output( "compact bars enabled" )
		
		local bc = 0  -- number of bars currently in this row
		local vr = { }  -- virtual row - holds a list of bars for this row
		
		for j = 1, codex.workpad.bar_count do
			
			--ArkInventory.Output( "bar [", j, "]" )
			
			if codex.workpad.bar[j] then
				if codex.workpad.bar[j].count > 0 then
					--ArkInventory.Output( "assignment: bar [", j, "] to frame [", bf, "]" )
					codex.workpad.bar[j].frame = bf
					bf = bf + 1
					bc = bc + 1
					vr[bc] = j
				else
					--ArkInventory.Output( "bar [", j, "] has no items" )
				end
			else
				--ArkInventory.Output( "bar [", j, "] has no items (does not exist)" )
			end
			
			if bc > 0 and ( bc == bpr or j == codex.workpad.bar_count ) then
				
				rownum = rownum + 1
				if not codex.workpad.container.row[rownum] then
					codex.workpad.container.row[rownum] = { }
				end
				
				--ArkInventory.Output( "row [", rownum, "] allocated [", bc, "] bars" )
				
				codex.workpad.container.row[rownum].bar = vr
				
				--ArkInventory.Output( "row [", rownum, "] created" )
				
				bc = 0
				vr = { }
				
			end
			
		end
		
	else
		
		for j = 1, codex.workpad.bar_count, bpr do
			
			local bc = 0  -- number of bars currently in this row
			local vr = { }  -- virtual row - holds a list of bars for this row
			
			for b = 1, bpr do
				if codex.workpad.bar[j + b - 1] then
					if codex.workpad.bar[j + b - 1].count > 0 then
						--ArkInventory.Output( "assignment: bar [", j + b - 1, "] to frame [", bf, "]" )
						codex.workpad.bar[j + b - 1]["frame"] = bf
						bf = bf + 1
						bc = bc + 1
						vr[bc] = j + b -1
					else
						--ArkInventory.Output( "bar [", j+b-1, "] has no items" )
					end
				else
					--ArkInventory.Output( "bar [", j+b-1, "] has no items (does not exist)" )
				end
			end
			
			if bc > 0 then
				
				rownum = rownum + 1
				if not codex.workpad.container.row[rownum] then
					codex.workpad.container.row[rownum] = { }
				end
				
				--ArkInventory.Output( "row [", rownum, "] allocated [", bc, "] bars" )
				
				codex.workpad.container.row[rownum].bar = vr
				
			end
			
		end
		
	end
	
	ArkInventory.ThreadYield_Window( loc_id )
	
	-- fit the bars into the row
	
	local rmw = codex.style.window.width -- row max width
	local rcw = 0 -- row current width
	local rch = 1 -- row current height
	local rmh = 0 -- row max height
	local igb = ArkInventory.Global.Mode.Edit and not codex.style.bar.showempty -- ignore ghost bars for row width purposes (makes the window get wider in edit mode)
	local rmb = 0 -- row max (height) bar - bar id of tallest bar
	local mwb = 0 -- number of minimum width bars in the row
	
	local bar = codex.workpad.bar
	
	--ArkInventory.Output( "bars per row=[", bpr, "], max columns=[", rmw, "], columns per bar=[", floor( rmw / bpr ), "]" )
	
	for rownum, row in ipairs( codex.workpad.container.row ) do
		
		rcw = 0
		mwb = 0
		
		for k, bar_id in ipairs( row.bar ) do
			
			-- initial setup for each bar
			bar[bar_id].minwidth = codex.layout.bar.data[bar_id].width.min
			if bar[bar_id].minwidth == 0 then
				bar[bar_id].minwidth = nil
			end

			if codex.style.window.list then
				bar[bar_id].maxwidth = 1
			else
				bar[bar_id].maxwidth = codex.layout.bar.data[bar_id].width.max
			end
			
			if bar[bar_id].maxwidth == 0 then
				bar[bar_id].maxwidth = nil
			end
			
			bar[bar_id].width = bar[bar_id].minwidth or 1
			bar[bar_id].height = bar[bar_id].count
			
			if bar[bar_id].minwidth then
				bar[bar_id].height = math.ceil( bar[bar_id].count / bar[bar_id].minwidth )
				mwb = mwb + 1
			end
			
			if bar[bar_id].height > rmh then
				rmh = bar[bar_id].height
			end
			
			
			rcw = rcw + ( igb and bar[bar_id].ghost and 0 or bar[bar_id].width )
			
			--ArkInventory.Output( "row=[", rownum, "], index=[", k, "], bar=[", bar_id, "], width=[", bar[bar_id].width, "], height=[", bar[bar_id].height, "], mwb=[", mwb, "]" )
			
		end
		
		if rmh > 1 then
			
			local first = true
			if #row.bar == mwb then
				-- if all the bars in the row have min width then allow them to be adjusted
				if rcw < rmw then
					-- but only if the total width is less than the window width
					first = false
					-- otherwise it will change the width of the tallest bar before passing through which we dont want
				end
			end
			
			
			repeat
				
				rmh = 1
				rmb = 0
				
				-- find the bar with tallest height (ignore bars at max width, and bars at minwidth on the first pass)
				for _, bar_id in ipairs( row.bar ) do
					--if ( bar[bar_id].height > rmh ) and not ( bar[bar_id].maxwidth and bar[bar_id].width >= bar[bar_id].maxwidth ) and not ( first and bar[bar_id].minwidth and bar[bar_id].width >= bar[bar_id].minwidth ) then
					if ( bar[bar_id].height > rmh ) and not ( bar[bar_id].maxwidth and bar[bar_id].width >= bar[bar_id].maxwidth ) and not ( first and bar[bar_id].minwidth and bar[bar_id].width >= bar[bar_id].minwidth ) then
						rmb = bar_id
						rmh = bar[bar_id].height
					end
				end
				
				if rmb > 0 and rmh > 1 then
					
					-- increase the tallest bars width by one
					bar[rmb].width = bar[rmb].width + 1
					
					-- recalcualte it's new height
					bar[rmb].height = math.ceil( bar[rmb].count / bar[rmb].width )
					
				end
				
				-- check if all fits
				rcw = 0
				rmh = 0
				for _, bar_id in ipairs( row.bar ) do
					rcw = rcw + ( igb and bar[bar_id].ghost and 0 or bar[bar_id].width )
					if bar[bar_id].height > rmh then
						rmh = bar[bar_id].height
					end
				end
				
				first = false
				
				-- exit if the width fits (or is over), or the max height is 1, no bar heights were changed on the second or higher pass
			until rcw >= rmw or rmh == 1 or (rmb == 0 and not first)
			
		end
		
		--ArkInventory.Output( "maximum height for row [", rownum, "] was [", rmh, "]" )
		
		for k, bar_id in ipairs( row.bar ) do
			
			--ArkInventory.Output( "setting max height for row [", rownum, "] bar [", bar_id, "] to [", rmh, "]" )
			
			-- set height of all bars in the row to the maximum height used (looks better)
			bar[bar_id].height = rmh
			
			if bar[bar_id].ghost or ArkInventory.Global.Mode.Edit or codex.style.bar.showempty then
				-- remove the ghost item from the count (it was only needed to calculate properly)
				bar[bar_id].count = bar[bar_id].count - 1
			end
			
		end
		
		ArkInventory.ThreadYield_Window( loc_id )
		
	end
	
	--ArkInventory.Output( GREEN_FONT_COLOR_CODE, "Frame_Container_Calculate( ", frame:GetName( ), " ) end" )
	
end

function ArkInventory.Frame_Container_Draw( frame )
	
	local loc_id = frame.ARK_Data.loc_id
	local codex = ArkInventory.GetLocationCodex( loc_id )
	
	local slotScale = codex.style.slot.scale or 1
	local slotSize = ( codex.style.slot.size or ArkInventory.Const.SLOT_SIZE ) * slotScale
	
	--ArkInventory.Output( "draw frame=", frame:GetName( ), ", loc=", loc_id, ", state=", ArkInventory.Global.Location[loc_id].drawState )
	
	if ArkInventory.Global.Location[loc_id].drawState <= ArkInventory.Const.Window.Draw.Recalculate then
		
		-- calculate what the container should look like
		ArkInventory.OutputThread( "Frame_Container_Calculate" )
		ArkInventory.Frame_Container_Calculate( frame )
		ArkInventory.ThreadYield_Window( loc_id )
		
		-- create (if required) the bar frames, and hide any that are no longer required
		for bar_id = 1, ArkInventory.Global.Location[loc_id].maxBar do
			
			local barframename = string.format( "%sBar%s", frame:GetName( ), bar_id )
			local barframe = _G[barframename]
			if not barframe then
				barframe = CreateFrame( "Frame", barframename, frame, "ARKINV_TemplateFrameBar" )
				barframe:Hide( )
			end
			
		end
		
		
		ArkInventory.ThreadYield_Window( loc_id )
		
		-- create (if required) the bags and their item buttons
		for bag_id in pairs( ArkInventory.Global.Location[loc_id].Bags ) do
			
			local bagframename = string.format( "%sBag%s", frame:GetName( ), bag_id )
			local bagframe = _G[bagframename]
			if not bagframe then
				bagframe = CreateFrame( "Frame", bagframename, frame, "ARKINV_TemplateFrameBag" )
				bagframe:Hide( )
			end
			
			
			-- remember the maximum number of slots used for each bag
			local c = codex.player.data.location[loc_id].bag[bag_id].count
			
			if not ArkInventory.Global.Location[loc_id].maxSlot[bag_id] then
				ArkInventory.Global.Location[loc_id].maxSlot[bag_id] = 0
			end
			
			if c > ArkInventory.Global.Location[loc_id].maxSlot[bag_id] then
				ArkInventory.Global.Location[loc_id].maxSlot[bag_id] = c
			end
			
			
			-- create the item frames for the bag
			for slot_id = 1, ArkInventory.Global.Location[loc_id].maxSlot[bag_id] do
				
				local itemframename, itemframe = ArkInventory.ContainerItemNameGet( loc_id, bag_id, slot_id )
				local tainteditemframename = itemframename .. "T"
				local tainteditemframe = _G[tainteditemframename]
				
				if tainteditemframe and not InCombatLockdown( ) then
					
					-- a tainteditemframe exists and youre no longer in combat so "delete" it.  a normal itemframe will get created further down
					
					tainteditemframe:Hide( )
					tainteditemframe:SetParent( nil )
					
					_G[tainteditemframename] = nil
					tainteditemframe = nil
					
					_G[itemframename] = nil
					itemframe = nil
					
					ArkInventory.Global.Location[loc_id].tainted = false
					
				end
				
				if not itemframe then
					
					if InCombatLockdown( ) then
						
						-- in combat, create a tainted frame that is viable
						
						itemframe = CreateFrame( "Button", tainteditemframename, bagframe, "ARKINV_TemplateButtonItemTainted" )
						
						ArkInventory.Global.Location[loc_id].tainted = true
						
						_G[tainteditemframename] = itemframe
						_G[itemframename] = itemframe
						
						--ArkInventory.Output( "tainted ", tainteditemframename )
						
					else
						
						itemframe = CreateFrame( "Button", itemframename, bagframe, ArkInventory.Global.Location[loc_id].template or "ARKINV_TemplateButtonViewOnlyItem" )
						
						ArkInventory.Global.Location[loc_id].tainted = false
						
						--ArkInventory.Output( "secure ", itemframename )
						
					end
					
					ArkInventory.MediaFrameDefaultFontSet( itemframe )
					itemframe:SetScale( slotScale )
					
					itemframe:Hide( )
					
				else
					
					if false then -- fix me - add config option
						itemframe:Hide( )
					end
					
				end
				
				ArkInventory.ThreadYield_Window( loc_id )
				
			end
			
		end
		
	end
	
	
	-- position the bar frames
	local name = frame:GetName( )
	
	local bpr = codex.style.window.list and 1 or codex.style.bar.per or 1
	local padSlot = codex.style.slot.pad * slotScale
	local padBarInternal = codex.style.bar.pad.internal * slotScale
	local padBarExternal = codex.style.bar.pad.external
	local padWindow = codex.style.window.pad
	local padLabel = codex.style.bar.name.show and ( not codex.style.window.list ) and ( codex.style.bar.name.height + padSlot ) or 0
	local padActionButtons = codex.style.title.hide and ArkInventory.Const.Frame.Main.MiniActionButtonSize or 0
	local anchor = codex.style.bar.anchor
	
	local padList = 0
	if codex.style.window.list then
		padList = ( codex.style.window.width - 1 ) * ( slotSize + padSlot )
	end
	
	local barOffsetX, barOffsetY, barWidth, barHeight
	
	for rownum, row in ipairs( codex.workpad.container.row ) do
		
		row.width = padWindow * 2 - padBarExternal
		
		for bar_index, bar_id in ipairs( row.bar ) do
			
			local bar = codex.workpad.bar[bar_id]
			local barframename = string.format( "%s%s%s", name, "Bar", bar.frame )
			local obj = _G[barframename]
			assert( obj, string.format( "xml element '%s' could not be found", barframename ) )
			
			-- assign the bar number used to the bar frame
			obj.ARK_Data.bar_id = bar_id
			obj.ARK_Data.displayed = true
			
			if ArkInventory.Global.Location[loc_id].drawState <= ArkInventory.Const.Window.Draw.Recalculate then
				
				obj:ClearAllPoints( )
				
				local obj_width = ( bar.width * slotSize ) + ( ( bar.width - 1 ) * padSlot ) + ( padBarInternal * 2 ) + padList
				obj:SetWidth( obj_width )
				
				row.width = row.width + obj_width + padBarExternal
				
				row.height = ( bar.height * slotSize ) + ( ( bar.height - 1 ) * padSlot ) + ( padBarInternal * 2 ) + padLabel
				obj:SetHeight( row.height )
				
				if bar_index == 1 then
					
					--ArkInventory.Output( "r[", rownum, "] h[", row.height, "] o[", barHeight, "]" )
					
					-- first bar in a new row, set X offset
					barOffsetX = padWindow
					barWidth = 0
					
					if bar.frame == 1 then
						
						-- first row, first bar, set Y offset
						barOffsetY = padWindow
						
						-- increment Y offset if mini action items are visible, theyre always at the top
						if codex.style.title.hide then
							if anchor == ArkInventory.Const.Anchor.TopLeft or anchor == ArkInventory.Const.Anchor.TopRight then
								barOffsetY = barOffsetY + ArkInventory.Const.Frame.Main.MiniActionButtonSize or 0
							end
						end
						
					else
						
						-- next row, first bar, increment Y offset
						barOffsetY = barOffsetY + ( barHeight or 0 ) + padBarExternal
						
					end
					
					barHeight = row.height
					
				else
					
					-- same row, subsequent bars, increment X offset
					barOffsetX = barOffsetX + ( barWidth or 0 ) + padBarExternal
					
				end
				
				barWidth = obj_width
				
				--ArkInventory.Output( "r[", rownum, "] b[", bar_index, "] f[", bar.frame, "] x[", barOffsetX, "] y[", barOffsetY, "]" )
				
				if anchor == ArkInventory.Const.Anchor.BottomLeft then
					obj:SetPoint( "BOTTOMLEFT", frame, barOffsetX, barOffsetY )
				elseif anchor == ArkInventory.Const.Anchor.TopLeft then
					obj:SetPoint( "TOPLEFT", frame, barOffsetX, 0 - barOffsetY )
				elseif anchor == ArkInventory.Const.Anchor.TopRight then
					obj:SetPoint( "TOPRIGHT", frame, 0 - barOffsetX, 0 - barOffsetY )
				else
					obj:SetPoint( "BOTTOMRIGHT", frame, 0 - barOffsetX, barOffsetY )
				end
				
			end
			
			if ArkInventory.Global.Location[loc_id].drawState <= ArkInventory.Const.Window.Draw.Refresh then
				
				ArkInventory.OutputThread( loc_id, " Frame_Bar_DrawItems")
				ArkInventory.Frame_Bar_DrawItems( obj )
				ArkInventory.ThreadYield_Window( loc_id )
				
			end
			
		end
		
	end
	
	
	if ArkInventory.Global.Location[loc_id].drawState <= ArkInventory.Const.Window.Draw.Recalculate then
		
		-- display/hide the appropriate bars
		for bar_id = 1, ArkInventory.Global.Location[loc_id].maxBar do
			
			local barframename = string.format( "%s%s%s", name, "Bar", bar_id )
			local obj = _G[barframename]
			assert( obj, string.format( "xml element '%s' could not be found", barframename ) )
			
			if obj.ARK_Data.displayed then
				ArkInventory.Frame_Bar_Paint( obj )
				obj:Show( )
			else
				obj:Hide( )
			end
			
			obj.ARK_Data.displayed = nil
			
		end
		
	end
	
	
	if ArkInventory.Global.Location[loc_id].drawState <= ArkInventory.Const.Window.Draw.Refresh then
		
		-- display/hide the appropriate items - mostly used for search matching (thus the refresh level)
		
		for bag_id in pairs( ArkInventory.Global.Location[loc_id].Bags ) do
			
			if codex.player.data.option[loc_id].bag[bag_id].display then
				
				-- this bag and its items should be visible
				for slot_id = 1, ArkInventory.Global.Location[loc_id].maxSlot[bag_id] do
					
					local itemframename, itemframe = ArkInventory.ContainerItemNameGet( loc_id, bag_id, slot_id )
					assert( itemframe, string.format( "xml element '%s' could not be found", itemframename ) )
					
					if itemframe.ARK_Data.displayed then
						
						if ArkInventory.Global.Location[loc_id].drawState <= ArkInventory.Const.Window.Draw.Recalculate then
							ArkInventory.Frame_Item_Update_Clickable( itemframe )
						end
						
						if ArkInventory.Global.Location[loc_id].drawState <= ArkInventory.Const.Window.Draw.Restart then
							
							itemframe:SetScale( slotScale )
							
							ArkInventory.Frame_Item_Update_Count_Anchor( itemframe )
							ArkInventory.Frame_Item_Update_Stock_Anchor( itemframe )
							ArkInventory.Frame_Item_Update_StatusIconUpgrade_Anchor( itemframe )
							ArkInventory.Frame_Item_Update_StatusIconJunk_Anchor( itemframe )
							ArkInventory.Frame_Item_Update_StatusIconTransmog_Anchor( itemframe )
							
						end
						
						itemframe:Show( )
						
					else
						
						itemframe:Hide( )
						
					end
					
					itemframe.ARK_Data.displayed = nil
					
				end
				
			end
			
		end
		
		-- display/hide the appropriate bags (separated for better reload visual impact)
		for bag_id in pairs( ArkInventory.Global.Location[loc_id].Bags ) do
			
			local bagframename = string.format( "%sBag%s", frame:GetName( ), bag_id )
			local bagframe = _G[bagframename]
			assert( bagframe, string.format( "xml element '%s' could not be found", bagframename ) )
			
			if codex.player.data.option[loc_id].bag[bag_id].display then
				bagframe:Show( )
			else
				bagframe:Hide( )
			end
			
		end
	
	end
	
	
	if ArkInventory.Global.Location[loc_id].drawState <= ArkInventory.Const.Window.Draw.Recalculate then
		
		-- set container height and width
		
		local c = codex.workpad.container
		
		c.width = ArkInventory.Const.Window.Min.Width
		
		c.height = padWindow * 2 + padActionButtons - padBarExternal

		for row_index, row in ipairs( c.row ) do
		
			if row.width > c.width then
				c.width = row.width
			end
			
			c.height = c.height + row.height + padBarExternal
			
		end
		
		-- set the container frame dimensions
		frame:SetWidth( c.width )
		frame:SetHeight( c.height )
		
		
		-- set scrollframe/slider
		local h = codex.style.window.height
		if c.height < h then
			h = c.height
		end
		
		local sf = frame:GetParent( )
		
		sf.range = c.height
		sf.stepSize = ArkInventory.Const.Frame.Scroll.stepSize
		
		if c.height > h then
			
			sf.scrollBar:SetMinMaxValues( 0, c.height - h )
			sf.scrollBar:Show( )
			
		else
			
			sf:SetVerticalScroll( 0 )
			sf.scrollBar:Hide( )
			
		end
		
		codex.profile.location[loc_id].container.width = c.width
		codex.profile.location[loc_id].container.height = h
--		codex.profile.location[loc_id].container.heightmax = c.height
		
		ArkInventory.ThreadYield_Window( loc_id )
		
	end
	
end

function ArkInventory.Frame_Container_OnLoad( frame )
	
	-- not in combat yet so theres no taint here
	
	local framename = frame:GetName( )
	local loc_id = string.match( framename, "^.-(%d+)ScrollContainer" )
	
	assert( loc_id, string.format( "xml element '%s' is not an %s frame", framename, ArkInventory.Const.Program.Name ) )
	
	loc_id = tonumber( loc_id )
	
	frame.ARK_Data = {
		loc_id = loc_id,
	}
	
	
	-- pre-build a set amount of non tainted usable bag slots for the backpack to cater for entering the world when in combat
	if loc_id == ArkInventory.Const.Location.Bag then
		for bag_id = 1, ( NUM_BAG_SLOTS + 1 ) do
			local bagframename = string.format( "%sBag%s", frame:GetName( ), bag_id )
			local bagframe = CreateFrame( "Frame", bagframename, frame, "ARKINV_TemplateFrameBag" )
			bagframe:Hide( )
		end
	end
	
end

function ArkInventory.Frame_Scroll_OnLoad( frame )
	
	assert( frame, "frame is nil" )
	
	local framename = frame:GetName( )
	
	local loc_id = string.match( framename, "^.-(%d+)Scroll" )
	assert( loc_id, string.format( "xml element '%s' is not an %s frame", framename, ArkInventory.Const.Program.Name ) )
	loc_id = loc_id
	
	frame.ARK_Data = {
		loc_id = loc_id,
	}
	
	frame.stepSize = ArkInventory.Const.Frame.Scroll.stepSize
	
end

function ArkInventory.Frame_Bar_OnLoad( frame )
	
	assert( frame, "Frame_Bar_OnLoad( ) passed a nil frame" )
	
	local framename = frame:GetName( )
	local loc_id, bar_id = string.match( framename, "^.-(%d+)ScrollContainerBar(%d+)" )
	
	assert( loc_id, string.format( "xml element '%s' is not an %s frame", framename, ArkInventory.Const.Program.Name ) )
	assert( bar_id, string.format( "xml element '%s' is not an %s frame", framename, ArkInventory.Const.Program.Name ) )
	
	loc_id = tonumber( loc_id )
	bar_id = tonumber( bar_id )
	
	frame.ARK_Data = {
		loc_id = loc_id,
		bar_id = bar_id,
	}
	
	frame:SetID( bar_id )
	
	ArkInventory.MediaFrameDefaultFontSet( frame )
	
end

function ArkInventory.Frame_Bar_Paint_All( )

	--ArkInventory.Output( "Frame_Bar_Paint_All( )" )

	for loc_id, loc_data in pairs( ArkInventory.Global.Location ) do
		if loc_data.canView then
			
			c = _G[string.format( "%s%s%s", ArkInventory.Const.Frame.Main.Name, loc_id, ArkInventory.Const.Frame.Container.Name )]
			
			if c then
			
				for bar_id = 1, loc_data.maxBar do
					
					obj = _G[string.format( "%s%s%s", c:GetName( ), "Bar", bar_id )]
					
					if obj then
						ArkInventory.Frame_Bar_Paint( obj )
					end
					
				end
				
			end
			
		end
	end

end

function ArkInventory.Frame_Bar_Paint( frame )
	
	if not frame then return end
	
	local loc_id = frame.ARK_Data.loc_id
	local bar_id = frame.ARK_Data.bar_id
	local codex = ArkInventory.GetLocationCodex( loc_id )
	
	-- border
	local obj = frame.ArkBorder
	if obj then
		
		if codex.style.bar.border.style ~= ArkInventory.Const.Texture.BorderNone then
			
			local border = codex.style.bar.border.style or ArkInventory.Const.Texture.BorderDefault
			local file = ArkInventory.Lib.SharedMedia:Fetch( ArkInventory.Lib.SharedMedia.MediaType.BORDER, border )
			local size = codex.style.bar.border.size or ArkInventory.Const.Texture.Border[ArkInventory.Const.Texture.BorderDefault].size
			local offset = codex.style.bar.border.offset or ArkInventory.Const.Texture.Border[ArkInventory.Const.Texture.BorderDefault].offsetdefault.bar
			local scale = codex.style.bar.border.scale or 1
			
			local colour = nil
			if codex.layout.bar.data[bar_id].border.custom == 2 then
				colour = codex.layout.bar.data[bar_id].border.colour
			else
				colour = codex.style.bar.border.colour
			end
			
			ArkInventory.Frame_Border_Paint( obj, file, size, offset, scale, colour.r, colour.g, colour.b, 1 )
			
			obj:Show( )
			
		else
			
			obj:Hide( )
			
		end
		
	end
	
	
	-- background colour
	local obj = frame.ArkBackground
	if obj then
		
		local colour = codex.style.bar.background.colour
		
		if codex.layout.bar.data[bar_id].background.custom == 3 then
			
			-- use border colour
			if codex.layout.bar.data[bar_id].border.custom == 2 then
				-- use custom border colour
				colour = codex.layout.bar.data[bar_id].border.colour
			else
				-- use default border colour
				colour = codex.style.bar.border.colour
			end
			
		elseif codex.layout.bar.data[bar_id].background.custom == 2 then
			
			-- use custom background colour
			colour = codex.layout.bar.data[bar_id].background.colour
			
		end
		
		--frame:SetBackdropBorderColor( colour.r, colour.g, colour.b, colour.a )
		ArkInventory.SetTexture( obj, true, colour.r, colour.g, colour.b, colour.a )
		
	end
	
	
	-- edit mode bar number
	local obj = frame.ArkEdit
	if obj then
		
		if ArkInventory.Global.Mode.Edit then
			
			local padSlot = codex.style.slot.pad
			local padBarInternal = codex.style.bar.pad.internal
			local padLabel = codex.style.bar.name.show and ( codex.style.bar.name.height + padSlot ) or 0
			local slotAnchor = codex.style.slot.anchor
			
			obj:ClearAllPoints( )
			
			-- anchor to the opposite corner that items are
			if slotAnchor == ArkInventory.Const.Anchor.BottomLeft then
				obj:SetPoint( "TOPRIGHT", 0 - padBarInternal, 0 - padBarInternal - padLabel )
			elseif slotAnchor == ArkInventory.Const.Anchor.TopLeft then
				obj:SetPoint( "BOTTOMRIGHT", 0 - padBarInternal, padBarInternal + padLabel )
			elseif slotAnchor == ArkInventory.Const.Anchor.TopRight then
				obj:SetPoint( "BOTTOMLEFT", padBarInternal, padBarInternal + padLabel )
			else -- slotAnchor == ArkInventory.Const.Anchor.BottomRight then
				obj:SetPoint( "TOPLEFT", padBarInternal, 0 - padBarInternal - padLabel )
			end
			
			obj:Show( )
			
		else
			
			obj:Hide( )
			
		end
		
	end
	
	
	-- label
	ArkInventory.Frame_Bar_Label( frame )
	
end

function ArkInventory.Frame_Bar_Label( frame )
	
	local loc_id = frame.ARK_Data.loc_id
	local bar_id = frame.ARK_Data.bar_id
	local codex = ArkInventory.GetLocationCodex( loc_id )
	
	local obj = frame.ArkLabel
	
	if obj then
		
		local txt = codex.layout.bar.data[bar_id].name.text
		
		if txt and txt ~= "" and codex.style.bar.name.show and not codex.style.window.list then
			
			local padBarInternal = codex.style.bar.pad.internal
			local anchor = codex.style.bar.name.anchor
			
			if anchor == ArkInventory.Const.Anchor.Default then
				anchor = codex.style.slot.anchor
				if anchor == ArkInventory.Const.Anchor.TopLeft or anchor == ArkInventory.Const.Anchor.TopRight then
					anchor = ArkInventory.Const.Anchor.Bottom
				else
					anchor = ArkInventory.Const.Anchor.Top
				end
			end
			
			obj:ClearAllPoints( )
			
			if anchor == ArkInventory.Const.Anchor.Top then
				obj:SetPoint( "TOPLEFT", frame:GetName( ), padBarInternal, 0 - padBarInternal )
			else
				obj:SetPoint( "BOTTOMLEFT", frame:GetName( ), padBarInternal, padBarInternal )
			end
			obj:SetPoint( "RIGHT", frame:GetName( ), 0 - padBarInternal )
			
			obj:SetHeight( codex.style.bar.name.height )
			obj:SetText( txt )
			
			local colour = codex.style.bar.name.colour
			if codex.layout.bar.data[bar_id].name.custom == 2 then
				-- use custom colour
				colour = codex.layout.bar.data[bar_id].name.colour
			end
			obj:SetTextColor( colour.r, colour.g, colour.b )
			
			ArkInventory.MediaObjectFontSet( obj, nil, codex.style.bar.name.height )
			
			obj:Show( )
			
		else
		
			obj:Hide( )
			
		end
		
	end

end

function ArkInventory.Frame_Bar_DrawItems( frame )
	
	--ArkInventory.Output( "Frame_Bar_DrawItems( ", frame:GetName( ), " )" )
	
	local loc_id = frame.ARK_Data.loc_id
	
	if ArkInventory.Global.Location[loc_id].drawState > ArkInventory.Const.Window.Draw.Refresh then
		return
	end
	
	ArkInventory.ThreadYield_Window( loc_id )
	
	local codex = ArkInventory.GetLocationCodex( loc_id )
	
	local bar_id = frame.ARK_Data.bar_id
	local bar = codex.workpad.bar[bar_id]
	assert( bar, string.format( "workpad data for bar %d does not exist", bar_id ) )
	
--	ArkInventory.Output( "drawing ", codex.player.data.info.name, " - bar ", bar_id, ", count = ", bar.count, ", start = ", time( ) )
	
	if bar.count == 0 or bar.ghost then
		return
	end
	
	if ArkInventory.Global.Location[loc_id].drawState <= ArkInventory.Const.Window.Draw.Resort then
		
		--ArkInventory.Output( "resorting loc[", loc_id, "] state[", ArkInventory.Global.Location[loc_id].drawState, "] bar[", bar_id, "] @ ", time( ) )
		
		-- sort the items in the bar (cpu intensive)
		local bag_id
		local slot_id
		local i
		
		ArkInventory.ThreadYield_Window( loc_id )
		
		for j = 1, bar.count do
			bag_id = bar.item[j].bag
			slot_id = bar.item[j].slot
			i = codex.player.data.location[loc_id].bag[bag_id].slot[slot_id]
			bar.item[j].sortkey = ArkInventory.ItemSortKeyGenerate( i, bar_id, codex ) or "!"
			ArkInventory.ThreadYield_Window( loc_id )
		end
		
		
		local sid_def = codex.style.sort.method or 9999
		local sid = codex.layout.bar.data[bar_id].sort.method or sid_def
		
		if ArkInventory.db.option.sort.method.data[sid].used ~= "Y" then
			--ArkInventory.OutputWarning( "bar ", bar_id, " in location ", loc_id, " is using an invalid sort method.  resetting it to default" )
			codex.layout.bar.data[bar_id].sort.method = nil
			sid = sid_def
		end
		
		if ArkInventory.db.option.sort.method.data[sid].ascending then
			sort( bar.item, function( a, b ) return a.sortkey > b.sortkey end )
		else
			sort( bar.item, function( a, b ) return a.sortkey < b.sortkey end )
		end
		
		ArkInventory.ThreadYield_Window( loc_id )
		
	end
	
	
	
	-- DO NOT SCALE THESE VALUES
	local slotSize = codex.style.slot.size or ArkInventory.Const.SLOT_SIZE
	local slotAnchor = codex.style.slot.anchor
	
	if codex.style.window.list then
		if slotAnchor == ArkInventory.Const.Anchor.TopLeft or slotAnchor == ArkInventory.Const.Anchor.BottomLeft then
			slotAnchor = ArkInventory.Const.Anchor.TopLeft
		else
			slotAnchor = ArkInventory.Const.Anchor.TopRight
		end
	end
	
	local padSlot = codex.style.slot.pad
	local padBarInternal = codex.style.bar.pad.internal
	
	local padList = 0
	if codex.style.window.list then
		padList = ( codex.style.window.width - 1 ) * slotSize + ( codex.style.window.width - 2 ) * padSlot
	end
	
	local col = bar.width
	
	-- cycle through the items in the bar
	
	--ArkInventory.Output( "bar = ", bar_id, ", count = ", bar.count, " ,width=", bar.width )
	
	local itemOffsetX, itemOffsetY
	
	for j = 1, bar.count do
		
		--local i = codex.player.data.location[loc_id].bag[bar.item[j].bag].slot[bar.item[j].slot]
		local objname, obj = ArkInventory.ContainerItemNameGet( loc_id, bar.item[j].bag, bar.item[j].slot )
		assert( obj, string.format( "xml element '%s' is missing", objname ) )
		
		local matches = ArkInventory.Frame_Item_MatchesFilter( obj )
		
		if ( ArkInventory.Global.Location[loc_id].drawState <= ArkInventory.Const.Window.Draw.Resort ) or ( codex.style.window.list and ArkInventory.Global.Location[loc_id].drawState <= ArkInventory.Const.Window.Draw.Refresh ) then
			
			obj:ClearAllPoints( )
			obj:SetSize( slotSize, slotSize )
			
			if mod( ( j - 1 ), col ) == 0 then
				
				-- first item in a new row, set X offset
				itemOffsetX = padBarInternal
				
				if j == 1 then
					
					-- first row, first item, set Y offset
					itemOffsetY = padBarInternal
					
					-- increment Y offset if bar names are enabled
					if codex.style.bar.name.show and not codex.style.window.list then
						
						local nameAnchor = codex.style.bar.name.anchor
						
						if nameAnchor ~= ArkInventory.Const.Anchor.Default then
							
							local tempAnchor = ArkInventory.Const.Anchor.Top
							if slotAnchor == ArkInventory.Const.Anchor.BottomLeft or slotAnchor == ArkInventory.Const.Anchor.BottomRight then
								tempAnchor = ArkInventory.Const.Anchor.Bottom
							end
							
							if nameAnchor == tempAnchor then
								itemOffsetY = itemOffsetY + codex.style.bar.name.height + padSlot
							end
							
						end
						
					end
					
					if codex.style.window.list and not matches then
						-- cater for first entry in list view being hidden
						itemOffsetY = itemOffsetY - slotSize - padSlot
					end
					
				else
					
					-- next row, first item, increment Y offset
					if not ( codex.style.window.list and not matches ) then
						-- non matching items are hidden
						-- in list view that leaves gaps so dont increment the Y offset if this is list view and the item does not match
						itemOffsetY = itemOffsetY + slotSize + padSlot
					end
					
				end
				
			else
				
				-- same row, subsequent items, increment X offset
				-- list view only has a single item per row so wont get here
				
				itemOffsetX = itemOffsetX + slotSize + padSlot
				
			end
			
			--ArkInventory.Output( "item ", j, ", x=", itemOffsetX, ", y=", itemOffsetY )
			
			if slotAnchor == ArkInventory.Const.Anchor.BottomLeft then
				obj:SetPoint( "BOTTOMLEFT", frame, itemOffsetX, itemOffsetY )
			elseif slotAnchor == ArkInventory.Const.Anchor.TopLeft then
				obj:SetPoint( "TOPLEFT", frame, itemOffsetX, 0 - itemOffsetY )
			elseif slotAnchor == ArkInventory.Const.Anchor.TopRight then
				obj:SetPoint( "TOPRIGHT", frame, 0 - itemOffsetX, 0 - itemOffsetY )
			else -- slotAnchor == ArkInventory.Const.Anchor.BottomRight then
				obj:SetPoint( "BOTTOMRIGHT", frame, 0 - itemOffsetX, itemOffsetY )
			end
			
			local listobj = obj.ArkListEntry
			if listobj then
				
				if codex.style.window.list then
					
					listobj:ClearAllPoints( )
					
					listobj:SetPoint( "TOP", obj )
					listobj:SetPoint( "BOTTOM", obj )
					
					if slotAnchor == ArkInventory.Const.Anchor.TopLeft then
						listobj:SetPoint( "LEFT", obj, "RIGHT", padSlot, 0 )
					else
						listobj:SetPoint( "RIGHT", obj, "LEFT", 0 - padSlot, 0 )
					end
					
					listobj:SetWidth( padList )
					listobj:Show( )
					
				else
					
					listobj:Hide( )
					
				end
				
			end
			
		end
		
		if ArkInventory.Global.Location[loc_id].drawState <= ArkInventory.Const.Window.Draw.Refresh then
			
			ArkInventory.Frame_Item_Update( loc_id, bar.item[j].bag, bar.item[j].slot )
			
			if matches then
				obj.ARK_Data.displayed = true
				--obj:Show( )
			else
				obj.ARK_Data.displayed = nil
				--obj:Hide( )
			end
			
		end
		
		ArkInventory.ThreadYield_Window( loc_id )
		
	end
	
	if codex.style.window.list and ArkInventory.Global.Location[loc_id].drawState <= ArkInventory.Const.Window.Draw.Refresh then
		frame:GetParent( ):GetParent( ):UpdateScrollChildRect( )
		frame:GetParent( ):GetParent( ):SetVerticalScroll( 0 )
	end
	
end

function ArkInventory.Frame_Bar_Insert( loc_id, bar_id )
	
	local codex = ArkInventory.GetLocationCodex( loc_id )
	local t = codex.layout.bar.data
	table.insert( t, bar_id, ArkInventory.Table.Copy( t[0] ) )
	
	
	-- move category data (bar numbers can be negative)
	for cat, bar in pairs( codex.layout.category ) do
		if abs( bar ) >= bar_id then
			if bar > 0 then
				ArkInventory.CategoryLocationSet( loc_id, cat, bar + 1 )
			else
				ArkInventory.CategoryLocationSet( loc_id, cat, bar - 1 )
			end
		end
	end
	
	
	-- move bag assignment
	for bag_id in pairs( ArkInventory.Global.Location[loc_id].Bags ) do
		local z = codex.layout.bag[bag_id].bar
		if z and z >= bar_id then
			codex.layout.bag[bag_id].bar = z + 1
		end
	end
	
end

function ArkInventory.Frame_Bar_Remove( loc_id, bar_id )
	
	local codex = ArkInventory.GetLocationCodex( loc_id )
	local t = codex.layout.bar.data
	table.remove( t, bar_id )
	
	
	-- move category data (bar numbers can be negative)
	local cat_def = ArkInventory.CategoryGetSystemID( "SYSTEM_DEFAULT" )
	
	for cat, bar in pairs( codex.layout.category ) do
		if abs( bar ) > bar_id then
			if bar > 0 then
				ArkInventory.CategoryLocationSet( loc_id, cat, bar - 1 )
			else
				ArkInventory.CategoryLocationSet( loc_id, cat, bar + 1 )
			end
		elseif abs( bar ) == bar_id then
			if cat == cat_def then
				-- if the DEFAULT category was on the bar then move it to bar 1
				ArkInventory.CategoryLocationSet( loc_id, cat, 1 )
			else
				-- erase the location, setting it back to the same as DEFAULT
				ArkInventory.CategoryLocationSet( loc_id, cat, nil )
			end
		end
		
	end
	
	
	-- move bag assignment
	for bag_id in pairs( ArkInventory.Global.Location[loc_id].Bags ) do
		local z = codex.layout.bag[bag_id].bar
		if not z then
			-- do nothing
		elseif z > bar_id then
			codex.layout.bag[bag_id].bar = z - 1
		elseif z == bar_id then
			codex.layout.bag[bag_id].bar = nil
		end
	end
	
end

function ArkInventory.Frame_Bar_Move( loc_id, bar1, bar2 )
	
	--ArkInventory.Output( "loc [", loc_id, "], bar1 [", bar1, "], bar2 [", bar2, "]" )
	
	if not bar1 or not bar2 or bar1 == bar2 or bar1 < 1 or bar2 < 1 then return end
	
	local codex = ArkInventory.GetLocationCodex( loc_id )
	local t = codex.layout.bar.data
	
	local step = 1
	if bar2 < bar1 then
		step = -1
		table.insert( t, bar2, ArkInventory.Table.Copy( t[bar1] ) )
		table.remove( t, bar1 + 1 )
	else
		table.insert( t, bar2 + 1, ArkInventory.Table.Copy( t[bar1] ) )
		table.remove( t, bar1 )
	end
	
	
	-- move category data (bar numbers can be negative)
	for cat, bar in pairs( codex.layout.category ) do
		local z = abs( bar )
		if z == bar1 then
			ArkInventory.CategoryLocationSet( loc_id, cat, bar2 )
		elseif ( ( step == 1 ) and ( z > bar1 and z <= bar2 ) ) or ( ( step == -1 ) and ( z >= bar2 and z < bar1 ) ) then
			if bar > 0 then
				ArkInventory.CategoryLocationSet( loc_id, cat, bar - step )
			else
				ArkInventory.CategoryLocationSet( loc_id, cat, bar + step )
			end
		end
	end
	
	-- move bag assignment
	for bag_id in pairs( ArkInventory.Global.Location[loc_id].Bags ) do
		local z = codex.layout.bag[bag_id].bar
		if not z then
			-- do nothing
		elseif z == bar1 then
			codex.layout.bag[bag_id].bar = bar2
		elseif ( ( step == 1 ) and ( z > bar1 and z <= bar2 ) ) or ( ( step == -1 ) and ( z >= bar2 and z < bar1 ) ) then
			codex.layout.bag[bag_id].bar = z - step
		end
	end
	
end

function ArkInventory.Frame_Bar_Clear( loc_id, bar_id )
	
	local codex = ArkInventory.GetLocationCodex( loc_id )
	
	-- clear bar data
	codex.layout.bar.data[bar_id] = ArkInventory.Table.Copy( codex.layout.bar.data[0] )
	
	-- clear category
	for k, v in pairs( codex.layout.category ) do
		if v == bar_id then
			local cat_def = ArkInventory.CategoryGetSystemID( "SYSTEM_DEFAULT" )
			if k ~= cat_def then
				-- erase the location, setting it back to the same as DEFAULT
				ArkInventory.CategoryLocationSet( loc_id, k, nil )
			end
		end
	end
	
	-- clear bag assignment
	for bag_id in pairs( ArkInventory.Global.Location[loc_id].Bags ) do
		if codex.layout.bag[bag_id].bar == bar_id then
			codex.layout.bag[bag_id].bar = nil
		end
	end
	
end


function ArkInventory.Frame_Bar_Edit_OnLoad( frame )
	
	assert( frame, "frame is missing" )
	
	local framename = frame:GetName( )
	local loc_id, bar_id = string.match( framename, "^.-(%d+)ScrollContainerBar(%d+)" )
	
	assert( loc_id, string.format( "xml element '%s' is not an %s frame", framename, ArkInventory.Const.Program.Name ) )
	assert( bar_id, string.format( "xml element '%s' is not an %s frame", framename, ArkInventory.Const.Program.Name ) )
	
	loc_id = tonumber( loc_id )
	bar_id = tonumber( bar_id )
	
	frame.ARK_Data = {
		loc_id = loc_id,
		bar_id = bar_id,
	}
	
	frame:SetID( bar_id )
	
	-- <START> because blizzard sometimes forgets to turn things off by default
	
	if frame.NewItemTexture then
		frame.NewItemTexture:Hide( )
	end
	
	if frame.BattlepayItemTexture then
		frame.BattlepayItemTexture:Hide( )
	end
	
	-- <END> because blizzard sometimes forgets to turn things off by default
	
	ArkInventory.MediaFrameDefaultFontSet( frame )
	
	ArkInventory.SetItemButtonTexture( frame, [[Interface\Buttons\WHITE8X8]] )
	SetItemButtonTextureVertexColor( frame, 0.5, 0.1, 0.1, 0.3 )
	
	frame:RegisterForClicks( "LeftButtonUp", "RightButtonUp" )
	frame:RegisterForDrag( "LeftButton" )
	
end

function ArkInventory.Frame_Bar_Edit_OnClick( frame, button )
	
	--ArkInventory.Output( "OnClick( ", frame:GetName( ), ", ", button, " )" )
	
	local loc_id = frame.ARK_Data.loc_id
	local bar_id = frame.ARK_Data.bar_id
	
	if button then
		ArkInventory.MenuBarOpen( frame )
	end
	
end

function ArkInventory.Frame_Bar_Edit_OnDragStart( frame )
	
	local loc_id = frame.ARK_Data.loc_id
	local bar_id = frame.ARK_Data.bar_id
	
	--ArkInventory.Output( "drag start for bar ", loc_id, ".", bar_id )
	
	ArkInventory.Global.Options.BarMoveLocation = loc_id
	ArkInventory.Global.Options.BarMoveSource = bar_id
	
end

function ArkInventory.Frame_Bar_Edit_OnDragReceive( frame )
	
	local loc_id = frame.ARK_Data.loc_id
	local bar_id = frame.ARK_Data.bar_id
	
	--ArkInventory.Output( "drag receive for bar ", loc_id, ".", bar_id )
	
	if ArkInventory.Global.Options.BarMoveLocation and ArkInventory.Global.Options.BarMoveSource then
		
		if ArkInventory.Global.Options.BarMoveLocation == loc_id and ArkInventory.Global.Options.BarMoveSource ~= bar_id then
			ArkInventory.Frame_Bar_Move( loc_id, ArkInventory.Global.Options.BarMoveSource, bar_id )
			ArkInventory.Global.Options.BarMoveInProgress = false
			ArkInventory.Global.Options.BarMoveLocation = nil
			ArkInventory.Global.Options.BarMoveSource = nil
			--ArkInventory.OutputWarning( "Frame_Bar_Edit_OnDragReceive - .Recalculate" )
			ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Recalculate )
		else
			if ArkInventory.Global.Options.BarMoveLocation == loc_id then
				ArkInventory.OutputWarning( ArkInventory.Localise["MENU_BAR_MOVE_FAIL_SAME"] )
			else
				ArkInventory.OutputWarning( ArkInventory.Localise["MENU_BAR_MOVE_FAIL_OUTSIDE"] )
			end
		end
		
	end
	
end


function ArkInventory.Frame_Bag_OnLoad( frame )

	assert( frame, "Frame_Bag_OnLoad( ) passed a nil frame" )

	local framename = frame:GetName( )
	local loc_id, bag_id = string.match( framename, "^.-(%d+)ScrollContainerBag(%d+)" )
	
	assert( loc_id, string.format( "xml element '%s' is not an %s frame", framename, ArkInventory.Const.Program.Name ) )
	assert( bag_id, string.format( "xml element '%s' is not an %s frame", framename, ArkInventory.Const.Program.Name ) )
	
	loc_id = tonumber( loc_id )
	bag_id = tonumber( bag_id )
	--local inv_id = ArkInventory.InventoryIDGet( loc_id, bag_id )
	
	frame.ARK_Data = {
		loc_id = loc_id,
		bag_id = bag_id,
		blizzard_id = ArkInventory.InternalIdToBlizzardBagId( loc_id, bag_id ),
		--["inv_id"] = inv_id,
	}
	
	frame:SetID( frame.ARK_Data.blizzard_id )
	
	-- pre-build a set amount of non tainted usable item slots for the backpack to cater for entering the world when in combat
	if loc_id == ArkInventory.Const.Location.Bag then
		ArkInventory.Global.Location[loc_id].maxSlot[bag_id] = MAX_CONTAINER_ITEMS
		for slot_id = 1, MAX_CONTAINER_ITEMS do
			local itemframename = ArkInventory.ContainerItemNameGet( loc_id, bag_id, slot_id )
			local itemframe = CreateFrame( "Button", itemframename, frame, ArkInventory.Global.Location[loc_id].template or "ARKINV_TemplateButtonItem" )
			itemframe:Hide( )
		end
	end
	
	ArkInventory.MediaFrameDefaultFontSet( frame )
	
end


function ArkInventory.SetTexture( obj, texture, r, g, b, a, c )
	
	if not obj then
		return
	end
	
	if texture then
		obj:Show( )
	else
		obj:Hide( )
		return
	end
	
	if texture == true then
		-- solid colour
		obj:SetColorTexture( r or 0, g or 0, b or 0, a or 1 )
	else
		if c then
			SetPortraitToTexture( obj, texture or ArkInventory.Const.Texture.Missing )
		else
			obj:SetTexture( texture or ArkInventory.Const.Texture.Missing )
			if r and g and b then
				obj:SetVertexColor( r, g, b )
			end
		end
	end
	
end

function ArkInventory.SetItemButtonTexture( frame, texture, r, g, b, a, c )
	
	if not frame then
		return
	end
	
	local obj = frame.icon
	
	if not obj then
		return
	end
	
	ArkInventory.SetTexture( obj, texture, r, g, b, a, c )
	
	--obj:SetTexCoord( 0.075, 0.935, 0.075, 0.935 )
	obj:SetTexCoord( 0.075, 0.925, 0.075, 0.925 )
	
end

function ArkInventory.SetItemButtonDesaturate( frame, desaturate, r, g, b )

	if not frame then
		return
	end
	
	local obj = frame.icon
	
	if not obj then
		return
	end
	
	local shaderSupported = obj:SetDesaturated( desaturate )
	
	if desaturate then
	
		if shaderSupported then
			return
		end
		
		if not r or not g or not b then
			r = 0.5
			g = 0.5
			b = 0.5
		end
		
	else

		if not r or not g or not b then
			r = 1.0
			g = 1.0
			b = 1.0
		end
		
	end
	
	obj:SetVertexColor( r, g, b )
	
end


function ArkInventory.Frame_Item_GetDB( frame )
	
	assert( frame.ARK_Data, " invalid frame" )
	
	--ArkInventory.Output( "frame=[", frame:GetName( ), "]" )
	local loc_id = frame.ARK_Data.loc_id
	local bag_id = frame.ARK_Data.bag_id
	local slot_id = frame.ARK_Data.slot_id
	
	local codex = ArkInventory.GetLocationCodex( loc_id )
	
	--ArkInventory.Output( codex.player.current, " / ", codex.player.data.info.player_id )
	--ArkInventory.Output( "loc=[", loc_id, "], bag=[", bag_id, "], slot=[", slot_id, "]" )
	
	if slot_id == nil then
		return codex.player.data.location[loc_id].bag[bag_id]
	else
		return codex.player.data.location[loc_id].bag[bag_id].slot[slot_id]
	end
	
end
	
function ArkInventory.Frame_Item_Update_Texture( frame )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local loc_id = frame.ARK_Data.loc_id
	local i = ArkInventory.Frame_Item_GetDB( frame )
	
	if i and i.h then
		
		-- frame has an item
		frame.hasItem = 1
		
		-- item is readable?
		if loc_id ~= ArkInventory.Const.Location.Vault then
			if not ArkInventory.Global.Location[loc_id].isOffline then
				frame.readable = i.r
			end
		else
			frame.readable = nil
		end
		
		-- item texture
		local t = i.texture or ArkInventory.ObjectInfoTexture( i.h )
		ArkInventory.SetItemButtonTexture( frame, t )
	
	else
		
		frame.hasItem = nil
		frame.readable = nil
		
		ArkInventory.Frame_Item_Update_Empty( frame )
		
	end
	
	ArkInventory.Frame_Item_Update_New( frame )
	
end

function ArkInventory.Frame_Item_Update_Quest( frame )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local obj = _G[frame:GetName( ) .. "IconQuestTexture"]
	if not obj then return end
	
	local loc_id = frame.ARK_Data.loc_id
	if ( loc_id == ArkInventory.Const.Location.Bag or loc_id == ArkInventory.Const.Location.Bank ) and not ArkInventory.Global.Location[loc_id].isOffline then
		
		local i = ArkInventory.Frame_Item_GetDB( frame )
		
		if i and i.h then
			
			local isQuestItem, questId, isActive = GetContainerItemQuestInfo( frame.ARK_Data.blizzard_id, frame.ARK_Data.slot_id )
			
			if questId then
				
				local codex = ArkInventory.GetLocationCodex( loc_id )
			
				if not isActive then
					if codex.style.slot.quest.bang then
						ArkInventory.SetTexture( obj, TEXTURE_ITEM_QUEST_BANG )
						return
					end
				elseif isQuestItem then
					if codex.style.slot.quest.border then
						ArkInventory.SetTexture( obj, TEXTURE_ITEM_QUEST_BORDER )
						return
					end
				end
				
			end
			
		end
		
	end
	
	obj:Hide( )
	
end

function ArkInventory.Frame_Item_Update_StatusIconUpgrade( frame )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local obj = frame.UpgradeIcon
	if not obj then return end
	
	local loc_id = frame.ARK_Data.loc_id
	if ( loc_id == ArkInventory.Const.Location.Bag or loc_id == ArkInventory.Const.Location.Bank ) and not ArkInventory.Global.Location[loc_id].isOffline then
		
		local i = ArkInventory.Frame_Item_GetDB( frame )
		if i and i.h then
			
			local codex = ArkInventory.GetLocationCodex( loc_id )
			
			if codex.style.slot.upgradeicon.show then
				
				ContainerFrameItemButton_UpdateItemUpgradeIcon( frame )
				return
				
			end
			
		end
		
	end
	
	obj:Hide( )
	
end

function ArkInventory.Frame_Item_Update_StatusIconUpgrade_Anchor( frame )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local obj = frame.UpgradeIcon
	if not obj then return end
	
	local loc_id = frame.ARK_Data.loc_id
	local codex = ArkInventory.GetLocationCodex( loc_id )
	
	if not codex.style.slot.upgradeicon.show then return end
	
	local anchor = codex.style.slot.upgradeicon.anchor
	local anchorpoint = "BOTTOMLEFT"
	local x, y = -3, -3
	
	if anchor == ArkInventory.Const.Anchor.BottomRight then
		anchorpoint = "BOTTOMRIGHT"
		x, y = 3, -3
	elseif anchor == ArkInventory.Const.Anchor.TopLeft then
		anchorpoint = "TOPLEFT"
		x, y = -3, 3
	elseif anchor == ArkInventory.Const.Anchor.TopRight then
		anchorpoint = "TOPRIGHT"
		x, y = 3, 3
	end
	
	obj:ClearAllPoints( )
	obj:SetPoint( anchorpoint, frame, x, y )
	
end

function ArkInventory.Frame_Item_Update_StatusIconJunk( frame )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local obj = frame.JunkIcon
	if not obj then return end
	
	local loc_id = frame.ARK_Data.loc_id
	if ( loc_id == ArkInventory.Const.Location.Bag or loc_id == ArkInventory.Const.Location.Bank ) and not ArkInventory.Global.Location[loc_id].isOffline then
		
		local i = ArkInventory.Frame_Item_GetDB( frame )
		if i and i.h then
			
			local codex = ArkInventory.GetLocationCodex( loc_id )
			
			if codex.style.slot.junkicon.show then
				
				local isJunk, vendorPrice = ArkInventory.JunkCheck( i, codex )
				
				if isJunk then
					obj:Show( )
					return
				end
				
			end
			
		end
		
	end
	
	obj:Hide( )
	
end

function ArkInventory.Frame_Item_Update_StatusIconJunk_Anchor( frame )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local obj = frame.JunkIcon
	if not obj then return end
	
	local loc_id = frame.ARK_Data.loc_id
	local codex = ArkInventory.GetLocationCodex( loc_id )
	
	if not codex.style.slot.junkicon.show then return end
	
	local anchor = codex.style.slot.junkicon.anchor
	local anchorpoint = "TOPRIGHT"
	local x, y = 3, 3
	
	if anchor == ArkInventory.Const.Anchor.BottomRight then
		anchorpoint = "BOTTOMRIGHT"
		x, y = 3, -3
	elseif anchor == ArkInventory.Const.Anchor.BottomLeft then
		anchorpoint = "BOTTOMLEFT"
		x, y = -3, -3
	elseif anchor == ArkInventory.Const.Anchor.TopLeft then
		anchorpoint = "TOPLEFT"
		x, y = -3, 3
	end
	
	obj:ClearAllPoints( )
	obj:SetPoint( anchorpoint, frame, x, y )
	
end

function ArkInventory.ItemTransmogState( h, sb, loc_id, rule )
	
--	if h and sb == ArkInventory.Const.Bind.Pickup and not ArkInventory.Global.Location[loc_id].isOffline then
--		return random( 4 )
--	end
			
	if h and sb == ArkInventory.Const.Bind.Equip and not ArkInventory.Global.Location[loc_id].isOffline then
		
		local visualID, sourceID = C_TransmogCollection.GetItemInfo( h )
		if visualID and sourceID then
			
			--ArkInventory.Output( h, " ", visualID, " / ", sourceID )
			
			-- this item has an appearance
			
--			local codex = ArkInventory.GetLocationCodex( loc_id )
--			if codex.style.slot.transmogicon.show or rule then
			if ArkInventory.db.option.transmog.enable or rule then
				
				local sourceMe = { } -- sources i can collect
				local sourceOther = { } -- sources i cannot collect
				
				local itemInfo = { GetItemInfoInstant( h ) }
				local itemSubType = itemInfo[7] or -2
				local invType = itemInfo[4] or -2
				
				local source = C_TransmogCollection.GetAllAppearanceSources( visualID )
				for _, id in pairs( source ) do
					
					local isInfoReady, canCollect = C_TransmogCollection.PlayerCanCollectSource( id )
					if isInfoReady then
						
						local info = C_TransmogCollection.GetSourceInfo( id )
						
						if canCollect then
							
							sourceMe[id] = info
							
						else
							
							local itemInfo = { GetItemInfoInstant( info.itemID ) }
							
							if itemSubType == itemInfo[7] then
								-- only add sources that match the sub type of the item
								sourceOther[id] = info
							end
							
						end
						
					end
					
				end
				
				
				local collectedMe = false
				local collectedMeFromThisItem = false
				
				if sourceMe[sourceID] then
					
					-- this character can collect this appearance
					-- check if the appearance hasn't been collected
					
					for id, info in pairs( sourceMe ) do
						if info.isCollected then
							collectedMe = true
							if id == sourceID then
								collectedMeFromThisItem = true
							end
						end
					end
					
					if not collectedMe then
						
						--ArkInventory.Output( h, " unknown, learn it" )
						
						-- can be learnt by this character
						return ArkInventory.Const.Transmog.State.CanLearnMyself
						
					end
					
				end
				
				
				local collectedOther = false
				local collectedOtherFromThisItem = false
				
				if sourceOther[sourceID] then
					
					-- cant be learnt by this character, another character may be able to collect it
					
					for id, info in pairs( sourceOther ) do
						if info.isCollected then
							collectedOther = true
							if id == sourceID then
								collectedOtherFromThisItem = true
							end
						end
					end
					
					if not collectedOther then
						
						--ArkInventory.Output( h, " unknown, send to another character" )
						
						-- can be learnt by another character
						return ArkInventory.Const.Transmog.State.CanLearnOther
						
					end
					
				end
				
				--if codex.style.slot.transmogicon.alternative or rule then
				if ArkInventory.db.option.transmog.secondary then
					
					if collectedMe and not collectedMeFromThisItem then
						
						--ArkInventory.Output( h, " learnt, from another item" )
						
						-- already known on this character but from another item, learn this one as well?
						return ArkInventory.Const.Transmog.State.CanLearnMyselfSecondary
						
					end
					
					if collectedOther and not collectedOtherFromThisItem then
						
						--ArkInventory.Output( h, " learnt, from another item, send to another character" )
						
						-- already known on another character but from another item, learn this one as well?
						return ArkInventory.Const.Transmog.State.CanLearnOtherSecondary
						
					end
					
				end
				
			end
			
		end
		
	end
	
	return false
	
end

function ArkInventory.Frame_Item_Update_StatusIconTransmog( frame )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local obj = frame.ArkTransmogIcon or _G[frame:GetName( ).."ArkTransmogIcon"]
	if not obj then return end
	
	local i = ArkInventory.Frame_Item_GetDB( frame )
	
	local state	= ArkInventory.ItemTransmogState( i.h, i.sb, i.loc_id )
	if state then
		
		local info = ArkInventory.db.option.transmog.icon[state]
		local file = ArkInventory.Lib.SharedMedia:Fetch( ArkInventory.Const.Transmog.SharedMediaType, info.style )
		ArkInventory.SetTexture( obj, file, info.colour.r, info.colour.g, info.colour.b, info.colour.a )
		return
		
	end
	
	obj:Hide( )
	
end

function ArkInventory.Frame_Item_Update_StatusIconTransmog_Anchor( frame )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local obj = frame.ArkTransmogIcon or _G[frame:GetName( ).."ArkTransmogIcon"]
	if not obj then return end
	
	local loc_id = frame.ARK_Data.loc_id
	--local codex = ArkInventory.GetLocationCodex( loc_id )
	
	--if not codex.style.slot.transmogicon.show then return end
	if not ArkInventory.db.option.transmog.enable then return end
	
	local anchor = ArkInventory.db.option.transmog.anchor
	local anchorpoint = "BOTTOMLEFT"
	local x, y = 2, 2
	
	if anchor == ArkInventory.Const.Anchor.BottomRight then
		anchorpoint = "BOTTOMRIGHT"
		x, y = -2, 2
	elseif anchor == ArkInventory.Const.Anchor.TopLeft then
		anchorpoint = "TOPLEFT"
		x, y = 2, -2
	elseif anchor == ArkInventory.Const.Anchor.TopRight then
		anchorpoint = "TOPRIGHT"
		x, y = -2, -2
	end
	
	obj:ClearAllPoints( )
	obj:SetPoint( anchorpoint, frame, 0, 0 )
	
end

function ArkInventory.Frame_Item_Update_Count( frame )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local obj = frame.Count or _G[frame:GetName( ).."Count"]
	if not obj then return end
	
	local i = ArkInventory.Frame_Item_GetDB( frame )
	
	frame.count = 0
	
	if i and i.h then
		
		local codex = ArkInventory.GetLocationCodex( i.loc_id )
		if codex.style.slot.itemcount.show and not codex.style.window.list then
			
			local osd = ArkInventory.ObjectStringDecode( i.h )
			local count = i.count or 0
			frame.count = count
			
			if osd.class == "battlepet" then
				count = osd.level
			end
			
			local more = 0
			
			if codex.style.slot.compress.count > 0 and codex.style.slot.compress.identify and not ArkInventory.Global.Options.ShowHiddenItems then
				
				local info = ArkInventory.ObjectInfoArray( i.h )
				if info.stacksize > 1 then
					
					local loc_id = frame.ARK_Data.loc_id
					local player = ArkInventory.GetPlayerInfo( )
					local search_id = ArkInventory.ObjectIDCount( i.h )
					
					if not ( ArkInventory.Global.Cache.ItemCountRaw[search_id] and ArkInventory.Global.Cache.ItemCountRaw[search_id][player.player_id] ) then
						ArkInventory.ObjectCountGetRaw( search_id )
					end
					
					if ArkInventory.Global.Cache.ItemCountRaw[search_id] and ArkInventory.Global.Cache.ItemCountRaw[search_id][player.player_id] and ArkInventory.Global.Cache.ItemCountRaw[search_id][player.player_id].location[loc_id] then
						more = ArkInventory.Global.Cache.ItemCountRaw[search_id][player.player_id].location[loc_id].s
						if more <= codex.style.slot.compress.count then
							more = 0
						end
					end
					
				end
				
			end
			
			if osd.class == "battlepet" or count > 1 or more > 0 or ( frame.isBag and count > 0 ) then
				
				if count > ( frame.maxDisplayCount or 9999 ) then
					count = "***"
				end
				
				if more > 0 then
					if codex.style.slot.compress.position == 1 then
						count = "+" .. count
					else
						count = count .. "+"
					end
				end
				
				obj:SetText( count )
				
				local colour = codex.style.slot.itemcount.colour
				obj:SetTextColor( colour.r, colour.g, colour.b )
				
				ArkInventory.MediaObjectFontSet( obj, nil, codex.style.slot.itemcount.font.height )
				
				obj:Show( )
				
				return
				
			end
			
		end
		
	end
	
	obj:Hide( )
	
end

function ArkInventory.Frame_Item_Update_Count_Anchor( frame )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local obj = frame.Count or _G[frame:GetName( ).."Count"]
	if not obj then return end
	
	local loc_id = frame.ARK_Data.loc_id
	local codex = ArkInventory.GetLocationCodex( loc_id )
	
	if not codex.style.slot.itemcount.show then return end
	
	local anchor = codex.style.slot.itemcount.anchor
	local anchorpoint = "BOTTOMRIGHT"
	
	if anchor == ArkInventory.Const.Anchor.BottomLeft then
		anchorpoint = "BOTTOMLEFT"
	elseif anchor == ArkInventory.Const.Anchor.TopLeft then
		anchorpoint = "TOPLEFT"
	elseif anchor == ArkInventory.Const.Anchor.TopRight then
		anchorpoint = "TOPRIGHT"
	end
	
	obj:ClearAllPoints( )
	obj:SetPoint( anchorpoint, frame )
	
end

function ArkInventory.Frame_Item_Update_Stock( frame )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local obj = frame.Stock or _G[frame:GetName( ).."Stock"]
	if not obj then return end
	
	local i = ArkInventory.Frame_Item_GetDB( frame )
	
	if i and i.h then
		
		local stock = 0
		local codex = ArkInventory.GetLocationCodex( i.loc_id )
		
		if codex.style.slot.itemlevel.show then
			
			local info = ArkInventory.ObjectInfoArray( i.h, i )
			
			if info.class == "item" then
				
				-- equipable items
				if info.equiploc ~= "" and info.equiploc ~= "INVTYPE_BAG" and info.ilvl >= codex.style.slot.itemlevel.min then
					stock = info.ilvl
				end
				
				-- artifact relics
				if info.itemtypeid == ArkInventory.Const.ItemClass.GEM and info.itemsubtypeid == ArkInventory.Const.ItemClass.GEM_ARTIFACT_RELIC then
					stock = info.ilvl
				end
				
				-- artifact power and ancient mana
				if info.itemtypeid == ArkInventory.Const.ItemClass.CONSUMABLE and info.itemsubtypeid == ArkInventory.Const.ItemClass.CONSUMABLE_OTHER then
					
					stock = ArkInventory.TooltipExtractValueArtifactPower( i.h ) or 0
					
					if stock == 0 then
						stock = ArkInventory.TooltipExtractValueAncientMana( i.h ) or 0
					end
					
				end
				
			elseif info.class == "keystone" then
				
				stock = info.ilvl
				
			end
			
			if stock > 0 then
				
				if stock > ( frame.maxDisplayCount or 9999 ) then
					
					if stock >= 1000000000000 then
						stock = string.format( "%.0f%s", stock / 1000000000000, ArkInventory.Localise["WOW_ITEM_TOOLTIP_10P12S"] )
					elseif stock >= 1000000000 then
						stock = string.format( "%.0f%s", stock / 1000000000, ArkInventory.Localise["WOW_ITEM_TOOLTIP_10P9S"] )
					elseif stock >= 1000000 then
						stock = string.format( "%.0f%s", stock / 1000000, ArkInventory.Localise["WOW_ITEM_TOOLTIP_10P6S"] )
					elseif stock > 9999 then
						stock = string.format( "%.0f%s", stock / 1000, ArkInventory.Localise["WOW_ITEM_TOOLTIP_10P3S"] )
					else
						stock = string.format( "%.0f", stock )
					end
					
				else
					
					stock = string.format( "%.0f", stock )
					
				end
				
				obj:SetText( stock )
				
				local colour = codex.style.slot.itemlevel.colour
				obj:SetTextColor( colour.r, colour.g, colour.b )
				
				ArkInventory.MediaObjectFontSet( obj, nil, codex.style.slot.itemlevel.font.height )
				
				obj:Show( )
				
				return
				
			end
			
		end
		
	end
	
	obj:Hide( )
	
end

function ArkInventory.Frame_Item_Update_Stock_Anchor( frame )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local obj = frame.Stock or _G[frame:GetName( ).."Stock"]
	if not obj then return end
	
	local loc_id = frame.ARK_Data.loc_id
	local codex = ArkInventory.GetLocationCodex( loc_id )
	
	if not codex.style.slot.itemlevel.show then return end
	
	local anchor = codex.style.slot.itemlevel.anchor
	local anchorpoint = "TOPLEFT"
	
	if anchor == ArkInventory.Const.Anchor.BottomRight then
		anchorpoint = "BOTTOMRIGHT"
	elseif anchor == ArkInventory.Const.Anchor.BottomLeft then
		anchorpoint = "BOTTOMLEFT"
	elseif anchor == ArkInventory.Const.Anchor.TopRight then
		anchorpoint = "TOPRIGHT"
	end
	
	obj:ClearAllPoints( )
	obj:SetPoint( anchorpoint, frame )
	
end

function ArkInventory.Frame_Item_MatchesFilter( frame )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local loc_id = frame.ARK_Data.loc_id
	local matches = false
	
	local f = string.trim( string.lower( ArkInventory.Global.Location[loc_id].filter or "" ) )
	
	f = ArkInventory.Search.CleanText( f )
	
	if f == "" then
		return true
	end
	
	local i = ArkInventory.Frame_Item_GetDB( frame )
	if not i or not i.h then
		return false
	end
	
	local txt = ArkInventory.Search.GetContent( i.h, i )
	
	if string.find( txt, f, nil, true ) then
		return true
	end
	
end

function ArkInventory.Frame_Item_Update_Fade( frame, changer )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local loc_id = frame.ARK_Data.loc_id
	local bag_id = frame.ARK_Data.bag_id
	local codex = ArkInventory.GetLocationCodex( loc_id )
	local alpha = 1
	
	if ArkInventory.Global.Location[loc_id].isOffline then
		if codex.style.slot.offline.fade then
			alpha = 0.6
		end
	end
	
	if loc_id == ArkInventory.Const.Location.Vault and changer then
		if codex.player.data.option[loc_id].bag[bag_id].display == false then
			alpha = 0.4
		end
	end
	
	frame:SetAlpha( alpha )
	
end

function ArkInventory.Frame_Item_Update_Border( frame, changer )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	--ArkInventory.Output( frame.ARK_Data.loc_id, ".", frame.ARK_Data.bag_id, ".", frame.ARK_Data.slot_id )
	
	local obj = frame.ArkBorder
	if obj then
		
		local loc_id = frame.ARK_Data.loc_id
		local codex = ArkInventory.GetLocationCodex( loc_id )
		
		if codex.style.slot.border.style ~= ArkInventory.Const.Texture.BorderNone then
			
			local border = codex.style.slot.border.style or ArkInventory.Const.Texture.BorderDefault
			local file = ArkInventory.Lib.SharedMedia:Fetch( ArkInventory.Lib.SharedMedia.MediaType.BORDER, border )
			local size = codex.style.slot.border.size or ArkInventory.Const.Texture.Border[ArkInventory.Const.Texture.BorderDefault].size
			local offset = codex.style.slot.border.offset or ArkInventory.Const.Texture.Border[ArkInventory.Const.Texture.BorderDefault].offsetdefault.slot
			local scale = codex.style.slot.border.scale or 1
			
			-- border colour
			local i = ArkInventory.Frame_Item_GetDB( frame )
			
			local r, g, b = ArkInventory.GetItemQualityColor( LE_ITEM_QUALITY_POOR )
			local a = 0.6
			
			if i and i.h then
				
				if codex.style.slot.border.rarity then
					if ( i.q or LE_ITEM_QUALITY_POOR ) >= ( codex.style.slot.border.raritycutoff or LE_ITEM_QUALITY_POOR ) then
						r, g, b = ArkInventory.GetItemQualityColor( i.q or LE_ITEM_QUALITY_POOR )
						if not frame.locked then
							a = 1
						end
					end
				end
				
			else
				
				if codex.style.slot.empty.border then
					
					if changer then
						
						r, g, b = ArkInventory.GetItemQualityColor( LE_ITEM_QUALITY_ARTIFACT )
						
					else
						
						local bag_id = frame.ARK_Data.bag_id
						local bt = codex.player.data.location[loc_id].bag[bag_id].type
						
						local c = codex.style.slot.data[bt].colour
						r, g, b = c.r, c.g, c.b
						
					end
					
				end
				
			end
			
			ArkInventory.Frame_Border_Paint( obj, file, size, offset, scale, r, g, b, a )
			
			obj:Show( )
			
		else
		
			obj:Hide( )
			
		end
		
	end
	
end

function ArkInventory.Frame_Item_Update_List( frame, show )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local obj = frame.ArkListEntry
	if obj then
		
		if show then
			
			ArkInventory.Frame_Item_Update_Border( obj )
			ArkInventory.Frame_Item_Update_List_Text( obj )
			
		else
			
			obj:Hide( )
			
		end
		
	end
	
end

function ArkInventory.Frame_Item_Update_List_Text( frame )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local i = ArkInventory.Frame_Item_GetDB( frame )
	
	if frame.Text1 and frame.Text2 then
		
		local txt1 = ""
		local txt2 = ""
		local txt3 = ""
		
		if i then
			
			local loc_id = frame.ARK_Data.loc_id
			local osd = ArkInventory.ObjectStringDecode( i.h )
			
			if osd.class == "currency" then
				
				local info = ArkInventory.Collection.Currency.GetCurrency( osd.id )
				if not info then
					
					txt1 = string.format( "no currency data found for [%s]", osd.id or "nil" )
					
				else
					
					txt1 = info.name
					
					if info.maximumAmount > 0 then
						txt2 = string.format( CURRENCY_TOTAL_CAP, "", FormatLargeNumber( info.currentAmount ), FormatLargeNumber( info.maximumAmount ) )
					else
						txt2 = string.format( CURRENCY_TOTAL, "", FormatLargeNumber( info.currentAmount ) )
					end
					
					if info.weeklyLimit > 0 then
						local weekly = string.format( CURRENCY_WEEKLY_CAP, "", FormatLargeNumber( info.currentWeeklyAmount ), FormatLargeNumber( info.weeklyLimit ) )
						txt2 = string.format( "%s\n%s", weekly, txt2 )
					end
					
				end
				
			elseif osd.class == "reputation" then
				
				local info = ArkInventory.Collection.Reputation.GetReputation( osd.id )
				if not info then
					txt1 = string.format( "no reputation data found for [%s]", osd.id or "nil" )
				else
					txt1 = info.name
					txt2 = ArkInventory.Collection.Reputation.LevelText( osd.id, ArkInventory.Const.Reputation.Style.TwoLines )
				end
				
			else
				
				txt1 = ArkInventory.ObjectInfoName( i.h )
				
			end
			
		end
		
		if txt1 == "" then
			frame.Text1:SetText( txt1 )
			frame.Text1:Hide( )
		else
			frame.Text1:SetText( txt1 )
			frame.Text1:Show( )
		end
			
		if txt2 == "" then
			frame.Text2:SetText( txt1 )
			frame.Text2:Hide( )
		else
			frame.Text2:SetText( txt2 )
			frame.Text2:SetTextColor( 1, 1, 1 )
			frame.Text2:Show( )
		end
		
	end
	
end

function ArkInventory.Frame_Item_Update_New( frame, clear )
	
	if not ArkInventory.ValidFrame( frame ) then return end

	local loc_id = frame.ARK_Data.loc_id
	local bag_id = frame.ARK_Data.bag_id
	local blizzard_id = frame.ARK_Data.blizzard_id
	local slot_id = frame.ARK_Data.slot_id
	
	local codex = ArkInventory.GetLocationCodex( loc_id )
	local i = ArkInventory.Frame_Item_GetDB( frame )
	
	local isNewItem = false
	local isBattlePayItem = false
	if loc_id == ArkInventory.Const.Location.Bag and not ArkInventory.Global.Location[loc_id].isOffline and not clear then
		isNewItem = C_NewItems.IsNewItem( blizzard_id, slot_id )
		isBattlePayItem = IsBattlePayItem( blizzard_id, slot_id )
	end
	
	local battlepayItemTexture = frame.BattlepayItemTexture
	local NewItemTexture = frame.NewItemTexture
	local flash = frame.flashAnim
	local newitemglowAnim = frame.newitemglowAnim
	local obj = frame.ArkAgeText
	
	if obj then
		
		if i and i.h then
			
			if codex.style.slot.age.show then
				
				local cutoff = codex.style.slot.age.cutoff
				local age, age_text = ArkInventory.ItemAgeGet( i.age )
				
				if age and ( cutoff == 0 or age <= cutoff ) then
					
					obj:ClearAllPoints( )
					if codex.style.slot.itemlevel.show then
						obj:SetPoint( "CENTER" )
					else
						obj:SetPoint( "TOPLEFT" )
					end
					
					local colour = codex.style.slot.age.colour
					
					obj:SetText( age_text )
					obj:SetTextColor( colour.r, colour.g, colour.b )
					ArkInventory.MediaObjectFontSet( obj, nil, codex.style.slot.age.font.height )
					obj:Show( )
					
				else
					
					obj:Hide( )
					
					if isNewItem then
						C_NewItems.RemoveNewItem( blizzard_id, slot_id )
					end
					
				end
				
			else
				
				obj:Hide( )
				
			end
			
		else
			
			obj:Hide( )
			
		end
		
	end
	
	if not isNewItem then
		
		if flash:IsPlaying( ) or newitemglowAnim:IsPlaying( ) then
			flash:Stop( )
			newitemglowAnim:Stop( )
		end
		
		battlepayItemTexture:Hide( )
		NewItemTexture:Hide( )
		
	else
		
		if isBattlePayItem then
			
			NewItemTexture:Hide( )
			battlepayItemTexture:Show( )
			
		else
			
			battlepayItemTexture:Hide( )
			
			if ArkInventory.db.option.newitemglow.enable then
				local c = ArkInventory.db.option.newitemglow.colour
				ArkInventory.SetTexture( frame.NewItemTexture, true, c.r, c.g, c.b, c.a )
				NewItemTexture:Show( )
			else
				NewItemTexture:Hide( )
			end
			
		end
		
		if ArkInventory.db.option.newitemglow.enable and not flash:IsPlaying( ) and not newitemglowAnim:IsPlaying( ) then
			flash:Play( )
			newitemglowAnim:Play( )
		end
		
	end
	
end

function ArkInventory.Frame_Main_Clear_NewItemGlow( loc_id )
	
	if ArkInventory.db.option.newitemglow.enable and ArkInventory.db.option.newitemglow.clearonclose and loc_id == ArkInventory.Const.Location.Bag and not ArkInventory.Global.Location[loc_id].isOffline then
		
		--ArkInventory.Output( "Frame_Main_Clear_NewItemGlow( ", loc_id, " )" )
		
		for bag_id in pairs( ArkInventory.Global.Location[loc_id].Bags ) do
			
			local blizzard_id = ArkInventory.InternalIdToBlizzardBagId( loc_id, bag_id )
			
			for slot_id = 1, ArkInventory.Global.Location[loc_id].maxSlot[bag_id] or 0 do
				
				if C_NewItems.IsNewItem( blizzard_id, slot_id ) then
					
					C_NewItems.RemoveNewItem( blizzard_id, slot_id )
					
					local objname, obj = ArkInventory.ContainerItemNameGet( loc_id, bag_id, slot_id )	
					ArkInventory.Frame_Item_Update_New( obj, true )
					
				end
				
			end
			
		end
		
	end
	
end

function ArkInventory.Frame_Item_Update_Empty( frame )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local loc_id = frame.ARK_Data.loc_id
	local bag_id = frame.ARK_Data.bag_id
	
	local i = ArkInventory.Frame_Item_GetDB( frame )
	
	if i and not i.h then
		
		local codex = ArkInventory.GetLocationCodex( loc_id )
		local bt = codex.player.data.location[loc_id].bag[bag_id].type
	
		-- slot background
		if codex.style.slot.empty.icon then
		
			-- icon
			local texture = ArkInventory.Const.Texture.Empty.Item
			
			if loc_id == ArkInventory.Const.Location.Wearing then
				-- wearing empty slot icons
				local a, b = GetInventorySlotInfo( ArkInventory.Const.InventorySlotName[i.slot_id] )
				--ArkInventory.Output( "id=[", i.slot_id, "], name=[", ArkInventory.Const.InventorySlotName[i.slot_id], "], texture=[", b, "]" )
				texture = b or texture
			else
				texture = ArkInventory.Const.Slot.Data[bt].texture or texture
			end
			
			ArkInventory.SetItemButtonTexture( frame, texture )
			
		else
			
			-- solid colour
			local colour = codex.style.slot.data[bt].colour
			colour.a = codex.style.slot.empty.alpha
			ArkInventory.SetItemButtonTexture( frame, true, colour.r, colour.g, colour.b, colour.a )
			
		end
		
	end
	
end
	
function ArkInventory.Frame_Item_Empty_Paint_All( )

	for loc_id, loc_data in pairs( ArkInventory.Global.Location ) do
		if loc_data.canView then
			
			for bag_id in pairs( loc_data.Bags ) do
				
				for slot_id = 1, ArkInventory.Global.Location[loc_id].maxSlot[bag_id] or 0 do
					
					local objname, obj = ArkInventory.ContainerItemNameGet( loc_id, bag_id, slot_id )
					ArkInventory.Frame_Item_Update_Empty( obj )
					ArkInventory.Frame_Item_Update_Border( obj )
					
				end
				
			end
			
		end
	end
	
end

function ArkInventory.Frame_Item_OnEnter( frame )
	
	if not ArkInventory.db.option.tooltip.show then return end
	
	local loc_id = frame.ARK_Data.loc_id
	local bag_id = frame.ARK_Data.bag_id
	local blizzard_id = frame.ARK_Data.blizzard_id
	local i = ArkInventory.Frame_Item_GetDB( frame )
	
	--ArkInventory.Output( "item=[", i.h, "]" )
	
	local reset = true
	
	if i.h then
		
		if ArkInventory.Global.Location[loc_id].isOffline then
			
			ArkInventory.GameTooltipSetHyperlink( frame, i.h )
			
		elseif blizzard_id == BANK_CONTAINER or blizzard_id == REAGENTBANK_CONTAINER then
			
			BankFrameItemButton_OnEnter( frame )
			reset = false
			
		elseif loc_id == ArkInventory.Const.Location.Pet then
			
			ArkInventory.GameTooltipSetPosition( frame )
			ArkInventory.TooltipBuildBattlepet( GameTooltip, i.h, i )
			CursorUpdate( frame )
			return
			
		elseif loc_id == ArkInventory.Const.Location.Toybox then
			
			ArkInventory.GameTooltipSetPosition( frame )
			GameTooltip:SetToyByItemID( i.item )
			
		elseif loc_id == ArkInventory.Const.Location.Heirloom then
			
			ArkInventory.GameTooltipSetPosition( frame )
			GameTooltip:SetHeirloomByItemID( i.item )
			
		elseif loc_id == ArkInventory.Const.Location.Token then
			
			ArkInventory.GameTooltipSetPosition( frame )
			GameTooltip:SetCurrencyByID( i.index )
			
		elseif loc_id == ArkInventory.Const.Location.Bag or loc_id == ArkInventory.Const.Location.Bank then
			
			ContainerFrameItemButton_OnEnter( frame )
			reset = false
			
		else
			
			ArkInventory.GameTooltipSetHyperlink( frame, i.h )
			
		end
		
		
		if IsModifiedClick( "DRESSUP" ) then
			
			ShowInspectCursor( )
			
		elseif IsModifiedClick( "COMPAREITEMS" ) or GetCVarBool( "alwaysCompareItems" ) then
			
			GameTooltip_ShowCompareItem( )
			ResetCursor( )
			
		elseif reset then
			
			ResetCursor( )
			
		end
		
	else
		
		GameTooltip:Hide( )
		ResetCursor( )
		
	end
	
end

function ArkInventory.Frame_Item_OnEnter_Tainted( frame )

	if not ArkInventory.ValidFrame( frame ) then return end

	if not ArkInventory.db.option.tooltip.show then
		return
	end
	
	ArkInventory.GameTooltipSetText( frame, ArkInventory.Localise["BUGFIX_TAINTED_ALERT_MOUSEOVER_TEXT"], 1.0, 0.1, 0.1 )

end

function ArkInventory.Frame_Item_OnMouseUp( frame, button )
	
	if ArkInventory.Global.Mode.Edit then
		ArkInventory.MenuItemOpen( frame )
		return
	end
	
	
	local loc_id = frame.ARK_Data.loc_id
	local i = ArkInventory.Frame_Item_GetDB( frame )
	
	if not i then return end
	
	if ArkInventory.Global.Location[loc_id].isOffline or ArkInventory.Global.Location[loc_id].tainted then
		
		if HandleModifiedItemClick( i.h ) then return end
		
		-- must be online or untainted to continue
		return
		
	end
	
	
	if loc_id == ArkInventory.Const.Location.Bag then
		
		-- already handled in onclick
		return
		
	end
	
	
	if loc_id == ArkInventory.Const.Location.Bank then
		
		-- already handled in onclick
		return
		
	end
	
	
	if HandleModifiedItemClick( i.h ) then return end
	
	
	if loc_id == ArkInventory.Const.Location.Vault then
		
		if not ArkInventory.Global.Mode.Vault then
			-- must be at the vault to continue
			return
		end
		
		local tab_id = frame.ARK_Data.bag_id
		local slot_id = frame.ARK_Data.slot_id
		
		if IsModifiedClick( "SPLITSTACK" ) then
			if i.count > 1 and not frame.locked then
				StackSplitFrame:OpenStackSplitFrame( frame.count, frame, "BOTTOMLEFT", "TOPLEFT" )
			end
			return
		end
		
		local infoType, info1, info2 = GetCursorInfo( )
		if infoType == "money" then
			DepositGuildBankMoney( info1 )
			ClearCursor( )
		elseif infoType == "guildbankmoney" then
			DropCursorMoney( )
			ClearCursor( )
		else
			if button == "RightButton" then
				AutoStoreGuildBankItem( tab_id, slot_id )
			else
				PickupGuildBankItem( tab_id, slot_id )
			end
		end
		
		return
		
	end
	
	
	if loc_id == ArkInventory.Const.Location.Mail then
		
		if not ArkInventory.Global.Mode.Mail then
			-- must be at the mailbox to continue
			return
		end
		
		if button == "RightButton" then
			if i.msg_id and i.money then	
				TakeInboxMoney( i.msg_id )
			elseif i.msg_id and i.att_id then
				TakeInboxItem( i.msg_id, i.att_id )
			end
		end
		
		return
		
	end
	
	
	if loc_id == ArkInventory.Const.Location.Wearing then
		
		-- nothing to do
		return
		
	end
	
	
	if loc_id == ArkInventory.Const.Location.Pet then
		
		if i.guid then
			
			if button == "LeftButton" then
				
				ArkInventory.Collection.Pet.Summon( i.guid )
				
			elseif button == "RightButton" then
				
				ArkInventory.MenuItemPetJournal( frame, i.guid )
				
			end
			
		end
		
		ClearCursor( )
		
		return
		
	end
	
	
	if loc_id == ArkInventory.Const.Location.Mount then
		
		if i.index then
			if button == "LeftButton" then
				
				local md = ArkInventory.Collection.Mount.GetMount( i.index )
				
				if md.active then
					ArkInventory.Collection.Mount.Dismiss( )
				elseif ArkInventory.Collection.Mount.IsUsable( md.index ) then
					ArkInventory.Collection.Mount.Summon( i.index )
				end
				
			elseif button == "RightButton" then
				
				ArkInventory.MenuItemMountJournal( frame, i.index )
				
			end
			
		end
		
		ClearCursor( )
		
		return
		
	end
	
	
	if loc_id == ArkInventory.Const.Location.Token then
		
		-- nothing to do
		return
		
	end
	
	
	if loc_id == ArkInventory.Const.Location.Auction then
		
		-- nothing to do
		return
		
	end
	
	
	if loc_id == ArkInventory.Const.Location.Toybox then
		
		if button == "LeftButton" then
			
			--ArkInventory.Collection.Toybox.Summon( i.index )
			ArkInventory.Output( "sorry, toys can no longer be summoned by code, please drag the ", i.h, " to your actionbar to use instead" )
			
		elseif button == "RightButton" then
			
			--ArkInventory.MenuItemToybox( frame, i.index ) !!! to be done
			
		end
		
		ClearCursor( )
		
		return
		
	end
	
	
	if loc_id == ArkInventory.Const.Location.Heirloom then
		
		if button == "LeftButton" then
			
			--C_Heirloom.CreateHeirloom( i.item ) -- secure action, cant be done
			
		elseif button == "RightButton" then
			
			--ArkInventory.MenuItemHeirloom( frame, i.index ) !!! to be done
			
		end
		
		ClearCursor( )
		
		return
		
	end
	
	
end

function ArkInventory.Frame_Item_OnDrag( frame )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local loc_id = frame.ARK_Data.loc_id
	local usedmycode = false
	
	if SpellIsTargeting( ) or ArkInventory.Global.Location[loc_id].isOffline or ArkInventory.Global.Mode.Edit then
	
		usedmycode = true
		-- do not drag / drag disabled
		
	end
	
	if not usedmycode then
		ContainerFrameItemButton_OnClick( frame, "LeftButton" )
		--ArkInventory.Frame_Item_OnMouseUp( frame, "LeftButton" )
	end
	
end

function ArkInventory.Frame_Item_Update_Cooldown( frame )
	
	-- triggered when a cooldown is first started
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local loc_id = frame.ARK_Data.loc_id
	local i = ArkInventory.Frame_Item_GetDB( frame )
	
	local framename = frame:GetName( )
	local obj = _G[string.format( "%s%s", framename, ArkInventory.Const.Frame.Cooldown.Name )]
	if not obj then return end
	
	if ArkInventory.Global.Location[loc_id].isOffline then
		obj:Hide( )
		return
	end
	
	local codex = ArkInventory.GetLocationCodex( loc_id )
	
	if not codex.style.slot.cooldown.show then
		obj:Hide( )
		return
	end
	
	if i and i.h then
		
		if loc_id == ArkInventory.Const.Location.Toybox and i.item then
			
			local start, duration, enable = GetItemCooldown( i.item )
			if obj and start and duration then
				
				--ArkInventory.Output( "toybox cooldown: ", obj:GetName( ) )
				
				if enable then
					obj:Show( )
				else
					obj:Hide( )
				end
				
				CooldownFrame_Set( obj, start, duration, enable )
				
			else
				
				obj:Hide( )
				
			end
			
		else
			
			ContainerFrame_UpdateCooldown( frame.ARK_Data.blizzard_id, frame )
			
		end
		
	else
		
		obj:Hide( )
		
	end
	
end

function ArkInventory.Frame_Item_Update_Lock( frame )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local loc_id = frame.ARK_Data.loc_id
	if ArkInventory.Global.Mode.Edit or ArkInventory.Global.Location[loc_id].isOffline then
		return
	end
	
	local i = ArkInventory.Frame_Item_GetDB( frame )
	
	local colour = { r = 1.00, g = 1.00, b = 1.00 }
	local tinted = { r = 1.00, g = 0.10, b = 0.10 }
	
	local locked = false
	
	if i and i.h then
		
		local codex = ArkInventory.GetLocationCodex( loc_id )
		
		if loc_id == ArkInventory.Const.Location.Vault then
			locked = select( 3, GetGuildBankItemInfo( frame.ARK_Data.bag_id, frame.ARK_Data.slot_id ) )
		else
			locked = select( 3, GetContainerItemInfo( frame.ARK_Data.blizzard_id, frame.ARK_Data.slot_id ) )
		end
		
	end
	
	ArkInventory.SetItemButtonDesaturate( frame, locked, colour.r, colour.g, colour.b )
	
	frame.locked = locked
	
end

function ArkInventory.Frame_Item_Update_Tint( frame )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local obj = frame.ArkItemTinted
	if not obj then return end
		
	local loc_id = frame.ARK_Data.loc_id
	if ArkInventory.Global.Mode.Edit or ArkInventory.Global.Location[loc_id].isOffline then
		return
	end
	
	local codex = ArkInventory.GetLocationCodex( loc_id )
	local tinted = false
		
	if codex.style.slot.unusable.tint then
		
		local i = ArkInventory.Frame_Item_GetDB( frame )
		
		if i and i.h then
			
			local osd = ArkInventory.ObjectStringDecode( i.h )
			
			if loc_id == ArkInventory.Const.Location.Pet or osd.class == "battlepet" then
				
				local player_id = ArkInventory.PlayerIDAccount( )
				local account = ArkInventory.GetPlayerStorage( player_id )
				
				if account and codex.player.data.info and codex.player.data.info.level and codex.player.data.info.level < osd.level then
					tinted = true
				end
				
			elseif loc_id == ArkInventory.Const.Location.Mount then
				
				if not ArkInventory.Collection.Mount.IsUsable( i.index ) then
					tinted = true
				end
				
			elseif loc_id == ArkInventory.Const.Location.Heirloom or loc_id == ArkInventory.Const.Location.Toybox then
				
				ArkInventory.TooltipSetHyperlink( ArkInventory.Global.Tooltip.Scan, i.h )
				
				if not ArkInventory.TooltipCanUse( ArkInventory.Global.Tooltip.Scan, true ) then
					tinted = true
				end
				
			else
				
				ArkInventory.TooltipSetHyperlink( ArkInventory.Global.Tooltip.Scan, i.h )
				
				if not ArkInventory.TooltipCanUse( ArkInventory.Global.Tooltip.Scan ) then
					tinted = true
				end
				
			end
			
		end
		
	end
	
	if tinted then
		obj:Show( )
	else
		obj:Hide( )
	end
	
end

function ArkInventory.Frame_Item_Update_PetJournal( frame )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local i = ArkInventory.Frame_Item_GetDB( frame )
	
	if frame.favorite then
		
		if i and i.guid then
			
			frame.active:SetShown( i.guid == ArkInventory.Collection.Pet.GetCurrent( ) )
			frame.slotted:SetShown( ArkInventory.Collection.Pet.IsSlotted( i.guid ) )
			frame.dead:SetShown( ( ArkInventory.Collection.Pet.GetStats( i.guid ) or 1 ) <= 0 )
			frame.favorite:SetShown( i.fav )
			
		else
			
			frame.active:Hide( )
			frame.slotted:Hide( )
			frame.dead:Hide( )
			frame.favorite:Hide( )
			
		end
		
	end
	
end

function ArkInventory.Frame_Item_Update_MountJournal( frame )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local i = ArkInventory.Frame_Item_GetDB( frame )
	
	if frame.favorite then
		if i then
			frame.favorite:SetShown( i.fav )
		else
			frame.favorite:Hide( )
		end
	end
	
end

function ArkInventory.Frame_Item_Update_Toybox( frame )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local i = ArkInventory.Frame_Item_GetDB( frame )
	
	if frame.favorite then
		if i then
			frame.favorite:SetShown( i.fav )
		else
			frame.favorite:Hide( )
		end
	end
	
end

function ArkInventory.Frame_Item_Update_Heirloom( frame )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local i = ArkInventory.Frame_Item_GetDB( frame )
	
	if i then
		
		
		
	else
		
		
		
	end
	
end

function ArkInventory.Frame_Item_Update_Clickable( frame )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local loc_id = frame.ARK_Data.loc_id
	local click = true
	
	if ArkInventory.Global.Mode.Edit or ArkInventory.Global.Location[loc_id].isOffline then
		
		click = false
		
	else
		
		if loc_id == ArkInventory.Const.Location.Vault then
			
			local bag_id = frame.ARK_Data.bag_id
			local _, _, _, canDeposit, numWithdrawals = GetGuildBankTabInfo( bag_id )
			if ( not canDeposit ) and ( numWithdrawals == 0 ) then
				click = false
			end
			
		end
		
	end
	
	
	if click then
		frame:RegisterForClicks( "LeftButtonUp", "RightButtonUp" )
		frame:RegisterForDrag( "LeftButton" )
	else
		-- disable clicks/drag when in edit mode or offline
		frame:RegisterForClicks( )
		frame:RegisterForDrag( )
	end
	
end

function ArkInventory.Frame_Item_OnLoad( frame, tainted )
	
	--ArkInventory.Output( frame:GetName( ), " / level = ", frame:GetFrameLevel( ) )
	
	local framename = frame:GetName( )
	local loc_id, bag_id, slot_id = string.match( framename, "^.-(%d+)ScrollContainerBag(%d+)Item(%d+)" )
	
	assert( loc_id, string.format( "xml element '%s' is not an %s frame", framename, ArkInventory.Const.Program.Name ) )
	assert( bag_id, string.format( "xml element '%s' is not an %s frame", framename, ArkInventory.Const.Program.Name ) )
	assert( slot_id, string.format( "xml element '%s' is not an %s frame", framename, ArkInventory.Const.Program.Name ) )
	
	loc_id = tonumber( loc_id )
	bag_id = tonumber( bag_id )
	slot_id = tonumber( slot_id )
	
	frame:SetID( slot_id )
	
	frame.ARK_Data = {
		loc_id = loc_id,
		bag_id = bag_id,
		blizzard_id = ArkInventory.InternalIdToBlizzardBagId( loc_id, bag_id ),
		slot_id = slot_id,
		tainted = not not tainted,
	}
	
	-- because blizzard sometimes forgets to turn things off by default
	if frame.BattlepayItemTexture then
		frame.BattlepayItemTexture:Hide( )
	end
	
	if frame.NewItemTexture then
		frame.NewItemTexture:Hide( )
	end
	
	if tainted then
		ContainerFrameItemButton_OnLoad( frame )
	else
		if loc_id == ArkInventory.Const.Location.Bank and bag_id == 1 then
			BankFrameItemButton_OnLoad( frame )
		elseif loc_id == ArkInventory.Const.Location.Bank and bag_id == ArkInventory.Global.Location[loc_id].tabReagent then
			ReagentBankFrameItemButton_OnLoad( frame )
		else
			ContainerFrameItemButton_OnLoad( frame )
		end
	end
	
	if tainted then
		frame.UpdateTooltip = ArkInventory.Frame_Item_OnEnter_Tainted
	else
		frame.UpdateTooltip = ArkInventory.Frame_Item_OnEnter
	end
	
	frame.locked = not not tainted
	
	if loc_id == ArkInventory.Const.Location.Vault then
		
		-- replace the split function
		frame.SplitStack = function( button, split )
			local tab_id = frame.ARK_Data.bag_id
			local slot_id = frame.ARK_Data.slot_id
			SplitGuildBankItem( tab_id, slot_id, split )
		end
		
	end
	
	
	-- adjust any fixed size blizzard subframes so they scale properly
	
	local obj = _G[string.format( "%s%s", frame:GetName( ), "IconQuestTexture" )]
	if obj then
		obj:ClearAllPoints( )
		obj:SetPoint( "TOPLEFT", frame, 1, -1 )
		obj:SetPoint( "BOTTOMRIGHT", frame, -1, 1 )
	end
	
	local obj = frame.NewItemTexture
	if obj then
		obj:ClearAllPoints( )
		obj:SetPoint( "TOPLEFT", frame, 1, -1 )
		obj:SetPoint( "BOTTOMRIGHT", frame, -1, 1 )
	end
	
	if not frame.ARK_Data.tainted then
		ArkInventory.API.ItemFrameLoaded( frame, loc_id, bag_id, slot_id  )
	end
	
end

function ArkInventory.Frame_Item_ListEntry_OnLoad( frame )
	
	--ArkInventory.Output( frame:GetName( ), " / level = ", frame:GetFrameLevel( ) )
	
	local framename = frame:GetName( )
	
	local loc_id, bag_id = string.match( framename, "^.-Frame(%d+)ScrollContainerBar(%d+)" )
	if loc_id then return end
	
	local loc_id, bag_id, slot_id = string.match( framename, "^.-Frame(%d+)ScrollContainerBag(%d+)Item(%d+)" )
	
	assert( loc_id, string.format( "xml element '%s' is not an %s frame", framename, ArkInventory.Const.Program.Name ) )
	assert( bag_id, string.format( "xml element '%s' is not an %s frame", framename, ArkInventory.Const.Program.Name ) )
	assert( slot_id, string.format( "xml element '%s' is not an %s frame", framename, ArkInventory.Const.Program.Name ) )
	
	loc_id = tonumber( loc_id )
	bag_id = tonumber( bag_id )
	slot_id = tonumber( slot_id )
	
	frame:SetID( slot_id )
	
	frame.ARK_Data = {
		loc_id = loc_id,
		bag_id = bag_id,
		blizzard_id = ArkInventory.InternalIdToBlizzardBagId( loc_id, bag_id ),
		slot_id = slot_id,
	}
	
end

function ArkInventory.Frame_Item_OnLoad_Tainted( frame )
	ArkInventory.Frame_Item_OnLoad( frame, true )
end

function ArkInventory.Frame_Item_OnDragStart_PetJournal( frame )
	
	if ArkInventory.Global.Mode.Edit then return end
	
	local i = ArkInventory.Frame_Item_GetDB( frame )
	
	if i and i.guid then
		
		ArkInventory.Collection.Pet.PickupPet( i.guid, true )
		
		if PetJournal:IsVisible( ) then
			PetJournal_UpdatePetLoadOut( )
		end

	end
	
end

function ArkInventory.Frame_Item_OnDragStart_Toybox( frame )
	
	if ArkInventory.Global.Mode.Edit then return end
	
	local i = ArkInventory.Frame_Item_GetDB( frame )
	
	if i and i.item then
		
		C_ToyBox.PickupToyBoxItem( i.item )
		
	end
	
end

function ArkInventory.Frame_Item_OnDragStart_Heirloom( frame )
	
	if ArkInventory.Global.Mode.Edit then return end
	
	local i = ArkInventory.Frame_Item_GetDB( frame )
	
	if i and i.h then
		
		
		
	end
	
end

function ArkInventory.Frame_Item_OnDragStart_MountJournal( frame )
	
	if ArkInventory.Global.Mode.Edit then return end
	
	local i = ArkInventory.Frame_Item_GetDB( frame )
	if i and i.slot_id then
		PickupCompanion( "MOUNT", i.slot_id )
	end
	
end

function ArkInventory.Frame_Item_Update( loc_id, bag_id, slot_id )
	
	local framename, frame = ArkInventory.ContainerItemNameGet( loc_id, bag_id, slot_id )	
	
	if frame then
		
		local codex = ArkInventory.GetLocationCodex( loc_id )
		
		ArkInventory.Frame_Item_Update_Lock( frame )
		
		ArkInventory.Frame_Item_Update_Border( frame )
		
		ArkInventory.Frame_Item_Update_Count( frame )
		ArkInventory.Frame_Item_Update_Stock( frame )
		
		ArkInventory.Frame_Item_Update_Texture( frame )
		ArkInventory.Frame_Item_Update_Fade( frame )
		
		ArkInventory.Frame_Item_Update_Quest( frame )
		ArkInventory.Frame_Item_Update_StatusIconUpgrade( frame )
		ArkInventory.Frame_Item_Update_StatusIconJunk( frame )
		ArkInventory.Frame_Item_Update_StatusIconTransmog( frame )
		
		ArkInventory.Frame_Item_Update_Cooldown( frame )
		
		ArkInventory.Frame_Item_Update_Tint( frame )
		
		if loc_id == ArkInventory.Const.Location.Pet then
			ArkInventory.Frame_Item_Update_PetJournal( frame )
		end
		
		if loc_id == ArkInventory.Const.Location.Toybox then
			ArkInventory.Frame_Item_Update_Toybox( frame )
		end
		
		if loc_id == ArkInventory.Const.Location.Heirloom then
			ArkInventory.Frame_Item_Update_Heirloom( frame )
		end
		
		ArkInventory.Frame_Item_Update_List( frame, codex.style.window.list )
		
		if not frame.ARK_Data.tainted then
			ArkInventory.API.ItemFrameUpdated( frame, loc_id, bag_id, slot_id )
		end
		
		if frame == GameTooltip:GetOwner( ) then
			frame.UpdateTooltip( frame )
		end
		
	end
	
end

function ArkInventory.Frame_Item_Event_Cooldown( frame )
	
	-- triggered when a cooldown is first started
	
	local loc_id = frame.ARK_Data.loc_id
	local i = ArkInventory.Frame_Item_GetDB( frame )
	
	if i and ( arg1 == nil or arg1 == i.bag_id ) then
		
		local framename = frame:GetName( )
		local obj_name = "Cooldown"
		local obj = _G[string.format( "%s%s", framename, obj_name )]
		assert( obj, string.format( "xml element '%s' is missing the sub element %s", framename, obj_name ) )
		
		if ArkInventory.Global.Location[loc_id].isOffline then
			obj:Hide( )
			return
		end
		
		local codex = ArkInventory.GetLocationCodex( loc_id )
		
		if not codex.style.slot.cooldown.show then
			obj:Hide( )
			return
		end
		
		if i.h then
			
			if loc_id == ArkInventory.Const.Location.Toybox and i.item then
				
				local start, duration, enable = GetItemCooldown( i.item )
				if obj and start and duration then
					
					--ArkInventory.Output( "toybox cooldown: ", obj:GetName( ) )
					
					if enable then
						obj:Show( )
					else
						obj:Hide( )
					end
					
					CooldownFrame_Set( obj, start, duration, enable )
					
				else
					
					obj:Hide( )
					
				end
				
			else
				
				ContainerFrame_UpdateCooldown( frame.ARK_Data.blizzard_id, frame )
				
			end
			
		else
			
			obj:Hide( )
			
		end
		
	end
	
end

function ArkInventory.Frame_Status_Update( frame )

	local loc_id = frame.ARK_Data.loc_id
	local codex = ArkInventory.GetLocationCodex( loc_id )
	--ArkInventory.Output( ArkInventory.Global.Location[loc_id].Name, ", player = ", codex.player.current )
	
	-- hide the status window if it's not needed
	local obj = _G[string.format( "%s%s", frame:GetName( ), ArkInventory.Const.Frame.Status.Name )]
	if codex.style.status.hide then
		obj:Hide( )
		obj:SetHeight( 1 )
		return
	else
		
		local height = codex.style.status.font.height
		ArkInventory.MediaFrameFontSet( obj, nil, height )
	
		if height < ArkInventory.Const.Frame.Status.MinHeight then
			height = ArkInventory.Const.Frame.Status.MinHeight
		end
		
		obj:SetHeight( height + ArkInventory.Const.Frame.Status.Height )
		obj:Show( )
		
	end
	
	
	
	-- update money
	local moneyFrameName = string.format( "%s%s", obj:GetName( ), "Gold" )
	local moneyFrame = _G[moneyFrameName]
	assert( moneyFrame, "moneyframe is nil" )
	--moneyFrame:SetHeight( height )
	
	if ArkInventory.Global.Location[loc_id].isOffline then
		ArkInventory.MoneyFrame_SetType( moneyFrame, "STATIC" )
		MoneyFrame_Update( moneyFrameName, codex.player.data.info.money or 0 )
		--SetMoneyFrameColor( moneyFrameName, 0.75, 0.75, 0.75 )
	else
		SetMoneyFrameColor( moneyFrameName, 1, 1, 1 )
		if loc_id == ArkInventory.Const.Location.Vault then
			ArkInventory.MoneyFrame_SetType( moneyFrame, "GUILDBANK" )
		else
			ArkInventory.MoneyFrame_SetType( moneyFrame, "PLAYER" )
		end
	end
	
	
	-- update the empty slot count
	local obj = _G[string.format( "%s%s%s", frame:GetName( ), ArkInventory.Const.Frame.Status.Name, "EmptyText" )]
	if obj then
		if codex.style.status.emptytext.show then
			local y = ArkInventory.Frame_Status_Update_Empty( loc_id, codex )
			obj:SetText( y )
		else
			obj:SetText( "" )
		end
		--obj:SetHeight( height )
	end
	
	
	-- update token tracking
	ArkInventory.Frame_Status_Update_Tracking( loc_id )
	
end

function ArkInventory.Frame_Status_Update_Empty( loc_id, codex, ldb )
	
	-- build the empty slot count status string
	
	local empty = { }
	local bags = codex.player.data.location[loc_id].bag
	
	for k, bag in pairs( bags ) do
		
		if not empty[bag.type] then
			empty[bag.type] = { ["count"] = 0, ["empty"] = 0, ["type"] = bag.type }
		end
		
		if bag.status == ArkInventory.Const.Bag.Status.Active then
			empty[bag.type].count = empty[bag.type].count + bag.count
			empty[bag.type].empty = empty[bag.type].empty + bag.empty
		end
		
		--ArkInventory.Output( "k=[", k, "] t=[", bag.type, "] c=[", bag.count, "], status=[", bag.status, "]" )
		
	end
	
	local ee = ArkInventory.Table.Sum( empty, function( a ) return a.empty end )
	local ts = codex.player.data.location[loc_id].slot_count
	
	local y = { }
	
	if ts == 0 then
		
		y[#y + 1] = string.format( "%s%s%s", RED_FONT_COLOR_CODE, ArkInventory.Localise["STATUS_NO_DATA"], FONT_COLOR_CODE_CLOSE )
		
	else
		
		for t, e in ArkInventory.spairs( empty, function(a,b) return empty[a].type < empty[b].type end ) do
			
			local c = HIGHLIGHT_FONT_COLOR_CODE
			local n = string.format( " %s", ArkInventory.Const.Slot.Data[t].name )
			
			if ldb then
				
				if codex.player.data.ldb.bags.colour then
					c = codex.style.slot.data[t].colour
					c = ArkInventory.ColourRGBtoCode( c.r, c.g, c.b )
				end
				
				if not codex.player.data.ldb.bags.includetype then
					n = ""
				end
				
				if codex.player.data.ldb.bags.full then
					y[#y + 1] = string.format( "%s%i/%i%s%s", c, e.count - e.empty, e.count, n, FONT_COLOR_CODE_CLOSE )
				else
					y[#y + 1] = string.format( "%s%i%s%s", c, e.empty, n, FONT_COLOR_CODE_CLOSE )
				end
				
			else
				
				if codex.style.status.emptytext.colour then
					c = codex.style.slot.data[t].colour
					c = ArkInventory.ColourRGBtoCode( c.r, c.g, c.b )
				end
				
				if not codex.style.status.emptytext.includetype then
					n = ""
				end
				
				if codex.player.data.info.player_id == ArkInventory.PlayerIDAccount( ) then
					y[#y + 1] = string.format( "%s%i%s%s", c, e.count, n, FONT_COLOR_CODE_CLOSE )
				elseif codex.style.status.emptytext.full then
					y[#y + 1] = string.format( "%s%i/%i%s%s", c, e.count - e.empty, e.count, n, FONT_COLOR_CODE_CLOSE )
				else
					y[#y + 1] = string.format( "%s%i%s%s", c, e.empty, n, FONT_COLOR_CODE_CLOSE )
				end
				
			end
			
		end
		
	end
	
	return string.format( "|cfff9f9f9%s", table.concat( y, ", " ) )

end

function ArkInventory.Frame_Status_Update_Tracking( loc_id )
	
	if not ArkInventory:IsEnabled( ) then return end
	
	if loc_id and loc_id ~= ArkInventory.Const.Location.Bag then
		return
	end
	
	local frame = ArkInventory.Frame_Main_Get( ArkInventory.Const.Location.Bag )
	frame = _G[string.format( "%s%s", frame:GetName( ), ArkInventory.Const.Frame.Status.Name )]
	
	for i = 1, MAX_WATCHED_TOKENS do
		
		local obj = _G[string.format( "%s%s%s", frame:GetName( ), "Tracking", i )]
		
		local name, count, icon, currencyID = GetBackpackCurrencyInfo( i )
		
		if currencyID then
			
			local name, amount, icon, earnedThisWeek, weeklyMax, totalMax, isDiscovered, quality = GetCurrencyInfo( currencyID )
			
			obj.currencyID = currencyID
			
			ArkInventory.SetTexture( obj.icon, icon )
			obj.count:SetText( FormatLargeNumber( amount ) )
			obj:SetWidth( 2 * obj.icon:GetWidth( ) + obj.count:GetWidth( ) )
			obj:Show( )
			
		else
			
			obj:SetWidth( 1 )
			obj:Hide( )
			
		end
		
	end
	
end


function ArkInventory.Frame_Changer_Update( loc_id )
	
	if not ArkInventory.Global.Location[loc_id].hasChanger then return end
	
	if loc_id == ArkInventory.Const.Location.Bag then
		
		for bag_id in pairs( ArkInventory.Global.Location[loc_id].Bags ) do
			
			local frame = _G[string.format( "%s%s%s%s%s", ArkInventory.Const.Frame.Main.Name, loc_id, ArkInventory.Const.Frame.Changer.Name, "WindowBag", bag_id )]
			
			if bag_id == 1 then
				ArkInventory.Frame_Changer_Primary_Update( frame )
			else
				ArkInventory.Frame_Changer_Slot_Update( frame )
			end
			
		end
		
	elseif loc_id == ArkInventory.Const.Location.Bank then
		
		ArkInventory.Frame_Changer_Bank_Update( )
		
	elseif loc_id == ArkInventory.Const.Location.Vault then
		
		ArkInventory.Frame_Changer_Vault_Update( )
		
	end
	
	
	local frame = _G[string.format( "%s%s", ArkInventory.Const.Frame.Main.Name, loc_id )]
	ArkInventory.Frame_Status_Update( frame )
	
end

function ArkInventory.Frame_Changer_Primary_Update( frame )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local loc_id = frame.ARK_Data.loc_id
	local bag_id = frame.ARK_Data.bag_id
	local codex = ArkInventory.GetLocationCodex( loc_id )
	
	ArkInventory.Frame_Item_Update_Fade( frame, true )
	
	ArkInventory.Frame_Item_Update_Border( frame, true )
	
	if codex.player.data.option[loc_id].bag[bag_id].display == false then
		SetItemButtonTextureVertexColor( frame, 1.0, 0.1, 0.1 )
	else
		SetItemButtonTextureVertexColor( frame, 1.0, 1.0, 1.0 )
	end
	
	local bag = codex.player.data.location[loc_id].bag[bag_id]
	
	SetItemButtonCount( frame, bag.count )
	
	if bag.status == ArkInventory.Const.Bag.Status.Active then
		ArkInventory.SetItemButtonStock( frame, bag.empty )
	else
		ArkInventory.SetItemButtonStock( frame, nil, bag.status )
	end
	
	ArkInventory.MediaFrameFontSet( frame, nil, codex.style.slot.itemcount.font.height )

end

function ArkInventory.Frame_Changer_Bank_Update( )
	
	local loc_id = ArkInventory.Const.Location.Bank
	
	local parent = _G[string.format( "%s%s%s%s", ArkInventory.Const.Frame.Main.Name, loc_id, ArkInventory.Const.Frame.Changer.Name, "Window" )]
	
	if not parent:IsVisible( ) then
--		return
	end
	
	for x = 1, ArkInventory.Global.Location[loc_id].bagCount do
		
		local frame = _G[string.format( "%s%s%s%s%s", ArkInventory.Const.Frame.Main.Name, loc_id, ArkInventory.Const.Frame.Changer.Name, "WindowBag", x )]
		
		if x == 1 then
			ArkInventory.Frame_Changer_Primary_Update( frame )
		elseif x == 2 then
			ArkInventory.Frame_Changer_Bank_ReagentBank_Update( frame )
		else
			ArkInventory.Frame_Changer_Slot_Update( frame )
		end
		
	end
	
	-- update blizzards frame as well because the static dialog box uses the data in it
	UpdateBagSlotStatus( )
	
end

function ArkInventory.Frame_Changer_Bank_ReagentBank_Update( frame )
	
	local loc_id = frame.ARK_Data.loc_id
	local bag_id = frame.ARK_Data.bag_id
	
	local codex = ArkInventory.GetLocationCodex( loc_id )
	local bag = codex.player.data.location[loc_id].bag[bag_id]
	
	--ArkInventory.Output( "who[", codex.player.data.info.name, "].loc[", loc_id, "].bag[", bag_id, "]" )
	
	if bag.count > 0 then
		
		frame.size = bag.count or 0
		ArkInventory.SetItemButtonTexture( frame, bag.texture )
		SetItemButtonCount( frame, frame.size )
		
	else
		
		frame.size = 0
		ArkInventory.SetItemButtonTexture( frame, bag.texture or ArkInventory.Const.Texture.Empty.Bag )
		SetItemButtonCount( frame, frame.size )
		
	end
	
	if bag.status == ArkInventory.Const.Bag.Status.Active then
		ArkInventory.SetItemButtonStock( frame, bag.empty )
	else
		ArkInventory.SetItemButtonStock( frame, nil, bag.status )
	end
	
	ArkInventory.Frame_Item_Update_Fade( frame, true )
	
	ArkInventory.Frame_Item_Update_Border( frame, true )
	
	if codex.player.data.option[loc_id].bag[bag_id].display == false then
		SetItemButtonTextureVertexColor( frame, 1.0, 0.1, 0.1 )
	else
		if bag.status == ArkInventory.Const.Bag.Status.Purchase then
			SetItemButtonTextureVertexColor( frame, 1.0, 0.1, 0.1 )
		else
			SetItemButtonTextureVertexColor( frame, 1.0, 1.0, 1.0 )
		end
	end
	
	ArkInventory.MediaFrameFontSet( frame, nil, codex.style.slot.itemcount.font.height )
	
end

function ArkInventory.Frame_Changer_Vault_Tab_OnEnter( frame )
	
	if not frame then return end
	
	local loc_id = frame.ARK_Data.loc_id
	local bag_id = frame.ARK_Data.bag_id
	local codex = ArkInventory.GetLocationCodex( loc_id )

	if ArkInventory.db.option.tooltip.show then
	
		ArkInventory.GameTooltipSetPosition( frame, true )
		
		local bag = codex.player.data.location[loc_id].bag[bag_id]
		
		if bag and bag.name then
			GameTooltip:SetText( string.format( ArkInventory.Localise["VAULT_TAB_NAME"], bag_id, bag.name ) )
			GameTooltip:AddLine( string.format( ArkInventory.Localise["VAULT_TAB_ACCESS"], bag.access ) )
			if bag.withdraw then
				GameTooltip:AddLine( string.format( ArkInventory.Localise["VAULT_TAB_REMAINING_WITHDRAWALS"], bag.withdraw ) )
			end
			--GameTooltip:AddLine( string.format( NUM_GUILDBANK_TABS_PURCHASED, GetNumGuildBankTabs( ), MAX_BUY_GUILDBANK_TABS ) )
			GameTooltip:Show( )
		else
			GameTooltip:Hide( )
		end
		
		CursorUpdate( frame )
		
	end
	
	--ArkInventory.BagHighlight( frame, true )
	
end

function ArkInventory.Frame_Changer_Vault_Tab_OnLoad( frame )
	ArkInventory.Frame_Changer_Slot_OnLoad( frame )
	if frame.ARK_Data.bag_id <= MAX_GUILDBANK_TABS then
		frame:Show( )
		frame.UpdateTooltip = ArkInventory.Frame_Changer_Vault_Tab_OnEnter
	end
end

function ArkInventory.Frame_Changer_Vault_Tab_OnClick( frame, button, mode )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local loc_id = frame.ARK_Data.loc_id
	local bag_id = frame.ARK_Data.bag_id
	
	local codex = ArkInventory.GetLocationCodex( loc_id )
	local mode = mode or ArkInventory.Global.Location[loc_id].view_mode
	local tab = codex.player.data.location[loc_id].bag[bag_id]
	
	--ArkInventory.Output( "Tab_OnClick(", frame:GetName( ), ", ", button, ", ", mode, ")" )
	
	if tab.name == nil then
		return
	end
	
	if tab.status == ArkInventory.Const.Bag.Status.Purchase then
		
		if button == "LeftButton" then
			if bag_id <= MAX_BUY_GUILDBANK_TABS then
				StaticPopup_Show( "CONFIRM_BUY_GUILDBANK_TAB" )
			end
		end
		
	else
		
		if button == nil then
			
			-- drag'n'drop (drop)
			
			if not ArkInventory.Global.Location[loc_id].isOffline then
				--ArkInventory.PutItemInGuildBank( tab_id )
			end
			
		else
			
			if ArkInventory.Global.Location[loc_id].isOffline then
				
				ArkInventory.Global.Location[loc_id].view_tab = bag_id
				ArkInventory.Global.Location[loc_id].view_mode = mode
				
				for x in pairs( ArkInventory.Global.Location[loc_id].Bags ) do
					if x == ArkInventory.Global.Location[loc_id].view_tab then
						codex.player.data.option[loc_id].bag[x].display = true
					else
						codex.player.data.option[loc_id].bag[x].display = false
					end
				end
				
				--ArkInventory.OutputWarning( "Frame_Changer_Vault_Tab_OnClick - .Recalculate" )
				ArkInventory.Frame_Main_Generate( loc_id, ArkInventory.Const.Window.Draw.Recalculate )
				
				return
				
			end
			
			if mode == ArkInventory.Global.Location[loc_id].view_mode and bag_id == ArkInventory.Global.Location[loc_id].view_tab then
				--ArkInventory.Output( "same tab, same mode, ignored" )
				return
			end
			
			if tab.status == ArkInventory.Const.Bag.Status.NoAccess then
				--ArkInventory.Output( "no access to this tab, ignored" )
				return
			end
			
			ArkInventory.VaultTabClick( bag_id, mode )
			
		end
		
	end
	
end

function ArkInventory.Frame_Changer_Vault_Action_OnEnter( frame )
	
	local loc_id = ArkInventory.Const.Location.Vault
	
end

function ArkInventory.Frame_Changer_Vault_Action_OnLoad( frame )
	
	local loc_id = ArkInventory.Const.Location.Vault
	
end

function ArkInventory.Frame_Changer_Vault_Action_OnClick( frame, button, mode )

	local loc_id = ArkInventory.Const.Location.Vault
	
	ArkInventory.MenuChangerVaultActionOpen( frame )
	
end

function ArkInventory.Frame_Changer_Vault_Update( )
	
	local loc_id = ArkInventory.Const.Location.Vault
	local parent = string.format( "%s%s%s%s", ArkInventory.Const.Frame.Main.Name, loc_id, ArkInventory.Const.Frame.Changer.Name, "Window" )
	
	if not _G[parent]:IsVisible( ) then
--		return
	end
	
	for bag_id in pairs( ArkInventory.Global.Location[loc_id].Bags ) do
		local frame = _G[string.format( "%s%s%s", parent, "Bag", bag_id )]
		ArkInventory.Frame_Changer_Slot_Update( frame )
	end
	
	local buttonAction = _G[string.format( "%s%s", parent, "Action" )]
	
	if ArkInventory.Global.Location[loc_id].isOffline then
		if buttonAction then buttonAction:Hide( ) end
	else
		if buttonAction then buttonAction:Show( ) end
	end
	
end

function ArkInventory.Frame_Changer_Secondary_OnDragStart( frame )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local loc_id = frame.ARK_Data.loc_id
	
	if InCombatLockdown( ) or ArkInventory.Global.Location[loc_id].isOffline or loc_id == ArkInventory.Const.Location.Vault then
		return
	end
	
	local bag_id = frame.ARK_Data.bag_id
	local inv_id = ArkInventory.InventoryIDGet( loc_id, bag_id )
	
	--ArkInventory.Output( "pick up bag ", loc_id, ".", bag_id, " = ", inv_id )
	
	PickupBagFromSlot( inv_id )
	
end

function ArkInventory.Frame_Changer_Secondary_OnReceiveDrag( frame )

	if not ArkInventory.ValidFrame( frame ) then return end

	local loc_id = frame.ARK_Data.loc_id
	
	if ArkInventory.Global.Location[loc_id].isOffline then
		return
	end
	
	ArkInventory.Frame_Changer_Slot_OnClick( frame )
	
end

function ArkInventory.Frame_Changer_Slot_OnLoad( frame )
	
	local framename = frame:GetName( )
	local loc_id, bag_id = string.match( framename, "^" .. ArkInventory.Const.Frame.Main.Name .. "(%d+).-(%d+)$" )
	
	loc_id = tonumber( loc_id )
	bag_id = tonumber( bag_id )
	
	frame.ARK_Data = {
		loc_id = loc_id,
		bag_id = bag_id,
		--blizzard_id = ArkInventory.InternalIdToBlizzardBagId( loc_id, bag_id ),
	}
	
	if frame.BattlepayItemTexture then
		frame.BattlepayItemTexture:Hide( )
	end
	
	if frame.NewItemTexture then
		frame.NewItemTexture:Hide( )
	end
	
	frame.SplitStack = nil
	
	frame.locked = nil
	
	frame:RegisterForClicks( "LeftButtonUp", "RightButtonUp" )
	
	if ( loc_id == ArkInventory.Const.Location.Bag and bag_id > 1 ) or ( loc_id == ArkInventory.Const.Location.Bank and bag_id > 1 and bag_id ~= ArkInventory.Global.Location[loc_id].tabReagent ) then
		frame:RegisterForDrag( "LeftButton" )
	end
	
	if bag_id == 1 then
		ArkInventory.SetItemButtonTexture( frame, ArkInventory.Global.Location[loc_id].Texture )
	elseif loc_id == ArkInventory.Const.Location.Bank and bag_id == ArkInventory.Global.Location[loc_id].tabReagent then
		ArkInventory.SetItemButtonTexture( frame, ArkInventory.Global.Location[loc_id].Texture )
	else
		ArkInventory.SetItemButtonTexture( frame, ArkInventory.Const.Texture.Empty.Bag )
	end
	
	local obj = frame.Count
	if obj ~= nil then
		obj:SetPoint( "BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 2 )
		obj:SetPoint( "LEFT", frame, "LEFT", 0, 0 )
	end

	local obj = _G[string.format( "%s%s", framename, "Stock" )]
	if obj ~= nil then
		obj:SetPoint( "TOPLEFT", frame, "TOPLEFT", 0, -2 )
		obj:SetPoint( "RIGHT", frame, "RIGHT", 0, 0 )
	end
	
	frame:Show( )
	
end

function ArkInventory.Frame_Changer_Slot_OnClick( frame, button )
	
	local loc_id = frame.ARK_Data.loc_id
	local bag_id = frame.ARK_Data.bag_id
	
	--ArkInventory.Output( "Frame_Changer_Slot_OnClick( ", frame:GetName( ), ", ", button, " )" )
	
	local codex = ArkInventory.GetLocationCodex( loc_id )
	local bag = codex.player.data.location[loc_id].bag[bag_id]
	
	if IsModifiedClick( "CHATLINK" ) then
		if bag and bag.h and bag.count > 0 then
			ChatEdit_InsertLink( bag.h )
		end
		return
	end
		
	if ArkInventory.Global.Mode.Edit then
		ArkInventory.MenuBagOpen( frame )
		return
	end
	
	if ArkInventory.Global.Location[loc_id].isOffline then
		return
	end
	
	if button == nil then
		
		-- drop from drag'n'drop
		if loc_id == ArkInventory.Const.Location.Bag and bag_id == 1 then
			PutItemInBackpack( )
		elseif loc_id == ArkInventory.Const.Location.Bank and bag_id == 1 then
			ArkInventory.PutItemInBank( )
		elseif loc_id == ArkInventory.Const.Location.Bank and bag_id == ArkInventory.Global.Location[loc_id].tabReagent then
			ArkInventory.PutItemInReagentBank( )
		end	
		
		return
		
	elseif button == "RightButton" then
		
		ArkInventory.MenuBagOpen( frame )
		
	elseif button == "LeftButton" then
		
		if loc_id == ArkInventory.Const.Location.Bank then
			if bag and bag.status == ArkInventory.Const.Bag.Status.Purchase then
				PlaySound( SOUNDKIT.IG_MAINMENU_OPTION )
				if bag_id == ArkInventory.Global.Location[loc_id].tabReagent then
					StaticPopup_Show( "CONFIRM_BUY_REAGENTBANK_TAB" )
				else
					StaticPopup_Show( "CONFIRM_BUY_BANK_SLOT" )
				end
				return
			end
		end
		
		if CursorHasItem( ) then
			
			if loc_id == ArkInventory.Const.Location.Bag and bag_id == 1 then
				PutItemInBackpack( )
				return
			end
		
			if loc_id == ArkInventory.Const.Location.Bank and bag_id == 1 then
				ArkInventory.PutItemInBank( )
				return
			end
			
			if loc_id == ArkInventory.Const.Location.Bank and bag_id == ArkInventory.Global.Location[loc_id].tabReagent then
				ArkInventory.PutItemInReagentBank( )
				return
			end
			
			local inv_id = ArkInventory.InventoryIDGet( loc_id, bag_id )
			--ArkInventory.Output( "drop item into ", loc_id, ".", bag_id, " / inventory slot ", inv_id )
			PutItemInBag( inv_id )
			
		else
			
			if loc_id == ArkInventory.Const.Location.Bag and bag_id == 1 then
				-- do nothing
				return
			end
		
			if loc_id == ArkInventory.Const.Location.Bank and ( bag_id == 1 or bag_id == ArkInventory.Global.Location[loc_id].tabReagent ) then
				-- do nothing
				return
			end
			
			-- pick up the bag in the slot
			ArkInventory.Frame_Changer_Secondary_OnDragStart( frame )
			
		end

	end
	
end

function ArkInventory.Frame_Changer_Slot_OnEnter( frame )
	
	local loc_id = frame.ARK_Data.loc_id
	local bag_id = frame.ARK_Data.bag_id
	
	local codex = ArkInventory.GetLocationCodex( loc_id )
	local bag = codex.player.data.location[loc_id].bag[bag_id]
	
	if ArkInventory.db.option.tooltip.show then
	
		ArkInventory.GameTooltipSetPosition( frame, true )
		
		if bag_id == 1 then
			
			if loc_id == ArkInventory.Const.Location.Bag then
				GameTooltip:SetText( BACKPACK_TOOLTIP, 1.0, 1.0, 1.0 )
			elseif loc_id == ArkInventory.Const.Location.Bank then
				GameTooltip:SetText( ArkInventory.Localise["BANK"], 1.0, 1.0, 1.0 )
			end
		
		elseif ArkInventory.Global.Location[loc_id].isOffline then
			
			if not bag or bag.count == 0 then
				
				-- do nothing
				
			else
		
				if loc_id == ArkInventory.Const.Location.Bank and bag_id == ArkInventory.Global.Location[loc_id].tabReagent then
					
					GameTooltip:SetText( ArkInventory.Localise["REAGENTBANK"], 1.0, 1.0, 1.0 )
					
				elseif bag.h then
					
					GameTooltip:SetHyperlink( bag.h )
					
				else
					
					GameTooltip:SetText( ArkInventory.Localise["STATUS_NO_DATA"], 1.0, 1.0, 1.0 )
					
				end
			
			end
		
		else
			
			if bag and bag.status == ArkInventory.Const.Bag.Status.Purchase then
				
				if loc_id == ArkInventory.Const.Location.Bank then
					
					if bag_id == ArkInventory.Global.Location[loc_id].tabReagent then
						GameTooltip:SetText( ArkInventory.Localise["TOOLTIP_PURCHASE_BANK_TAB_REAGENT"] )
					else
						GameTooltip:SetText( ArkInventory.Localise["TOOLTIP_PURCHASE_BANK_BAG_SLOT"] )
					end
					
				end
				
			elseif bag and bag.status == ArkInventory.Const.Bag.Status.Active then
				
				if loc_id == ArkInventory.Const.Location.Bank and bag_id == ArkInventory.Global.Location[loc_id].tabReagent then
					
					GameTooltip:SetText( ArkInventory.Localise["REAGENTBANK"], 1.0, 1.0, 1.0 )
					
				elseif bag.h then
					
					GameTooltip:SetInventoryItem( "player", ArkInventory.InventoryIDGet( loc_id, bag_id ) )
					
				end
				
			elseif bag and bag.status == ArkInventory.Const.Bag.Status.Unknown then
				
				GameTooltip:SetText( ArkInventory.Localise["STATUS_NO_DATA"] )
				
			end
			
		end
	
		CursorUpdate( frame )
	
	end
	
	ArkInventory.BagHighlight( frame, true )
	
end

function ArkInventory.Frame_Changer_Slot_Update( frame )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local loc_id = frame.ARK_Data.loc_id
	local bag_id = frame.ARK_Data.bag_id
	local slot_id = frame.ARK_Data.slot_id
	
	local codex = ArkInventory.GetLocationCodex( loc_id )
	local bag = codex.player.data.location[loc_id].bag[bag_id]
	
	--ArkInventory.Output( "changer update[", codex.player.data.info.name, "].loc[", loc_id, "].bag[", bag_id, "]" )
	
	if bag.count > 0 then
		frame.size = bag.count or 0
	else
		frame.size = 0
	end
	
	ArkInventory.SetItemButtonTexture( frame, bag.texture or ArkInventory.Const.Texture.Empty.Bag )
	SetItemButtonCount( frame, frame.size )
	
	if bag.status == ArkInventory.Const.Bag.Status.Active then
		ArkInventory.SetItemButtonStock( frame, bag.empty )
	else
		ArkInventory.SetItemButtonStock( frame, nil, bag.status )
	end
	
	ArkInventory.Frame_Item_Update_Fade( frame, true )
	
	ArkInventory.Frame_Item_Update_Border( frame, true )
	
	-- tint non displayed bags (except at the vault where they are faded)
	if codex.player.data.option[loc_id].bag[bag_id].display == false then
		if loc_id == ArkInventory.Const.Location.Vault then
			-- only tint no acess bags at the vault
			if bag.status == ArkInventory.Const.Bag.Status.NoAccess then
				SetItemButtonTextureVertexColor( frame, 1.0, 0.1, 0.1 )
			end
		else
			SetItemButtonTextureVertexColor( frame, 1.0, 0.1, 0.1 )
		end
	else
		if bag.status == ArkInventory.Const.Bag.Status.Purchase then
			SetItemButtonTextureVertexColor( frame, 1.0, 0.1, 0.1 )
		else
			SetItemButtonTextureVertexColor( frame, 1.0, 1.0, 1.0 )
		end
	end
	
	ArkInventory.MediaFrameFontSet( frame, nil, codex.style.slot.itemcount.font.height )
	
end

function ArkInventory.Frame_Changer_Slot_Update_Lock( loc_id, bag_id )

	local frame = _G[string.format( "%s%s%sWindowBag%s", ArkInventory.Const.Frame.Main.Name, loc_id, ArkInventory.Const.Frame.Changer.Name, bag_id )]
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	if ArkInventory.Global.Location[loc_id].isOffline then return end
	
	local me = ArkInventory.GetPlayerCodex( )
	if me.player.data.location[loc_id].bag[bag_id].h then
	
		local inv_id = ArkInventory.InventoryIDGet( loc_id, bag_id )
		local locked = IsInventoryItemLocked( inv_id )
		ArkInventory.SetItemButtonDesaturate( frame, locked )
		frame.locked = locked
	
	else
	
		frame.locked = false
	
	end

end

function ArkInventory.Frame_Changer_Generic_OnLeave( frame )
	GameTooltip:Hide( )
	ResetCursor( )
	ArkInventory.BagHighlight( frame, false )
end

function ArkInventory.BagHighlight( frame, show )
	
	if not ArkInventory.ValidFrame( frame ) then return end
	
	local loc_id = frame.ARK_Data.loc_id
	local bag_id = frame.ARK_Data.bag_id
	
	if loc_id ~=nil and bag_id ~= nil then
		
		local codex = ArkInventory.GetLocationCodex( loc_id )
		
		local b = codex.player.data.location[loc_id].bag[bag_id]
		if not b then
			return
		end
		
		local name = string.format( "%s%s%s%s%s", ArkInventory.Const.Frame.Main.Name, loc_id, ArkInventory.Const.Frame.Container.Name, "Bag", bag_id )
		local frame = _G[name]
		if not frame then
			return
		end
		
		local enabled = codex.style.changer.highlight.show
		local colour = codex.style.changer.highlight.colour
		
		for slot_id in pairs( b.slot ) do
			local obj = _G[string.format( "%s%s%s%s", name, "Item", slot_id, "ArkBagHighlight" )]
			if obj then
				ArkInventory.SetTexture( obj, enabled and show, colour.r, colour.g, colour.b, 0.3 )
			end
		end
	
	end
	
end


function ArkInventory.MyHook(...)
	if not ArkInventory:IsHooked(...) then
		ArkInventory:RawHook(...)
	end
end

function ArkInventory.MyUnhook(...)
	if ArkInventory:IsHooked(...) then
		ArkInventory:Unhook(...)
	end
end

function ArkInventory.MySecureHook(...)
	if not ArkInventory:IsHooked(...) then
		ArkInventory:SecureHook(...)
	end
end

function ArkInventory.HookOpenBackpack( self, ... )

	--ArkInventory.Output( "HookOpenBackpack( )" )
	
	local loc_id = ArkInventory.Const.Location.Bag
	
	if ArkInventory.LocationIsControlled( loc_id ) then
		-- original function returns state of backpack being open at time of call
		local BACKPACK_WAS_OPEN = ArkInventory.Frame_Main_Get( loc_id ):IsVisible( )
		ArkInventory.Frame_Main_Show( loc_id )
		return BACKPACK_WAS_OPEN
	end
	
	ArkInventory.hooks.OpenBackpack( ... )
	
end

function ArkInventory.HookToggleBackpack( self, ... )

	--ArkInventory.Output( "HookToggleBackpack( )" )
	
	local loc_id = ArkInventory.Const.Location.Bag
	
	if ArkInventory.LocationIsControlled( loc_id ) then
		ArkInventory.Frame_Main_Toggle( loc_id )
		return
	end
	
	ArkInventory.hooks.ToggleBackpack( ... )
	
end

function ArkInventory.HookOpenBag( self, ... )
	
	local bag_id = ...
	
	--ArkInventory.Output( "HookOpenBag( ", bag_id, " )" )
	
	if bag_id then
		
		local loc_id = ArkInventory.BlizzardBagIdToInternalId( bag_id )
		
		if loc_id and ( loc_id == ArkInventory.Const.Location.Bag or ( loc_id == ArkInventory.Const.Location.Bank and ArkInventory.Global.Mode.Bank ) ) then
			if ArkInventory.LocationIsControlled( loc_id ) then
				ArkInventory.Frame_Main_Show( loc_id )
				return
			end
		end
		
	end
	
	ArkInventory.hooks.OpenBag( ... )
	
end

function ArkInventory.HookToggleBag( self, ... )
	
	local bag_id = ...
	
	--ArkInventory.Output( "HookToggleBag( ", bag_id, " )" )
	
	if bag_id then
		
		local loc_id = ArkInventory.BlizzardBagIdToInternalId( bag_id )
		
		if loc_id and ( loc_id == ArkInventory.Const.Location.Bag or ( loc_id == ArkInventory.Const.Location.Bank and ArkInventory.Global.Mode.Bank ) ) then
			if ArkInventory.LocationIsControlled( loc_id ) then
				ArkInventory.Frame_Main_Toggle( loc_id )
				return
			end
		end
		
	end
	
	ArkInventory.hooks.ToggleBag( ... )
	
end

function ArkInventory.HookOpenAllBags( self, who, ... )
	
	if who then
		
		who = who:GetName( )
		local BACKPACK_WAS_OPEN = ArkInventory.Frame_Main_Get( ArkInventory.Const.Location.Bag ):IsVisible( )	
		--ArkInventory.Output( "OpenAllBags: ", who, " / ", BACKPACK_WAS_OPEN )
		
		if who == "MerchantFrame" then
			
			if ArkInventory.LocationIsControlled( ArkInventory.Const.Location.Bag ) then
				
				-- blizzard auto-opens the backpack when you talk to a merchant, do we want that to happen or not
				if not ArkInventory.db.option.auto.open.merchant and not BACKPACK_WAS_OPEN then
					-- it wasnt already opened, blizzard is about the open it, so stop them
					return
				end
				
				if MerchantBuyBackItemItemButton and MerchantBuyBackItemItemButton:IsVisible( ) then
					if GetMerchantNumItems( ) > 0 then
						--ArkInventory.Output( "auto sell starting" )
						ArkInventory.JunkSell( )
					end
				end
				
			end
		
		elseif who == "MailFrame" then
		
			if ArkInventory.LocationIsControlled( ArkInventory.Const.Location.Bag ) then
				
				-- blizzard auto-opens the backpack when you open the mailbox, do we want that to happen or not
				if not ArkInventory.db.option.auto.open.mail and not BACKPACK_WAS_OPEN then
					-- it wasnt already opened, blizzard is about the open it, so stop them
					return
				end
				
			end
			
		else
			
			ArkInventory.Output( "OpenAllBags: ", who )
			
		end
		
	end
	
	
	local loc_id = ArkInventory.Const.Location.Bag
	if ArkInventory.LocationIsControlled( loc_id ) then
		ArkInventory.Frame_Main_Show( loc_id )
	else
		CloseAllBags( )
	end
	
	if ArkInventory.Global.Mode.Bank then
		
		local loc_id = ArkInventory.Const.Location.Bank
		if not ArkInventory.LocationIsControlled( loc_id ) then
			for x = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
				if GetContainerNumSlots( x ) > 0 then
					CloseBag( x )
				end
			end
		end
		
	end
	
	local loc_id = ArkInventory.Const.Location.Bag
	if not ArkInventory.LocationIsControlled( loc_id ) then
		ArkInventory.hooks.OpenAllBags( )
	end
	
	if ArkInventory.Global.Mode.Bank then
		
		local loc_id = ArkInventory.Const.Location.Bank
		if not ArkInventory.LocationIsControlled( loc_id ) then
			for x = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
				if GetContainerNumSlots( x ) > 0 then
					ArkInventory.hooks.OpenBag( x )
				end
			end
		end
		
	end
	
end

function ArkInventory.HookToggleAllBags( self, ... )
	
	--ArkInventory.Output( "HookToggleAllBags( )" )
	
	if ArkInventory.LocationIsControlled( ArkInventory.Const.Location.Bag ) and ArkInventory.LocationIsControlled( ArkInventory.Const.Location.Bank ) then
		ArkInventory.Frame_Main_Toggle( ArkInventory.Const.Location.Bag )
		return
	end
	
	if not ArkInventory.LocationIsControlled( ArkInventory.Const.Location.Bag ) and not ArkInventory.LocationIsControlled( ArkInventory.Const.Location.Bank ) then
		ArkInventory.hooks.ToggleAllBags( ... )
		return
	end
	
	-- i have control of the bags, but not the bank
	
	local loc_id = ArkInventory.Const.Location.Bag
	if not ArkInventory.LocationIsControlled( loc_id ) then
		
		local bagsOpen = 0
		local bagsTotal = 0
		
		bagsTotal = bagsTotal + 1
		if IsBagOpen( 0 ) then
			bagsOpen = bagsOpen + 1
			CloseBackpack( )
		end
		
		for x = 1, NUM_BAG_SLOTS do
			if GetContainerNumSlots( x ) > 0 then
				bagsTotal = bagsTotal + 1
				if IsBagOpen( x ) then
					bagsOpen = bagsOpen + 1
					CloseBag( x )
				end
			end
		end
		
		if bagsOpen < bagsTotal then
			
			ArkInventory.hooks.OpenBackpack( )
			for x = 1, NUM_BAG_SLOTS do
				if GetContainerNumSlots( x ) > 0 then
					ArkInventory.hooks.OpenBag( x )
				end
			end
			
		end
		
	end
	
	
	-- i have control of the bank, but not the bags
	
	if ArkInventory.Global.Mode.Bank then
		
		local loc_id = ArkInventory.Const.Location.Bank
		if not ArkInventory.LocationIsControlled( loc_id ) then
			
			local bagsOpen = 0
			local bagsTotal = 0
			
			bagsTotal = bagsTotal + 1
			local BACKPACK_WAS_OPEN = ArkInventory.Frame_Main_Get( ArkInventory.Const.Location.Bag ):IsVisible( )
			if BACKPACK_WAS_OPEN then
				bagsOpen = bagsOpen + 1
				ArkInventory.Frame_Main_Hide( ArkInventory.Const.Location.Bag )
			end
			
			if bagsOpen < bagsTotal then
				
				ArkInventory.Frame_Main_Show( ArkInventory.Const.Location.Bag )
				
			else			
				
				bagsOpen = 0
				bagsTotal = 0
				
				for x = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
					if GetContainerNumSlots( x ) > 0 then
						bagsTotal = bagsTotal + 1
						if IsBagOpen( x ) then
							bagsOpen = bagsOpen + 1
							CloseBag( x )
						end
					end
				end
				
				if bagsOpen < bagsTotal then
					
					ArkInventory.Frame_Main_Show( ArkInventory.Const.Location.Bag )
					
					for x = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
						if GetContainerNumSlots( x ) > 0 then
							ArkInventory.hooks.OpenBag( x )
						end
					end
					
				end
				
			end
		
		end
		
	end
	
end

function ArkInventory.HookDoNothing( self )
	-- ArkInventory.OutputDebug( "HookDoNothing( )" )
	-- do nothing
end

function ArkInventory.HookGuildBankPopupOkayButton_OnClick( self )

	--ArkInventory.OutputDebug( "GuildBankPopupOkayButton_OnClick( )" )
	--ArkInventory.hooks.GuildBankPopupOkayButton_OnClick( )
	
	local loc_id = ArkInventory.Const.Location.Vault
	
	if not ArkInventory.Global.Location[loc_id].isOffline then
		ArkInventory.Frame_Main_Generate( loc_id )
	end
	
end

function ArkInventory.HookVoidStorageShow( )
	
	--ArkInventory.Output( "void storage opened" )
	
	if not ArkInventory:IsEnabled( ) then return end
	
	local loc_id = ArkInventory.Const.Location.Void
	
	if not ArkInventory.LocationIsMonitored( loc_id ) then return end
	
	ArkInventory.Global.Mode.Void = true
	ArkInventory.Global.Location[loc_id].isOffline = false
	
	ArkInventory.ScanLocation( loc_id )

	
	ArkInventory.Frame_Main_DrawStatus( loc_id, ArkInventory.Const.Window.Draw.Refresh )
	
	if ArkInventory.LocationIsControlled( loc_id ) then
		ArkInventory.Frame_Main_Show( loc_id )
	end
	
	if ArkInventory.db.option.auto.open.void and ArkInventory.LocationIsControlled( ArkInventory.Const.Location.Bag ) then
		ArkInventory.Frame_Main_Show( ArkInventory.Const.Location.Bag )
	end
	
	ArkInventory.Frame_Main_Generate( loc_id )
	
end

function ArkInventory.HookVoidStorageHide( )
	
	--ArkInventory.Output( "void storage closed" )
	
	if not ArkInventory:IsEnabled( ) then return end
	
	local loc_id = ArkInventory.Const.Location.Void
	
	if not ArkInventory.LocationIsMonitored( loc_id ) then return end
	
	ArkInventory.Global.Mode.Void = false
	ArkInventory.Global.Location[loc_id].isOffline = true
	
	ArkInventory.Frame_Main_DrawStatus( loc_id, ArkInventory.Const.Window.Draw.Refresh )
	
	if ArkInventory.LocationIsControlled( loc_id ) then
		ArkInventory.Frame_Main_Hide( loc_id )
	end
	
	if ArkInventory.db.option.auto.close.void and ArkInventory.LocationIsControlled( ArkInventory.Const.Location.Bag ) then
		ArkInventory.Frame_Main_Hide( ArkInventory.Const.Location.Bag )
	end
	
	if not ArkInventory.LocationIsSaved( loc_id ) then
		local me = ArkInventory.GetPlayerCodex( )
		ArkInventory.EraseSavedData( me.player.data.info.player_id, loc_id, not me.player.data.location[loc_id].notify )
	end
	
	ArkInventory.Frame_Main_Generate( loc_id )
	
end

function ArkInventory.HookVoidStorageEvent( self, event )
	
	--ArkInventory.Output( "void storage event ", event )
	
end

function ArkInventory.HookFloatingBattlePet_Show( ... )
	
	-- speciesID, level, breedQuality, maxHealth, power, speed, customName, bPetID
	
	if not ArkInventory:IsEnabled( ) then return end
	
	if not ArkInventory.db.option.tooltip.battlepet.enable then return end
	
	local h = ArkInventory.BattlepetBaseHyperlink( ... )
	
	FloatingBattlePetTooltip:Hide( )
	
	if not ItemRefTooltip:IsVisible( ) then
		ItemRefTooltip:SetOwner( UIParent, "ANCHOR_PRESERVE" )
	end
	
	if ItemRefTooltip:IsShown( ) and ItemRefTooltip.ARKTTD[1] == h then
		ItemRefTooltip:Hide( )
	else
		ArkInventory.TooltipBuildBattlepet( ItemRefTooltip, h )
	end
	
end

function ArkInventory.HookCPetJournalSetFavorite( ... )
	ArkInventory:SendMessage( "EVENT_ARKINV_COLLECTION_PET_UPDATE_BUCKET", "SET_FAVOURITE" )
end

function ArkInventory.HookCPetJournalSetCustomName( ... )
	ArkInventory:SendMessage( "EVENT_ARKINV_COLLECTION_PET_UPDATE_BUCKET", "RENAME" )
end

function ArkInventory.HookCToyboxSetFavorite( ... )
	ArkInventory:SendMessage( "EVENT_ARKINV_COLLECTION_TOYBOX_UPDATE_BUCKET", "SET_FAVOURITE" )
end

function ArkInventory.LoadAddOn( addonname )
	if IsAddOnLoaded( addonname ) then
		return true
	else
		local loaded, reason = LoadAddOn( addonname )
		if reason then
			ArkInventory.OutputError( "Failed to load ", addonname, ": ", getglobal( "ADDON_" .. reason ) )
		end
		return not not loaded
	end
end

function ArkInventory.BlizzardAPIHook( disable, reload )
	
	-- required blizzard internal addons - load them here as they expect to be loaded after the user has logged in, they usually have issues if you try to load them too early
	ArkInventory.LoadAddOn( "Blizzard_GuildBankUI" )
	ArkInventory.LoadAddOn( "Blizzard_VoidStorageUI" )
	ArkInventory.LoadAddOn( "Blizzard_Collections" )
	--ArkInventory.LoadAddOn( "Blizzard_ScrappingMachineUI" )
	
	local tooltip_functions = {
		"SetAuctionSellItem",
		"SetBagItem", "SetInventoryItem", "SetItemByID",
		"SetCraftItem", --"SetCraftSpell",
		"SetBackpackToken", "SetCurrencyByID", "SetCurrencyToken", "SetCurrencyTokenByID",
		"SetGuildBankItem",
		"SetHeirloomByItemID",
		"SetHyperlink", "SetHyperlinkCompareItem",
		"SetInboxItem", "SetSendMailItem",
		"SetLootItem", "SetLootRollItem",
		"SetMerchantItem", "SetMerchantCostItem", "SetBuybackItem", 
		"SetQuestItem", "SetQuestLogSpecialItem", "SetQuestLogItem", 
		"SetQuestCurrency", "SetQuestLogCurrency", "LogCurrency",
		--"SetQuestLogRewardSpell","SetQuestRewardSpell",
		"SetTradePlayerItem", "SetTradeTargetItem",
		"SetVoidItem", "SetVoidDepositItem", "SetVoidWithdrawalItem",
		"SetRecipeReagentItem", "SetRecipeResultItem",
		"SetAuctionItem",
		"SetToyByItemID",
--		"SetText",
		"ClearLines", "FadeOut",
		
--		dont ever hook these functions or they'll cause double ups
		-- "SetUnit" --  > conflicts with OnSetUnit
	}
    
	
	if not ArkInventory.Global.BlizzardAPIHook then
		
		-- void storage
		VoidStorageFrame:HookScript( "OnShow", ArkInventory.HookVoidStorageShow )
		VoidStorageFrame:HookScript( "OnHide", ArkInventory.HookVoidStorageHide )
		
		-- collections
		PetJournal:HookScript( "OnHide", ArkInventory.Collection.Pet.OnHide )
		MountJournal:HookScript( "OnHide", ArkInventory.Collection.Mount.OnHide )
		HeirloomsJournal:HookScript( "OnHide", ArkInventory.Collection.Heirloom.OnHide )
		ToyBox:HookScript( "OnHide", ArkInventory.Collection.Toybox.OnHide )
		TokenFrame:HookScript( "OnHide", ArkInventory.Collection.Currency.OnHide )
		ReputationFrame:HookScript( "OnHide", ArkInventory.Collection.Reputation.OnHide )
		
		ArkInventory.Global.BlizzardAPIHook = true
		
	end
	
	
	if not disable and not reload then
		
		-- backpack functions
		ArkInventory:RawHook( "OpenBackpack", "HookOpenBackpack", true )
		ArkInventory:RawHook( "ToggleBackpack", "HookToggleBackpack", true )
		ArkInventory:SecureHook( "BackpackTokenFrame_Update", ArkInventory.Frame_Status_Update_Tracking )
		
		-- bag functions
		ArkInventory:RawHook( "OpenBag", "HookOpenBag", true )
		ArkInventory:RawHook( "ToggleBag", "HookToggleBag", true )
		ArkInventory:RawHook( "OpenAllBags", "HookOpenAllBags", true )
		if ToggleAllBags then
			ArkInventory:RawHook( "ToggleAllBags", "HookToggleAllBags", true )
		end
		
		-- mailbox fuctions
		ArkInventory:SecureHook( "SendMail", ArkInventory.HookMailSend )
		ArkInventory:SecureHook( "ReturnInboxItem", ArkInventory.HookMailReturn )
		
		-- battlepet functions
		ArkInventory:SecureHook( C_PetJournal, "SetFavorite", ArkInventory.HookCPetJournalSetFavorite )
		ArkInventory:SecureHook( C_PetJournal, "SetCustomName", ArkInventory.HookCPetJournalSetCustomName )
		
		-- toybox functions
		ArkInventory:SecureHook( C_ToyBox, "SetIsFavorite", ArkInventory.HookCToyboxSetFavorite )
		
		-- tooltips
		for _, func in pairs( tooltip_functions ) do
			local myfunc = "HookTooltip"..func
			if not ArkInventory[myfunc] then
				ArkInventory.OutputWarning( "code issue - function for [", myfunc, "] was not found!" )
			end
		end
		
		for _, obj in pairs( ArkInventory.Global.Tooltip.WOW ) do
			if obj then
				
				ArkInventory.TooltipDataReset( obj )
				
				for _, func in pairs( tooltip_functions ) do
					local myfunc = "HookTooltip"..func
					if obj[func] and ArkInventory[myfunc] then
						ArkInventory:SecureHook( obj, func, ArkInventory[myfunc] )
					end
				end
				
				obj:HookScript( "OnHide", ArkInventory.HookTooltipOnHide )
				obj:HookScript( "OnUpdate", ArkInventory.HookTooltipOnUpdate )
				
				-- battlepet mouseovers
				if obj:HasScript( "OnTooltipSetUnit" ) then
					obj:HookScript( "OnTooltipSetUnit", ArkInventory.HookTooltipOnSetUnit )
				end
				
				if obj:HasScript( "OnTooltipSetItem" ) then
					--obj:HookScript( "OnTooltipSetItem", ArkInventory.HookTooltipOnSetItem )
				end
				
				if obj:HasScript( "OnTooltipSetSpell" ) then
					--obj:HookScript( "OnTooltipSetSpell", ArkInventory.HookTooltipOnSetSpell )
				end
				
			end
		end
		
		-- battlepet tooltips
		ArkInventory:SecureHook( "BattlePetToolTip_Show", ArkInventory.HookBattlePetToolTip_Show )
		ArkInventory:SecureHook( "FloatingBattlePet_Show", ArkInventory.HookFloatingBattlePet_Show )
		
	end
	
	
	if disable then
		ArkInventory.Frame_Main_Hide( )
	end
	
	
	-- bank
	if disable or not ArkInventory.LocationIsControlled( ArkInventory.Const.Location.Bank ) then
		BankFrame_OnHide( BankFrame )
		BankFrame:RegisterEvent( "BANKFRAME_OPENED" )
	else
		CloseBankFrame( )
		BankFrame:UnregisterEvent( "BANKFRAME_OPENED" )
	end
	
	
	-- guild bank
	if not GuildBankFrame or not GuildBankPopupFrame then
		
		ArkInventory.OutputWarning( "GuildBankFrame or GuildBankPopupFrame are missing, cannot monitor or override vault" )
		
	else
		
		if disable or not ArkInventory.LocationIsControlled( ArkInventory.Const.Location.Vault ) then
			
			-- restore guild bank functions
			
			UIParent:RegisterEvent( "GUILDBANKFRAME_OPENED" )
			
			GuildBankFrame:RegisterEvent( "GUILDBANKBAGSLOTS_CHANGED" )
			GuildBankFrame:RegisterEvent( "GUILDBANK_ITEM_LOCK_CHANGED" )
			GuildBankFrame:RegisterEvent( "GUILDBANK_UPDATE_TABS" )
			GuildBankFrame:RegisterEvent( "GUILDBANK_UPDATE_MONEY" )
			GuildBankFrame:RegisterEvent( "GUILDBANK_UPDATE_TEXT" )
			GuildBankFrame:RegisterEvent( "GUILD_ROSTER_UPDATE" )
			GuildBankFrame:RegisterEvent( "GUILDBANKLOG_UPDATE" )
			GuildBankFrame:RegisterEvent( "GUILDTABARD_UPDATE" )
			
			-- anchor pop-up to blizzard frame
			local frame = _G["GuildBankFrame"]
			if frame then
				GuildBankPopupFrame:ClearAllPoints( )
				GuildBankPopupFrame:SetPoint( "TOPLEFT", frame, "TOPRIGHT", -4, -30 )
			end
			
		else
			
			-- sever guild bank functions
			
			UIParent:UnregisterEvent( "GUILDBANKFRAME_OPENED" )
			
			GuildBankFrame:UnregisterEvent( "GUILDBANKBAGSLOTS_CHANGED" )
			GuildBankFrame:UnregisterEvent( "GUILDBANK_ITEM_LOCK_CHANGED" )
			GuildBankFrame:UnregisterEvent( "GUILDBANK_UPDATE_TABS" )
			GuildBankFrame:UnregisterEvent( "GUILDBANK_UPDATE_MONEY" )
			GuildBankFrame:UnregisterEvent( "GUILDBANK_UPDATE_TEXT" )
			GuildBankFrame:UnregisterEvent( "GUILD_ROSTER_UPDATE" )
			GuildBankFrame:UnregisterEvent( "GUILDBANKLOG_UPDATE" )
			GuildBankFrame:UnregisterEvent( "GUILDTABARD_UPDATE" )
			
			GuildBankFrame:Hide( )
			
			-- anchor popup to AI frame
			local frame = _G[string.format( ArkInventory.Const.Frame.Main.Name, ArkInventory.Const.Location.Vault )]
			if frame then
				GuildBankPopupFrame:Hide( )
				GuildBankPopupFrame:ClearAllPoints( )
				GuildBankPopupFrame:SetPoint( "TOPLEFT", frame, "TOPRIGHT", -4, -30 )
			end
			
		end
		
	end
	

	-- tooltips
	if disable or not ArkInventory.db.option.tooltip.show then
		for _, obj in pairs( ArkInventory.Global.Tooltip.WOW ) do
			ArkInventory.TooltipDataReset( tooltip )
		end
	else
		for _, obj in pairs( ArkInventory.Global.Tooltip.WOW ) do
			if obj then
				
				if ArkInventory.db.option.tooltip.scale.enabled then
					if not obj.IsEmbedded then
						-- do not scale embedded tooltips, theyre already scaled from their parent
						obj:SetScale( ArkInventory.db.option.tooltip.scale.amount or 1 )
					end
				end
				
			end
		end
	end
	
	-- battlepet tooltips
	if disable or not ArkInventory.db.option.tooltip.battlepet.enable then
		ItemRefTooltip:Hide( )
	else
		FloatingBattlePetTooltip:Hide( )
	end
	
	
end



function ArkInventory.ClassColourRGB( class )
	
	if not class then return end
	
	local ct = nil
	
	-- reminder: ct is now pointing to a secured variable, if you change it you'll taint it and screw up AI (and a lot of other mods as well) - so dont.
	
	if class == "GUILD" then
		ct = ORANGE_FONT_COLOR
	elseif class == "ACCOUNT" then
		ct = YELLOW_FONT_COLOR
	else
		ct = ( CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] ) or RAID_CLASS_COLORS[class]
	end
	
	if not ct then
		return
	end
	
	local c = { r = ct.r <= 1 and ct.r >= 0 and ct.r or 0, g = ct.g <= 1 and ct.g >= 0 and ct.g or 0, b = ct.b <= 1 and ct.b >= 0 and ct.b or 0 }
	
	return c
	
end

function ArkInventory.ClassColourCode( class )
	
	local c = ArkInventory.ClassColourRGB( class )
	
	if not c then
		return FONT_COLOR_CODE_CLOSE
	end
	
	return string.format( "|cff%02x%02x%02x", c.r * 255, c.g * 255, c.b * 255 )
	
end
	
function ArkInventory.ColourRGBtoCode( r, g, b )
	
	if not r or not g or not b then
		return FONT_COLOR_CODE_CLOSE
	end
	
	local r = r <= 1 and r >= 0 and r or 0
	local g = g <= 1 and g >= 0 and g or 0
	local b = b <= 1 and b >= 0 and b or 0
	
	return string.format( "|cff%02x%02x%02x", r * 255, g * 255, b * 255 )
	
end

function ArkInventory.ColourCodetoRGB( c )

	if not c then
		return 1, 1, 1
	end
	
	local a, r, g, b = string.match( c, "|c(%x%x)(%x%x)(%x%x)(%x%x)" )
	
	a = tonumber( a ) / 255
	r = tonumber( r ) / 255
	g = tonumber( g ) / 255
	b = tonumber( b ) / 255
	
	return r, g, b, a

end

function ArkInventory.StripColourCodes( txt )
	local txt = txt or ""
	txt = string.gsub( txt, "|c%x%x%x%x%x%x%x%x", "" )
	txt = string.gsub( txt, "|c%x%x %x%x%x%x%x", "" ) -- the trading parts colour has a space instead of a zero for some weird reason
	txt = string.gsub( txt, "|r", "" )
	return txt
end

function ArkInventory.PT_ItemInSets( item, setnames )
	
	if not item or not setnames then return false end
	
	for setname in string.gmatch( setnames, "[^,]+" ) do
		
		local r = ArkInventory.Lib.PeriodicTable:ItemInSet( item, string.trim( setname ) )
		
		if r then
			return true
		end
		
	end
	
	return false
	
end

function ArkInventory.ContainerNameGet( loc_id, bag_id )
	if loc_id ~= nil and bag_id ~= nil then
		local name = string.format( "%s%s%s%s%s", ArkInventory.Const.Frame.Main.Name, loc_id, ArkInventory.Const.Frame.Container.Name, "Bag", bag_id )
		return name, _G[name]
	end
end

function ArkInventory.ContainerItemNameGet( loc_id, bag_id, slot_id )
	local name = ArkInventory.ContainerNameGet( loc_id, bag_id )
	if name and slot_id ~= nil then
		name = string.format( "%s%s%s", name, "Item", slot_id )
		return name, _G[name]
	end
end

function ArkInventory.ToggleChanger( loc_id )
	local codex = ArkInventory.GetLocationCodex( loc_id )
	codex.style.changer.hide = not codex.style.changer.hide
	ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Refresh )
end

function ArkInventory.ToggleEditMode( )
	ArkInventory.Global.Mode.Edit = not ArkInventory.Global.Mode.Edit
	--ArkInventory.OutputWarning( "ToggleEditMode - .restart window draw" )
	ArkInventory.Frame_Main_Generate( nil, ArkInventory.Const.Window.Draw.Restart )
	--ArkInventory.Frame_Bar_Paint_All( )
end

function ArkInventory.GameTooltipSetPosition( frame, bottom )
	
	local frame = frame or UIParent
	GameTooltip:SetOwner( frame, "ANCHOR_NONE" )
	
	local anchorFromLeft = frame:GetLeft( ) + ( frame:GetRight( ) - frame:GetLeft( ) ) / 2 < GetScreenWidth( ) / 2
	
	if bottom then
		if anchorFromLeft then
			GameTooltip:SetAnchorType( "ANCHOR_BOTTOMRIGHT" )
		else
			GameTooltip:SetAnchorType( "ANCHOR_BOTTOMLEFT" )
		end
	else
		if anchorFromLeft then
			GameTooltip:SetAnchorType( "ANCHOR_RIGHT" )
		else
			GameTooltip:SetAnchorType( "ANCHOR_LEFT" )
		end
	end
	
end

function ArkInventory.GameTooltipSetText( frame, txt, r, g, b, bottom )
	ArkInventory.GameTooltipSetPosition( frame, bottom )
	GameTooltip:SetText( txt or "text is missing", r or 1, g or 1, b or 1 )
	GameTooltip:Show( )
end

function ArkInventory.GameTooltipSetHyperlink( frame, h )
	
	ArkInventory.GameTooltipSetPosition( frame )
	
	local osd = ArkInventory.ObjectStringDecode( h )
	if osd.class == "battlepet" then
		
		ArkInventory.TooltipBuildBattlepet( GameTooltip, h )
		
	elseif osd.class == "reputation" then
		
		ArkInventory.TooltipBuildReputation( GameTooltip, h )
		
	elseif osd.class == "copper" then
		
		SetTooltipMoney( GameTooltip, osd.amount )
		GameTooltip:Show( )
		
	elseif osd.class == "empty" then
		
		GameTooltip:ClearLines( )
		GameTooltip:Hide( )
		
	else
		
		GameTooltip:SetHyperlink( h )
		
	end
	
end

function ArkInventory.GameTooltipHide( )
	GameTooltip:Hide( )
end

function ArkInventory.PTItemSearch( h )
	
	-- sourced from pt3.0 because someone decided that it didnt belong in pt3.1
	
	local osd = ArkInventory.ObjectStringDecode( h )
	local item = osd.id
	
	if not item or item <= 0 then
		return nil
	end
	
	local matches = { }
	local c = 0
	for k, v in pairs( ArkInventory.Lib.PeriodicTable.sets ) do
		local _, set = ArkInventory.Lib.PeriodicTable:ItemInSet( item, k )
		if set then
			local have
			for _, v in ipairs( matches ) do
				if v == set then
					have = true
				end
			end
			if not have then
				c = c + 1
				matches[c] = set
			end
		end
	end
	
	if #matches > 0 then
		table.sort( matches )
		return matches
	end
	
end

function ArkInventory.Frame_Vault_Log_Update( )
	
	local loc_id = ArkInventory.Const.Location.Vault
	
	local numTransactions = 0
	if GuildBankFrame.mode == "log" then
		numTransactions = GetNumGuildBankTransactions( ArkInventory.Global.Location[loc_id].view_tab ) or 0
	elseif GuildBankFrame.mode == "moneylog" then
		numTransactions = GetNumGuildBankMoneyTransactions( ) or 0
	end
	
	local maxLines = numTransactions
	
	if GuildBankFrame.mode == "moneylog" then
		maxLines = maxLines + 2
	end
	
	if numTransactions == 0 then
		maxLines = 1
	end
	
	local obj = _G[string.format( "%s%s%s%s", ArkInventory.Const.Frame.Main.Name, loc_id, ArkInventory.Const.Frame.Log.Name, ArkInventory.Const.Frame.Scrolling.List )]
	obj:SetMaxLines( maxLines )
	obj:ScrollToTop( )
	
	local tab = ArkInventory.Global.Location[loc_id].view_tab
	
	--obj:SetInsertMode( "TOP" )
	--obj:AddMessage( "-*- end of list -*-" )
	
	if numTransactions == 0 then
		obj:AddMessage( ArkInventory.Localise["NO_DATA_AVAILABLE"] )
	end
	
	local msg, transaction, name, h, count, tab1, tab2, amount, year, month, day, hour, money
	
	for i = 1, numTransactions do
		
		if GuildBankFrame.mode == "log" then
			transaction, name, h, count, tab1, tab2, year, month, day, hour = GetGuildBankTransaction( tab, i )
		elseif GuildBankFrame.mode == "moneylog" then
			transaction, name, amount, year, month, day, hour = GetGuildBankMoneyTransaction( i )
		end
		
		if not name then
			name = UNKNOWN
		end
		
		name = string.format( "%s%s%s", NORMAL_FONT_COLOR_CODE, name, FONT_COLOR_CODE_CLOSE )
		
		if GuildBankFrame.mode == "log" then
			
			if transaction == "deposit" then
				msg = format( GUILDBANK_DEPOSIT_FORMAT, name, h )
				if count > 1 then
					msg = string.format( "%s%s", msg, string.format( GUILDBANK_LOG_QUANTITY, count ) )
				end
			elseif transaction == "withdraw" then
				msg = string.format( GUILDBANK_WITHDRAW_FORMAT, name, h )
				if count > 1 then
					msg = string.format( "%s%s", msg, format( GUILDBANK_LOG_QUANTITY, count ) )
				end
			elseif transaction == "move" then
				msg = format( GUILDBANK_MOVE_FORMAT, name, h, count, GetGuildBankTabInfo( tab1 ), GetGuildBankTabInfo( tab2 ) )
			end
			
		elseif GuildBankFrame.mode == "moneylog" then
			
			money = GetDenominationsFromCopper( amount )
			
			if transaction == "deposit" then
				msg = format( GUILDBANK_DEPOSIT_MONEY_FORMAT, name, money )
			elseif transaction == "withdraw" then
				msg = format( GUILDBANK_WITHDRAW_MONEY_FORMAT, name, money )
			elseif transaction == "repair" then
				msg = format( GUILDBANK_REPAIR_MONEY_FORMAT, name, money )
			elseif transaction == "withdrawForTab" then
				msg = format( GUILDBANK_WITHDRAWFORTAB_MONEY_FORMAT, name, money )
			elseif transaction == "buyTab" then
				msg = format( GUILDBANK_BUYTAB_MONEY_FORMAT, name, money )
			end
			
		end
		
		if msg then
			obj:AddMessage( string.format( "%s%s%s", msg, GUILD_BANK_LOG_TIME_PREPEND, string.format( GUILD_BANK_LOG_TIME, RecentTimeDate( year, month, day, hour ) ) ) )
		end
		
	end
	
	if GuildBankFrame.mode == "moneylog" then
		obj:AddMessage( " " )
		obj:AddMessage( string.format( "%s %s", GUILDBANK_CASHFLOW, GetDenominationsFromCopper( GetGuildBankBonusDepositMoney( ) ) ) )
	end
	
	--ArkInventory.OutputWarning( "Frame_Vault_Log_Update - .Recalculate" )
	ArkInventory.Frame_Main_Generate( loc_id, ArkInventory.Const.Window.Draw.Recalculate )
	
end

function ArkInventory.Frame_Vault_Info_Update( )
	
	local loc_id = ArkInventory.Const.Location.Vault
	local tab = ArkInventory.Global.Location[loc_id].view_tab
	local obj = _G[string.format( "%s%s%s%s", ArkInventory.Const.Frame.Main.Name, loc_id, ArkInventory.Const.Frame.Info.Name, "ScrollInfo" )]
	local text = GetGuildBankText( tab )
	
	if text then
		obj.text = text
		obj:SetText( text )
	else
		obj.text = ""
		obj:SetText( "" )
	end
	
	--ArkInventory.OutputWarning( "Frame_Vault_Info_Update - .Recalculate" )
	ArkInventory.Frame_Main_Generate( loc_id, ArkInventory.Const.Window.Draw.Recalculate )
	
end

function ArkInventory.Frame_Vault_Info_Changed( self )
	
	local loc_id = ArkInventory.Const.Location.Vault
	local tab = ArkInventory.Global.Location[loc_id].view_tab
	local button = _G[self:GetParent( ):GetParent( ):GetName( ).."Save"]
	
	if tab <= GetNumGuildBankTabs( ) and CanEditGuildTabInfo( tab ) and self:GetText( ) ~= self.text then
		button:Enable( )
	else
		button:Disable( )
	end
	
end

function ArkInventory.ScrollingMessageFrame_Scroll( parent, name, direction )

	if not parent or not name then
		return
	end
	
	local obj = _G[string.format( "%s%s", parent:GetName( ), name )]
	if not obj then
		return
	end
	
	local i = obj:GetInsertMode( )
	
	if i == "TOP" then
	
		if direction == "up" and not obj:AtBottom( ) then
			obj:ScrollDown( )
		elseif direction == "pageup" and not obj:AtBottom( ) then
			obj:PageDown( )
		elseif direction == "down" and not obj:AtTop( ) then
			obj:ScrollUp( )
		elseif direction == "pagedown" and not obj:AtTop( ) then
			obj:PageUp( )
		end
	
	else
	
		if direction == "up" and not obj:AtTop( ) then
			obj:ScrollUp( )
		elseif direction == "pageup" and not obj:AtTop( ) then
			obj:PageUp( )
		elseif direction == "down" and not obj:AtBottom( ) then
			obj:ScrollDown( )
		elseif direction == "pagedown" and not obj:AtBottom( ) then
			obj:PageDown( )
		end
	
	end
	
end

function ArkInventory.ScrollingMessageFrame_ScrollWheel( parent, name, direction )
	
	if direction == 1 then
		ArkInventory.ScrollingMessageFrame_Scroll( parent, name, "up" )
	else
		ArkInventory.ScrollingMessageFrame_Scroll( parent, name, "down" )
	end
	
end

function ArkInventory.LocationIsMonitored( loc_id ) -- listen for changes in this location
	local me = ArkInventory.GetPlayerCodex( loc_id )
	return me.profile.location[loc_id].monitor
end

function ArkInventory.LocationIsControlled( loc_id )
	local me = ArkInventory.GetPlayerCodex( loc_id )
	return me.profile.location[loc_id].override
end

function ArkInventory.LocationIsSaved( loc_id )
	local me = ArkInventory.GetPlayerCodex( loc_id )
	return me.profile.location[loc_id].save
end

function ArkInventory.DisplayName1( p )
	-- window titles (normal)
	if p.class == "ACCOUNT" then
		return p.name or ArkInventory.Localise["UNKNOWN"]
	else
		return string.format( "%s\n%s > %s", p.name or ArkInventory.Localise["UNKNOWN"], p.faction_local or ArkInventory.Localise["UNKNOWN"], p.realm or ArkInventory.Localise["UNKNOWN"] )
	end
end

function ArkInventory.DisplayName2( p )
	-- switch menu
	if p.class == "ACCOUNT" then
		return p.name or ArkInventory.Localise["UNKNOWN"]
	else
		return string.format( "%s > %s > %s", p.realm or ArkInventory.Localise["UNKNOWN"], p.faction_local or ArkInventory.Localise["UNKNOWN"], p.name or ArkInventory.Localise["UNKNOWN"] )
	end
end

function ArkInventory.DisplayName3( p, paint, ref )
	
	-- tooltip item/gold count
	assert( p, "code error: argument is missing" )
	
	local me = ArkInventory.GetPlayerCodex( )
	local ref = ref or me.player.data.info
	
	local name = p.name
	if paint then
		name = string.format( "%s%s", ArkInventory.ClassColourCode( p.class ), p.name or ArkInventory.Localise["UNKNOWN"] )
	end
	
	local realm = p.realm or ArkInventory.Localise["UNKNOWN"]
	if p.class == "ACCOUNT" or realm == ref.realm then
		realm = ""
	else
		realm = string.format( " - %s", realm )
	end
	
	local faction_local = p.faction_local or ArkInventory.Localise["UNKNOWN"]
	if p.class == "ACCOUNT" or faction_local == ref.faction_local then
		faction_local = ""
	else
		faction_local = string.format( " [%s]", faction_local )
	end
	
	return string.format( "%s%s%s", name, realm, faction_local )
	
end

function ArkInventory.DisplayName4( p, f )
	-- switch character
	if p.class == "ACCOUNT" then
		return string.format( "%s%s|r", ArkInventory.ClassColourCode( p.class ), p.name or ArkInventory.Localise["UNKNOWN"] )
	else
		if p.faction == f then
			-- same faction
			return string.format( "%s%s (%s:%s)", ArkInventory.ClassColourCode( p.class ), p.name or ArkInventory.Localise["UNKNOWN"], p.class_local or ArkInventory.Localise["UNKNOWN"], p.level or ArkInventory.Localise["UNKNOWN"] )
		else
			-- different faction so display faction name
			--return string.format( "%s%s (%s:%s) |cff7f7f7f[%s]|r", ArkInventory.ClassColourCode( p.class ), p.name or ArkInventory.Localise["UNKNOWN"], p.class_local or ArkInventory.Localise["UNKNOWN"], p.level or ArkInventory.Localise["UNKNOWN"], p.faction_local or ArkInventory.Localise["UNKNOWN"] )
			return string.format( "%s%s (%s:%s) [%s]|r", ArkInventory.ClassColourCode( p.class ), p.name or ArkInventory.Localise["UNKNOWN"], p.class_local or ArkInventory.Localise["UNKNOWN"], p.level or ArkInventory.Localise["UNKNOWN"], p.faction_local or ArkInventory.Localise["UNKNOWN"] )
		end
	end
end

function ArkInventory.DisplayName5( p )
	-- window titles (thin)
	return string.format( "%s", p.name or ArkInventory.Localise["UNKNOWN"] )
end

function ArkInventory.MemoryUsed( c )

	if c then
		collectgarbage( "stop" )
	end

	--UpdateAddOnMemoryUsage( )

	--local am = GetAddOnMemoryUsage( ArkInventory.Const.Program.Name ) * 1000
	local am = collectgarbage( "count" )
	
	if not c then
		collectgarbage( "restart" )
	end
	
	return am

end

function ArkInventory.TimeAsMinutes( )
	return math.floor( time( date( '*t' ) ) / 60 ) -- minutes
end

function ArkInventory.ItemAgeGet( age )
	
	if age and type( age ) == "number" then
		
		local s = ArkInventory.Localise["DHMS"]
		
		local x = ArkInventory.TimeAsMinutes( ) - age
		local m = x + 1 -- push seconds up so that items with less than a minute get displayed
		
		local d = math.floor( m / 1440 )
		m = math.floor( m - d * 1440 )
		local h = math.floor( m / 60 )
		m = math.floor( m - h * 60 )
		
		local t = ""
		
--[[
		if d > 0 then
			t = string.format( "%d%s ", d, string.sub( s, 1, 1 ) )
		end
		
		if h > 0 or ( d > 0 and m > 0 ) then
			t = string.format( "%s%d%s ", t, h, string.sub( s, 2, 2 ) )
		end
		
		if m > 0 and d == 0 then -- only show minutes if were not into days
			t = string.format( "%s%d%s", t, m, string.sub( s, 3, 3 ) )
		end
]]--		
		
		if d > 0 then
			t = string.format( "%d:%d%s", d, h, string.sub( s, 1, 1 ) )
		elseif h > 0 then
			t = string.format( "%d:%d%s", h, m, string.sub( s, 2, 2 ) )
		else
			t = string.format( "%d%s", m, string.sub( s, 3, 3 ) )
		end
		
		return x, string.trim( t )
		
	end
	
	return false, ""
	
end

function ArkInventory.StartupChecks( )
	
end

function ArkInventory.UiSetEditBoxLabel( frame, label )
	assert( frame and label, "code error: argument is missing" )
	_G[string.format( "%s%s", frame:GetName( ), "Label" )]:SetText( label )
end

function ArkInventory.UiTabToNext( frame, c, p, n )
	
	assert( frame and c and p and n, "code error: argument is missing" )
	
	local f = frame:GetName( )
	f = string.sub( f, 1, string.len( f ) - string.len( c ) )
	
	if IsShiftKeyDown( ) then
		f = string.format( "%s%s", f, p )
	else
		f = string.format( "%s%s", f, n )
	end
	
	local w = _G[f]
	assert( w, "code error: invalid prev/next argument" )
	w:SetFocus( )
	
end

function ArkInventory.FrameDragStart( frame )
	
	--ArkInventory.Output( "START: ", frame:GetName( ), " / level = ", frame:GetFrameLevel( ), " / strata = ", frame:GetFrameStrata( ) )
	
	frame.ARK_Data.Level = frame:GetFrameLevel( )
	
	frame:StartMoving( )
	
end
	
function ArkInventory.FrameDragStop( frame )
	
	frame:StopMovingOrSizing( )
	
	--ArkInventory.Output( "STOP: ", frame:GetName( ), " / level = ", frame:GetFrameLevel( ), " / strata = ", frame:GetFrameStrata( ) )
	
	ArkInventory.Frame_Main_Anchor_Save( frame )
	
	frame:SetUserPlaced( false )
	
end

function ArkInventory.Frame_Search_Paint( )
	
	
	if ArkInventory.Search.frame then
		ArkInventorySearch.Frame_Paint( )
	end
	
end

function ArkInventory.ThreadRunning( thread_id )
	
	if not ArkInventory.Global.Thread.Use then
		return false
	end
	
	local data = ArkInventory.Global.Thread.data[thread_id]
	if data and data.thread and type( data.thread ) == "thread" and coroutine.status( data.thread ) ~= "dead" then
		return true
	end
	
	return false
	
end

function ArkInventory.ThreadStart( thread_id, thread_func )
	
	local threads = ArkInventory.Global.Thread.data
	
	if threads[thread_id] then
		
		ArkInventory.OutputThread( string.format( "%s restarting", thread_id ) )
		
	else
		
		local tz = debugprofilestop( )
		
		ArkInventory.OutputThread( string.format( "%s starting", thread_id ) )
		threads[thread_id] = {
			timer = nil, -- if the thread needs to wait before running again then this needs to be set
			duration = 0, -- how long the thread actually ran for
		}
		
		
		if thread_id == ArkInventory.Global.Thread.Format.JunkSell then
			threads[thread_id].timer = ArkInventory.db.option.thread.timeout.junksell
		end
		
	end
	
	threads[thread_id].resumed = debugprofilestop( )
	threads[thread_id].thread = coroutine.create( thread_func )
	
	ARKINV_ThreadTimer:Show( )
	
end

function ArkInventory.ThreadResume( )
	
	local threads = ArkInventory.Global.Thread.data
	
	--ArkInventory.Output( threads )
	
	local tz = debugprofilestop( )
	
	-- we only run the first suspended thread, then we return, we dont keep looping here
	
	for thread_id, data in ArkInventory.spairs( threads, function( a, b ) return a < b end ) do
		
		if data and data.thread and type( data.thread ) == "thread" then
			
			if coroutine.status( data.thread ) == "suspended" then
				
				if data.timer then
					
					-- threads that have to wait a certain amount of time before they can run again
					
					if data.duration < data.timer then
						
						-- increment duration until timer is reached
						
						if data.duration == 0 then
							data.resumed = tz - 1 -- needs a small offset or duration never gets off zero
						end
						
						data.duration = tz - data.resumed
						
						--ArkInventory.OutputThread( string.format( "%s %s waiting %0.2fms (%0.2fms)", thread_id, coroutine.status( data.thread ), data.duration, data.timer ) )
						
						return false
						
					else
						
						--ArkInventory.OutputThread( string.format( "%s %s waited %0.2fms (%0.2fms)", thread_id, coroutine.status( data.thread ), data.duration, data.timer ) )
						
						local ok, errmsg = coroutine.resume( data.thread )
						-- yields come back here
						
						data.duration = 0
						
						if not ok then
							ArkInventory.OutputError( errmsg )
							error( errmsg )
						end
						
						return false
						
					end
					
				else
					
					-- threads that can only run for so long
					
					data.resumed = tz
					
					local ok, errmsg = coroutine.resume( data.thread )
					-- yields come back here
					
					tz = debugprofilestop( ) - data.resumed
					data.duration = data.duration + tz
					ArkInventory.OutputThread( string.format( "%s %s after %0.2fms (%0.2fms)", thread_id, coroutine.status( data.thread ), tz, data.duration ) )
					
					if not ok then
						ArkInventory.OutputError( errmsg )
						error( errmsg )
					end
					
					return false
					
				end
				
			else
				
				ArkInventory.OutputThread( thread_id, ": clearing (state is ", coroutine.status( data.thread ), ")" )
				ArkInventory.Global.Thread.data[thread_id] = nil
				return false
				
			end
			
		else
			
			ArkInventory.OutputThread( thread_id, ": clearing (not a thread)" )
			ArkInventory.Global.Thread.data[thread_id] = nil
			return false
			
		end
		
	end
	
	return true
	
end

function ArkInventory.ThreadYield( thread_id )
	
	if not ArkInventory.Global.Thread.Use then return end
	
	local threads = ArkInventory.Global.Thread.data
	
	local thread_id = thread_id or ArkInventory.Global.Thread.Format.Force
	local tz = debugprofilestop( )
	local duration = tz - threads[thread_id].resumed
	
	local timeout = ArkInventory.db.option.thread.timeout.normal
	
	if thread_id == ArkInventory.Global.Thread.Format.Tooltip then
		
		timeout = ArkInventory.db.option.thread.timeout.tooltip
		
	elseif thread_id == ArkInventory.Global.Thread.Format.JunkSell then
		
		thread_id = ArkInventory.Global.Thread.Format.Force
		
	else
		
		if InCombatLockdown( ) then
			timeout = ArkInventory.db.option.thread.timeout.combat
		end
		
	end
	
	if thread_id == ArkInventory.Global.Thread.Format.Force or duration >= timeout then
		
		if thread_id == ArkInventory.Global.Thread.Format.Force then
			ArkInventory.OutputThread( GREEN_FONT_COLOR_CODE, string.format( "%s forced yield (%0.0fms)", thread_id, duration ) )
		else
			--ArkInventory.OutputThread( GREEN_FONT_COLOR_CODE, string.format( "%s yielding %0.0f >= %0.0f", thread_id, duration, timeout ) )
		end
		
		ARKINV_ThreadTimer:Show( )
		coroutine.yield( )
		
	else
		
		--ArkInventory.OutputThread( GREEN_FONT_COLOR_CODE, string.format( "%s continue %0.0f >= %0.0f", thread_id, duration, timeout ) )
		
	end
	
end

function ArkInventory.ThreadYield_Scan( thread_id )
	ArkInventory.ThreadYield( thread_id )
end

function ArkInventory.ThreadYield_Window( loc_id )
	local thread_id
	if loc_id then
		thread_id = string.format( ArkInventory.Global.Thread.Format.Window, loc_id )
	end
	ArkInventory.ThreadYield( thread_id )
end
