--[[--
	virtual@0
--]]--
----------------------------------------------------------------------------------------------------
local ADDON,NS=...;
local FUNC=NS.FUNC;
if not FUNC then return;end
local L=NS.L;
if not L then return;end
----------------------------------------------------------------------------------------------------
local math,table,string,pairs,type,select,tonumber,unpack=math,table,string,pairs,type,select,tonumber,unpack
----------------------------------------------------------------------------------------------------
local EMOTE_DATA=L.EMOTE;
if not EMOTE_DATA then return;end

local btnSize=24;

local GameTooltip=GameTooltip
local GetCurrentResolution=GetCurrentResolution
local GetScreenResolutions=GetScreenResolutions
local ChatEdit_ChooseBoxForSend=ChatEdit_ChooseBoxForSend

local Emote_IconSize=1
local ICON_PATH="Interface\\AddOns\\alaChat\\icon\\"
local EMOTE_PATH="Interface\\AddOns\\alaChat\\emote\\"
local PANEL_HIDE_PERIOD=1.5
local EMOTE_STRING=L.EMOTE_STRING or {}
local Emote_Panel_STRING_1=EMOTE_STRING.Emote_Panel_STRING_1 or ""
local Emote_Panel_STRING_2=EMOTE_STRING.Emote_Panel_STRING_2 or ""
local Emote_Panel_STRING_3=EMOTE_STRING.Emote_Panel_STRING_3 or ""
------------------------------------------------------------------------------------------------
--------------------------------------------------chat Emote
local control_chatEmote=true;
local Emote_CallButton,Emote_IconPanel
local Emote_Index2Path={}
local Emote_IconTable={
	{"rt1","Interface\\TargetingFrame\\UI-RaidTargetingIcon_1"},
	{"rt2","Interface\\TargetingFrame\\UI-RaidTargetingIcon_2"},
	{"rt3","Interface\\TargetingFrame\\UI-RaidTargetingIcon_3"},
	{"rt4","Interface\\TargetingFrame\\UI-RaidTargetingIcon_4"},
	{"rt5","Interface\\TargetingFrame\\UI-RaidTargetingIcon_5"},
	{"rt6","Interface\\TargetingFrame\\UI-RaidTargetingIcon_6"},
	{"rt7","Interface\\TargetingFrame\\UI-RaidTargetingIcon_7"},
	{"rt8","Interface\\TargetingFrame\\UI-RaidTargetingIcon_8"},
	{EMOTE_DATA["Angel"],EMOTE_PATH.."angel.tga"},
	{EMOTE_DATA["Angry"],EMOTE_PATH.."angry.tga"},
	{EMOTE_DATA["Biglaugh"],EMOTE_PATH.."biglaugh.tga"},
	{EMOTE_DATA["Clap"],EMOTE_PATH.."clap.tga"},
	{EMOTE_DATA["Cool"],EMOTE_PATH.."cool.tga"},
	{EMOTE_DATA["Cry"],EMOTE_PATH.."cry.tga"},
	{EMOTE_DATA["Cute"],EMOTE_PATH.."cutie.tga"},
	{EMOTE_DATA["Despise"],EMOTE_PATH.."despise.tga"},
	{EMOTE_DATA["Dreamsmile"],EMOTE_PATH.."dreamsmile.tga"},
	{EMOTE_DATA["Embarras"],EMOTE_PATH.."embarrass.tga"},
	{EMOTE_DATA["Evil"],EMOTE_PATH.."evil.tga"},
	{EMOTE_DATA["Excited"],EMOTE_PATH.."excited.tga"},
	{EMOTE_DATA["Faint"],EMOTE_PATH.."faint.tga"},
	{EMOTE_DATA["Fight"],EMOTE_PATH.."fight.tga"},
	{EMOTE_DATA["Flu"],EMOTE_PATH.."flu.tga"},
	{EMOTE_DATA["Freeze"],EMOTE_PATH.."freeze.tga"},
	{EMOTE_DATA["Frown"],EMOTE_PATH.."frown.tga"},
	{EMOTE_DATA["Greet"],EMOTE_PATH.."greet.tga"},
	{EMOTE_DATA["Grimace"],EMOTE_PATH.."grimace.tga"},
	{EMOTE_DATA["Growl"],EMOTE_PATH.."growl.tga"},
	{EMOTE_DATA["Happy"],EMOTE_PATH.."happy.tga"},
	{EMOTE_DATA["Heart"],EMOTE_PATH.."heart.tga"},
	{EMOTE_DATA["Horror"],EMOTE_PATH.."horror.tga"},
	{EMOTE_DATA["Ill"],EMOTE_PATH.."ill.tga"},
	{EMOTE_DATA["Innocent"],EMOTE_PATH.."innocent.tga"},
	{EMOTE_DATA["Kongfu"],EMOTE_PATH.."kongfu.tga"},
	{EMOTE_DATA["Love"],EMOTE_PATH.."love.tga"},
	{EMOTE_DATA["Mail"],EMOTE_PATH.."mail.tga"},
	{EMOTE_DATA["Makeup"],EMOTE_PATH.."makeup.tga"},
	{EMOTE_DATA["Mario"],EMOTE_PATH.."mario.tga"},
	{EMOTE_DATA["Meditate"],EMOTE_PATH.."meditate.tga"},
	{EMOTE_DATA["Miserable"],EMOTE_PATH.."miserable.tga"},
	{EMOTE_DATA["Okay"],EMOTE_PATH.."okay.tga"},
	{EMOTE_DATA["Pretty"],EMOTE_PATH.."pretty.tga"},
	{EMOTE_DATA["Puke"],EMOTE_PATH.."puke.tga"},
	{EMOTE_DATA["Shake"],EMOTE_PATH.."shake.tga"},
	{EMOTE_DATA["Shout"],EMOTE_PATH.."shout.tga"},
	{EMOTE_DATA["Silent"],EMOTE_PATH.."shuuuu.tga"},
	{EMOTE_DATA["Shy"],EMOTE_PATH.."shy.tga"},
	{EMOTE_DATA["Sleep"],EMOTE_PATH.."sleep.tga"},
	{EMOTE_DATA["Smile"],EMOTE_PATH.."smile.tga"},
	{EMOTE_DATA["Suprise"],EMOTE_PATH.."suprise.tga"},
	{EMOTE_DATA["Surrender"],EMOTE_PATH.."surrender.tga"},
	{EMOTE_DATA["Sweat"],EMOTE_PATH.."sweat.tga"},
	{EMOTE_DATA["Tear"],EMOTE_PATH.."tear.tga"},
	{EMOTE_DATA["Tears"],EMOTE_PATH.."tears.tga"},
	{EMOTE_DATA["Think"],EMOTE_PATH.."think.tga"},
	{EMOTE_DATA["Titter"],EMOTE_PATH.."titter.tga"},
	{EMOTE_DATA["Ugly"],EMOTE_PATH.."ugly.tga"},
	{EMOTE_DATA["Victory"],EMOTE_PATH.."victory.tga"},
	{EMOTE_DATA["Volunteer"],EMOTE_PATH.."volunteer.tga"},
	{EMOTE_DATA["Wronged"],EMOTE_PATH.."wronged.tga"},
}
local Emote_ICON_TAG_LIST={
	{strlower(ICON_TAG_RAID_TARGET_STAR1),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_1"},
	{strlower(ICON_TAG_RAID_TARGET_STAR2),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_1"},
	{strlower(ICON_TAG_RAID_TARGET_CIRCLE1),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_2"},
	{strlower(ICON_TAG_RAID_TARGET_CIRCLE2),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_2"},
	{strlower(ICON_TAG_RAID_TARGET_DIAMOND1),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_3"},
	{strlower(ICON_TAG_RAID_TARGET_DIAMOND2),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_3"},
	{strlower(ICON_TAG_RAID_TARGET_TRIANGLE1),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_4"},
	{strlower(ICON_TAG_RAID_TARGET_TRIANGLE2),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_4"},
	{strlower(ICON_TAG_RAID_TARGET_MOON1),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_5"},
	{strlower(ICON_TAG_RAID_TARGET_MOON2),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_5"},
	{strlower(ICON_TAG_RAID_TARGET_SQUARE1),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_6"},
	{strlower(ICON_TAG_RAID_TARGET_SQUARE2),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_6"},
	{strlower(ICON_TAG_RAID_TARGET_CROSS1),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_7"},
	{strlower(ICON_TAG_RAID_TARGET_CROSS2),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_7"},
	{strlower(ICON_TAG_RAID_TARGET_SKULL1),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_8"},
	{strlower(ICON_TAG_RAID_TARGET_SKULL2),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_8"},
	{strlower(RAID_TARGET_1),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_1"},
	{strlower(RAID_TARGET_2),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_2"},
	{strlower(RAID_TARGET_3),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_3"},
	{strlower(RAID_TARGET_4),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_4"},
	{strlower(RAID_TARGET_5),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_5"},
	{strlower(RAID_TARGET_6),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_6"},
	{strlower(RAID_TARGET_7),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_7"},
	{strlower(RAID_TARGET_8),"Interface\\TargetingFrame\\UI-RaidTargetingIcon_8"},
}
for k,v in pairs(Emote_IconTable) do
	Emote_Index2Path["{"..v[1].."}"]=v[2]
end
for k,v in pairs(Emote_ICON_TAG_LIST) do
	Emote_Index2Path["{"..v[1].."}"]=v[2]
end
------------------------------------------------------------------------------------------------
local function IconSize(f)
 	local _,font=f:GetFont()
 	--local res=select(GetCurrentResolution(),GetScreenResolutions())
 	--local _,h=string.match(res,"(%d+)x(%d+)")
 	font=Emote_IconSize*font--*h/800
 	font=floor(font)
 	return font
end
------------------------------------------------------------------------------------------------
local function Emote_SendChatMessage_Filter(text)
	for s in string.gmatch(text,"\124T([^:]+):%d+\124t") do
  		local index
		for k,v in pairs(Emote_Index2Path) do
		    if v==s then
			    index=k
			end
		end
		if index then
   			text=string.gsub(text,"(\124T[^:]+:%d+\124t)",index,1)
  		end
 	end
 	return text
end
local function Emote_AddMessage_Filter(self,text)
	for s in string.gmatch(text,"({[^}]+})") do
  		if (Emote_Index2Path[s]) then
   			text=string.gsub(text,s,"\124T"..Emote_Index2Path[s] ..":"..IconSize(self).."\124t",1)
  		end
 	end
 	return text
end
for i=1,NUM_CHAT_WINDOWS do
		if i~=2 then
			local f=getglobal("ChatFrame"..i)
			f._xAddMessage=f.AddMessage
			f.AddMessage=function(self,text,...)
							text=Emote_AddMessage_Filter(self,text) self:_xAddMessage(text,...)
			             end
		end
end
local _xSendChatMessage=SendChatMessage
_G["SendChatMessage"]=function(text,...) text=Emote_SendChatMessage_Filter(text) _xSendChatMessage(text,...) end
local _xBNSendWhisper=BNSendWhisper
_G["BNSendWhisper"]=function(presenceID,text) text=Emote_SendChatMessage_Filter(text) _xBNSendWhisper(presenceID,text) end
local _xBNSendConversationMessage=BNSendConversationMessage
_G["BNSendConversationMessage"]=function(target,text) text=Emote_SendChatMessage_Filter(text) _xBNSendConversationMessage(target,text) end

local Emote_CallButton=CreateFrame("Button","Emote_CallButton",UIParent)
Emote_CallButton:SetWidth(btnSize)
Emote_CallButton:SetHeight(btnSize)
Emote_CallButton:SetNormalTexture(ICON_PATH.."text_nor_icon")
Emote_CallButton:SetPushedTexture(ICON_PATH.."text_push_icon")
Emote_CallButton:SetHighlightTexture("Interface\\Buttons\\CheckButtonHilight")
Emote_CallButton:GetHighlightTexture():SetBlendMode("ADD")
Emote_CallButton:SetAlpha(0.8)
Emote_CallButton:SetFrameLevel(32)
Emote_CallButton:SetMovable(true)
Emote_CallButton:EnableMouse(true)
Emote_CallButton:RegisterForClicks("LeftButtonUp","RightButtonUp")
Emote_CallButton:RegisterForDrag("LeftButton","RightButton")
Emote_CallButton:Show()
function Emote_CallButton:OnClick()
	if Emote_IconPanel:IsShown() then Emote_IconPanel:Hide() else Emote_IconPanel:Show() end
	if GameTooltip:GetOwner()==self then GameTooltip:Hide() end
end
function Emote_CallButton:OnDragStart()
	--if self:IsMovable() and IsControlKeyDown() then self:StartMoving() end
end
function Emote_CallButton:OnDragStop()
	--if self:IsMovable() then self:StopMovingOrSizing()  end
end
function Emote_CallButton:OnEnter()
	GameTooltip:SetOwner(self,"ANCHOR_TOPLEFT")
	GameTooltip:AddLine(Emote_Panel_STRING_1)
	GameTooltip:AddLine(Emote_Panel_STRING_2)
	--GameTooltip:AddLine(Emote_Panel_STRING_3)
	GameTooltip:Show()
	Emote_IconPanel.isCounting=nil
end
function Emote_CallButton:OnLeave()
	if GameTooltip:GetOwner()==self then GameTooltip:Hide() end
	Emote_IconPanel.showTimer=PANEL_HIDE_PERIOD
	Emote_IconPanel.isCounting=1
end
Emote_CallButton:SetScript("OnEnter",Emote_CallButton.OnEnter)
Emote_CallButton:SetScript("OnLeave",Emote_CallButton.OnLeave)
--Emote_CallButton:SetScript("OnDragStart",Btn.OnDragStart)
--Emote_CallButton:SetScript("OnDragStop",Btn.OnDragStop)
Emote_CallButton:SetScript("OnClick",Emote_CallButton.OnClick)
Emote_CallButton:SetPoint("BOTTOMRIGHT",ChatFrame1EditBox,"BOTTOMLEFT",-1,3)
--
Emote_IconPanel=CreateFrame("Frame","Emote_IconPanel",UIParent)
Emote_IconPanel:SetWidth(260)
Emote_IconPanel:SetHeight(160)
Emote_IconPanel:SetFrameLevel(32)
Emote_IconPanel:SetMovable(true)
Emote_IconPanel:EnableMouse(true)
Emote_IconPanel:Hide()
Emote_IconPanel:ClearAllPoints()
Emote_IconPanel:SetPoint("BOTTOMLEFT",Emote_CallButton,"TOPRIGHT",0,0)
Emote_IconPanel:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile=true,tileSize=16,edgeSize=7,insets={left=4,right=4,top=4,bottom=4}})
Emote_IconPanel:SetBackdropColor(0,0,0)
Emote_IconPanel.showTimer=0
function Emote_IconPanel:OnUpdate(elapsed)
	if (not self.isCounting) then
		return
	elseif (self.showTimer<=0) then
		self:Hide()
		self.showTimer=nil
		self.isCounting=nil
	else
		self.showTimer=self.showTimer-elapsed
	end
end
function Emote_IconPanel:OnEnter()
	self.isCounting=nil
end
function Emote_IconPanel:OnLeave()
	self.showTimer=PANEL_HIDE_PERIOD
	self.isCounting=1.5
end
function Emote_IconPanel:OnShow()
	for k,v in pairs(self.IconList) do v:Show() end
end
function Emote_IconPanel:OnHide()
	for k,v in pairs(self.IconList) do v:Hide() end
end
Emote_IconPanel:SetScript("OnUpdate",Emote_IconPanel.OnUpdate)
Emote_IconPanel:SetScript("OnEnter",Emote_IconPanel.OnEnter)
Emote_IconPanel:SetScript("OnLeave",Emote_IconPanel.OnLeave)
Emote_IconPanel:SetScript("OnShow",Emote_IconPanel.OnShow)
Emote_IconPanel:SetScript("OnHide",Emote_IconPanel.OnHide)

Emote_IconPanel.IconList={}

local function btnOnClick(self)
	local editBox=ChatEdit_ChooseBoxForSend()
	editBox:Show()
	editBox:SetFocus()
	editBox:Insert("\124T"..self.texture..":"..IconSize(SELECTED_CHAT_FRAME).."\124t")
	self.parent:Hide()
end
local function btnOnEnter(self)
	GameTooltip:SetOwner(self.parent,"ANCHOR_TOPLEFT")
	GameTooltip:SetText(self.text)
	GameTooltip:Show()
	self.parent.isCounting=nil
end
local function btnOnLeave(self)
	if GameTooltip:GetOwner()==self.parent then
		GameTooltip:Hide()
	end
	self.parent.showTimer=PANEL_HIDE_PERIOD
	self.parent.isCounting=1
end
	local px=1
 	local py=1
 	for k,v in pairs(Emote_IconTable) do
		local b=CreateFrame("Button","Emote_Icon"..k,Emote_IconPanel)
     	b:Show()
 	    b:EnableMouse(true)
 	    b:SetWidth(23)
 	    b:SetHeight(23)
 	    b.text=v[1]
 	    b.texture=v[2]
 	    b:SetNormalTexture(v[2])
 	    b:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
 	    b:GetHighlightTexture():SetBlendMode("ADD")
 	    b:SetFrameLevel(35)
 	    b:ClearAllPoints()
		b.parent=Emote_IconPanel
 	    b:SetPoint("TOPLEFT",Emote_IconPanel,"TOPLEFT",(px-1)*25+5,(1-py)*25-5)
 	    b:SetScript("OnClick",btnOnClick)
 	    b:SetScript("OnEnter",btnOnEnter)
 	    b:SetScript("OnLeave",btnOnLeave)
  	    Emote_IconPanel.IconList[k]=b
  	    px=px+1
  	    if px>=11 then
   	    	px=1
   		    py=py+1
  	    end
 	end

_G["Emote_CallButton"]=Emote_CallButton

Emote_IconTable=nil

local function chatEmote_ToggleOn(initing)
	if not initing and control_chatEmote then
		return;
	end
	control_chatEmote=true;
	Emote_CallButton:Show();
	if __alaBaseBtn then
		__alaBaseBtn:AddBtn(1,1,Emote_CallButton,true)
	end
	return control_chatEmote;
end
local function chatEmote_ToggleOff()
	if not control_chatEmote then
		return;
	end
	control_chatEmote=false;
	Emote_CallButton:Hide();
	if __alaBaseBtn then
		__alaBaseBtn:RemoveBtn(Emote_CallButton)
	end
	return control_chatEmote;
end

FUNC.ON.chatEmote=chatEmote_ToggleOn;
FUNC.OFF.chatEmote=chatEmote_ToggleOff;
------------------------------------------------------------------------------------------------
