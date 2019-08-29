if BOOM_ACTIVE == nil then
	BOOM_ACTIVE = true
end

local BOOM_CHANNEL = "YELL"
local playerGUID = UnitGUID("player")
local MSG_CRITICAL_HIT = "#YOLO [ %s - %d ]"

local f = CreateFrame("Frame")

function logStatus()
	if BOOM_ACTIVE then
		print("|cFFFFFF00Boom is |cFF00FF00on|r.");
		print("|cFF4EC6E0Boom!|r.");
	else
		print("|cFFFFFF00Boom is |cFFFF0000off|r.");
	end
end

function toggleBoom(state)
	if state then
		BOOM_ACTIVE = false
		f:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		logStatus()
	else
		BOOM_ACTIVE = true
		logStatus()
		f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		f:SetScript("OnEvent", function(self, event)
			self:OnEvent(event, CombatLogGetCurrentEventInfo())
		end)

		function f:OnEvent(event, ...)
			local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
			local spellId, spellName, spellSchool
			local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand

			if subevent == "SWING_DAMAGE" then
				amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)
			elseif subevent == "SPELL_DAMAGE" then
				spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)
			end
			
			if critical and sourceGUID == playerGUID then
				if spellName then
					-- Chat:
					SendChatMessage(MSG_CRITICAL_HIT:format(spellName, amount), BOOM_CHANNEL)
				end
			end
		end
	end
end

SLASH_BOOMTOGGLE1 = "/boom"
SlashCmdList["BOOMTOGGLE"] = function(msg, editBox)
	toggleBoom(BOOM_ACTIVE)
end

print("|cFFFFFF00Boom loaded!|r")
toggleBoom(BOOM_ACTIVE)