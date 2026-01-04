local _, AtomicPortals = ...

local AP = CreateFrame("Frame")

local ChallengeModeCreatedButtons = {}

function AP:OnEvent(event, ...)
    self[event](self, ...)
end

function AP:ADDON_LOADED(addOnName)
    if addOnName == "Blizzard_ChallengesUI" then
        self:CreateAndUpdateButtons()
        self:UnregisterEvent("ADDON_LOADED")
    end
end

-- something in retail is calling this, before ChallengesFrame is on screen
-- does not happen on PTR, but this is probably not needed as it was an attempt at replacing CHALLENGE_MODE_LEADERS_UPDATE
-- function AP:CHALLENGE_MODE_MAPS_UPDATE()
--     self:CreateAndUpdateButtons()
-- end

function AP:CHALLENGE_MODE_LEADERS_UPDATE()
    self:CreateAndUpdateButtons()
end

local topOffset = 26
local buttonSize = 34
local vPad = 4

local function getYOffset(i)
    if (i == 1) then
        return -(topOffset + vPad)
    else
        return ((-buttonSize - vPad) * i) + (buttonSize - topOffset)
    end
end

function AP:CreateAndUpdateButtons()
    if (InCombatLockdown()) then
        return
    end

    for i, mapId in ipairs(C_ChallengeMode.GetMapTable()) do
        local spellInfo = AtomicPortals.getSpellInfoFromMapId(mapId)

        if (spellInfo and C_SpellBook.IsSpellInSpellBook(spellInfo.spellId)) then
            local createdButton = ChallengeModeCreatedButtons[mapId]

            if (createdButton == nil) then
                local button = CreateFrame("Button", nil, ChallengesFrame, "InsecureActionButtonTemplate")
                button:SetAttribute("type", "spell")
                button:SetAttribute("spell", spellInfo.spellId)
                button:RegisterForClicks("AnyUp", "AnyDown")
                button:SetPoint("TOPRIGHT", -12, getYOffset(i))
                button:SetSize(buttonSize, buttonSize)

                local buttonTexture = button:CreateTexture(nil, "BACKGROUND")
                buttonTexture:SetAllPoints(button)
                buttonTexture:SetTexture(C_Spell.GetSpellTexture(spellInfo.spellId))
                buttonTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
                button.buttonTexture = buttonTexture

                local buttonCooldownText = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
                buttonCooldownText:SetAllPoints(button)
                button.buttonCooldownText = buttonCooldownText

                local buttonTextSName = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                buttonTextSName:SetPoint("RIGHT", button, "LEFT", -2, 0)
                buttonTextSName:SetTextColor(1, 1, 1)
                buttonTextSName:SetText(spellInfo.sName)

                AP:UpdateCooldowns(button, spellInfo.spellId)

                ChallengeModeCreatedButtons[mapId] = button
            else
                AP:UpdateCooldowns(createdButton, spellInfo.spellId)
            end
        end
    end
end

function AP:UpdateCooldowns(button, spellId)
    local spellCooldown = C_Spell.GetSpellCooldown(spellId)
    local isOnCooldown = spellCooldown.duration ~= 0

    if (isOnCooldown) then
        button.buttonTexture:SetDesaturated(true)
        button.buttonCooldownText:SetCooldown(spellCooldown.startTime, spellCooldown.duration)
    else
        button.buttonTexture:SetDesaturated(false)
        button.buttonCooldownText:SetCooldown(0, 0)
    end
end

SLASH_AtomicPortals1 = "/ap"
SLASH_AtomicPortals2 = "/port"

SlashCmdList.AtomicPortals = function(msg)
    if msg == "" then
        print("TODO!")
    end
end

AP:RegisterEvent("ADDON_LOADED")
-- AP:RegisterEvent("CHALLENGE_MODE_MAPS_UPDATE")
AP:RegisterEvent("CHALLENGE_MODE_LEADERS_UPDATE")

AP:SetScript("OnEvent", AP.OnEvent)
