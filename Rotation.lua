local RotationHUD, Rotation = ...
local RotationHUD, Buttons = ...
GridFrames = {}
Rotation.DamageFrames = {}
Rotation.DefenseFrames = {}
Rotation.CooldownFrames = {}
Rotation.HealingFrames = {}
Rotation.PrevDamageButton = {}
Rotation.PrevDefenseButton = {}
Rotation.PrevCooldownButton = {}
Rotation.PrevHealingButton = {}
Rotation.LastClickedSpellId = 0
Rotation.InterruptAbility = 0
Rotation.Channeling = false

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

Rotation.Colors = {
    Default = { 0.95, 0.95, 0.32, 1 },
    Red = { 1, 0, 0, 1 },
    TransRed = { 1, 0, 0, .3 },
    Blue = { 0, 0, 1, 1 },
    Clear = { 1, 1, 1, 1 },
    Yellow = { 0, .7, .3, 1 },
    Green = { .3, 1, .3, 1 },
    Pink = { .3, .7, 1, 1 }
}

function Rotation:InitializeIconGrid(selectedLayout, healthBarFrame)
    for rowIndex = 1, selectedLayout.rowCount do
        local rowName = "Row" .. rowIndex
        local row = selectedLayout[rowName]

        for btnIndex = 1, row.buttonCount do
            local btnName = "Button" .. btnIndex
            local btn = row[btnName]
            local ability = Buttons.Mapping[rowName .. btnName]
            local spellId = nil
            if (ability) then
                spellId = ability.spellId
            end
            local frame = self:CreateFrame(spellId, btn.point, btn.relativeTo, btn.relativePoint, btn.xOfs, btn.yOfs,
                btn.frame)
            tinsert(GridFrames, frame)
        end
    end

    if (healthBarFrame) then
        healthBarFrame:SetAlpha(0)
    end
end

function Rotation:CreateFrame(spellId, point, relativeTo, relativePoint, offsetX, offsetY, pframe)
    local spellTexture
    if (spellId) then
        _, _, spellTexture = GetSpellInfo(spellId);
    end

    local btnFrame = _G[pframe]

    if not btnFrame then
        btnFrame = CreateFrame("Frame", pframe, nil, nil, nil)
    end

    btnFrame:SetMovable(true)
    btnFrame:SetClampedToScreen(true)
    btnFrame:EnableMouse(true)
    btnFrame:SetSize(15, 15)
    btnFrame:SetFrameStrata("MEDIUM")
    btnFrame:SetFrameLevel(52)
    btnFrame:SetPoint(point, relativeTo, relativePoint, offsetX, offsetY)
    local icon = btnFrame.iconart
    if not icon then
        icon = btnFrame:CreateTexture("IconArt", "ARTWORK")
        if (spellId == nil) then
            icon:SetColorTexture(0, 0, 0, .3)
        else
            icon:SetTexture(spellTexture)
        end

        icon:SetBlendMode("BLEND")
        btnFrame.iconart = icon
    end
    icon:SetAllPoints(btnFrame)

    local overlay = btnFrame.overlay;
    if not overlay then
        overlay = btnFrame:CreateTexture('Overlay', 'OVERLAY')
        overlay:SetColorTexture(1, 1, 1, 0)
        overlay:SetBlendMode("BLEND")
        btnFrame.overlay = overlay
    end
    overlay:SetAllPoints(btnFrame)

    return btnFrame
end

function Rotation:AttachToNamePlate(healthBarFrame)
    local plate = C_NamePlate.GetNamePlateForUnit("target")
    local keyBtn = _G["Row1Button1"]
    local yOfs = 0

    if (plate) then
        if (not plate:IsVisible()) then
            yOfs = -300
        end

        keyBtn:SetPoint("TOPLEFT", plate, "BOTTOMLEFT", 0, yOfs)
        healthBarFrame:ClearAllPoints()
        healthBarFrame:SetPoint("CENTER", plate, "CENTER", 0, -120)
        healthBarFrame:SetAlpha(1)

        return true
    else
        return false
    end
end

function Rotation:ShowGrid(healthBarFrame)
    if (self:AttachToNamePlate(healthBarFrame)) then
        for i, btnFrame in pairs(GridFrames) do
            btnFrame:SetAlpha(1)
        end
    end
end

function Rotation:HideGrid(healthBarFrame)
    for i, btnFrame in pairs(GridFrames) do
        btnFrame:SetAlpha(0)
    end

    if (healthBarFrame) then
        healthBarFrame:SetAlpha(0)
    end

end

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
    local inRange = IsSpellInRange(spellId, "target")
    local energyGood = true
    local chiGood = true
    local healingSpell = false
    local lowHealth = false
    local justClicked = false

    if (self.LastClickedSpellId == spellId) then
        justClicked = true
    end

    if (cd > 0) then
        onCooldown = true
    end

    if (inRange == nil) then
        inRange = true
    end

    if (ability.playerHealthCheck) then
        healingSpell = true
        local maxPlayerHealth = UnitHealthMax("player");
        local currentPlayerHealth = UnitHealth("player")
        local healthPercentage = (currentPlayerHealth / maxPlayerHealth) * 100
        if (healthPercentage < ability.playerHealthCheck) then
            lowHealth = true
        end
    end

    if (ability.forceMeleeRangeCheck) then
        local meleeRange = IsSpellInRange("Tiger Palm", "target")
        if (meleeRange == nil or meleeRange < 1) then
            inRange = false
        end
    end

    if (ability.checkEnergy) then
        if (energy < (energyMax + ability.energyMaxOffset)) then
            energyGood = false
        end
    end

    if (ability.checkChi) then
        if (chi <= (chiMax + ability.chiMaxOffset)) then
            chiGood = true
        end
    end

    if (
        known and usable and not notEnoughPower and not onCooldown and energyGood and chiGood and inRange and
            not justClicked
        ) then
        ready = true

        if (healingSpell) then
            if (lowHealth) then
                ready = true
            else
                ready = false
            end
        end
    end

    return ready, inRange, notEnoughPower, energyGood, chiGood, onCooldown, healingSpell, lowHealth
end

function Rotation:Saturate(btnFrame)
    local frame = _G[btnFrame]
    if not frame then
        frame = btnFrame
    end
    local t = frame.iconart;
    --print("saturate ", t:GetTexture())
    t:SetDesaturated(false)
end

function Rotation:Desaturate(btnFrame)
    local frame = _G[btnFrame]
    -- if not frame then
    -- 	frame =btnFrame
    -- end

    local t = frame.iconart;
    --print("desaturate ", t:GetTexture())
    t:SetDesaturated(true)
end

function Rotation:SetColor(btnFrame, color)
    local r, g, b, a = color[1], color[2], color[3], color[4]
    local frame = _G[btnFrame]
    if (frame) then
        local t = frame.iconart
        t:SetVertexColor(r, g, b, a)
    end
end

function Rotation:HideGlow(btnFrame)
    local frame = _G[btnFrame]
    if (frame) then
        LibStub("LibCustomGlow-1.0").ButtonGlow_Stop(frame)
    end
end

function Rotation:HideAllGlows(frameTable)
    for index, frame in pairs(frameTable) do
        self:HideGlow(frame)
    end
end

function Rotation:ShowGlow(btnFrame, color)
    local frame = _G[btnFrame]
    if (frame) then
        LibStub("LibCustomGlow-1.0").ButtonGlow_Start(frame, color)
    end
end

function Rotation:ShowNextSpellGlow(nextFrame, color)
    self:ShowGlow(nextFrame, color)
end

function Rotation:CheckAbilities(abilityPool, lastCheckedBtn, frames, glowColor, typeName)
    local readyButtons = {}
    local readyButton = 0
    for _, ability in pairs(abilityPool) do
        if (ability) then
            local btn = Buttons.AbilityMapping[ability.spellId]
            if (btn) then
                local ready, inRange, notEnoughPower, energyGood, chiGood, onCooldown, healthGood = self:AbilityReady(ability)
                if (ready) then
                    self:SetColor(btn, self.Colors.Clear)
                    self:Saturate(btn)
                    tinsert(readyButtons, btn)
                else
                    if (not inRange) then
                        self:Desaturate(btn)
                        self:SetColor(btn, self.Colors.Red)
                    elseif (notEnoughPower or not energyGood or not chiGood) then
                        self:Desaturate(btn)
                    end
                end
            end
        end

    end

    if (not readyButtons[1]) then
        self:HideAllGlows(frames)
        return
    end

    local nextInLineButton = readyButtons[1]
    if (nextInLineButton ~= lastCheckedBtn) then
        self:HideAllGlows(frames)
        self:ShowNextSpellGlow(nextInLineButton, glowColor)
        readyButton = nextInLineButton
    else
        readyButton = lastCheckedBtn
    end

    return readyButton
end

function Rotation:CheckInterrupt()
    local name, _, _, _, _, _, _, notInterruptible, _ = UnitCastingInfo("target")
    local btnFrame = Buttons.AbilityMapping[self.InterruptAbility.spellId]
    if (not notInterruptible and self:AbilityReady(self.InterruptAbility)) then
        print(name, " is interruptible!")
        self:ShowGlow(btnFrame, self.Colors.Pink)
    else
        self:HideGlow(btnFrame)
    end
end

function Rotation:LoadFrameList(priorityList)
    local frames = {}
    for _, ability in pairs(priorityList) do
        if (ability) then
            tinsert(frames, Buttons.AbilityMapping[ability.spellId])
        end
    end

    return frames
end

function Rotation:ShowButtonClick(btnFrame)
    local frame = _G[btnFrame]
    local color = self.Colors.Yellow
    local r, g, b = color[1], color[2], color[3]
    if (frame) then
        if (frame.overlay) then
            frame.overlay:SetAlpha(1)
            frame.overlay:SetColorTexture(r, g, b, .8)
        end
    end
end

function Rotation:HideButtonClick(btnFrame)
    local frame = _G[btnFrame]
    if (frame) then
        if (frame.overlay) then
            frame.overlay:SetAlpha(0)
        else
            print("Couldn't find texture ")
        end
    end
end

function Rotation:HandleSpellCastChannelStart(spellId)
    self.Channeling = true
    local frame = Buttons.AbilityMapping[spellId]
    if (frame ~= nil) then
        --cancelTimers()
        self:HideAllGlows(self.DamageFrames)
        self:HideAllGlows(self.DefenseFrames)
        self:HideAllGlows(self.CooldownFrames)
        self:HideAllGlows(self.HealingFrames)
        local btnFrame = Buttons.AbilityMapping[self.InterruptAbility.spellId]
        self:HideGlow(btnFrame)
        self:ShowButtonClick(frame)
    end
end

function Rotation:HandleSpellCastChannelStop(spellId)
    local frame = Buttons.AbilityMapping[spellId]
    if (frame) then
        --startTimers()
        self:HideButtonClick(frame)
        self.Channeling = false
    end
end

function Rotation:HandleSpellCastSucceeded(spellId)
    local clickedBtn = Buttons.AbilityMapping[spellId]
    self.LastClickedSpellId = spellId
    if (not self.Channeling) then
        self:ShowButtonClick(clickedBtn)
        C_Timer.After(0.1, function()
            self:HideButtonClick(clickedBtn)
        end)

        if (spellId == self.InterruptAbility.spellId) then
            local btnFrame = Buttons.AbilityMapping[self.InterruptAbility.spellId]
            self:HideGlow(btnFrame)
        end
    end
end