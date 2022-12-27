local RotationHUD, Buttons = ...
local RotationHUD, Abilities = ...

Buttons.Mapping = {}
Buttons.Mapping["Row1Button1"] = Abilities.Monk.Windwalker.TouchofKarma
Buttons.Mapping["Row1Button2"] = Abilities.Monk.Windwalker.FortifyingBrew
Buttons.Mapping["Row1Button3"] = Abilities.Monk.Windwalker.SpearHandStrike
Buttons.Mapping["Row1Button4"] = Abilities.Monk.Windwalker.StormEarthandFire
Buttons.Mapping["Row1Button5"] = Abilities.Monk.Windwalker.TouchofDeath
Buttons.Mapping["Row2Button1"] = Abilities.Monk.Windwalker.RisingSunKick
Buttons.Mapping["Row2Button2"] = Abilities.Monk.Windwalker.BlackoutKick
Buttons.Mapping["Row2Button3"] = Abilities.Monk.Windwalker.FistsofFury
Buttons.Mapping["Row2Button4"] = Abilities.Monk.Windwalker.TigerPalm
Buttons.Mapping["Row2Button5"] = Abilities.Monk.Windwalker.ExpelHarm
Buttons.Mapping["Row3Button1"] = Abilities.Monk.Windwalker.SoothingMist
Buttons.Mapping["Row3Button2"] = Abilities.Monk.Windwalker.Vivify
Buttons.Mapping["Row3Button3"] = Abilities.Monk.Windwalker.StrikeoftheWindlord
Buttons.Mapping["Row3Button4"] = Abilities.Monk.Windwalker.SpinningCraneKick

Buttons.AbilityMapping = {}
for btn, ability in pairs(Buttons.Mapping) do
    Buttons.AbilityMapping[ability.spellId] = btn
end