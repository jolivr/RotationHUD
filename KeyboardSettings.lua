local RotationHUD, KeyboardSettings = ...
local RotationHUD, Abilities = ...

KeyboardSettings.SpellToButtonMapping = {}
KeyboardSettings.PrimaryOffset = {}
KeyboardSettings.SecondaryOffset = {}

KeyboardSettings.G13 = {
	PrimaryOffset = {xOfs = 0, yOfs = 0},
	PrimaryLayout = {
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
	PrimaryAbilityMappings = {
		Row1Button1 = 0,
		Row1Button2 = 0,
		Row1Button3 = 0,
		Row1Button4 = 0,
		Row1Button5 = 0,
		Row2Button1 = 0,
		Row2Button2 = 0,
		Row2Button3 = 0,
		Row2Button4 = 0,
		Row2Button5 = 0,
		Row3Button1 = 0,
		Row3Button2 = 0,
		Row3Button3 = 0,
		Row3Button4 = 0,
	},
	SecondaryLayout = {
		rowCount = 4,
		TwoRow1 = {
			buttonCount = 3,
			Button1 = {
				point = "TOPLEFT",
				relativePoint = "TOPRIGHT",
				relativeTo = "Row1Button5",
				xOfs = 0,
				yOfs = 0,
				frame = "TwoRow1Button1"
			},
			Button2 = {
				point = "TOPLEFT",
				relativePoint = "TOPRIGHT",
				relativeTo = "TwoRow1Button1",
				xOfs = 1,
				yOfs = 0,
				frame = "TwoRow1Button2"
			},
			Button3 = {
				point = "TOPLEFT",
				relativePoint = "TOPRIGHT",
				relativeTo = "TwoRow1Button2",
				xOfs = 1,
				yOfs = 0,
				frame = "TwoRow1Button3"
			}
		},
		TwoRow2 = {
			buttonCount = 3,
			Button1 = {
				point = "TOPLEFT",
				relativePoint = "BOTTOMLEFT",
				relativeTo = "TwoRow1Button1",
				xOfs = 0,
				yOfs = -1,
				frame = "TwoRow2Button1"
			},
			Button2 = {
				point = "TOPLEFT",
				relativePoint = "TOPRIGHT",
				relativeTo = "TwoRow2Button1",
				xOfs = 1,
				yOfs = 0,
				frame = "TwoRow2Button2"
			},
			Button3 = {
				point = "TOPLEFT",
				relativePoint = "TOPRIGHT",
				relativeTo = "TwoRow2Button2",
				xOfs = 1,
				yOfs = 0,
				frame = "TwoRow2Button3"
			}
		},
		TwoRow3 = {
			buttonCount = 3,
			Button1 = {
				point = "TOPLEFT",
				relativePoint = "BOTTOMLEFT",
				relativeTo = "TwoRow2Button1",
				xOfs = 0,
				yOfs = -1,
				frame = "TwoRow3Button1"
			},
			Button2 = {
				point = "TOPLEFT",
				relativePoint = "TOPRIGHT",
				relativeTo = "TwoRow3Button1",
				xOfs = 1,
				yOfs = 0,
				frame = "TwoRow3Button2"
			},
			Button3 = {
				point = "TOPLEFT",
				relativePoint = "TOPRIGHT",
				relativeTo = "TwoRow3Button2",
				xOfs = 1,
				yOfs = 0,
				frame = "TwoRow3Button3"
			}
		},
		TwoRow4 = {
			buttonCount = 3,
			Button1 = {
				point = "TOPLEFT",
				relativePoint = "BOTTOMLEFT",
				relativeTo = "TwoRow3Button1",
				xOfs = 0,
				yOfs = -1,
				frame = "TwoRow4Button1"
			},
			Button2 = {
				point = "TOPLEFT",
				relativePoint = "TOPRIGHT",
				relativeTo = "TwoRow4Button1",
				xOfs = 1,
				yOfs = 0,
				frame = "TwoRow4Button2"
			},
			Button3 = {
				point = "TOPLEFT",
				relativePoint = "TOPRIGHT",
				relativeTo = "TwoRow4Button2",
				xOfs = 1,
				yOfs = 0,
				frame = "TwoRow4Button3"
			}
		}
	},
	SecondaryAbilityMappings = {
		TwoRow1Button1 = 0,
		TwoRow1Button2 = 0,
		TwoRow1Button3 = 0,
		TwoRow2Button1 = 0,
		TwoRow2Button2 = 0,
		TwoRow2Button3 = 0,
		TwoRow3Button1 = 0,
		TwoRow3Button2 = 0,
		TwoRow3Button3 = 0,
		TwoRow4Button1 = 0,
		TwoRow4Button2 = 0,
		TwoRow4Button3 = 0,
	}
}

function KeyboardSettings:InitializeBtnMapping(abilityList, abilityList2)
	self.SpellToButtonMapping = {}
	for btn, spellId in pairs(abilityList) do
		self.SpellToButtonMapping[spellId] = btn
	end

	for btn, spellId in pairs(abilityList2) do
		self.SpellToButtonMapping[spellId] = btn
	end
end
