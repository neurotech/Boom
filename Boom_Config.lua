local function UpdateSavedVariables()
  local defaults = {
    active = false,
    localOnly = false,
    cooldown = 5,
    messageTemplate = "#YOLO [ %s - %s ] on %s!",
    playSound = true
  }

  if not BOOM_CONFIG then
    BOOM_CONFIG = defaults
  end

  if BOOM_ACTIVE ~= nil then
    BOOM_CONFIG.active = BOOM_ACTIVE
    BOOM_ACTIVE = nil
  end

  for index, value in pairs(defaults) do
    if BOOM_CONFIG[index] == nil then
      BOOM_CONFIG[index] = value
    end
  end
end

local function OnSettingChanged(setting, value)
  if (setting:GetVariable() == "active") then
    if value then
      Boom.enableBoom()
    else
      Boom.disableBoom()
    end

    Boom.logStatus()
  end
end

local function CreateCheckbox(category, variableKey, checkboxName, tooltipText, defaultValue)
  local setting = Settings.RegisterAddOnSetting(category, variableKey, variableKey, BOOM_CONFIG, type(defaultValue),
    checkboxName, defaultValue)
  setting:SetValueChangedCallback(OnSettingChanged)

  Settings.CreateCheckbox(category, setting, tooltipText)
end

local function CreateSlider(category, variableKey, checkboxName, tooltipText, defaultValue, minValue, maxValue, step)
  local stepValue = step or 1

  local setting = Settings.RegisterAddOnSetting(category, variableKey, variableKey, BOOM_CONFIG, type(defaultValue),
    checkboxName, defaultValue)
  setting:SetValueChangedCallback(OnSettingChanged)

  local options = Settings.CreateSliderOptions(minValue, maxValue, stepValue)
  options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
  Settings.CreateSlider(category, setting, options, tooltipText)
end

local function CreateConfigFrame()
  local category = Settings.RegisterVerticalLayoutCategory("|cffe61f00B|r|cffff3819o|r|cffff4e33o|r|cffff644dm|r")

  CreateCheckbox(category, "active", "Enabled",
    "Check this to enable " .. Boom.BoomTextColour .. ".", BOOM_CONFIG.active)

  CreateCheckbox(category, "playSound", "Play Sound",
    "Check this to make " ..
    Boom.BoomTextColour .. " play the iconic \"BaM!\" sound effect when you perform a critical hit.",
    BOOM_CONFIG.playSound)

  CreateCheckbox(category, "localOnly", "Local Only",
    "Check this to make " ..
    Boom.BoomTextColour ..
    " only show messages to your local chat window. Nobody else will be informed of your critical hits.",
    BOOM_CONFIG.localOnly)

  CreateSlider(category, "cooldown", "Cooldown (seconds)",
    "Adjust the cooldown for " .. Boom.BoomTextColour .. " messages here.",
    BOOM_CONFIG.cooldown, 0, 60)

  Settings.RegisterAddOnCategory(category)
end

function Boom.InitialiseConfig()
  UpdateSavedVariables()
  CreateConfigFrame()
end
