local RotationHUD, Rotation = ...
local RotationHUD, KeyboardSettings = ...
local RotationHUD, KeyboardDisplay = ...
local RotationHUD, Abilities = ...

Rotation.PrevDamageButton = {}
Rotation.PrevDefenseButton = {}
Rotation.PrevCooldownButton = {}
Rotation.PrevHealingButton = {}
Rotation.PrevInterruptButton = {}
Rotation.LastClickedSpellId = 0
Rotation.InterruptAbility = {}

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

function Rotation:AbilityReady(ability, printDebug)
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
        if(printDebug) then
            print("")
            print("---")
            print("Debug for ", spellName)
        end
    if (cd > 0) then
        if(printDebug) then
            print("On cooldown")
        end

        onCooldown = true
    end

    
    if (ability.checkHealthLevel) then
        local health = UnitHealth("player")
        local healthMax = UnitHealthMax("player")
        local healthCheck = self:ConditionalCheck(health, healthMax, ability.healthLevel, ability.healthOp, true, printDebug)
        if (not healthCheck) then
            healthGood = false
            if(printDebug) then
                print("Failed health check")
            end
        end
    end

    if (ability.checkEnergyLevel) then
        local energyCheck = self:ConditionalCheck(energy, energyMax, ability.energyLevel, ability.energyOp, true, printDebug)
        if (not energyCheck) then
            energyGood = false
            if(printDebug) then
                print("energy ", energy, ",energyMax ", energyMax,",energyLevel ", ability.energyLevel,",energyOp ", ability.energyOp)
                print("Failed energy check")
            end
        end
    end

    if (ability.checkChiLevel) then
        local chiCheck = self:ConditionalCheck(chi, chiMax, ability.chiLevel, ability.chiOp, false, printDebug)

        if (not chiCheck) then
            chiGood = false
            if(printDebug) then
                print("Failed chi check")
            end
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
            if(not buffs[proc.name] or buffs[proc.name].stacks < proc.procStacks) then
                procCheckPassed = false
                if(printDebug) then
                    print("Failed proc check")
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
    if(inRange == 1) then
        inRange = true
    end

    if(not inRange) then
        if(printDebug) then
            print("Failed range check")
        end
    end

    if (
        known and usable and not notEnoughPower and not onCooldown and energyGood and chiGood and inRange and healthGood
            and procCheckPassed
            --not justClicked
        ) then
        ready = true
    end

    return ready, inRange, notEnoughPower, energyGood, chiGood, onCooldown, healthGood, procCheckPassed
end

function Rotation:ConditionalCheck(playerLevel, playerMaxLevel, targetLevel, targetOp, isPercentage, printDebug)
    local playerPropLevel = playerLevel --math.floor((playerProp / playerPropMax) * 100)
    local targetPropLevel = targetLevel --(targetLevel * 100)

    if (isPercentage) then
        playerPropLevel = math.floor((playerPropLevel / playerMaxLevel) * 100)
        targetPropLevel = targetLevel * 100
    end

    if(printDebug) then
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
            local printDebug = false
            if (btn) then
                -- if(ability.spellId == 322101) then
                --   printDebug = true
                -- end

                local ready, inRange, notEnoughPower, energyGood, chiGood, onCooldown, healthGood, procCheckPassed = self:AbilityReady(ability, printDebug)

                if (ready) then
                    KeyboardDisplay:SetColor(btn, KeyboardDisplay.Colors.Clear)
                    KeyboardDisplay:Saturate(btn)
                    tinsert(readyButtons, btn)
                else
                    KeyboardDisplay:Desaturate(btn)
                    if (not inRange) then
                        KeyboardDisplay:SetColor(btn, KeyboardDisplay.Colors.Red)
                    else
                        KeyboardDisplay:SetColor(btn, KeyboardDisplay.Colors.Clear)
                    end

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

function Rotation:CheckInterrupt()
    local name, _, _, _, _, _, _, notInterruptible, _ = UnitCastingInfo("target")
    local btnFrame = KeyboardSettings.SpellToButtonMapping[self.InterruptAbility.spellId]

    if (not notInterruptible and self:AbilityReady(self.InterruptAbility)) then
        KeyboardDisplay:ShowGlow(btnFrame, KeyboardDisplay.Colors.Pink)
    else
        KeyboardDisplay:HideGlow(btnFrame)
    end
end

function Rotation:ClearPreviousButtons()
    Rotation.PrevDamageButton = {}
    Rotation.PrevDefenseButton = {}
    Rotation.PrevCooldownButton = {}
    Rotation.PrevHealingButton = {}
end
