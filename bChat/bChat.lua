﻿-----------------------------------------------
--Config
-----------------------------------------------
-- Font Shadow
shadowoffset = {x = 1, y = -1}
-----------------------------------------------
--Config End
-----------------------------------------------
CHAT_FONT_HEIGHTS = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}
ChatTypeInfo.WHISPER.sticky = 1
ChatTypeInfo.OFFICER.sticky = 1
ChatTypeInfo.CHANNEL.sticky = 1

ChatFrameMenuButton.Show = ChatFrameMenuButton.Hide 
ChatFrameMenuButton:Hide() 
FriendsMicroButton.Show = FriendsMicroButton.Hide 
FriendsMicroButton:Hide()
BNToastFrame:SetClampedToScreen(true)

CHAT_FRAME_FADE_OUT_TIME = 1
CHAT_TAB_HIDE_DELAY = 1
CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = 0

local EventFrame = CreateFrame("Frame");
EventFrame:RegisterEvent("ADDON_LOADED");
local function EventHandler(self, event, ...)
	if ... == "Blizzard_CombatLog" then
		local topbar = _G["CombatLogQuickButtonFrame_Custom"];
		if not topbar then return end
		topbar:Hide();
		topbar:HookScript("OnShow", function(self) topbar:Hide(); end);
		topbar:SetHeight(0);
	end
end
EventFrame:SetScript("OnEvent", EventHandler);

local gsub = _G.string.gsub
local newAddMsg = {}
CHAT_FLAG_GM = "GM "
CHAT_BN_WHISPER_INFORM_GET = "T %s "
CHAT_BN_WHISPER_GET = "F %s "
CHAT_RAID_WARNING_GET = "%s "

local function AddMessage(frame, text, ...)
    text = gsub(text, "%[(%d0?)%. .-%]", "%1")
    text = gsub(text, "^|Hchannel:[^%|]+|h%[[^%]]+%]|h ", "")
	text = gsub(text, "|Hplayer:([^%|]+)|h%[([^%]]+)%]|h", "|Hplayer:%1|h%2|h")
    text = gsub(text, "<Away>", "")
	text = gsub(text, "<Busy>", "")
    text = gsub(text, "|Hplayer:([^%|]+)|h(.+)|h says:", "|Hplayer:%1|h%2|h:")
	text = gsub(text, "|Hplayer:([^%|]+)|h(.+)|h yells:", "|Hplayer:%1|h%2|h:")
	text = gsub(text, "|Hplayer:([^%|]+)|h(.+)|h whispers:", "F |Hplayer:%1|h%2|h:")
	text = gsub(text, "^To", "T")
    text = gsub(text, "Guild Message of the Day:", "GMotD -")
	return newAddMsg[frame:GetName()](frame, text, ...)
end

function string.color(text, color)
    return "|cff"..color..text.."|r"
end
function string.link(text, type, value, color)
    return "|H"..type..":"..tostring(value).."|h"..tostring(text):color(color or "ffffff").."|h"
end
local function highlighturl(before,url,after)
    foundurl = true
    return " "..string.link(""..url.."", "url", url, "DDDDDD").." "
end
local function searchforurl(frame, text, ...)
    foundurl = false
    if string.find(text, "%pTInterface%p+") then foundurl = true end
    if not foundurl then text = string.gsub(text, "(%s?)(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?:%d%d?%d?%d?%d?)(%s?)", highlighturl) end
    if not foundurl then text = string.gsub(text, "(%s?)(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?)(%s?)", highlighturl) end
    if not foundurl then text = string.gsub(text, "(%s?)([%w_-]+%.?[%w_-]+%.[%w_-]+:%d%d%d?%d?%d?)(%s?)", highlighturl) end
    if not foundurl then text = string.gsub(text, "(%s?)(%a+://[%w_/%.%?%%=~&-'%-]+)(%s?)", highlighturl) end
    if not foundurl then text = string.gsub(text, "(%s?)(www%.[%w_/%.%?%%=~&-'%-]+)(%s?)", highlighturl) end
    if not foundurl then text = string.gsub(text, "(%s?)([_%w-%.~-]+@[_%w-]+%.[_%w-%.]+)(%s?)", highlighturl) end
    frame.am(frame,text,...)
end

local tabs = {"Left", "Middle", "Right", "SelectedLeft", "SelectedMiddle",
    "SelectedRight", "Glow", "HighlightLeft", "HighlightMiddle", 
    "HighlightRight",}

for i = 1, NUM_CHAT_WINDOWS do
    local cf = 'ChatFrame'..i
    local tex = ({_G[cf..'EditBox']:GetRegions()})
    
    _G[cf..'ButtonFrame'].Show = _G[cf..'ButtonFrame'].Hide 
    _G[cf..'ButtonFrame']:Hide()
    
    _G[cf..'EditBox']:SetAltArrowKeyMode(false)
    _G[cf..'EditBox']:ClearAllPoints()
    _G[cf..'EditBox']:SetPoint('BOTTOMLEFT', ChatFrame1, 'TOPLEFT', -4, 6)
    _G[cf..'EditBox']:SetPoint('TOPRIGHT', _G.ChatFrame1, 'TOPRIGHT', 6, 30)
    _G[cf..'EditBox']:SetShadowOffset(0, 0)
    _G[cf..'EditBox']:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8x8', edgeFile = 'Interface\\Buttons\\WHITE8x8', edgeSize = 2})
    _G[cf..'EditBox']:SetBackdropColor(0,0,0,.8)
    _G[cf..'EditBox']:SetBackdropBorderColor(0,0,0,1)
    _G[cf..'EditBox']:HookScript("OnEditFocusGained", function(self) self:Show() end)
	_G[cf..'EditBox']:HookScript("OnEditFocusLost", function(self) self:Hide() end)
    _G[cf..'EditBoxHeader']:SetShadowOffset(0, 0)
    
	_G["ChatFrame"..i.."Tab"]:HookScript("OnClick", function() _G["ChatFrame"..i.."EditBox"]:Hide() end)
    tex[6]:SetAlpha(0) tex[7]:SetAlpha(0) tex[8]:SetAlpha(0) tex[9]:SetAlpha(0) tex[10]:SetAlpha(0) tex[11]:SetAlpha(0)
    _G[cf]:SetMinResize(0,0)
	_G[cf]:SetMaxResize(0,0)
    _G[cf]:SetFading(true)	
	_G[cf]:SetClampRectInsets(0,0,0,0)
    _G[cf]:SetShadowOffset(shadowoffset.x, shadowoffset.y)
    _G[cf..'ResizeButton']:SetPoint("BOTTOMRIGHT", cf, "BOTTOMRIGHT", 9,-5)
    _G[cf..'ResizeButton']:SetScale(.4)
    _G[cf..'ResizeButton']:SetAlpha(0.5)
    
    for g = 1, #CHAT_FRAME_TEXTURES do
        _G["ChatFrame"..i..CHAT_FRAME_TEXTURES[g]]:SetTexture(nil)
    end
    for index, value in pairs(tabs) do
        local texture = _G['ChatFrame'..i..'Tab'..value]
        texture:SetTexture(nil)
    end
    if i ~= 2 then
        _G[cf].am = _G[cf].AddMessage
        _G[cf].AddMessage = searchforurl
		local f = _G[format("%s%d", "ChatFrame", i)]
		newAddMsg[format("%s%d", "ChatFrame", i)] = f.AddMessage
		f.AddMessage = AddMessage
	end
end

local AltInvite = SetItemRef
SetItemRef = function(link, text, button)
    local linkType = string.sub(link, 1, 6)
    if IsAltKeyDown() and linkType == "player" then
        local name = string.match(link, "player:([^:]+)")
        InviteUnit(name)
        return nil
    end
    return AltInvite(link,text,button)
end

FloatingChatFrame_OnMouseScroll = function(self, dir)
    if(dir > 0) then
        if(IsShiftKeyDown()) then
            self:ScrollToTop() else self:ScrollUp() end
    else if(IsShiftKeyDown()) then 
        self:ScrollToBottom() else self:ScrollDown() end
    end
end

local orig = ChatFrame_OnHyperlinkShow
function ChatFrame_OnHyperlinkShow(frame, link, text, button)
    local type, value = link:match("(%a+):(.+)")
    if ( type == "url" ) then
        local eb = _G[frame:GetName()..'EditBox']
        if eb then
            eb:SetText(value)
            eb:SetFocus()
            eb:HighlightText()
        end
    else
        orig(self, link, text, button)
    end
end