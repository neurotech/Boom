# Boom

Keep everyone informed of your critical hits.

## Credits

Thanks to https://wow.gamepedia.com/API_CombatLogGetCurrentEventInfo for the original implementation.

---

## TODO

```lua
local function OnEvent(self, event)
	print(CombatLogGetCurrentEventInfo())
end

local f = CreateFrame("Frame")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:SetScript("OnEvent", OnEvent)
```