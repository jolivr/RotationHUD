local RotationHUD, KeyboardDisplay = ...
local RotationHUD, KeyboardSettings = ...
local RotationHUD, Abilities = ...

KeyboardDisplay.Frames = {}
KeyboardDisplay.DamageFrames = {}
KeyboardDisplay.DefenseFrames = {}
KeyboardDisplay.CooldownFrames = {}
KeyboardDisplay.HealingFrames = {}
KeyboardDisplay.DamagePriorities = {}
KeyboardDisplay.DefensePriorities = {}
KeyboardDisplay.CooldownPriorities = {}
KeyboardDisplay.HealingPriorities = {}
KeyboardDisplay.Channeling = false

KeyboardDisplay.Colors = {
    Default = { 0.95, 0.95, 0.32, 1 },
    Red = { 1, 0, 0, 1 },
    TransRed = { 1, 0, 0, .3 },
    Blue = { 0, 0, 1, 1 },
    Clear = { 1, 1, 1, 1 },
    Yellow = { 0, .7, .3, 1 },
    Green = { .3, 1, .3, 1 },
    Pink = { .3, .7, 1, 1 }
}

function KeyboardDisplay:InitializeIconGrid(keyboard, healthBarFrame)
    for rowIndex = 1, keyboard.Layout.rowCount do
        local rowName = "Row" .. rowIndex
        local row = keyboard.Layout[rowName]

        for btnIndex = 1, row.buttonCount do
            local btnName = "Button" .. btnIndex
            local btn = row[btnName]
            local ability = keyboard.AbilityMappings[rowName .. btnName]
            local spellId = nil
            if (ability) then
                spellId = ability.spellId
            end
            local frame = self:CreateFrame(spellId, btn.point, btn.relativeTo, btn.relativePoint, btn.xOfs, btn.yOfs,
                btn.frame)
            tinsert(self.Frames, frame)
        end
    end

    if (healthBarFrame) then
        healthBarFrame:SetAlpha(0)
    end

    self:InitializeFrames()
end

function KeyboardDisplay:CreateFrame(spellId, point, relativeTo, relativePoint, offsetX, offsetY, pframe)
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

function KeyboardDisplay:InitializeFrames()
    KeyboardDisplay.DamageFrames = KeyboardDisplay:LoadFrameList(self.DamagePriorities)
    KeyboardDisplay.DefenseFrames = KeyboardDisplay:LoadFrameList(self.DefensePriorities)
    KeyboardDisplay.CooldownFrames = KeyboardDisplay:LoadFrameList(self.CooldownPriorities)
    KeyboardDisplay.HealingFrames = KeyboardDisplay:LoadFrameList(self.HealingPriorities)
    KeyboardDisplay.InterruptAbility = Abilities.Monk.Windwalker.SpearHandStrike
end

function KeyboardDisplay:LoadFrameList(priorityList)
    local frames = {}
    for _, ability in pairs(priorityList) do
        if (ability) then
            tinsert(frames, KeyboardSettings.AbilityMapping[ability.spellId])
        end
    end

    return frames
end

function KeyboardDisplay:AttachToNamePlate(healthBarFrame)
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

function KeyboardDisplay:ShowGrid(healthBarFrame)
    if (self:AttachToNamePlate(healthBarFrame)) then
        for i, btnFrame in pairs(self.Frames) do
            btnFrame:SetAlpha(1)
        end
    end
end

function KeyboardDisplay:HideGrid(healthBarFrame)
    for i, btnFrame in pairs(self.Frames) do
        btnFrame:SetAlpha(0)
    end

    if (healthBarFrame) then
        healthBarFrame:SetAlpha(0)
    end

end

function KeyboardDisplay:Saturate(btnFrame)
    local frame = _G[btnFrame]
    if not frame then
        frame = btnFrame
    end
    local t = frame.iconart;
    --print("saturate ", t:GetTexture())
    t:SetDesaturated(false)
end

function KeyboardDisplay:Desaturate(btnFrame)
    local frame = _G[btnFrame]
    -- if not frame then
    -- 	frame =btnFrame
    -- end

    local t = frame.iconart;
    --print("desaturate ", t:GetTexture())
    t:SetDesaturated(true)
end

function KeyboardDisplay:SetColor(btnFrame, color)
    local r, g, b, a = color[1], color[2], color[3], color[4]
    local frame = _G[btnFrame]
    if (frame) then
        local t = frame.iconart
        t:SetVertexColor(r, g, b, a)
    end
end

function KeyboardDisplay:ShowGlow(btnFrame, color)
    local frame = _G[btnFrame]
    if (frame) then
        LibStub("LibCustomGlow-1.0").ButtonGlow_Start(frame, color)
    end
end

function KeyboardDisplay:ShowNextSpellGlow(nextFrame, color)
    self:ShowGlow(nextFrame, color)
end

function KeyboardDisplay:HideGlow(btnFrame)
    local frame = _G[btnFrame]
    if (frame) then
        LibStub("LibCustomGlow-1.0").ButtonGlow_Stop(frame)
    end
end

function KeyboardDisplay:HideAllGlows(frameTable)
    for index, frame in pairs(frameTable) do
        self:HideGlow(frame)
    end
end

function KeyboardDisplay:ShowButtonClick(btnFrame)
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

function KeyboardDisplay:HideButtonClick(btnFrame)
    local frame = _G[btnFrame]
    if (frame) then
        if (frame.overlay) then
            frame.overlay:SetAlpha(0)
        else
            print("Couldn't find texture ")
        end
    end
end

function KeyboardDisplay:HandleSpellCastChannelStart(spellId)
    self.Channeling = true
    local frame = KeyboardSettings.AbilityMapping[spellId]
    if (frame ~= nil) then
        --cancelTimers()
        self:HideAllGlows(self.DamageFrames)
        self:HideAllGlows(self.DefenseFrames)
        self:HideAllGlows(self.CooldownFrames)
        self:HideAllGlows(self.HealingFrames)
        local btnFrame = KeyboardSettings.AbilityMapping[self.InterruptAbility.spellId]
        self:HideGlow(btnFrame)
        self:ShowButtonClick(frame)
    end
end

function KeyboardDisplay:HandleSpellCastChannelStop(spellId)
    local frame = KeyboardSettings.AbilityMapping[spellId]
    if (frame) then
        --startTimers()
        self:HideButtonClick(frame)
        self.Channeling = false
    end
end

function KeyboardDisplay:HandleSpellCastSucceeded(spellId)
    local clickedBtn = KeyboardSettings.AbilityMapping[spellId]
    self.LastClickedSpellId = spellId
    if (not self.Channeling) then
        self:ShowButtonClick(clickedBtn)
        C_Timer.After(0.1, function()
            self:HideButtonClick(clickedBtn)
        end)

        if (spellId == self.InterruptAbility.spellId) then
            local btnFrame = KeyboardSettings.AbilityMapping[self.InterruptAbility.spellId]
            self:HideGlow(btnFrame)
        end
    end
end
