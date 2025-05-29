local BoomFrame = CreateFrame("Frame")
local playerGUID = UnitGUID("player")
local playerName = UnitName("player")

local BOOM_CHANNEL = "EMOTE"
local MSG_CRITICAL_HIT = "#YOLO [ %s - %s ] on %s!"
local MSG_BOOM_LOG = "|cffffde99[|r|cffe61f00B|r|cffff3819o|r|cffff4e33o|r|cffff644dm|r|cffffde99]|r is %s."
local BoomCooldown = 0

local function logStatus()
	if BOOM_ACTIVE then
		print(MSG_BOOM_LOG:format("|cFF00FF00on|r"))
	else
		print(MSG_BOOM_LOG:format("|cFFFF0000off|r"))
	end
end

local function formatWithCommas(number)
	-- Convert the number to a string
	local str = tostring(number)

	-- Handle the integer and fractional parts separately
	local integerPart, fractionalPart = str:match("([^%.]+)%.?(.*)")

	-- Format the integer part with commas
	local formattedInteger = integerPart:reverse():gsub("(%d%d%d)", "%1,"):reverse()

	-- Remove any leading comma (if the number of digits is a multiple of 3)
	if formattedInteger:sub(1, 1) == "," then
		formattedInteger = formattedInteger:sub(2)
	end

	-- Recombine the formatted integer part with the fractional part
	if fractionalPart and fractionalPart ~= "" then
		return formattedInteger .. "." .. fractionalPart
	else
		return formattedInteger
	end
end

local getTargetName = function(fullName)
	local targetName = fullName

	if fullName then
		targetName = Ambiguate(fullName, "short")
	end

	return targetName
end

local function enableBoom()
	BoomFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

	BoomFrame:SetScript("OnEvent", function(self, event)
		self:OnEvent(event, CombatLogGetCurrentEventInfo())
	end)

	function BoomFrame:OnEvent(_, ...)
		local _, subevent, _, sourceGUID, _, _, _, _, _, _, _ = ...
		local spellName, amount, critical, target

		if subevent == "SPELL_HEAL" or subevent == "SPELL_PERIODIC_HEAL" then
			_, spellName, _, amount, _, _, critical, _ = select(12, ...)
			target = getTargetName(select(9, ...))
		end

		if subevent == "SWING_DAMAGE" then
			amount, _, _, _, _, _, critical, _, _, _ = select(12, ...)
		elseif subevent == "SPELL_DAMAGE" or subevent == "SPELL_PERIODIC_DAMAGE" then
			_, spellName, _, amount, _, _, _, _, _, critical, _, _, _ = select(12, ...)
			target = getTargetName(select(9, ...))
		end

		if critical and sourceGUID == playerGUID and target ~= playerName then
			if spellName then
				if BoomCooldown == 0 then
					local formattedAmount = formatWithCommas(amount)
					BoomCooldown = 5

					PlaySoundFile([[Interface\Addons\Boom\bam.ogg]])
					SendChatMessage(MSG_CRITICAL_HIT:format(spellName, formattedAmount, target), BOOM_CHANNEL)

					C_Timer.After(BoomCooldown, function()
						BoomCooldown = 0
					end)
				end
			end
		end
	end
end

local function disableBoom()
	BoomFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

local function toggleBoom()
	BOOM_ACTIVE = not BOOM_ACTIVE

	if BOOM_ACTIVE then
		enableBoom()
	else
		disableBoom()
	end

	logStatus()
end

SLASH_BOOMTOGGLE1 = "/boom"

SlashCmdList["BOOMTOGGLE"] = function(msg, editBox)
	toggleBoom()
end

local loadingEvents = CreateFrame("Frame")
loadingEvents:RegisterEvent("ADDON_LOADED")
loadingEvents:RegisterEvent("PLAYER_ENTERING_WORLD")

loadingEvents:SetScript(
	"OnEvent",
	function(_, event, arg1)
		if event == "ADDON_LOADED" and arg1 == "Boom" then
			if BOOM_ACTIVE == nil then
				BOOM_ACTIVE = false
			end

			loadingEvents:UnregisterEvent("ADDON_LOADED")
		end

		if event == "PLAYER_ENTERING_WORLD" then
			if BOOM_ACTIVE then
				enableBoom()
			end

			logStatus()
			loadingEvents:UnregisterEvent("PLAYER_ENTERING_WORLD")
		end
	end
)
