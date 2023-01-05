local RotationHUD, Rotation = ...
local RotationHUD, KeyboardDisplay = ...
local RotationHUD, KeyboardSettings = ...
local RotationHUD, ConfigOptions = ...
local RotationHUD, Abilities = ...
local Icon = LibStub("LibDBIcon-1.0")
local ConfigDB = LibStub("AceDB-3.0")
local healthBarFrame = {}
local cdTimers = {}
local rotationTimer = {}

RoHUD = LibStub('AceAddon-3.0'):NewAddon('RoHUD', 'AceConsole-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

RoHUD.defaultOptions = {
    profile = {
        damagePriorities = { check = true, abilities = {} },
        defensePriorities = { check = true, abilities = {} },
        cooldownPriorities = { check = true, abilities = {} },
        healingPriorities = { check = true, abilities = {}},
        interruptAbility = { check = true, spellId = 116705},
        minimap = { hide = false },
        keyboard = KeyboardSettings.G13
    }
}

function RoHUD:OnInitialize()
    self.db = ConfigDB:New("RotationHUD_DB", self.defaultOptions)
    self:InitializePersistentVariables()

    ConfigOptions:InitializeRegistry()
    self:CreateMiniMapButton()

    self:Print("Rotation HUD Initialized")
end

function RoHUD:OpenOptions()
    self:CancelRotationTimer()
    ConfigOptions:Open()
end

function RoHUD:PriorityRotationTimer()
    Rotation.PrevDamageButton = Rotation:CheckAbilities(self.db.profile.damagePriorities, Rotation.PrevDamageButton,
        KeyboardDisplay.DamageFrames, KeyboardDisplay.Colors.Default)

    Rotation.PrevDefenseButton = Rotation:CheckAbilities(self.db.profile.defensePriorities, Rotation.PrevDefenseButton,
        KeyboardDisplay.DefenseFrames, KeyboardDisplay.Colors.Red)

    Rotation.PrevCooldownButton = Rotation:CheckAbilities(self.db.profile.cooldownPriorities, Rotation.PrevCooldownButton
        , KeyboardDisplay.CooldownFrames, KeyboardDisplay.Colors.Blue)

    Rotation.PrevHealingButton = Rotation:CheckAbilities(self.db.profile.healingPriorities, Rotation.PrevHealingButton,
        KeyboardDisplay.HealingFrames, KeyboardDisplay.Colors.Green)

   -- if(self.db.profile.interruptAbility.debug) then
        Rotation:CheckInterrupt(self.db.profile.interruptAbility)
   -- end
end

function RoHUD:StartRotationTimer()
    --print("Starting timers")
    Rotation.Debug = true
    rotationTimer = self:ScheduleRepeatingTimer("PriorityRotationTimer", .25)
end

function RoHUD:CancelRotationTimer()
   -- print("Cancelling timers")
    self:CancelTimer(rotationTimer)
end

function RoHUD:CreateMiniMapButton()
    local RoHUD_LDB = LibStub("LibDataBroker-1.1"):NewDataObject("rohudldb", {
        type = "data source",
        text = "bunnies!",
        icon = "Interface\\Icons\\INV_Chest_Cloth_17",
        OnClick = function()
            self:OpenOptions()
        end,
    })
---@diagnostic disable-next-line: param-type-mismatch
    Icon:Register("MiniMapIcon", RoHUD_LDB, self.db.profile.minimap)
end

function RoHUD:InitializePersistentVariables()
    Rotation.InterruptAbility = self.db.profile.interruptAbility
    KeyboardDisplay.DamagePriorities = self.db.profile.damagePriorities
    KeyboardDisplay.DefensePriorities = self.db.profile.defensePriorities
    KeyboardDisplay.CooldownPriorities = self.db.profile.cooldownPriorities
    KeyboardDisplay.HealingPriorities = self.db.profile.healingPriorities
    --KeyboardDisplay.InterruptPriorities = self.db.profile.interruptPriorities

    ConfigOptions.DamagePriorities = self.db.profile.damagePriorities
    ConfigOptions.DefensePriorities = self.db.profile.defensePriorities
    ConfigOptions.CooldownPriorities = self.db.profile.cooldownPriorities
    ConfigOptions.HealingPriorities = self.db.profile.healingPriorities
    ConfigOptions.InterruptAbility = self.db.profile.interruptAbility

    ConfigOptions.Keyboard = self.db.profile.keyboard
    KeyboardDisplay.Keyboard = self.db.profile.keyboard
    KeyboardSettings:InitializeBtnMapping(self.db.profile.keyboard.PrimaryAbilityMappings,self.db.profile.keyboard.SecondaryAbilityMappings)
end

function RoHUD:PLAYER_ENTERING_WORLD(_, _, _)
    KeyboardDisplay:InitializeIconGrid(self.db.profile.keyboard.PrimaryLayout, self.db.profile.keyboard.PrimaryAbilityMappings, "Row")
    KeyboardDisplay:InitializeIconGrid(self.db.profile.keyboard.SecondaryLayout, self.db.profile.keyboard.SecondaryAbilityMappings, "TwoRow")
    ConfigOptions:InitializeMenu()
end

function RoHUD:PLAYER_TARGET_CHANGED()
    self:CancelRotationTimer()
    KeyboardDisplay:HideGrid(healthBarFrame)
    self:Print("Can attack: ", UnitCanAttack("player", "target"))
    if (UnitCanAttack("player", "target")) then
        C_Timer.After(0.1, function()
           -- print("calling start from TARGET CHANGED")
            self:StartRotationTimer()
            KeyboardDisplay:ShowGrid(healthBarFrame)
        end)
    end
end

function RoHUD:UNIT_SPELLCAST_START(_, unitTarget, _, _)
    if (unitTarget == "target") then
       -- Rotation:CheckInterrupt()
    end
end

function RoHUD:UNIT_SPELLCAST_CHANNEL_START(_, unitId, _, spellId)
    if unitId == 'player' then
       -- print("calling stop from CHANNEL START")
        self:CancelRotationTimer()
        Rotation:ClearPreviousButtons()
        KeyboardDisplay:HandleSpellCastChannelStart(spellId)
    end
end

function RoHUD:UNIT_SPELLCAST_CHANNEL_STOP(_, unitId, _, spellId)
    if unitId == 'player' then
        --print("calling start from CHANNEL STOP")
        self:StartRotationTimer()
        KeyboardDisplay:HandleSpellCastChannelStop(spellId)
    end
end

function RoHUD:CooldownTimer(spellId)
    local cooldownms, gcdms = GetSpellBaseCooldown(spellId)
   -- print("timer for " , spellId, " gcd: ", gcdms)
   -- print("Cooldown: ", cooldownms / 1000, "GCD cooldown: ", gcdms)
    local start, duration, enabled, modRate = GetSpellCooldown(spellId)
    local timeLeft = ceil(start + duration - GetTime())
    if(gcdms > 0) then
        timeLeft = timeLeft - (gcdms / 1000)
    end
    if(timeLeft > 0) then
        KeyboardDisplay:ShowCooldown(spellId, timeLeft)
    else
        KeyboardDisplay:HideCooldown(spellId)
        self:CancelTimer(cdTimers[spellId])
    end
   
end

function RoHUD:UNIT_SPELLCAST_SUCCEEDED(_, unitId, _, spellId)
    if unitId == 'player' then
        KeyboardDisplay:HandleSpellCastSucceeded(spellId)
        local cooldownms, gcdms = GetSpellBaseCooldown(spellId)

        if(cooldownms > 0) then
            local frameName = KeyboardSettings.SpellToButtonMapping[spellId]
            KeyboardDisplay:Desaturate(frameName)
            cdTimers[spellId] = self:ScheduleRepeatingTimer("CooldownTimer", 1, spellId)
        end
    
        if (spellId == Rotation.InterruptAbility.spellId) then
            local btnFrame = KeyboardSettings.SpellToButtonMapping[Rotation.InterruptAbility.spellId]
            KeyboardDisplay:HideGlow(btnFrame)
        end
    end
end

RoHUD:RegisterEvent("PLAYER_ENTERING_WORLD")
RoHUD:RegisterEvent("PLAYER_TARGET_CHANGED")
RoHUD:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
RoHUD:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
RoHUD:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
RoHUD:RegisterEvent("UNIT_SPELLCAST_START")
