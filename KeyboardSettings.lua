local RotationHUD, KeyboardSettings = ...
local RotationHUD, Abilities = ...

KeyboardSettings.G13 = {
	Layout = {
		rowCount = 3,
		Row1 = {
			buttonCount = 5,
			Button1 = {
				point = "TOPLEFT",
				relativePoint = "TOPLEFT",
				relativeTo = "UIParent",
				xOfs = 0,
				yOfs = 0,
				frame = "Row1Button1"
			},
			Button2 = {
				point = "TOPLEFT",
				relativePoint = "TOPRIGHT",
				relativeTo = "Row1Button1",
				xOfs = 1,
				yOfs = 0,
				frame = "Row1Button2"
			},
			Button3 = {
				point = "TOPLEFT",
				relativePoint = "TOPRIGHT",
				relativeTo = "Row1Button2",
				xOfs = 1,
				yOfs = 0,
				frame = "Row1Button3"
			},
			Button4 = {
				point = "TOPLEFT",
				relativePoint = "TOPRIGHT",
				relativeTo = "Row1Button3",
				xOfs = 1,
				yOfs = 0,
				frame = "Row1Button4"
			},
			Button5 = {
				point = "TOPLEFT",
				relativePoint = "TOPRIGHT",
				relativeTo = "Row1Button4",
				xOfs = 5,
				yOfs = 0,
				frame = "Row1Button5"
			}
		},
		Row2 = {
			buttonCount = 5,
			Button1 = {
				point = "TOPLEFT",
				relativePoint = "BOTTOMLEFT",
				relativeTo = "Row1Button1",
				xOfs = 0,
				yOfs = -1,
				frame = "Row2Button1"
			},
			Button2 = {
				point = "TOPLEFT",
				relativePoint = "TOPRIGHT",
				relativeTo = "Row2Button1",
				xOfs = 1,
				yOfs = 0,
				frame = "Row2Button2"
			},
			Button3 = {
				point = "TOPLEFT",
				relativePoint = "TOPRIGHT",
				relativeTo = "Row2Button2",
				xOfs = 1,
				yOfs = 0,
				frame = "Row2Button3"
			},
			Button4 = {
				point = "TOPLEFT",
				relativePoint = "TOPRIGHT",
				relativeTo = "Row2Button3",
				xOfs = 1,
				yOfs = 0,
				frame = "Row2Button4"
			},
			Button5 = {
				point = "TOPLEFT",
				relativePoint = "TOPRIGHT",
				relativeTo = "Row2Button4",
				xOfs = 5,
				yOfs = 0,
				frame = "Row2Button5"
			}
		},
		Row3 = {
			buttonCount = 4,
			Button1 = {
				point = "TOPLEFT",
				relativePoint = "BOTTOMLEFT",
				relativeTo = "Row2Button1",
				xOfs = 0,
				yOfs = -1,
				frame = "Row3Button1"
			},
			Button2 = {
				point = "TOPLEFT",
				relativePoint = "TOPRIGHT",
				relativeTo = "Row3Button1",
				xOfs = 1,
				yOfs = 0,
				frame = "Row3Button2"
			},
			Button3 = {
				point = "TOPLEFT",
				relativePoint = "TOPRIGHT",
				relativeTo = "Row3Button2",
				xOfs = 1,
				yOfs = 0,
				frame = "Row3Button3"
			},
			Button4 = {
				point = "TOPLEFT",
				relativePoint = "TOPRIGHT",
				relativeTo = "Row3Button3",
				xOfs = 1,
				yOfs = 0,
				frame = "Row3Button4"
			}
		}
	},
	AbilityMappings = {
		Row1Button1 = Abilities.Monk.Windwalker.TouchofKarma,
		Row1Button2 = Abilities.Monk.Windwalker.FortifyingBrew,
		Row1Button3 = Abilities.Monk.Windwalker.SpearHandStrike,
		Row1Button4 = Abilities.Monk.Windwalker.StormEarthandFire,
		Row1Button5 = Abilities.Monk.Windwalker.TouchofDeath,
		Row2Button1 = Abilities.Monk.Windwalker.RisingSunKick,
		Row2Button2 = Abilities.Monk.Windwalker.BlackoutKick,
		Row2Button3 = Abilities.Monk.Windwalker.FistsofFury,
		Row2Button4 = Abilities.Monk.Windwalker.TigerPalm,
		Row2Button5 = Abilities.Monk.Windwalker.ExpelHarm,
		Row3Button1 = Abilities.Monk.Windwalker.DampenHarm,
		Row3Button2 = Abilities.Monk.Windwalker.Vivify,
		Row3Button3 = Abilities.Monk.Windwalker.StrikeoftheWindlord,
		Row3Button4 = Abilities.Monk.Windwalker.SpinningCraneKick,
	}
}

KeyboardSettings.AbilityMapping = {}
for btn, ability in pairs(KeyboardSettings.G13.AbilityMappings) do
    KeyboardSettings.AbilityMapping[ability.spellId] = btn
end