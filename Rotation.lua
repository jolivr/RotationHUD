local RotationHUD, Rotation = ...
local RotationHUD, KeyboardSettings = ...
local RotationHUD, KeyboardDisplay = ...
local RotationHUD, Abilities = ...
local GUI = LibStub("AceGUI-3.0")

Rotation.PrevDamageButton = {}
Rotation.PrevDefenseButton = {}
Rotation.PrevCooldownButton = {}
Rotation.PrevHealingButton = {}
Rotation.PrevInterruptButton = {}
Rotation.LastClickedSpellId = 0
Rotation.InterruptAbility = {}
Rotation.DebugText = ""
Rotation.Debug = true
Rotation.DebugWindowCreated = false
Rotation.DebugTextBox = {}
Rotation.EnergyList = {
    [0] = 'Mana',
    [1] = 'Rage',
    [2] = 'Focus',
    [3] = 'Energy',
    [4] = 'Combo',
    [6] = 'RunicPower',
    [7] = 'SoulShards',
    [8] = 'LunarPower',
    [9] = 'HolyPower',
    [11] = 'Maelstrom',
    [12] = 'Chi',
    [13] = 'Insanity',
    [16] = 'ArcaneCharges',
    [17] = 'Fury',
    [19] = 'Essence',
}


function Rotation:PlayerPower(_EnergyType)
    local resource;

    for k, v in pairs(self.EnergyList) do
        if v == _EnergyType then
            resource = k;
            break
        end
    end

    local _Resource = UnitPower('player', resource);
    local _Resource_Max = UnitPowerMax('player', resource);
    local _Resource_Percent = math.max(0, _Resource) / math.max(1, _Resource_Max) * 100;

    return _Resource, _Resource_Max, _Resource_Percent;
end

function Rotation:GetCooldown(spellid, timeShift)
    local start, maxCooldown, enabled = GetSpellCooldown(spellid);
    local baseCooldownMS, gcdMS = GetSpellBaseCooldown(spellid);
    local baseCooldown = 0;

    if (timeShift == nil) then
        local t = GetTime();
        local gcd
        local gstart, gduration = GetSpellCooldown(61304);
        gcd = gduration - (t - gstart);

        if gcd < 0 then
            gcd = 0;
        end
        timeShift = gcd
    end

    if baseCooldownMS ~= nil then
        baseCooldown = (baseCooldownMS / 1000) + (timeShift or 0);
    end

    if enabled and maxCooldown == 0 and start == 0 then
        return 0, maxCooldown, baseCooldown;
    elseif enabled then
        return (maxCooldown - (GetTime() - start) - (timeShift or 0)), maxCooldown, baseCooldown;
    else
        return 100000, maxCooldown, baseCooldown;
    end
end

function Rotation:AbilityReady(ability)
    local ready = false
    local spellId = ability.spellId
    local known = IsPlayerSpell(spellId)
    local usable, notEnoughPower = IsUsableSpell(spellId)
    local chi, chiMax = self:PlayerPower('Chi');
    local energy, energyMax = self:PlayerPower('Energy');
    local cd, MaxCd = self:GetCooldown(spellId)
    local onCooldown = false
    local spell = Spell:CreateFromSpellID(spellId)
    local spellName = spell:GetSpellName()
    local inRange = IsSpellInRange(spellName, "target")
    local rangeCheck = LibStub("LibRangeCheck-2.0")
    local _, _, _, _, minRange, maxRange = GetSpellInfo(spellId)
    local energyGood = true
    local chiGood = true
    local healthGood = true
    -- local justClicked = false
    local procCheckPassed = true

    -- if (self.LastClickedSpellId == spellId) then
    --     justClicked = true
    -- end

    if (cd > 0) then
        onCooldown = true
    end

    if (ability.checkHealthLevel) then
        local health = UnitHealth("player")
        local healthMax = UnitHealthMax("player")
        local healthCheck = self:ConditionalCheck(health, healthMax, ability.healthLevel, ability.healthOp, true)
        if (not healthCheck) then
            healthGood = false
        end
    end

    if (ability.checkEnergyLevel) then
        local energyCheck = self:ConditionalCheck(energy, energyMax, ability.energyLevel, ability.energyOp, true)
        if (not energyCheck) then
            energyGood = false
        end
    end

    if (ability.checkChiLevel) then
        local chiCheck = self:ConditionalCheck(chi, chiMax, ability.chiLevel, ability.chiOp, false)

        if (not chiCheck) then
            chiGood = false
        end
    end

    if (ability.checkProcs) then
        local buffs = {}
        for i = 1, 40 do
            local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal,
            spellId = UnitBuff("player", i);
            if name then
                buffs[name] = { spellId = spellId, stacks = count }
            end
        end

        for i, proc in pairs(ability.procList) do
            if (not buffs[proc.name]) then
                procCheckPassed = false
            else
                if (proc.checkStacks and buffs[proc.name].stacks < proc.procStacks) then
                    procCheckPassed = false
                else
                    --print(proc.name, " triggered!")
                end
            end
        end
    end

    local _, targetMax = rangeCheck:GetRange('target')

    if (inRange == nil) then -- if "not in range" take a closer look
        if (targetMax) then --if target range can be estimated
            if (maxRange > 0 and targetMax <= maxRange) then --range check
                inRange = true
            else -- problem child
                inRange = true
            end
        end
    end

    if (inRange == 0) then
        inRange = false
    end
    if (inRange == 1) then
        inRange = true
    end
    if (inRange == nil) then
        inRange = false
    end

    if (
        known and usable and not notEnoughPower and not onCooldown and energyGood and chiGood and inRange and healthGood
            and procCheckPassed
        --not justClicked
        ) then
        ready = true
    end

    if (self.Debug) then
        if (ability.debug) then
            Rotation.DebugText = ""
            self.DebugText = "Debug for " .. spellName .. "\r\n"
            self.DebugText = self.DebugText .. date('%r') .. "\r\n"
            self:AddDebug("Ready", ready, true)
            self:AddDebug("Useable", usable, true)
            self:AddDebug("Not Enough Power", notEnoughPower, false)
            self:AddDebug("On Cooldown", onCooldown, false)
            self:AddDebug("Energy Good", energyGood, true)
            self:AddDebug("Chi Good", chiGood, true)
            self:AddDebug("In Range", inRange, true)
            self:AddDebug("Health Good", healthGood, true)
            self:AddDebug("Proc Check", procCheckPassed, true)
            self:ShowDebugWindow()
            self.DebugTextBox:SetText(self.DebugText)
        end
    end


    return ready, inRange, usable, notEnoughPower, energyGood, chiGood, onCooldown, healthGood, procCheckPassed
end

function Rotation:ConditionalCheck(playerLevel, playerMaxLevel, targetLevel, targetOp, isPercentage, printDebug)
    local playerPropLevel = playerLevel --math.floor((playerProp / playerPropMax) * 100)
    local targetPropLevel = targetLevel --(targetLevel * 100)

    if (isPercentage) then
        playerPropLevel = math.floor((playerPropLevel / playerMaxLevel) * 100)
        targetPropLevel = targetLevel * 100
    end

    if (printDebug) then
        print("player%: ", playerPropLevel)
        print("target%: ", targetPropLevel)
    end

    local conditionMatched = false
    if (targetOp == "=") then
        if (playerPropLevel == targetPropLevel) then
            conditionMatched = true
        end
    elseif (targetOp == ">") then
        if (playerPropLevel > targetPropLevel) then
            conditionMatched = true
        end
    elseif (targetOp == "<") then
        if (playerPropLevel < targetPropLevel) then
            conditionMatched = true
        end
    elseif (targetOp == ">=") then
        if (playerPropLevel >= targetPropLevel) then
            conditionMatched = true
        end
    elseif (targetOp == "<=") then
        if (playerPropLevel <= targetPropLevel) then
            conditionMatched = true
        end
    end

    return conditionMatched
end

function Rotation:CheckAbilities(priorityList, lastCheckedBtn, frames, glowColor)
    if (not priorityList.check) then
        return
    end

    local readyButtons = {}
    local readyButton = 0
    for _, ability in pairs(priorityList.abilities) do
        if (ability) then
            local btn = KeyboardSettings.SpellToButtonMapping[ability.spellId]
            if (btn) then
                local ready, inRange, usable, notEnoughPower = self:AbilityReady(ability)

                if (ready) then
                    self:SetReadyTexture(btn)
                    tinsert(readyButtons, btn)
                else
                    self:SetNotReadyTexture(btn, inRange, usable, notEnoughPower)
                end
            end
        end

    end

    if (not readyButtons[1]) then
        KeyboardDisplay:HideAllGlows(frames)
        return
    end

    local nextInLineButton = readyButtons[1]
    if (nextInLineButton ~= lastCheckedBtn) then
        KeyboardDisplay:HideAllGlows(frames)
        KeyboardDisplay:ShowNextSpellGlow(nextInLineButton, glowColor)
        readyButton = nextInLineButton
    else
        readyButton = lastCheckedBtn
    end

    return readyButton
end

function Rotation:CheckInterrupt(ability)
    local _, _, _, _, _, _, _, notInterruptible, _ = UnitCastingInfo("target")
    local btn = KeyboardSettings.SpellToButtonMapping[ability.spellId]
    local ready, inRange, usable, notEnoughPower = self:AbilityReady(ability)

    if (ready) then
        self:SetReadyTexture(btn)
        --tinsert(readyButtons, btn)
        if (not notInterruptible) then
            KeyboardDisplay:ShowGlow(btn, KeyboardDisplay.Colors.Pink)
        else
            KeyboardDisplay:HideGlow(btn)
        end
    else
        KeyboardDisplay:HideGlow(btn)
        self:SetNotReadyTexture(btn, inRange, usable, notEnoughPower)
    end
end

function Rotation:SetNotReadyTexture(btn, inRange, usable, notEnoughPower)
    if (not inRange) then
        KeyboardDisplay:SetColor(btn, KeyboardDisplay.Colors.Red)
    elseif (not usable or notEnoughPower) then
        KeyboardDisplay:Desaturate(btn)
    else
        KeyboardDisplay:SetColor(btn, KeyboardDisplay.Colors.Clear)
    end

end

function Rotation:SetReadyTexture(btn)
    KeyboardDisplay:SetColor(btn, KeyboardDisplay.Colors.Clear)
    KeyboardDisplay:Saturate(btn)
end

function Rotation:ClearPreviousButtons()
    Rotation.PrevDamageButton = {}
    Rotation.PrevDefenseButton = {}
    Rotation.PrevCooldownButton = {}
    Rotation.PrevHealingButton = {}
end

function Rotation:ShowDebugWindow()
    self.Debug = true
    if (not self.DebugWindowCreated) then
        print("creating window")
        local mainWindow = GUI:Create("Frame")
        DebugWindow = mainWindow
        mainWindow:SetTitle("Debug Window")
        mainWindow:SetWidth(400)
        mainWindow:SetPoint("LEFT", 600, 100)
        mainWindow:SetCallback("OnClose", function(widget)
            self.DebugWindowCreated = false
            self.Debug = false
            GUI:Release(widget)
        end)

        --Stop Debug Button
        local btnStop = GUI:Create("Button")
        btnStop:SetText("Stop")
        btnStop:SetWidth(100)
        btnStop:SetCallback("OnClick", function() self.Debug = false end)
        mainWindow:AddChild(btnStop)

        --Start Debug Button
        local btnStart = GUI:Create("Button")
        btnStart:SetText("Start")
        btnStart:SetWidth(100)
        btnStart:SetCallback("OnClick", function() self.Debug = true end)
        mainWindow:AddChild(btnStart)

        --Textbox
        local txtBox = GUI:Create("MultiLineEditBox")
        txtBox:SetNumLines(20)
        txtBox:SetFullWidth(true)
        txtBox:DisableButton(true)
        mainWindow:AddChild(txtBox)
        self.DebugTextBox = txtBox
        self.DebugWindowCreated = true

    end

end

function Rotation:AddDebug(name, value, validCondition)
    self.DebugText = self.DebugText .. name .. ": " .. self:SetTextColor(value, validCondition) .. "\r\n"
end

function Rotation:SetTextColor(value, validCondition)
    --\124cFF00FF00See existing conditions\124r
    if (value ~= validCondition) then
        return "  \124cFFFF0000" .. tostring(value) .. "\124r" -- Red
    else
        return "  \124cFF00FF00" .. tostring(value) .. "\124r" -- Green
    end
end
