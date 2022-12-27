local RotationHUD, Rotation = ...
local RotationHUD, Buttons = ...
GridFrames = {}

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
			local frame = self:CreateFrame(spellId, btn.point, btn.relativeTo, btn.relativePoint, btn.xOfs, btn.yOfs, btn.frame)
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

function Rotation:CheckAbilities(abilityPool, lastCheckedBtn, frames, glowColor, typeName)
local readyButtons = {}
local readyButton = 0
for _, ability in pairs(abilityPool) do
    if (ability) then
        local btn = GI.AbilityMapping[ability.spellId]
        if (btn) then
            local ready, inRange, notEnoughPower, energyGood, chiGood, onCooldown, healthGood = abilityReady(ability)
            if (ready) then
                setColor(btn, Colors.Clear)
                saturate(btn)
                tinsert(readyButtons, btn)
            else
                if (not inRange) then
                    desaturate(btn)
                    setColor(btn, Colors.Red)
                elseif (notEnoughPower or not energyGood or not chiGood) then
                    desaturate(btn)
                end
            end
        end
    end

end

if (not readyButtons[1]) then
    hideAllGlows(frames)
    return
end

local nextInLineButton = readyButtons[1]
if (nextInLineButton ~= lastCheckedBtn) then
    hideAllGlows(frames)
    showNextSpellGlow(nextInLineButton, glowColor)
    readyButton = nextInLineButton
else
    readyButton = lastCheckedBtn
end

return readyButton
end