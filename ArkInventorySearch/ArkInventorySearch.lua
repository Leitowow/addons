--[[

License: All Rights Reserved, (c) 2006-2018

$Revision: 2107 $
$Date: 2018-07-15 23:13:01 +1000 (Sun, 15 Jul 2018) $

]]--

local _G = _G
local select = _G.select
local pairs = _G.pairs
local ipairs = _G.ipairs
local string = _G.string
local type = _G.type
local error = _G.error
local table = _G.table


ArkInventorySearch = LibStub( "AceAddon-3.0" ):NewAddon( "ArkInventorySearch" )

function ArkInventorySearch:OnEnable( )
	
	ArkInventory.Search.frame = ARKINV_Search
	
	ArkInventorySearch.rebuild = true
	ArkInventorySearch.SourceTable = { }
	ArkInventorySearch.cache = { }
	
end

function ArkInventorySearch:OnDisable( )
	
	ArkInventory.Search.Frame_Hide( )
	
	ArkInventory.Search.frame = nil
	
	table.wipe( ArkInventorySearch.SourceTable )
	table.wipe( ArkInventorySearch.cache )
	
end


function ArkInventorySearch.Frame_Paint( )
	
	local frame = ArkInventory.Search.frame
	
	-- frameStrata
	if frame:GetFrameStrata( ) ~= ArkInventory.db.option.ui.search.strata then
		frame:SetFrameStrata( ArkInventory.db.option.ui.search.strata )
	end
	
	-- title
	local obj = _G[string.format( "%s%s", frame:GetName( ), "TitleWho" )]
	if obj then
		local t = string.format( "%s: %s %s", ArkInventory.Localise["SEARCH"], ArkInventory.Const.Program.Name, ArkInventory.Global.Version )
		obj:SetText( t )
	end
	
	-- font
	ArkInventory.MediaFrameDefaultFontSet( frame )
	
	-- scale
	frame:SetScale( ArkInventory.db.option.ui.search.scale or 1 )
	
	local style, file, size, offset, scale, colour
	
	for _, z in pairs( { frame:GetChildren( ) } ) do
		
		-- background
		local obj = _G[string.format( "%s%s", z:GetName( ), "Background" )]
		if obj then
			style = ArkInventory.db.option.ui.search.background.style or ArkInventory.Const.Texture.BackgroundDefault
			if style == ArkInventory.Const.Texture.BackgroundDefault then
				colour = ArkInventory.db.option.ui.search.background.colour
				ArkInventory.SetTexture( obj, true, colour.r, colour.g, colour.b, colour.a )
			else
				file = ArkInventory.Lib.SharedMedia:Fetch( ArkInventory.Lib.SharedMedia.MediaType.BACKGROUND, style )
				ArkInventory.SetTexture( obj, file )
			end
		end
		
		-- border
		style = ArkInventory.db.option.ui.search.border.style or ArkInventory.Const.Texture.BorderDefault
		file = ArkInventory.Lib.SharedMedia:Fetch( ArkInventory.Lib.SharedMedia.MediaType.BORDER, style )
		size = ArkInventory.db.option.ui.search.border.size or ArkInventory.Const.Texture.Border[ArkInventory.Const.Texture.BorderDefault].size
		offset = ArkInventory.db.option.ui.search.border.offset or ArkInventory.Const.Texture.Border[ArkInventory.Const.Texture.BorderDefault].offsetdefault.window
		scale = ArkInventory.db.option.ui.search.border.scale or 1
		colour = ArkInventory.db.option.ui.search.border.colour or { }
	
		local obj = _G[string.format( "%s%s", z:GetName( ), "ArkBorder" )]
		if obj then
			if ArkInventory.db.option.ui.search.border.style ~= ArkInventory.Const.Texture.BorderNone then
				ArkInventory.Frame_Border_Paint( obj, file, size, offset, scale, colour.r, colour.g, colour.b, 1 )
				obj:Show( )
			else
				obj:Hide( )
			end
		end
		
		for _, c1 in pairs( { z:GetChildren( ) } ) do
			if c1:GetName( ) then
				for _, c2 in pairs( { c1:GetChildren( ) } ) do
					if c2:GetName( ) then
						local obj = _G[string.format( "%s%s", c2:GetName( ), "ArkBorder" )]
						if obj then
							if ArkInventory.db.option.ui.search.border.style ~= ArkInventory.Const.Texture.BorderNone then
								ArkInventory.Frame_Border_Paint( obj, file, size, offset, scale, colour.r, colour.g, colour.b, 1 )
								obj:Show( )
							else
								obj:Hide( )
							end
						end
					end
				end
			end
		end
		
	end
	
end

function ArkInventorySearch.Frame_Table_Row_Build( frame )
	
	local f = frame:GetName( )
	
	local x
	local sz = 18
	
	-- item icon
	x = _G[string.format( "%s%s", f, "T1" )]
	x:ClearAllPoints( )
	x:SetWidth( sz )
	x:SetHeight( sz )
	x:SetPoint( "LEFT", 17, 0 )
	x:Show( )
	
	-- item name
	x = _G[string.format( "%s%s", f, "C1" )]
	x:ClearAllPoints( )
	x:SetWidth( 250 )
	x:SetPoint( "LEFT", string.format( "%s%s", f, "T1" ), "RIGHT", 12, 0 )
	x:SetPoint( "TOP", 0, 0 )
	x:SetPoint( "BOTTOM", 0, 0 )
	x:SetPoint( "RIGHT", -5, 0 )
	x:SetTextColor( 1, 1, 1, 1 )
	x:SetJustifyH( "LEFT", 0, 0 )
	x:Show( )
	
	-- Highlight
	x = _G[string.format( "%s%s", f, "Highlight" )]
	x:Hide( )
	
end

function ArkInventorySearch.Frame_Table_Build( frame )
	
	local f = frame:GetName( )
	
	local maxrows = tonumber( _G[string.format( "%s%s", f, "MaxRows" )]:GetText( ) )
	local rows = maxrows
	local height = 24
	
	if rows > maxrows then rows = maxrows end
	_G[string.format( "%s%s", f, "NumRows" )]:SetText( rows )
	
	if height == 0 then
		height = tonumber( _G[string.format( "%s%s", f, "RowHeight" )]:GetText( ) )
	end
	_G[string.format( "%s%s", f, "RowHeight" )]:SetText( height )
	
	-- stretch scrollbar to bottom row
	_G[string.format( "%s%s", f, "Scroll" )]:SetPoint( "BOTTOM", string.format( "%s%s%s", f, "Row", rows ), "BOTTOM", 0, 0 )
	
	-- set frame height to correct size
	_G[f]:SetHeight( height * rows + 20 )
	
end

function ArkInventorySearch.Frame_Table_Row_OnClick( frame )
	
	h = _G[string.format( "%s%s", frame:GetName( ), "Id" )]:GetText( )
	if HandleModifiedItemClick( h ) then return end
	
end

function ArkInventorySearch.Frame_Table_Reset( f )
	
	assert( f and type( f ) == "string" and _G[f], "CODE ERROR: Invalid parameter passed to Search.Frame_Table_Reset( )" )
	
	-- hide and reset all rows
	
	local t = string.format( "%s%s", f, "Table" )
	
	local h = tonumber( _G[string.format( "%s%s", t ,"RowHeight" )]:GetText( ) )
	local r = tonumber( _G[string.format( "%s%s", t, "NumRows" )]:GetText( ) )
	
	_G[string.format( "%s%s", t, "SelectedRow" )]:SetText( "-1" )
	for x = 1, r do
		_G[string.format( "%s%s%s%s", t, "Row", x, "Selected" )]:Hide( )
		_G[string.format( "%s%s%s%s", t, "Row", x, "Id" )]:SetText( "-1" )
		_G[string.format( "%s%s%s", t, "Row", x )]:Hide( )
		_G[string.format( "%s%s%s", t, "Row", x )]:SetHeight( h )
	end
	
end

function ArkInventorySearch.Frame_Table_Refresh( frame )
	
	local f = frame:GetParent( ):GetParent( ):GetParent( ):GetName( )
	
	f = string.format( "%s%s", f, "View" )
	
	ArkInventorySearch.Frame_Table_Reset( f )
	
	local filter = _G[string.format( "%s%s", f, "SearchFilter" )]:GetText( )
	filter = ArkInventory.Search.CleanText( filter )
	--ArkInventory.Output( "filter = [", filter, "]" )
	
	table.wipe( ArkInventorySearch.SourceTable )
	local c = 0
	
	local tt = { }
	local name, txt, texture, info
	
	ArkInventorySearch.rebuild = false
	
	for p, pd in ArkInventory.spairs( ArkInventory.db.player.data ) do
		
		for l, ld in pairs( pd.location ) do
			
			for b, bd in pairs( ld.bag ) do
			
				for s, sd in pairs( bd.slot ) do
					
					if sd.h then
						
						local id = ArkInventory.ObjectIDCount( sd.h )
						
						if not ArkInventorySearch.cache[id] then
							
							info = ArkInventory.ObjectInfoArray( id )
							texture = info.texture
							name = info.name
							
							txt = ArkInventory.Search.GetContent( id )
							
							if name and name ~= "" then
								ArkInventorySearch.cache[id] = { name = name, txt = txt, texture = texture, info = info }
							else
								name = ""
								ArkInventorySearch.rebuild = true
							end
							
						else
							
							name = ArkInventorySearch.cache[id].name
							txt = ArkInventorySearch.cache[id].txt
							texture = ArkInventorySearch.cache[id].texture
							
						end
						
							
						
						local ignore = false
						
						--ArkInventory.Output( "[", filter, "] [", name, "] [", txt, "]" )
						
						if filter ~= "" and txt ~= "" then
							if not string.find( txt, filter, nil, true ) then
								ignore = true
							end
						end
						
						if not ignore then
							
							if not tt[id] then
								
								tt[id] = true
								
								c = c + 1
								ArkInventorySearch.SourceTable[c] = { id = id, sorted = name, name = name, h = id, q = sd.q, t = texture }
								
							end
							
						end
						
					end
					
				end
				
			end
			
		end
		
	end
	
	
	if #ArkInventorySearch.SourceTable > 0 then
		table.sort( ArkInventorySearch.SourceTable, function( a, b ) return a.sorted < b.sorted end )
		ArkInventorySearch.Frame_Table_Scroll( frame )
	end
	
end

function ArkInventorySearch.Frame_Table_Scroll( frame )
	
	local f = frame:GetParent( ):GetParent( ):GetParent( ):GetName( )

	f = string.format( "%s%s", f, "View" )
	
	local ft = string.format( "%s%s", f, "Table" )
	local fs = string.format( "%s%s", f, "Search" )

	local height = tonumber( _G[string.format( "%s%s", ft, "RowHeight" )]:GetText( ) )
	local rows = tonumber( _G[string.format( "%s%s", ft, "NumRows" )]:GetText( ) )

	local line
	local lineplusoffset
	
	ArkInventorySearch.Frame_Table_Reset( f )
	
	local tc = #ArkInventorySearch.SourceTable
	
	FauxScrollFrame_Update( _G[string.format( "%s%s", ft, "Scroll" )], tc, rows, height )
	
	local linename, c, r
	
	for line = 1, rows do

		linename = string.format( "%s%s%s", ft, "Row", line )
		
		lineplusoffset = line + FauxScrollFrame_GetOffset( _G[string.format( "%s%s", ft, "Scroll" )] )

		if lineplusoffset <= tc then

			c = ""
			r = ArkInventorySearch.SourceTable[lineplusoffset]
			
			_G[string.format( "%s%s", linename, "Id" )]:SetText( r.h )

			ArkInventory.SetTexture( _G[string.format( "%s%s", linename, "T1" )], r.t )
			
			local cc = select( 5, ArkInventory.GetItemQualityColor( r.q ) )
			_G[string.format( "%s%s", linename, "C1" )]:SetText( string.format( "%s%s", cc, r.name ) )

			_G[linename]:Show( )
			
		else
		
			_G[string.format( "%s%s", linename, "Id" )]:SetText( "" )
			_G[linename]:Hide( )
			
		end
		
	end

end
