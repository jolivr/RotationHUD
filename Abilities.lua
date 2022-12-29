local RotationHUD, Abilities = ...

Abilities.Monk = {
    Windwalker = {
        BlackoutKick = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 100784 },
        ChiBurst = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 123986, talentID = 101527 },
        ChiTorpedo = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 115008, talentID = 101502 },
        ChiWave = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 115098, talentID = 101528 },
        CracklingJadeLightning = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 117952 },
        DampenHarm = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 122278, talentID = 101522 },
        DiffuseMagic = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 122783, talentID = 101515 },
        Detox = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 218164, talentID = 101416 },
        Disable = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 116095, talentID = 101495 },
        ExpelHarm = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 322101, checkChi = true, checkEnergy = true, chiMaxOffset = 0, energyMaxOffset = 05,
            forceMeleeRangeCheck = true },
        FortifyingBrew = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 115203, talentID = 101496, defense = true },
        LegSweep = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 119381 },
        Paralysis = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 115078, talentID = 101506 },
        Provoke = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 115546 },
        Resuscitate = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 115178 },
        RisingSunKick = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 107428, talentID = 101508 },
        RingofPeace = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 116844, talentID = 101516 },
        Roll = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 109132 },
        SpearHandStrike = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 116705, talentID = 101504 },
        SpinningCraneKick = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 101546, aoe = true },
        SoothingMist = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 115175, talentID = 101509, playerHealthCheck = 60 },
        SummonBlackOxStatue = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 115315, talentID = 101535 },
        SummonJadeSerpentStatue = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 115313, talentID = 101532 },
        SummonWhiteTigerStatue = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 388686, talentID = 101519 },
        TigerPalm = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 100780, checkChi = true, chiMaxOffset = -2, checkMultiples = true,
            forceMeleeRangeCheck = true },
        TigersLust = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 116841, talentID = 101507 },
        TouchofDeath = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 322109, cooldown = true, forceMeleeRangeCheck = true },
        Transcendence = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 101643, talentID = 101512 },
        TranscendenceTransfer = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 119996, talentID = 101512 },
        Vivify = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 116670, playerHealthCheck = 90 },
        ZenFlight = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 125883 },
        ZenPilgrimage = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 126892 },
        --Windwalker
        BonedustBrew = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 386276, talentID = 101485 },
        FaelineStomp = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 388193, talentID = 101488 },
        FistsofFury = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 113656, talentID = 101423 },
        FlyingSerpentKick = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 101545, talentID = 101432 },
        FlyingSerpentKickStop = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 115057, talentID = 101432 },
        InvokeXuentheWhiteTiger = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 123904, talentID = 101473 },
        RushingJadeWind = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 116847, talentID = 101436 },
        Serenity = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 152173, talentID = 101428 },
        StormEarthandFire = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 137639, talentID = 101429, cooldown = true, forceMeleeRangeCheck = true },
        StrikeoftheWindlord = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 392983, talentID = 101491 },
        TouchofKarma = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 122470, talentID = 101420, defense = true },
        WhirlingDragonPunch = {checkHealthLevel = false, healthLevel = 0, healthOp = "=", checkChiLevel = false, chiOp = "=", chiLevel = 0, checkEnergyLevel = false, energyOp = "=", energyLevel = 0, spellId = 152175, talentID = 101474 }
    }
}

Abilities.Monk.AbilityNameLookup = {}
Abilities.Monk.AbilityLookup = {}
for name, ability in pairs(Abilities.Monk.Windwalker) do
    Abilities.Monk.AbilityNameLookup[ability.spellId] = name
    Abilities.Monk.AbilityLookup[ability.spellId] = ability
end
