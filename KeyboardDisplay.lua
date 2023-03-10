local RotationHUD, KeyboardDisplay = ...
local RotationHUD, KeyboardSettings = ...
local RotationHUD, Abilities = ...

KeyboardDisplay.Frames = {}
KeyboardDisplay.DamageFrames = {}
KeyboardDisplay.DefenseFrames = {}
KeyboardDisplay.CooldownFrames = {}
KeyboardDisplay.HealingFrames = {}
KeyboardDisplay.InterruptFrames = {}
KeyboardDisplay.DamagePriorities = {}
KeyboardDisplay.DefensePriorities = {}
KeyboardDisplay.CooldownPriorities = {}
KeyboardDisplay.HealingPriorities = {}
KeyboardDisplay.InterruptPriorities = {}
KeyboardDisplay.Channeling = false
KeyboardDisplay.HealthbarFrame = {}
KeyboardDisplay.PrimaryXOfs = 0
KeyboardDisplay.PrimaryYOfs = 0
KeyboardDisplay.HealthbarXOfs = 0
KeyboardDisplay.HealthbarYOfs = 0
KeyboardDisplay.Keyboard = {}

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

function KeyboardDisplay:InitializeIconGrid(layout, mappings, rowPrefix)
    for rowIndex = 1, layout.rowCount do
        local rowName = rowPrefix .. rowIndex --"Row" .. rowIndex

        local row = layout[rowName]

        for btnIndex = 1, row.buttonCount do
            local btnName = "Button" .. btnIndex
            local btn = row[btnName]
            if (rowPrefix == "Row" and rowIndex == 1 and btnIndex == 1) then
                self.PrimaryXOfs = btn.xOfs
                self.PrimaryYOfs = btn.yOfs
                self.HealthbarXOfs = self.Keyboard["Healthbar"].xOfs
                self.HealthbarYOfs = self.Keyboard["Healthbar"].yOfs
                self.HealthbarFrame = _G[self.Keyboard["Healthbar"].frame]
            end

            local spellId = mappings[rowName .. btnName]
            local frame = self:CreateFrame(spellId, btn.point, btn.relativeTo, btn.relativePoint, btn.xOfs, btn.yOfs,
                btn.frame)
            tinsert(self.Frames, frame)
        end
    end

    if (self.HealthbarFrame) then
        self.HealthbarFrame:SetAlpha(0)
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
        btnFrame:SetMovable(true)
        btnFrame:SetClampedToScreen(true)
        btnFrame:EnableMouse(true)
        btnFrame:SetSize(15, 15)
        btnFrame:SetFrameStrata("MEDIUM")
        btnFrame:SetFrameLevel(52)
    end

    btnFrame:SetPoint(point, relativeTo, relativePoint, offsetX, offsetY)

    local icon = btnFrame.iconart
    if not icon then
        icon = btnFrame:CreateTexture("IconArt", "ARTWORK")


        icon:SetBlendMode("BLEND")

        icon:SetAllPoints(btnFrame)
    end

    if (spellId == nil or spellId == 0) then
        icon:SetColorTexture(0, 0, 0, .6)
    else
        icon:SetTexture(spellTexture)
    end
    btnFrame.iconart = icon

    local overlay = btnFrame.overlay;
    if not overlay then
        overlay = btnFrame:CreateTexture('Overlay', 'OVERLAY')
        overlay:SetColorTexture(1, 1, 1, 0)
        overlay:SetBlendMode("BLEND")
        btnFrame.overlay = overlay
        overlay:SetAllPoints(btnFrame)
    end

    local textOverlay = btnFrame.textOverlay
    if not textOverlay then
        textOverlay = btnFrame:CreateFontString("TextOverlay", "OVERLAY")
        textOverlay:SetPoint("CENTER", 0, 0)

        btnFrame.textOverlay = textOverlay
    end

    return btnFrame
end

function KeyboardDisplay:InitializeFrames()
    KeyboardDisplay.DamageFrames = KeyboardDisplay:LoadFrameList(self.DamagePriorities)
    KeyboardDisplay.DefenseFrames = KeyboardDisplay:LoadFrameList(self.DefensePriorities)
    KeyboardDisplay.CooldownFrames = KeyboardDisplay:LoadFrameList(self.CooldownPriorities)
    KeyboardDisplay.HealingFrames = KeyboardDisplay:LoadFrameList(self.HealingPriorities)
    -- KeyboardDisplay.InterruptFrames = KeyboardDisplay:LoadFrameList(self.InterruptPriorities)
end

function KeyboardDisplay:LoadFrameList(priorityList)
    local frames = {}
    for _, ability in pairs(priorityList.abilities) do
        if (ability) then
            tinsert(frames, KeyboardSettings.SpellToButtonMapping[ability.spellId])
        end
    end

    return frames
end

function KeyboardDisplay:AttachToNamePlate()
    local plate = C_NamePlate.GetNamePlateForUnit("target")
    local keyBtn = _G["Row1Button1"]
    if (plate) then
        keyBtn:SetPoint("TOPLEFT", plate, "BOTTOMLEFT", self.PrimaryXOfs, self.PrimaryYOfs)
        self.HealthbarFrame:ClearAllPoints()
        self.HealthbarFrame:SetPoint("TOPLEFT", keyBtn, "BOTTOMLEFT", self.HealthbarXOfs, self.HealthbarYOfs)
        self.HealthbarFrame:SetAlpha(1)

        return true
    else
        return false
    end
end

function KeyboardDisplay:ShowGrid()
    if (self:AttachToNamePlate()) then
        for i, btnFrame in pairs(self.Frames) do
            btnFrame:SetAlpha(1)
        end
    end
end

function KeyboardDisplay:HideGrid()
    for i, btnFrame in pairs(self.Frames) do
        btnFrame:SetAlpha(0)
    end

    if (self.HealthbarFrame) then
        self.HealthbarFrame:SetAlpha(0)
    end

end

function KeyboardDisplay:Saturate(btnFrame)
    local frame = _G[btnFrame]
    if not frame then
        frame = btnFrame
    end
    if (frame) then
        local t = frame.iconart;
        t:SetDesaturated(false)
    end

end

function KeyboardDisplay:Desaturate(btnFrame)
    local frame = _G[btnFrame]
    if (frame) then
        local t = frame.iconart;
        t:SetDesaturated(true)
    end
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
            frame.overlay:SetColorTexture(r, g, b, 1)

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
    local frame = KeyboardSettings.SpellToButtonMapping[spellId]
    if (frame ~= nil) then
        self:HideAllGlows(self.DamageFrames)
        self:HideAllGlows(self.DefenseFrames)
        self:HideAllGlows(self.CooldownFrames)
        self:HideAllGlows(self.HealingFrames)

        self:ShowButtonClick(frame)
    end
end

function KeyboardDisplay:HandleSpellCastChannelStop(spellId)
    local frame = KeyboardSettings.SpellToButtonMapping[spellId]
    if (frame) then
        self:HideButtonClick(frame)
        self.Channeling = false
    end
end

function KeyboardDisplay:HandleSpellCastSucceeded(spellId)
    local clickedBtn = KeyboardSettings.SpellToButtonMapping[spellId]
    self.LastClickedSpellId = spellId
    if (not self.Channeling) then
        self:ShowButtonClick(clickedBtn)
        C_Timer.After(0.1, function()
            self:HideButtonClick(clickedBtn)
        end)
    end
end

function KeyboardDisplay:ShowCooldown(spellId, timeLeft)
    local frameName = KeyboardSettings.SpellToButtonMapping[spellId]
    local frame = _G[frameName]
    if (frame) then
        if (frame.textOverlay) then
            --local c = KeyboardDisplay.Colors.Green
            --textOverlay:SetTextColor(c[1],c[2],c[3],c[4])
            local fontSize = 11
            if(timeLeft >= 60) then
                fontSize = 8
                timeLeft = tostring(ceil((timeLeft / 60))).."m"
            end
            frame.textOverlay:SetFont("Fonts\\FRIZQT__.TTF", fontSize, "OUTLINE")
            frame.textOverlay:SetText(timeLeft)
        end
    end
end

function KeyboardDisplay:HideCooldown(spellId)
    local frameName = KeyboardSettings.SpellToButtonMapping[spellId]
    local frame = _G[frameName]
    if (frame) then
        if (frame.textOverlay) then
            frame.textOverlay:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
            frame.textOverlay:SetText("")
        end
    end
end
