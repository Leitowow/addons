local _G = _G
local select = _G.select
local pairs = _G.pairs
local ipairs = _G.ipairs
local string = _G.string
local type = _G.type
local error = _G.error
local table = _G.table

ArkInventory = LibStub( "AceAddon-3.0" ):NewAddon( "ArkInventory", "AceConsole-3.0", "AceHook-3.0", "AceEvent-3.0", "AceBucket-3.0" )

ArkInventory.Lib = { -- libraries live here
	
	Config = LibStub( "AceConfig-3.0" ),
	Dialog = LibStub( "AceConfigDialog-3.0" ),
	Serializer = LibStub( "AceSerializer-3.0" ),
	
	PeriodicTable = LibStub( "LibPeriodicTable-3.1" ),
	SharedMedia = LibStub( "LibSharedMedia-3.0" ),
	DataBroker = LibStub( "LibDataBroker-1.1" ),
	
	Dewdrop = LibStub( "ArkDewdrop" ),
	
	StaticDialog = LibStub( "LibDialog-1.0" ),
	
}

ArkInventory.Table = { } -- table functions live here, coded elsewhere

ArkInventory.Const = { -- constants
	
	TOC = select( 4, GetBuildInfo( ) ) or 0,  -- /run print( ArkInventory.Const.TOC )
	TOC_Min = 80000,
	TOC_Name = "Battle for Azeroth",
	
	Program = {
		Name = "ArkInventory",
		Version = nil, -- calculated at load
	},
	
	Blizzard = {
		Events = {
			["ACTIONBAR_UPDATE_USABLE"] = "EVENT_ARKINV_ACTIONBAR_UPDATE_USABLE",
			["ACTIVE_TALENT_GROUP_CHANGED"] = "EVENT_ARKINV_TALENT_CHANGED",
			["AUCTION_HOUSE_CLOSED"] = "EVENT_ARKINV_AUCTION_LEAVE",
			["AUCTION_OWNED_LIST_UPDATE"] = "EVENT_ARKINV_AUCTION_UPDATE",
			["AUCTION_HOUSE_SHOW"] = "EVENT_ARKINV_AUCTION_ENTER",
--			["BAG_NEW_ITEMS_UPDATED"] = "EVENT_ARKINV_BAG_UPDATE", -- fix me : do something with it?
--			["BAG_SLOT_FLAGS_UPDATED"] = "EVENT_ARKINV_BAG_UPDATE", -- fix me : do something with it?
			["BAG_UPDATE"] = "EVENT_ARKINV_BAG_UPDATE",
			["BAG_UPDATE_COOLDOWN"] = "EVENT_ARKINV_BAG_UPDATE_COOLDOWN",
			["BANKFRAME_CLOSED"] = "EVENT_ARKINV_BANK_LEAVE",
			["BANKFRAME_OPENED"] = "EVENT_ARKINV_BANK_ENTER",
--			["BANK_BAG_SLOT_FLAGS_UPDATED"] = "EVENT_ARKINV_BANK_UPDATE",
			["BATTLE_PET_CURSOR_CLEAR"] = "EVENT_ARKINV_COLLECTION_PET_UPDATE",
--			["CHAT_MSG_PET_BATTLE_COMBAT_LOG"] = "EVENT_ARKINV_COLLECTION_PET_UPDATE",
--			["CHAT_MSG_PET_BATTLE_INFO"] = "EVENT_ARKINV_COLLECTION_PET_UPDATE",
--			["CHAT_MSG_PET_INFO"] = "EVENT_ARKINV_COLLECTION_PET_UPDATE",
			["COMPANION_LEARNED"] = "EVENT_ARKINV_COLLECTION_MOUNT_UPDATE",
			["COMPANION_UNLEARNED"] = "EVENT_ARKINV_COLLECTION_MOUNT_UPDATE",
--			["COMPANION_UPDATE"] = "EVENT_ARKINV_COLLECTION_MOUNT_UPDATE", -- do i really need this? it triggers when other people mount/dismount as well
			["CURRENCY_DISPLAY_UPDATE"] = "EVENT_ARKINV_COLLECTION_CURRENCY_UPDATE",
			["CVAR_UPDATE"] = "EVENT_ARKINV_CVAR_UPDATE",
			["EQUIPMENT_SETS_CHANGED"] = "EVENT_ARKINV_EQUIPMENT_SETS_CHANGED",
--			["GET_ITEM_INFO_RECEIVED"] = "", -- do something with this?
			["GUILDBANKBAGSLOTS_CHANGED"] = "EVENT_ARKINV_VAULT_UPDATE",
			["GUILDBANKFRAME_CLOSED"] = "EVENT_ARKINV_VAULT_LEAVE",
			["GUILDBANKFRAME_OPENED"] = "EVENT_ARKINV_VAULT_ENTER",
			["GUILDBANKLOG_UPDATE"] = "EVENT_ARKINV_VAULT_LOG",
			["GUILDBANK_ITEM_LOCK_CHANGED"] = "EVENT_ARKINV_VAULT_LOCK",
			["GUILDBANK_UPDATE_MONEY"] = "EVENT_ARKINV_VAULT_MONEY",
			["GUILDBANK_UPDATE_TABS"] = "EVENT_ARKINV_VAULT_TABS",
			["GUILDBANK_UPDATE_TEXT"] = "EVENT_ARKINV_VAULT_INFO",
			["HEIRLOOMS_UPDATED"] = "EVENT_ARKINV_COLLECTION_HEIRLOOM_UPDATE",
			["ITEM_LOCK_CHANGED"] = "EVENT_ARKINV_BAG_LOCK",
--			["INVENTORY_SEARCH_UPDATE"] = "", -- do something with this?
			["LFG_BONUS_FACTION_ID_UPDATED"] = "EVENT_ARKINV_COLLECTION_REPUTATION_UPDATE",
--			["LOCALPLAYER_PET_RENAMED"] = "", -- do something with this?
			["MAIL_CLOSED"] = "EVENT_ARKINV_MAIL_LEAVE",
			["MAIL_INBOX_UPDATE"] = "EVENT_ARKINV_MAIL_UPDATE",
			["MAIL_SEND_SUCCESS"] = "EVENT_ARKINV_MAIL_SEND_SUCCESS",
			["MAIL_SHOW"] = "EVENT_ARKINV_MAIL_ENTER",
			["MERCHANT_CLOSED"] = "EVENT_ARKINV_MERCHANT_LEAVE",
			["MERCHANT_SHOW"] = "EVENT_ARKINV_MERCHANT_ENTER",
--			["MOUNT_JOURNAL_USABILITY_CHANGED"] = "", -- do something with this?
			["NEW_MOUNT_ADDED"] = "EVENT_ARKINV_COLLECTION_MOUNT_UPDATE",
			["NEW_PET_ADDED"] = "EVENT_ARKINV_COLLECTION_PET_UPDATE",
--			["OBLITERUM_FORGE_CLOSE"] = "",
--			["OBLITERUM_FORGE_SHOW"] = "",
			["PET_BATTLE_CLOSE"] = "EVENT_ARKINV_COLLECTION_PET_UPDATE",
			["PET_BATTLE_LEVEL_CHANGED"] = "EVENT_ARKINV_COLLECTION_PET_UPDATE",
			["PET_BATTLE_OPENING_DONE"] = "EVENT_ARKINV_BATTLEPET_OPENING_DONE",
--			["PET_BATTLE_OVER"] = "EVENT_ARKINV_COLLECTION_PET_UPDATE",
--			["PET_BATTLE_PET_CHANGED"] = "EVENT_ARKINV_COLLECTION_PET_UPDATE",
--			["PET_BATTLE_PET_ROUND_RESULTS"] = "EVENT_ARKINV_COLLECTION_PET_UPDATE",
			["PET_BATTLE_QUEUE_STATUS"] = "EVENT_ARKINV_COLLECTION_PET_UPDATE",
--			["PET_BATTLE_XP_CHANGED"] = "EVENT_ARKINV_COLLECTION_PET_UPDATE",
			["PET_JOURNAL_LIST_UPDATE"] = "EVENT_ARKINV_COLLECTION_PET_UPDATE",
			["PET_JOURNAL_PET_DELETED"] = "EVENT_ARKINV_COLLECTION_PET_UPDATE",
			["PET_JOURNAL_PET_RESTORED"] = "EVENT_ARKINV_COLLECTION_PET_UPDATE",
			["PET_JOURNAL_PET_REVOKED"] = "EVENT_ARKINV_COLLECTION_PET_UPDATE",
			["PET_JOURNAL_PETS_HEALED"] = "EVENT_ARKINV_COLLECTION_PET_UPDATE",
			["PLAYERBANKSLOTS_CHANGED"] = "EVENT_ARKINV_BANK_UPDATE", -- a bag_update event for the bank (-1)
			["PLAYERBANKBAGSLOTS_CHANGED"] = "EVENT_ARKINV_BANK_SLOT", -- triggered when you purchase a new bank bag slot
			["PLAYERREAGENTBANKSLOTS_CHANGED"] = "EVENT_ARKINV_REAGENTBANK_UPDATE", -- a bag_update event for the reagent bank (-3)
--			["PLAYER_CONTROL_GAINED"] = "EVENT_ARKINV_PLAYER_CONTROL_GAINED",
--			["PLAYER_CONTROL_LOST"] = "EVENT_ARKINV_PLAYER_CONTROL_LOST",
			["PLAYER_ENTERING_WORLD"] = "EVENT_ARKINV_PLAYER_ENTER", -- not really needed but seems to fix a bug where ace doesnt seem to init again
			["PLAYER_LEAVING_WORLD"] = "EVENT_ARKINV_PLAYER_LEAVE", -- when the player logs out or the UI is reloaded.
			["PLAYER_MONEY"] = "EVENT_ARKINV_PLAYER_MONEY",
			["PLAYER_REGEN_DISABLED"] = "EVENT_ARKINV_COMBAT_ENTER", -- player entered combat
			["PLAYER_REGEN_ENABLED"] = "EVENT_ARKINV_COMBAT_LEAVE", -- player left combat
			["QUEST_ACCEPTED"] = "EVENT_ARKINV_QUEST_UPDATE",
			["QUEST_FINISHED"] = "EVENT_ARKINV_QUEST_UPDATE",
--			["QUEST_ITEM_UPDATED"] = "EVENT_ARKINV_QUEST_UPDATE", -- no longer valid in BFA
--			["QUEST_LOG_UPDATE"] = "", -- triggers too often to be usable
			["REAGENTBANK_PURCHASED"] = "EVENT_ARKINV_BANK_TAB", -- triggered when you purchase a bank tab (reagent bank)
			["REAGENTBANK_UPDATE"] = "EVENT_ARKINV_REAGENTBANK_UPDATE",
			["SCRAPPING_MACHINE_CLOSE"] = "EVENT_ARKINV_SCRAP_LEAVE",
			["SCRAPPING_MACHINE_SHOW"] = "EVENT_ARKINV_SCRAP_ENTER",
			["SKILL_LINES_CHANGED"] = "EVENT_ARKINV_PLAYER_SKILLS", -- triggered when you gain or lose a skill, skillup, collapse/expand a skill header
			["TRADE_CLOSED"] = "EVENT_ARKINV_TRADE_LEAVE",
			["TRADE_SHOW"] = "EVENT_ARKINV_TRADE_ENTER",
			["TRANSMOGRIFY_CLOSE"] = "EVENT_ARKINV_MERCHANT_LEAVE",
			["TRANSMOGRIFY_OPEN"] = "EVENT_ARKINV_TRANSMOG_ENTER",
			["TOYS_UPDATED"] = "EVENT_ARKINV_COLLECTION_TOYBOX_UPDATE",
			["UNIT_INVENTORY_CHANGED"] = "EVENT_ARKINV_INVENTORY_CHANGE",
--			["UNIT_POWER"] = "EVENT_ARKINV_UNIT_POWER",
			["UNIT_QUEST_LOG_CHANGED"] = "EVENT_ARKINV_QUEST_UPDATE",
			["UPDATE_FACTION"] = "EVENT_ARKINV_COLLECTION_REPUTATION_UPDATE",
--			["VOID_DEPOSIT_WARNING"] = "EVENT_ARKINV_VOID_UPDATE",
			["VOID_STORAGE_CONTENTS_UPDATE"] = "EVENT_ARKINV_VOID_UPDATE",
--			["VOID_STORAGE_DEPOSIT_UPDATE"] = "EVENT_ARKINV_VOID_UPDATE",
			["VOID_STORAGE_UPDATE"] = "EVENT_ARKINV_VOID_UPDATE",
--			["VOID_TRANSFER_DONE"] = "EVENT_ARKINV_VOID_UPDATE",
--			["ZONE_CHANGED"] = "EVENT_ARKINV_ZONE_CHANGED",
--			["ZONE_CHANGED_INDOORS"] = "EVENT_ARKINV_ZONE_CHANGED",
--			["ZONE_CHANGED_NEW_AREA"] = "EVENT_ARKINV_ZONE_CHANGED",
		},
	},
	
	SLOT_SIZE = 37,
	MAX_PET_LEVEL = 25,
	MAX_ACTIVE_PETS = 3,
	MAX_PET_SAVED_SPECIES = 3,
	VOID_STORAGE_MAX = 80,
	VOID_STORAGE_PAGES = 2,
	TOOLTIP_UPDATE_TIME = 1,
	
	Frame = {
		Main = {
			Name = "ARKINV_Frame",
			MiniActionButtonSize = 12,
		},
		Title = {
			Name = "Title",
			Height = 20,
			MinHeight = 20,
		},
		Scroll = {
			Name = "Scroll",
			stepSize = 40,
		},
		Container = {
			Name = "ScrollContainer",
		},
		Log = {
			Name = "Log",
		},
		Info = {
			Name = "Info",
		},
		Changer = {
			Name = "Changer",
			Height = 58,
		},
		Status = {
			Name = "Status",
			Height = 10,
			MinHeight = 20,
		},
		Search = {
			Name = "Search",
			Height = 10,
			MinHeight = 20,
		},
		Scrolling = {
			List = "List",
			ScrollBar = "ScrollBar",
		},
		Config = {
			Internal = "ArkInventory",
			Blizzard = "ArkInventoryConfigBlizzard",
		},
		Cooldown = {
			Name = "Cooldown",
		},
	},
	
	Debug = false,
	
	Event = {
		BagUpdate = 1,
		--ObjectLock = 2,
		--PlayerMoney = 3,
		--GuildMoney = 4,
		--TabInfo = 5,
		--SkillUpdate = 6,
		--ItemUpdate = 7,
		--BagEmpty = 8,
	},

	Location = {
		Bag = 1,
		--Key = 2,
		Bank = 3,
		Vault = 4,
		Mail = 5,
		Wearing = 6,
		Pet = 7,
		Mount = 8,
		Token = 9,
		Auction = 10,
		--Spellbook = 11,
		--Tradeskill = 12,
		Void = 13,
		Toybox = 14,
		Heirloom = 15,
		Reputation = 16,
	},

	Offset = {
		Vault = 1000,
		Mail = 2000,
		Wearing = 3000,
		Pet = 4000,
		Token = 5000,
		Mount = 6000,
		Auction = 7000,
		--Spellbook = 8000,
		--Tradeskill = 9000,
		Void = 1500,
		Toybox = 1200,
		Heirloom = 1300,
		Reputation = 1600,
	},
	
	Bag = {
		Status = { -- these need to be negative values,  do not use -1
			Unknown = -2,
			Active = -3,
			Empty = -4,
			Purchase = -5,
			NoAccess = -6,
		},
	},
	
	Slot = {
		
		Type = { -- slot type numbers, do not change this order, just add new ones to the end of the list
			Unknown = 0,
			Bag = 1,
			--Key = 3,
			--Soulshard = 5,
			Herb = 6,
			Enchanting = 7,
			Engineering = 8,
			Gem = 9,
			Mining = 10,
			--Bullet = 11,
			--Arrow = 12,
			Leatherworking = 13,
			Wearing = 14,
			Mail = 15,
			Inscription = 16,
			Critter = 17,
			Mount = 18,
			Token = 19,
			Auction = 20,
			--Spellbook = 21,
			--Tradeskill = 22,
			Tackle = 23,
			Void = 24,
			Cooking = 25,
			Toybox = 26,
			ReagentBank = 27,
			Heirloom = 28,
			Reputation = 29,
		},

		New = {
			No = false,
			Yes = 1,
			Inc = 2,
			Dec = 3,
		},
	
		Data = { },
		
		ItemLevel = {
			Min = 1,
			Max = 9999,
		},
		
	},

	Anchor = {
		Default = 0,
		BottomRight = 1,
		BottomLeft = 2,
		TopLeft = 3,
		TopRight = 4,
		Top = 5,
		Bottom = 6,
		Left = 7,
		Right = 8,
	},
	
	Direction = {
		Horizontal = 1,
		Vertical = 2,
	},
	
	Window = {
		
		Min = {
			Rows = 1,
			Columns = 6,
			Width = 400,
		},
		
		Draw = {
			Init = 0, -- intital state, only exists at load, never set to init
			Restart = 1, -- rebuild the entire window from scratch
			Recalculate = 2, -- calculate
			Resort = 3, -- sort
			Refresh = 4, -- item changes
			None = 5, -- nothing
		},
		
		Title = {
			SizeNormal = 1,
			SizeThin = 2,
		},
	},
	
	Font = {
		Face = "Arial Narrow",
		Height = 16,
		MinHeight = 4,
		MaxHeight = 72,
	},
	
	Fade = 0.6,
	GuildTag = "+",
	PlayerIDSep = " - ",
	
	ItemClass = {
		
		["UNKNOWN"] = -2,
		
		["EMPTY"] = -1,
		
		["CONSUMABLE"] = LE_ITEM_CLASS_CONSUMABLE,
		["CONSUMABLE_EXPLOSIVES_AND_DEVICES"] = 0,
		["CONSUMABLE_POTION"] = 1,
		["CONSUMABLE_ELIXIR"] = 2,
		["CONSUMABLE_FLASK"] = 3,
		["CONSUMABLE_SCROLL"] = 4, -- OBSOLETE
		["CONSUMABLE_FOOD_AND_DRINK"] = 5,
		["CONSUMABLE_ITEM_ENHANCEMENT"] = 6, -- OBSOLETE
		["CONSUMABLE_BANDAGE"] = 7,
		["CONSUMABLE_OTHER"] = 8,
		["CONSUMABLE_VANTUSRUNE"] = 9,
		
		["CONTAINER"] = LE_ITEM_CLASS_CONTAINER,
		["CONTAINER_BAG"] = 0,
		["CONTAINER_SOUL"] = 1,
		["CONTAINER_HERB"] = 2,
		["CONTAINER_ENCHANTING"] = 3,
		["CONTAINER_ENGINEERING"] = 4,
		["CONTAINER_GEM"] = 5,
		["CONTAINER_MINING"] = 6,
		["CONTAINER_LEATHERWORKING"] = 7,
		["CONTAINER_INSCRIPTION"] = 8,
		["CONTAINER_FISHING"] = 9,
		["CONTAINER_COOKING"] = 10,
		
		["WEAPON"] = LE_ITEM_CLASS_WEAPON,
		["WEAPON_AXE1H"] = LE_ITEM_WEAPON_AXE1H,
		["WEAPON_AXE2H"] = LE_ITEM_WEAPON_AXE2H,
		["WEAPON_MACE1H"] = LE_ITEM_WEAPON_MACE1H,
		["WEAPON_MACE2H"] = LE_ITEM_WEAPON_MACE2H,
		["WEAPON_SWORD1H"] = LE_ITEM_WEAPON_SWORD1H,
		["WEAPON_SWORD2H"] = LE_ITEM_WEAPON_SWORD2H,
		["WEAPON_WARGLAIVE"] = LE_ITEM_WEAPON_WARGLAIVE,
		["WEAPON_DAGGER"] = LE_ITEM_WEAPON_DAGGER,
		["WEAPON_FIST"] = LE_ITEM_WEAPON_UNARMED,
		["WEAPON_WAND"] = LE_ITEM_WEAPON_WAND,
		["WEAPON_POLEARM"] = LE_ITEM_WEAPON_POLEARM,
		["WEAPON_STAFF"] = LE_ITEM_WEAPON_STAFF,
		["WEAPON_BOW"] = LE_ITEM_WEAPON_BOWS,
		["WEAPON_CROSSBOW"] = LE_ITEM_WEAPON_CROSSBOW,
		["WEAPON_GUN"] = LE_ITEM_WEAPON_GUNS,
		["WEAPON_THROWN"] = LE_ITEM_WEAPON_THROWN,
		["WEAPON_FISHING"] = LE_ITEM_WEAPON_FISHINGPOLE,
		["WEAPON_GENERIC"] = LE_ITEM_WEAPON_GENERIC,
		
		["GEM"] = LE_ITEM_CLASS_GEM,
		["GEM_ARTIFACT_RELIC"] = 11,
		
		["ARMOR"] = LE_ITEM_CLASS_ARMOR,
		["ARMOR_CLOTH"] = LE_ITEM_ARMOR_CLOTH,
		["ARMOR_LEATHER"] = LE_ITEM_ARMOR_LEATHER,
		["ARMOR_MAIL"] = LE_ITEM_ARMOR_MAIL,
		["ARMOR_PLATE"] = LE_ITEM_ARMOR_PLATE,
		["ARMOR_GENERIC"] = LE_ITEM_ARMOR_GENERIC,
		["ARMOR_SHIELD"] = LE_ITEM_ARMOR_SHIELD,
		["ARMOR_COSMETIC"] = LE_ITEM_ARMOR_COSMETIC,
		
		["REAGENT"] = LE_ITEM_CLASS_REAGENT,
		["REAGENT_REAGENT"] = 0,
		["REAGENT_KEYSTONE"] = 1,
		
		["PROJECTILE"] = LE_ITEM_CLASS_PROJECTILE,
		["PROJECTILE_WAND"] = 0, -- OBSOLETE
		["PROJECTILE_BOLT"] = 1, -- OBSOLETE
		["PROJECTILE_ARROW"] = 2,
		["PROJECTILE_BULLET"] = 3,
		["PROJECTILE_THROWN"] = 4, -- OBSOLETE
		
		["TRADEGOODS"] = LE_ITEM_CLASS_TRADEGOODS,
		["TRADEGOODS_TRADEGOODS"] = 0, -- OBSOLETE
		["TRADEGOODS_PARTS"] = 1,
		["TRADEGOODS_EXPLOSIVES"] = 2, -- OBSOLETE
		["TRADEGOODS_DEVICES"] = 3, -- OBSOLETE
		["TRADEGOODS_JEWELCRAFTING"] = 4,
		["TRADEGOODS_CLOTH"] = 5,
		["TRADEGOODS_LEATHER"] = 6,
		["TRADEGOODS_METAL_AND_STONE"] = 7,
		["TRADEGOODS_COOKING"] = 8,
		["TRADEGOODS_HERB"] = 9,
		["TRADEGOODS_ELEMENTAL"] = 10,
		["TRADEGOODS_OTHER"] = 11,
		["TRADEGOODS_ENCHANTING"] = 12,
		["TRADEGOODS_MATERIALS"] = 13, -- OBSOLETE
		["TRADEGOODS_ITEM_ENCHANTMENT"] = 14, -- OBSOLETE
		["TRADEGOODS_WEAPON_ENCHANTMENT"] = 15, --OBSOLETE
		["TRADEGOODS_INSCRIPTION"] = 16,
		["TRADEGOODS_EXPLOSIVES_AND_DEVICES"] = 17, -- OBSOLETE
		
		["ITEM_ENHANCEMENT"] = LE_ITEM_CLASS_ITEM_ENHANCEMENT,
		
		["RECIPE"] = LE_ITEM_CLASS_RECIPE,
		["RECIPE_BOOK"] = LE_ITEM_RECIPE_BOOK,
		["RECIPE_LEATHERWORKING"] = LE_ITEM_RECIPE_LEATHERWORKING,
		["RECIPE_TAILORING"] = LE_ITEM_RECIPE_TAILORING,
		["RECIPE_ENGINEERING"] = LE_ITEM_RECIPE_ENGINEERING,
		["RECIPE_BLACKSMITHING"] = LE_ITEM_RECIPE_BLACKSMITHING,
		["RECIPE_COOKING"] = LE_ITEM_RECIPE_COOKING,
		["RECIPE_ALCHEMY"] = LE_ITEM_RECIPE_ALCHEMY,
		["RECIPE_FIRST_AID"] = LE_ITEM_RECIPE_FIRST_AID,
		["RECIPE_ENCHANTING"] = LE_ITEM_RECIPE_ENCHANTING,
		["RECIPE_FISHING"] = LE_ITEM_RECIPE_FISHING,
		["RECIPE_JEWELCRAFTING"] = LE_ITEM_RECIPE_JEWELCRAFTING,
		["RECIPE_INSCRIPTION"] = LE_ITEM_RECIPE_INSCRIPTION,
		
		["QUIVER"] = LE_ITEM_CLASS_QUIVER,
		["QUIVER_QUIVER"] = 0,  -- OBSOLETE
		["QUIVER_BOLT"] = 1, -- OBSOLETE
		["QUIVER_QUIVER"] = 2,
		["QUIVER_AMMO_POUCH"] = 3,
		
		["QUEST"] = LE_ITEM_CLASS_QUESTITEM,
		["QUEST_QUEST"] = 0,
		
		["KEY"] = LE_ITEM_CLASS_KEY,
		["KEY_KEY"] = 0,
		["KEY_LOCKPICK"] = 1,
		
		["MISC"] = LE_ITEM_CLASS_MISCELLANEOUS,
		["MISC_JUNK"] = LE_ITEM_MISCELLANEOUS_JUNK,
		["MISC_REAGENT"] = LE_ITEM_MISCELLANEOUS_REAGENT,
		["MISC_PET"] = LE_ITEM_MISCELLANEOUS_COMPANION_PET,
		["MISC_HOLIDAY"] = LE_ITEM_MISCELLANEOUS_HOLIDAY,
		["MISC_OTHER"] = LE_ITEM_MISCELLANEOUS_OTHER,
		["MISC_MOUNT"] = LE_ITEM_MISCELLANEOUS_MOUNT,
		
		["GLYPH"] = LE_ITEM_CLASS_GLYPH,
		
		["BATTLEPET"] = LE_ITEM_CLASS_BATTLEPET,
--		"0 Humanoid", -- [163]
--		"1 Dragonkin", -- [164]
--		"2 Flying", -- [165]
--		"3 Undead", -- [166]
--		"4 Critter", -- [167]
--		"5 Magic", -- [168]
--		"6 Elemental", -- [169]
--		"7 Beast", -- [170]
--		"8 Aquatic", -- [171]
--		"9 Mechanical", -- [172]
		
		["WOW_TOKEN"] = ITEM_CLASS_WOW_TOKEN,
--		"0 WoW Token", -- [174]
		
	},
	
	InventorySlotName = { "HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot", "ShirtSlot", "TabardSlot", "WristSlot", "HandsSlot", "WaistSlot", "LegsSlot", "FeetSlot", "Finger0Slot", "Finger1Slot", "Trinket0Slot", "Trinket1Slot", "MainHandSlot", "SecondaryHandSlot" },
	
	Texture = {
		
		Missing = [[Interface\Icons\Temp]],
		
		Empty = {
			Item = [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
			Bag = [[Interface\PaperDoll\UI-PaperDoll-Slot-Bag]],
		},
		
		CategoryDamaged = [[Interface\Icons\Spell_Shadow_DeathCoil]],
		CategoryEnabled = [[Interface\RAIDFRAME\ReadyCheck-Ready]],
		CategoryDisabled = [[Interface\RAIDFRAME\ReadyCheck-NotReady]],
		
		BackgroundDefault = "Solid",
		
		BorderDefault = "Blizzard Tooltip",
		BorderNone = "None",
		
		Border = {
			["Blizzard Tooltip"] = {
				["size"] = 16,
				["offset"] = nil,
				["offsetdefault"] = {
					["slot"] = 4,
					["bar"] = 3,
					["window"] = 3,
				},
				["scale"] = 1,
			},
			["Blizzard Dialog"] = {
				["size"] = 32,
				["offset"] = nil,
				["offsetdefault"] = {
					["slot"] = 9,
					["bar"] = 6,
					["window"] = 6,
				},
			},
			["Blizzard Dialog Gold"] = {
				["size"] = 32,
				["offset"] = nil,
				["offsetdefault"] = {
					["slot"] = 9,
					["bar"] = 6,
					["window"] = 6,
				},
			},
			["ArkInventory Tooltip 1"] = {
				["size"] = 16,
				["offset"] = nil,
				["offsetdefault"] = {
					["slot"] = 3,
					["bar"] = 3,
					["window"] = 3,
				},
			},
			["ArkInventory Tooltip 2"] = {
				["size"] = 16,
				["offset"] = nil,
				["offsetdefault"] = {
					["slot"] = 4,
					["bar"] = 3,
					["window"] = 3,
				},
			},
			["ArkInventory Tooltip 3"] = {
				["size"] = 16,
				["offset"] = nil,
				["offsetdefault"] = {
					["slot"] = 5,
					["bar"] = 4,
					["window"] = 4,
				},
			},
			["ArkInventory Square 1"] = {
				["size"] = 16,
				["offset"] = nil,
				["offsetdefault"] = {
					["slot"] = 3,
					["bar"] = 3,
					["window"] = 3,
				},
			},
			["ArkInventory Square 2"] = {
				["size"] = 16,
				["offset"] = nil,
				["offsetdefault"] = {
					["slot"] = 4,
					["bar"] = 3,
					["window"] = 3,
				},
			},
			["ArkInventory Square 3"] = {
				["size"] = 16,
				["offset"] = nil,
				["offsetdefault"] = {
					["slot"] = 5,
					["bar"] = 4,
					["window"] = 4,
				},
			},
		},
		
		Yes = [[Interface\RAIDFRAME\ReadyCheck-Ready]],
		No = [[Interface\RAIDFRAME\ReadyCheck-NotReady]],
		
	},
	
	SortKeys = { -- true = keep, false = remove
		category = true,
		location = true,
		itemuselevel = true,
		itemstatlevel = true,
		itemtype = true,
		quality = true,
		name = true,
		vendorprice = true,
		itemage = true,
		id = true,
		slottype = true,
		expansion = true,
	},

	DatabaseDefaults = { },
	
	MountTypes = {
		["l"] = 0x01, -- land
		["a"] = 0x02, -- air
		["s"] = 0x04, -- water surface
		["u"] = 0x08, -- underwater
		["x"] = 0x00, -- ignored / unknown
	},
	
	booleantable = { true, false },
	
	Realm = { }, -- connected realm array
	
	SortWhen = {
		Instant = 1,
		Open = 2,
		Manual = 3,
	},
	
	ActionID = {
		MainMenu = 0,
		Close = 1,
		EditMode = 2,
		Rules = 3,
		Search = 4,
		SwitchCharacter = 5,
		SwitchLocation = 6,
		Restack = 7,
		Changer = 8,
		Refresh = 9,
	},
	
	Bind = {
		Never = 0,
		Use = 1,
		Equip = 2,
		Pickup = 3,
		Account = 4,
	},
	
	Reputation = {
		Custom = {
			Default = 1,
			Custom = 2,
		},
		Style = {
			TooltipNormal = "*st**pv**pr* (*br*)", -- rep tooltip
			TooltipItemCount = "*st**pv**pr* (*br*)", -- itemcount tooltip
			TwoLines = "*st**pv**pr*\n*bc*", -- List view
			OneLine = "*st**pv**pr* *bc*", -- LDB tooltip
			OneLineWithName = "*nn*: *st**pv**pr* *bc*", -- LDB text
		},
	},
	
	Transmog = {
		State = {
			CanLearnMyself = 1,
			CanLearnMyselfSecondary = 2,
			CanLearnOther = 3,
			CanLearnOtherSecondary = 4,
		},
		StyleDefault = "Smiley Face",
		SharedMediaType = "arkinventory-icons-transmog",
	},
	
	ItemStats = { 
		
--[[
		ITEM_MOD_AGILITY_SHORT,
		ITEM_MOD_ATTACK_POWER_SHORT,
		ITEM_MOD_BLOCK_RATING_SHORT,
		ITEM_MOD_BLOCK_VALUE_SHORT,
		ITEM_MOD_CRIT_RATING_SHORT,
		ITEM_MOD_DEFENSE_SKILL_RATING_SHORT,
		ITEM_MOD_DODGE_RATING_SHORT,
		ITEM_MOD_EXPERTISE_RATING_SHORT,
		ITEM_MOD_EXTRA_ARMOR_SHORT,
		ITEM_MOD_HASTE_RATING_SHORT,
		ITEM_MOD_HIT_RATING_SHORT,
		ITEM_MOD_HIT_TAKEN_RATING_SHORT,
		ITEM_MOD_INTELLECT_SHORT,
		ITEM_MOD_MASTERY_RATING_SHORT,
		ITEM_MOD_PARRY_RATING_SHORT,
		ITEM_MOD_PVP_POWER_SHORT,
		ITEM_MOD_SPELL_POWER_SHORT,
		ITEM_MOD_SPIRIT_SHORT,
		ITEM_MOD_STAMINA_SHORT,
		ITEM_MOD_STRENGTH_SHORT,
		ITEM_MOD_VERSATILITY,
]]--
		
		ITEM_MOD_CR_AVOIDANCE_SHORT,
		ITEM_MOD_CR_LIFESTEAL_SHORT,
		ITEM_MOD_CR_MULTISTRIKE_SHORT,
		ITEM_MOD_CR_SPEED_SHORT,
		ITEM_MOD_CR_STURDINESS_SHORT,
		
	},
	
}

function ArkInventory.OutputSerialize( d )
	if d == nil then
		return "nil"
	elseif type( d ) == "number" then
		return tostring( d )
	elseif type( d ) == "string" then
		--return string.format( "%q", d )
		return d
	elseif type( d ) == "boolean" then
		if d then
			return "true"
		else
			return "false"
		end
	elseif type( d ) == "table" then
		local tmp = { }
		local c = 0
		for k, v in pairs( d ) do
			c = c + 1
			tmp[c] = string.format( "[%s]=%s", ArkInventory.OutputSerialize( k ), ArkInventory.OutputSerialize( v ) )
		end
		return string.format( "{ %s }", table.concat( tmp, ", " ) )
	else
		return string.format( "**%s**", type( d ) or ArkInventory.Localise["UNKNOWN"] )
	end
end

local ArkInventory_TempOutputTable = { }

function ArkInventory.Output( ... )
	
	if not DEFAULT_CHAT_FRAME then
		return
	end
	
	table.wipe( ArkInventory_TempOutputTable )
	
	local n = select( '#', ... )
	
	if n == 0 then
		
		ArkInventory:Print( "nil" )
		
	else
		
		for i = 1, n do
			local v = select( i, ... )
			ArkInventory_TempOutputTable[i] = ArkInventory.OutputSerialize( v )
		end
		
		ArkInventory:Print( table.concat( ArkInventory_TempOutputTable ) )
		
	end
	
end

function ArkInventory.OutputThread( ... )
	if ArkInventory.db.option.thread.debug then
		ArkInventory.Output( "|cffffff9aTHREAD> ", ... )
	end
end

function ArkInventory.OutputDebug( ... )
	if ArkInventory.Const.Debug then
		ArkInventory.Output( "|cffffff9aDEBUG> ", ... )
	end
end

function ArkInventory.OutputWarning( ... )
	ArkInventory.Output( "|cfffa8000WARNING> ", ... )
end

function ArkInventory.OutputError( ... )
	ArkInventory.Output( RED_FONT_COLOR_CODE, ERROR_CAPS, "> ", ... )
end

function ArkInventory.OutputDebugModeSet( value )
	
	if ArkInventory.Const.Debug ~= value then
		
		local state = ArkInventory.Localise["ENABLED"]
		if not value then
			state = ArkInventory.Localise["DISABLED"]
		end
		
		ArkInventory.Const.Debug = value
		
		ArkInventory.Output( "debug mode is now ", state )
		
	end
	
end


function ArkInventory.Table.Sum( src, fcn )
	local r = 0
	for k, v in pairs( src ) do
		r = r + ( fcn( v ) or 0 )
	end
	return r
end

function ArkInventory.Table.Max( src, fcn )
	local r = nil
	for k, v in pairs( src ) do
		if not r then
			r = ( fcn( v ) or 0 )
		else
			if ( fcn( v ) or 0 ) > r then
				r = ( fcn( v ) or 0 )
			end
		end
	end
	return r
end

function ArkInventory.Table.Elements( src )
	-- #table only returns the number of elements where the table keys are numeric and does not take into account missing values
	if src and type( src ) == "table" then
		local r = 0
		for _ in pairs( src ) do
			r = r + 1
		end
		return r
	end
end

function ArkInventory.Table.IsEmpty( src )
	-- #table only returns the number of elements where the table keys are numeric and does not take into account missing values
	if src and type( src ) == "table" then
		for _ in pairs( src ) do
			return false
		end
		return true
	end
end

function ArkInventory.Table.Clean( src, key, nilsubtables )

	-- src = table to be cleaned

	-- key = a specific key you want cleaned (nil for all keys)

	-- nilsubtables (true) = if a value is a table then nil it as well
	-- nilsubtables (false) = if a value is a table then leave the skeleton there
	
	if type( src ) ~= "table" then
		return
	end
	
	for k, v in pairs( src ) do
		
		if key == nil or key == k then
		
			if type( v ) == "table" then
				
				ArkInventory.Table.Clean( v, nil, nilsubtables )
				
				if nilsubtables then
					--ArkInventory.Output( "erasing subtable ", k )
					src[k] = nil
				end
				
			else
				
				--ArkInventory.Output( "erasing value ", k )
				src[k] = nil

			end
			
		end
		
	end

end

function ArkInventory.Table.Copy( src )
	
	local cpy
	
	if type( src ) == "table" then
		
		cpy = { }
		
		for src_key, src_val in next, src, nil do
			cpy[ArkInventory.Table.Copy( src_key )] = ArkInventory.Table.Copy( src_val )
		end
		
		if getmetatable( src ) then
			setmetatable( cpy, ArkInventory.Table.Copy( getmetatable( src ) ) )
		end
		
	else
		
		cpy = src
		
	end
	
	return cpy
	
end

function ArkInventory.Table.Merge( src, dst )
	
	if type( src ) == "table" and type( dst ) == "table" then
		
		for key, val in next, src, nil do
			
			if type( val ) == "table" then
				if dst[key] == nil then
					dst[ArkInventory.Table.Copy( key )] = ArkInventory.Table.Copy( val )
				end
				ArkInventory.Table.Merge( src[key], dst[key] )
			else
				dst[ArkInventory.Table.Copy( key )] = ArkInventory.Table.Copy( val )
			end
			
		end
		
	end
	
end

function ArkInventory.Table.Subset( t1, t2 )
	
	-- t1 must be a subset of t2
	
	if type( t1 ) == "table" and type( t2 ) == "table" then
		
		for k, v in pairs( t1 ) do
			
			if type( v ) == "table" then
				if not ArkInventory.Table.Subset( v, t2[k] ) then
					return
				end
			elseif type( v ) == "number" or type( v ) == "string" then
				if v ~= t2[k] then
					return
				end
			end
			
		end
		
		return true
		
	end
	
end

function ArkInventory.Table.removeDefaults( tbl, def )
	
	if type( tbl ) ~= "table" then
		return
	end
	
	setmetatable( tbl, nil )
	
	for k, v in pairs( tbl ) do
		if type( v ) == "table" then
			if type( def ) == "table" then
				ArkInventory.Table.removeDefaults( v, def[k] )
			else	
				ArkInventory.Table.removeDefaults( v )
			end
			if ArkInventory.Table.IsEmpty( v ) then
				tbl[k] = nil
			end
		else
			if type( def ) == "table" and v == def[k] then
				tbl[k] = nil
			end
		end
	end
	
end


local function spairs_iter( a )
	a.idx = a.idx + 1
	local k = a[a.idx]
	if k ~= nil then
		return k, a.tbl[k]
	end
	--table.wipe( a )
	a.tbl = nil
end

function ArkInventory.spairs( tbl, cf )
	
	if type( tbl ) ~= "table" then return end
	
	local a = { }
	local c = 0
	
	for k in pairs( tbl ) do
		c = c + 1
		a[c] = k
	end
	
	table.sort( a, cf )
	
	a.idx = 0
	a.tbl = tbl
	
	return spairs_iter, a
	
end











--[[
for x = 0, 50 do
	local n = GetItemClassInfo( x )
	if n and n ~= "" then
		ArkInventory.Output( "----------" )
		ArkInventory.Output( x, " ", n )
	end
	for y = 0, 50 do
		n = GetItemSubClassInfo( x, y )
		if n and n ~= "" then
			ArkInventory.Output( y, " ", n )
		end
	end
end
]]--
