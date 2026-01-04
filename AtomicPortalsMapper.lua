local _, AtomicPortals = ...

local englishFaction = UnitFactionGroup("player")

local function getMotherlodeId()
    if (englishFaction == "Horde") then
        return 467555
    else
        return 467553
    end
end

local spellTable = {
    -- Battle for Azeroth
    [247] = { spellId = getMotherlodeId(), sName = "ML" },

    -- Shadowlands
    [378] = { spellId = 354465, sName = "HOA" },
    [392] = { spellId = 367416, sName = "GMBT" },
    [391] = { spellId = 367416, sName = "STRT" },

    -- The War Within
    [503] = { spellId = 445417, sName = "ARAK" },
    [506] = { spellId = 445440, sName = "BREW" },
    [502] = { spellId = 445416, sName = "COT" },
    [505] = { spellId = 445414, sName = "DAWN" },
    [504] = { spellId = 445441, sName = "DFC" },
    [542] = { spellId = 1237215, sName = "EDA" },
    [525] = { spellId = 1216786, sName = "FLOOD" },
    [499] = { spellId = 445444, sName = "PSF" },
    [500] = { spellId = 445443, sName = "ROOK" },
    [501] = { spellId = 445269, sName = "SV" },
}

local function getSpellInfoFromMapId(mapId)
    local spellInfo = spellTable[mapId]

    return spellInfo
end

AtomicPortals.getSpellInfoFromMapId = getSpellInfoFromMapId
