local RotationHUD, Rotation = ...
local RotationHUD, KeyboardDisplay = ...
local RotationHUD, KeyboardSettings = ...
local RotationHUD, ConfigOptions = ...

local Icon = LibStub("LibDBIcon-1.0")
local ConfigDB = LibStub("AceDB-3.0")
local healthBarFrame = {}

RoHUD = LibStub('AceAddon-3.0'):NewAddon('RoHUD', 'AceConsole-3.0', 'AceEvent-3.0', 'AceTimer-3.0');
RoHUD.masterPriorityList = {}

RoHUD.defaultOptions = {
    profile = {
        damagePriorities = { { spellId = 100784 } },
        defensePriorities = { { spellId = 100784 } },
        cooldownPriorities = { { spellId = 100784 } },
        healingPriorities = { { spellId = 100784 } },
        minimap = { hide = false }
    }
}

function RoHUD:OnInitialize()
    self.db = ConfigDB:New("RotationHUD_DB", self.defaultOptions)
    ConfigOptions:InitializeRegistry()
    self:Print("Rotation HUD Initialized")
end

function RoHUD:CompileMasterListOfPriorities()
    for _, ability in pairs(self.db.profile.damagePriorities) do
        self.masterPriorityList[ability.spellId] = ability
    end
    for _, ability in pairs(self.db.profile.defensePriorities) do
        self.masterPriorityList[ability.spellId] = ability
    end
    for _, ability in pairs(self.db.profile.cooldownPriorities) do
        self.masterPriorityList[ability.spellId] = ability
    end
    for _, ability in pairs(self.db.profile.healingPriorities) do
        self.masterPriorityList[ability.spellId] = ability
    end
end

function RoHUD:PriorityRotationTimer()
    -- for type, pack in pairs(abilityPacks) do
    Rotation.PrevDamageButton = Rotation:CheckAbilities(self.db.profile.damagePriorities, Rotation.PrevDamageButton,
        Rotation.DamageFrames, Rotation.Colors.Default, type)
    Rotation.PrevDefenseButton = Rotation:CheckAbilities(self.db.profile.defensePriorities, Rotation.PrevDefenseButton,
        Rotation.DefenseFrames, Rotation.Colors.Red, type)
    Rotation.PrevCooldownButton = Rotation:CheckAbilities(self.db.profile.cooldownPriorities, Rotation.PrevCooldownButton
        , Rotation.CooldownFrames, Rotation.Colors.Blue, type)
    Rotation.PrevHealingButton = Rotation:CheckAbilities(self.db.profile.healingPriorities, Rotation.PrevHealingButton,
        Rotation.HealingFrames, Rotation.Colors.Green, type)
    -- end
end

function RoHUD:StartTimers()
    self:Print("Starting timers")
    self:ScheduleRepeatingTimer("PriorityRotationTimer", .25)
end

function RoHUD:CancelTimers()
    self:Print("Stopping timers")
    self:CancelAllTimers()
end

function RoHUD:CreateMiniMapButton()
    local RoHUD_LDB = LibStub("LibDataBroker-1.1"):NewDataObject("rohudldb", {
        type = "data source",
        text = "bunnies!",
        icon = "Interface\\Icons\\INV_Chest_Cloth_17",
        OnClick = function()
            ConfigOptions:Open()
        end,
    })
    Icon:Register("MiniMapIcon", RoHUD_LDB, self.db.profile.minimap)
end

function RoHUD:PLAYER_ENTERING_WORLD(_, _, _)
    healthBarFrame = _G["ElvNP_Player"] --temporary variable
    KeyboardDisplay.DamagePriorities = self.db.profile.damagePriorities
    KeyboardDisplay.DefensePriorities = self.db.profile.defensePriorities
    KeyboardDisplay.CooldownPriorities = self.db.profile.cooldownPriorities
    KeyboardDisplay.HealingPriorities = self.db.profile.healingPriorities

    KeyboardDisplay:InitializeIconGrid(KeyboardSettings.G13, healthBarFrame)

    ConfigOptions.DamagePriorities = self.db.profile.damagePriorities
    ConfigOptions.DefensePriorities = self.db.profile.defensePriorities
    ConfigOptions.CooldownPriorities = self.db.profile.cooldownPriorities
    ConfigOptions.HealingPriorities = self.db.profile.healingPriorities

    ConfigOptions:InitializeMenu()

    self:CreateMiniMapButton()
end

function RoHUD:PLAYER_TARGET_CHANGED()
    if (UnitCanAttack("player", "target")) then
        self:StartTimers()
        KeyboardDisplay:ShowGrid(healthBarFrame)
    else
        self:CancelTimers()
        KeyboardDisplay:HideGrid(healthBarFrame)
    end
end

function RoHUD:UNIT_SPELLCAST_START(_, unitTarget, _, _)
    if (unitTarget == "target") then
        KeyboardDisplay:CheckInterrupt()
    end
end

function RoHUD:UNIT_SPELLCAST_CHANNEL_START(_, unitId, _, spellId)
    if unitId == 'player' then
        self:CancelTimers()
        KeyboardDisplay:HandleSpellCastChannelStart(spellId)
    end
end

function RoHUD:UNIT_SPELLCAST_CHANNEL_STOP(_, unitId, _, spellId)
    if unitId == 'player' then
        self:StartTimers()
        KeyboardDisplay:HandleSpellCastChannelStop(spellId)
    end
end

function RoHUD:UNIT_SPELLCAST_SUCCEEDED(_, unitId, _, spellId)
    if unitId == 'player' then
        KeyboardDisplay:HandleSpellCastSucceeded(spellId)
    end
end

RoHUD:RegisterEvent("PLAYER_ENTERING_WORLD")
RoHUD:RegisterEvent("PLAYER_TARGET_CHANGED")
RoHUD:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
RoHUD:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
RoHUD:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
RoHUD:RegisterEvent("UNIT_SPELLCAST_START")
