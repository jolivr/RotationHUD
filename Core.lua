local RotationHUD, Abilities = ...
local RotationHUD, Rotation = ...
local RotationHUD, Layouts = ...

RoHUD = LibStub('AceAddon-3.0'):NewAddon('RoHUD', 'AceConsole-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

local GUI = LibStub("AceGUI-3.0")
local ConfigDialog = LibStub("AceConfigDialog-3.0")
local ConfigDB = LibStub("AceDB-3.0")
local ConfigRegistry = LibStub("AceConfigRegistry-3.0")
RoHUD.selectedLayout = Layouts.G13
local spellListFrame, specIconList = {}, {}
local healthBarFrame={}
RoHUD.masterPriorityList = {}
RoHUD.damageArgs = {}
RoHUD.defenseArgs = {}
RoHUD.cooldownArgs = {}
RoHUD.healingArgs = {}

RoHUD.defaultOptions = {
    profile = {
        damagePriorities = { { spellId = 100784 } },
        defensePriorities = { { spellId = 100784 } },
        cooldownPriorities = { { spellId = 100784 } },
        healingPriorities = { { spellId = 100784 } }
    }
}

RoHUD.configOptions = {
    name = "Gamepad Icons - Windwalker",
    type = "group",
    args = {
        priorities = {
            name = "Priorities",
            type = "group",
            childGroups = "tree",
            args = {
                damage = {
                    name = "Damage",
                    type = "group",
                    args = RoHUD.damageArgs,
                    order = 1
                },
                defense = {
                    name = "Defense",
                    type = "group",
                    args = RoHUD.defenseArgs,
                    order = 2
                },
                cooldown = {
                    name = "Cooldown",
                    type = "group",
                    args = RoHUD.cooldownArgs,
                    order = 3
                },
                healing = {
                    name = "Healing",
                    type = "group",
                    args = RoHUD.healingArgs,
                    order = 4
                }
            }
        },
        reloadUI = {
            name = "Reload UI",
            type = "execute",
            func = function() ReloadUI() end,
            order = 1000
        },
        resetProfile = {
            name = "Reset profile",
            type = "execute",
            func = function() RoHUD.db.profile = nil ReloadUI() end,
            order = 1100
        }
    },
}


function RoHUD:OnInitialize()
    self.db = ConfigDB:New("RotationHUD_DB", self.defaultOptions)
    ConfigRegistry:RegisterOptionsTable("RoHUD", self.configOptions)

    self:InitializeConfigOptions()
    self:Print("Rotation HUD Initialized")
end

function RoHUD:InitializeConfigOptions()
    self:CreatePrioritySection("Damage", self.damageArgs, self.db.profile.damagePriorities)
    self:CreatePrioritySection("Defense", self.defenseArgs, self.db.profile.defensePriorities)
    self:CreatePrioritySection("Cooldown", self.cooldownArgs, self.db.profile.cooldownPriorities)
    self:CreatePrioritySection("Healing", self.healingArgs, self.db.profile.healingPriorities)
end

function RoHUD:CreatePrioritySection(abilityType, optionArgs, priorityList)

    for i, _ in pairs(optionArgs) do
        optionArgs[i] = nil
    end

    for index, priority in pairs(priorityList) do
        local upDisabled, downDisabled = false, false

        if (index == 1) then
            upDisabled = true
        end
        if (index == #priorityList) then
            downDisabled = true
        end
        local prioritySection = {
            type = "group",
            inline = true,
            name = "Priority " .. index,
            order = index,
            width = .7,
            args = {
                icon = {
                    name = Abilities.Monk.AbilityNameLookup[priority.spellId],
                    type = "execute",
                    image = GetSpellTexture(priority.spellId),
                    imageHeight = 40,
                    imageWidth = 40,
                    func = function() end,
                    order = 1,
                    width = .75
                },
                upPriority = {
                    name = "up",
                    type = "execute",
                    func = function()
                        self:changeAbilityPriority(priority.spellId, index, index - 1, abilityType, optionArgs,
                            priorityList)
                    end,
                    order = 2,
                    width = .4,
                    disabled = upDisabled
                },
                downpriority = {
                    name = "down",
                    type = "execute",
                    func = function()
                        self:changeAbilityPriority(priority.spellId, index, index + 1, abilityType, optionArgs,
                            priorityList)
                    end,
                    order = 3,
                    width = .4,
                    disabled = downDisabled
                },
                delete = {
                    name = "delete",
                    type = "execute",
                    confirm = function() return "Delete this ability?" end,
                    func = function()
                        self:deleteAbilityPriority(index, abilityType, optionArgs, priorityList)
                    end,
                    order = 4,
                    width = .4
                }
            }
        }

        optionArgs[tostring(index)] = prioritySection
    end
    -- end
    local addNewPrioritySection = {
        type = "group",
        inline = true,
        name = "Add Spell",
        width = .7,
        args = {
            abilitybtn1 = {
                name = "",
                type = "execute",
                image = "Interface\\ICONS\\INV_Misc_QuestionMark",
                imageHeight = 40,
                imageWidth = 40,
                func = function()
                    self:PopulateSpells(abilityType, optionArgs, priorityList)
                end,
                order = 1,
                width = .75
            }
        }
    }
    optionArgs["100"] = addNewPrioritySection
end

function RoHUD:CompileMasterListOfPriorities()
    for _, ability in pairs(self.db.profile.damagePriorities) do
        self.masterPriorityList[ability.spellId] = ability
    end
    for _, ability in pairs(self.db.profile.defensePriorities) do
        self.masterPriorityList[ability.spellId] = ability
    end
    for _, ability in pairs(self.db.profile.cooldownPriorities) do
        self.masterPriorityList[ability.spellId] = ability
    end
    for _, ability in pairs(self.db.profile.healingPriorities) do
        self.masterPriorityList[ability.spellId] = ability
    end
end

function RoHUD:PopulateSpells(type, args, priorityList)
    local spellList = {}
    local index = 1
    spellListFrame = GUI:Create("Frame")
    spellListFrame:SetStatusText("Select a spell ... ")
    spellListFrame:SetTitle("Pick a Spell!")
    spellListFrame:SetLayout("Fill")
    spellListFrame:SetHeight(400)
    spellListFrame:SetWidth(500)

    self:CompileMasterListOfPriorities()

    specIconList = GUI:Create("ScrollFrame")
    specIconList:SetLayout("Flow")
    spellListFrame:AddChild(specIconList)

    local id, specName = GetSpecializationInfo(GetSpecialization())
    local className = UnitClass("player")
    local numTabs = GetNumSpellTabs()

    for i = 1, numTabs do
        local name, texture, offset, numSpells = GetSpellTabInfo(i)

        if (name == specName or name == className) then
            for n = offset + 1, offset + numSpells do
                if not IsPassiveSpell(n, "spell") then
                    local spellName, _, spellIcon, _, _, _, spellId = GetSpellInfo(n, "spell")
                    if spellName ~= nil and self.masterPriorityList[spellId] == nil then
                        spellList[index] = { name = spellName, icon = spellIcon, id = spellId }
                        index = index + 1
                    end
                end
            end
        end
    end


    table.sort(spellList, function(a, b) return a.name < b.name end)

    for _, spell in pairs(spellList) do
        local addIcon = GUI:Create("Icon")
        addIcon:SetImage(spell.icon)
        addIcon:SetImageSize(36, 36)
        addIcon:SetLabel(spell.name)
        addIcon:SetCallback("OnClick", function(self)
            RoHUD:AddPriority(spell.id, type, args, priorityList)
        end)
        specIconList:AddChild(addIcon)
    end
end

function RoHUD:AddPriority(spellId, type, args, priorityList)

    if not spellId then return end
    local newIndex = #priorityList + 1

    priorityList[newIndex] = Abilities.Monk.AbilityLookup[spellId]

    ConfigRegistry:NotifyChange("RoHUD"); -- necessary for options to refresh
    self:CreatePrioritySection(type, args, priorityList)
    spellListFrame:Hide()
end

function RoHUD:deleteAbilityPriority(index, type, args, priorityList)
    local maxIndex = #priorityList
    for i, v in pairs(priorityList) do
        local listIndex = tonumber(i)
        if (listIndex >= index and listIndex ~= 100) then
            if (i ~= maxIndex) then
                priorityList[listIndex] = priorityList[listIndex + 1]
            else
                table.remove(priorityList, listIndex)
            end
        end
    end

    self:CreatePrioritySection(type, args, priorityList)
end

function RoHUD:changeAbilityPriority(spellId, currentIndex, newIndex, type, args, priorityList)
    if (newIndex > 0) and (newIndex <= #priorityList) then
        local currentAbility = priorityList[currentIndex]
        local prevAbility = priorityList[newIndex]

        priorityList[newIndex] = currentAbility
        priorityList[currentIndex] = prevAbility
    end

    self:CreatePrioritySection(type, args, priorityList)
end

function RoHUD:PriorityRotationTimer()
	-- for type, pack in pairs(abilityPacks) do
	-- 	checkAbilities(pack.abilityPool, prevDmgButton, GI.DamageFrames, pack.glowColor, type)
	-- end
end

function RoHUD:StartTimers()
    self:Print("Starting timers")
    self:ScheduleRepeatingTimer("PriorityRotationTimer", .25)
end

function RoHUD:CancelTimers()
	self:Print("Stopping timers")
	self:CancelAllTimers()
end

function RoHUD:PLAYER_ENTERING_WORLD(_, _, _)
    healthBarFrame = _G["ElvNP_Player"]
    Rotation:InitializeIconGrid(self.selectedLayout, healthBarFrame)
    ConfigDialog:Open("RoHUD")
    ConfigDialog:SelectGroup("RoHUD", "priorities", "damage")
end

function RoHUD:PLAYER_TARGET_CHANGED()
	if (UnitCanAttack("player", "target")) then
		self:StartTimers()
		Rotation:ShowGrid(healthBarFrame)
	else
		self:CancelTimers()
		Rotation:HideGrid(healthBarFrame)
	end
end

RoHUD:RegisterEvent("PLAYER_ENTERING_WORLD")
RoHUD:RegisterEvent("PLAYER_TARGET_CHANGED")

--= _G["ElvNP_Player"]