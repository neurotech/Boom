# boom

Keep everyone informed of your critical hits.

## TODO

```lua
local function OnEvent(self, event)
	print(CombatLogGetCurrentEventInfo())
end

local f = CreateFrame("Frame")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:SetScript("OnEvent", OnEvent)
```