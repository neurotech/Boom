local BoomFrame = CreateFrame("Frame")

if BOOM_ACTIVE == nil then
	BOOM_ACTIVE = true
end

local BOOM_CHANNEL = "EMOTE"
local playerGUID = UnitGUID("player")
local MSG_CRITICAL_HIT = "#YOLO [ %s - %d ]"

local function logStatus()
	if BOOM_ACTIVE then
		print("|cFFFFFF00Boom is |cFF00FF00on|r.");
	else
		print("|cFFFFFF00Boom is |cFFFF0000off|r.");
	end
end

local function enableBoom()
	BoomFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

	BoomFrame:SetScript("OnEvent", function(self, event)
		self:OnEvent(event, CombatLogGetCurrentEventInfo())
	end)

	function BoomFrame:OnEvent(event, ...)
		local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
		local spellId, spellName, spellSchool
		local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand

		if subevent == "SWING_DAMAGE" then
			amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)
		elseif subevent == "SPELL_DAMAGE" or subevent == "SPELL_PERIODIC_DAMAGE" then
			spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing,
					isOffHand = select(12, ...)
		end

		if critical and sourceGUID == playerGUID then
			if spellName then
				PlaySoundFile([[Interface\Addons\Boom\bam.ogg]])
				SendChatMessage(MSG_CRITICAL_HIT:format(spellName, amount), BOOM_CHANNEL)
			end
		end
	end
end

local function disableBoom()
	BoomFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

local function toggleBoom(state)
	if state then
		BOOM_ACTIVE = false
		disableBoom()
	else
		BOOM_ACTIVE = true
		enableBoom()
	end

	logStatus()
end

SLASH_BOOMTOGGLE1 = "/boom"

SlashCmdList["BOOMTOGGLE"] = function(msg, editBox)
	toggleBoom(BOOM_ACTIVE)
end

print("|cFFFFFF00Boom loaded!|r")

if BOOM_ACTIVE then
	enableBoom()
end

logStatus()
