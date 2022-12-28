local RotationHUD, Abilities = ...

Abilities.Monk = {
    Windwalker = {
        BlackoutKick = { spellId = 100784 },
        ChiBurst = { spellId = 123986, talentID = 101527 },
        ChiTorpedo = { spellId = 115008, talentID = 101502 },
        ChiWave = { spellId = 115098, talentID = 101528 },
        CracklingJadeLightning = { spellId = 117952 },
        DampenHarm = { spellId = 122278, talentID = 101522 },
        DiffuseMagic = { spellId = 122783, talentID = 101515 },
        Detox = { spellId = 218164, talentID = 101416 },
        Disable = { spellId = 116095, talentID = 101495 },
        ExpelHarm = { spellId = 322101, checkChi = true, checkEnergy = true, chiMaxOffset = -1, energyMaxOffset = -15,
            forceMeleeRangeCheck = true },
        FortifyingBrew = { spellId = 115203, talentID = 101496, defense = true },
        LegSweep = { spellId = 119381 },
        Paralysis = { spellId = 115078, talentID = 101506 },
        Provoke = { spellId = 115546 },
        Resuscitate = { spellId = 115178 },
        RisingSunKick = { spellId = 107428, talentID = 101508 },
        RingofPeace = { spellId = 116844, talentID = 101516 },
        Roll = { spellId = 109132 },
        SpearHandStrike = { spellId = 116705, talentID = 101504 },
        SpinningCraneKick = { spellId = 101546, aoe = true },
        SoothingMist = { spellId = 115175, talentID = 101509, playerHealthCheck = 60 },
        SummonBlackOxStatue = { spellId = 115315, talentID = 101535 },
        SummonJadeSerpentStatue = { spellId = 115313, talentID = 101532 },
        SummonWhiteTigerStatue = { spellId = 388686, talentID = 101519 },
        TigerPalm = { spellId = 100780, checkChi = true, chiMaxOffset = -2, checkMultiples = true,
            forceMeleeRangeCheck = true },
        TigersLust = { spellId = 116841, talentID = 101507 },
        TouchofDeath = { spellId = 322109, cooldown = true, forceMeleeRangeCheck = true },
        Transcendence = { spellId = 101643, talentID = 101512 },
        TranscendenceTransfer = { spellId = 119996, talentID = 101512 },
        Vivify = { spellId = 116670, playerHealthCheck = 90 },
        ZenFlight = { spellId = 125883 },
        ZenPilgrimage = { spellId = 126892 },
        --Windwalker
        BonedustBrew = { spellId = 386276, talentID = 101485 },
        FaelineStomp = { spellId = 388193, talentID = 101488 },
        FistsofFury = { spellId = 113656, talentID = 101423 },
        FlyingSerpentKick = { spellId = 101545, talentID = 101432 },
        FlyingSerpentKickStop = { spellId = 115057, talentID = 101432 },
        InvokeXuentheWhiteTiger = { spellId = 123904, talentID = 101473 },
        RushingJadeWind = { spellId = 116847, talentID = 101436 },
        Serenity = { spellId = 152173, talentID = 101428 },
        StormEarthandFire = { spellId = 137639, talentID = 101429, cooldown = true, forceMeleeRangeCheck = true },
        StrikeoftheWindlord = { spellId = 392983, talentID = 101491 },
        TouchofKarma = { spellId = 122470, talentID = 101420, defense = true },
        WhirlingDragonPunch = { spellId = 152175, talentID = 101474 }
    }
}

Abilities.Monk.AbilityNameLookup = {}
Abilities.Monk.AbilityLookup = {}
for name, ability in pairs(Abilities.Monk.Windwalker) do
    Abilities.Monk.AbilityNameLookup[ability.spellId] = name
    Abilities.Monk.AbilityLookup[ability.spellId] = ability
end
