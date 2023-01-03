local RotationHUD, Abilities = ...

function Abilities:CreateSpell(spellId)
    local newAbility = {
        showConditions = false,
        checkHealthLevel = false,
        healthLevel = 0,
        healthOp = "=",
        checkChiLevel = false,
        chiOp = "=",
        chiLevel = 0,
        checkEnergyLevel = false,
        energyOp = "=",
        energyLevel = 0,
        checkProcs = false,
        procList = {},
        spellId = spellId
    }

    return newAbility
end



-- Abilities.Monk = {
--     Windwalker = {
--         BlackoutKick = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 100784 },
--         ChiBurst = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 123986, talentID = 101527 },
--         ChiTorpedo = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 115008, talentID = 101502 },
--         ChiWave = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 115098, talentID = 101528 },
--         CracklingJadeLightning = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 117952 },
--         DampenHarm = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 122278, talentID = 101522 },
--         DiffuseMagic = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 122783, talentID = 101515 },
--         Detox = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 218164, talentID = 101416 },
--         Disable = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 116095, talentID = 101495 },
--         ExpelHarm = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 322101, checkChi = true, checkEnergy = true, chiMaxOffset = 0, energyMaxOffset = 05,
--             forceMeleeRangeCheck = true },
--         FortifyingBrew = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 115203, talentID = 101496, defense = true },
--         LegSweep = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 119381 },
--         Paralysis = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 115078, talentID = 101506 },
--         Provoke = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 115546 },
--         Resuscitate = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 115178 },
--         RisingSunKick = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 107428, talentID = 101508 },
--         RingofPeace = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 116844, talentID = 101516 },
--         Roll = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 109132 },
--         SpearHandStrike = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 116705, talentID = 101504 },
--         SpinningCraneKick = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, forceMeleeRangeCheck = true, checkProcs = false, procList = {}, spellId = 101546, aoe = true },
--         SoothingMist = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 115175, talentID = 101509, playerHealthCheck = 60 },
--         SummonBlackOxStatue = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 115315, talentID = 101535 },
--         SummonJadeSerpentStatue = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 115313, talentID = 101532 },
--         SummonWhiteTigerStatue = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 388686, talentID = 101519 },
--         TigerPalm = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 100780, checkChi = true, chiMaxOffset = -2, checkMultiples = true,
--             forceMeleeRangeCheck = true },
--         TigersLust = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 116841, talentID = 101507 },
--         TouchofDeath = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 322109, cooldown = true, forceMeleeRangeCheck = true },
--         Transcendence = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 101643, talentID = 101512 },
--         TranscendenceTransfer = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 119996, talentID = 101512 },
--         Vivify = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 116670, playerHealthCheck = 90 },
--         ZenFlight = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 125883 },
--         ZenPilgrimage = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 126892 },
--         --Windwalker
--         BonedustBrew = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 386276, talentID = 101485 },
--         FaelineStomp = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 388193, talentID = 101488 },
--         FistsofFury = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 113656, talentID = 101423 },
--         FlyingSerpentKick = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 101545, talentID = 101432 },
--         FlyingSerpentKickStop = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 115057, talentID = 101432 },
--         InvokeXuentheWhiteTiger = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 123904, talentID = 101473 },
--         RushingJadeWind = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 116847, talentID = 101436 },
--         Serenity = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 152173, talentID = 101428 },
--         StormEarthandFire = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 137639, talentID = 101429, cooldown = true, forceMeleeRangeCheck = true },
--         StrikeoftheWindlord = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 392983, talentID = 101491 },
--         TouchofKarma = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 122470, talentID = 101420, defense = true },
--         WhirlingDragonPunch = { showConditions = false, checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, checkProcs = false, procList = {}, spellId = 152175, talentID = 101474 }
--     }
-- }

-- Abilities.Monk.AbilityNameLookup = {}
-- Abilities.Monk.AbilityLookup = {}
-- for name, ability in pairs(Abilities.Monk.Windwalker) do
--     Abilities.Monk.AbilityNameLookup[ability.spellId] = name
--     Abilities.Monk.AbilityLookup[ability.spellId] = ability
-- end
