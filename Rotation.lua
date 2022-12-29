local RotationHUD, Rotation = ...
local RotationHUD, Buttons = ...
local RotationHUD, Grid = ...

Rotation.PrevDamageButton = {}
Rotation.PrevDefenseButton = {}
Rotation.PrevCooldownButton = {}
Rotation.PrevHealingButton = {}
Rotation.LastClickedSpellId = 0
Rotation.InterruptAbility = 0

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
    local inRange = IsSpellInRange(spellId, "target")
    local energyGood = true
    local chiGood = true
    local healthGood = true
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
    if (ability.forceMeleeRangeCheck) then
        local meleeRange = IsSpellInRange("Tiger Palm", "target")
        if (meleeRange == nil or meleeRange < 1) then
            inRange = false
        end
    end

    if (ability.checkHealthLevel) then
        local health = UnitHealth("player")
        local healthMax = UnitHealthMax("player")
        local healthCheck = self:ConditionalCheck(health, healthMax, ability.healthLevel, ability.healthOp, true)
        if(not healthCheck) then
            healthGood = false
        end
    end

    if (ability.checkEnergyLevel) then
      local energyCheck = self:ConditionalCheck(energy, energyMax, ability.energyLevel, ability.energyOp, true)
        if(not energyCheck) then
            energyGood = false
        end
    end

    if (ability.checkChiLevel) then
        local chiCheck = self:ConditionalCheck(chi, chiMax, ability.chiLevel, ability.chiOp, false)
        
        if(not chiCheck) then
            chiGood = false
        end
    end

    if (
        known and usable and not notEnoughPower and not onCooldown and energyGood and chiGood and inRange and healthGood and
            not justClicked
        ) then
        ready = true
    end

    return ready, inRange, notEnoughPower, energyGood, chiGood, onCooldown
end

function Rotation:ConditionalCheck(playerLevel, playerMaxLevel, targetLevel, targetOp, isPercentage)
    local playerPropLevel = playerLevel --math.floor((playerProp / playerPropMax) * 100)
    local targetPropLevel = targetLevel --(targetLevel * 100)

    if(isPercentage) then
        playerPropLevel = math.floor((playerPropLevel / playerMaxLevel) * 100)
        targetPropLevel = targetLevel * 100
    end

    local conditionMatched = false
    if(targetOp == "=") then
        if(playerPropLevel == targetPropLevel) then
            conditionMatched = true
        end
    elseif(targetOp == ">") then
        if(playerPropLevel > targetPropLevel) then
            conditionMatched = true
        end
    elseif(targetOp == "<") then
        if(playerPropLevel < targetPropLevel) then
            conditionMatched = true
        end
    elseif(targetOp == ">=") then
        if(playerPropLevel >= targetPropLevel) then
            conditionMatched = true
        end
    elseif(targetOp == "<=") then
        if(playerPropLevel <= targetPropLevel) then
            conditionMatched = true
        end
    end

    return conditionMatched
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
                    Grid:SetColor(btn, Grid.Colors.Clear)
                    Grid:Saturate(btn)
                    tinsert(readyButtons, btn)
                else
                    if (not inRange) then
                        Grid:Desaturate(btn)
                        Grid:SetColor(btn, Grid.Colors.Red)
                    elseif (notEnoughPower or not energyGood or not chiGood) then
                        Grid:Desaturate(btn)
                    end
                end
            end
        end

    end

    if (not readyButtons[1]) then
        Grid:HideAllGlows(frames)
        return
    end

    local nextInLineButton = readyButtons[1]
    if (nextInLineButton ~= lastCheckedBtn) then
        Grid:HideAllGlows(frames)
        Grid:ShowNextSpellGlow(nextInLineButton, glowColor)
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
        Grid:ShowGlow(btnFrame, self.Colors.Pink)
    else
        Grid:HideGlow(btnFrame)
    end
end









