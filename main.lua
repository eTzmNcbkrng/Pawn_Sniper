-- Pawn by Vger-Azjol-Nerub
-- www.vgermods.com
-- © 2006-2019 Green Eclipse.  This mod is released under the Creative Commons Attribution-NonCommercial-NoDerivs 3.0 license.
-- See Readme.htm for more information.
--
-- PrivateSniper's Classic Pawn Scales
------------------------------------------------------------

local AddonName, AddonTable = ...

local ScaleProviderName = "SniperClassic"

PawnSniperLastUpdatedVersion = 1.00

local SniperUnitClasses = {
    [1] = {
        ['name'] = "Warrior",
        ['spec'] = {
            [1] = 'Protection',
            [2] = 'Arms',
            [3] = 'Fury'
        }
    },
    -- [2] = {
    -- },
    [3] = {
      ['name'] = "Hunter",
        ['spec'] = {
            [1] = 'Beast Mastery',
            [2] = 'Marksmanship',
            [3] = 'Survival'
        }
    },
    -- [4] = {
    -- },
    -- [5] = {
    -- },
    -- [6] = {
    -- },
    -- [7] = {
    -- },
    [8] = {
        ['name'] = "Mage",
        ['spec'] = {
            [1] = 'Fire',
            [2] = 'Frost',
            [3] = 'Arcane'
        }
    },
}


function SniperPawnDump(str, obj)
    if ViragDevTool_AddData then
        ViragDevTool_AddData(obj, str)
    end
end


------------------------------------------------------------
-- Customise PawnAddPluginScale code to work in classic

function SniperPawnGetStatValuesForTemplate(Template, NoStats)
	--local _, _, _, _, Role = GetSpecializationInfoForClassID(Template.ClassID, Template.SpecID)

	local ScaleValues
	if NoStats then
		ScaleValues = {}
	else
		ScaleValues = {
			["Stamina"] = 0.01,

			["CritRating"] = 0.5,
			["HasteRating"] = 0.5,
			["MasteryRating"] = 0.5,
			["Versatility"] = 0.5,

			["MovementSpeed"] = 0.01,
			["Avoidance"] = 0.01,
			["Leech"] = 0.01,
			["Indestructible"] = 0.01,
		}

		ScaleValues[Template.PrimaryStat] = 1

		-- if Role == "TANK" then
		-- 	ScaleValues.Stamina = 1
		-- 	ScaleValues.Armor = 1
		-- end
	end

	local StatName
	for _, StatName in pairs(PawnNeverUsableStats[Template.ClassID]) do
		ScaleValues[StatName] = PawnIgnoreStatValue
	end
	for _, StatName in pairs(Template.UnusableStats) do
		ScaleValues[StatName] = PawnIgnoreStatValue
	end

	return ScaleValues
end

-- Adds a plugin scale from Pawn, starting from one of Pawn's existing templates.
function SniperPawnAddPluginScaleFromTemplate(ProviderInternalName, ClassID, SpecID, Stats, NormalizationFactor, Color)
	if not PawnScaleProviders[ProviderInternalName] then
		VgerCore.Fail("A scale provider with that name is not registered.  Use PawnAddPluginScaleProvider first.")
		return
	end

	if not PawnCommon then VgerCore.Fail("Can't add plugin scales until Pawn starts to initialize.") return end

    SniperPawnDump('SniperUnitClasses', SniperUnitClasses)
    SniperPawnDump('SniperUnitClasses ClassId', SniperUnitClasses[ClassID])

    local clId = tonumber(ClassID)

    SniperPawnDump('clId', clId)

    local className = SniperUnitClasses[tonumber(ClassID)]['name']
    local specName = SniperUnitClasses[tonumber(ClassID)]['spec'][tonumber(SpecID)]

	local Template = PawnFindScaleTemplate(ClassID, SpecID)
	if not Template then VgerCore.Fail("Can't add this plugin scale because the class" .. tostring(className) .. " ID " .. tostring(ClassID) .. " and/or spec " .. tostring(LocalizedSpecName) .. " ID " .. tostring(SpecID) .. " wasn't found.") return end

	-- Build up the values table.
	local ScaleValues = SniperPawnGetStatValuesForTemplate(Template)
	if Stats then
		local StatName, Value
		for StatName, Value in pairs(Stats) do
			ScaleValues[StatName] = Stats[StatName]
		end
	end

	--local Color = strsub(RAID_CLASS_COLORS[UnlocalizedClassName].colorStr, 3)
	-- Choose a lighter color for death knights so it's easier to read.
	-- if ClassID == 6 then Color = "ff4d6b" end

	-- Then, transfer control to the regular plugin scale codepath.
	local ScaleInternalName = className .. SpecID
	PawnAddPluginScale(
		ProviderInternalName,
		ScaleInternalName,
		className .. ": " .. specName, -- LocalizedScaleName
		Color,
		ScaleValues,
		NormalizationFactor,
		Template.HideUpgrades
	)
	
	-- Finally, make a few more customizations to that scale.
	local NewScale = PawnCommon.Scales[PawnGetProviderScaleName(ProviderInternalName, ScaleInternalName)]
	if not NewScale then return end

	NewScale.ClassID = ClassID
	NewScale.SpecID = SpecID
	NewScale.IconTexturePath = IconTexturePath
	NewScale.Role = Role
end


-- Start of Stat Weight Scales


function SniperPawnScaleProvider_AddScales()

    SniperPawnDump('addonTable', AddonTable)

    -- Warrior: Protection
    SniperPawnAddPluginScaleFromTemplate( ScaleProviderName, 1, 1, AddonTable.warrior["Protection"], nil, AddonTable.warrior['colour'] )

    -- Hunter: Marksmanship
    SniperPawnAddPluginScaleFromTemplate( ScaleProviderName, 3, 2, AddonTable.hunter["Marksmanship"], nil, AddonTable.hunter['colour'] )

    ------------------------------------------------------------

    -- PawnMrRobotScaleProviderOptions.LastAdded keeps track of the last time that we tried to automatically enable scales for this character.
    if not PawnMrRobotScaleProviderOptions then PawnMrRobotScaleProviderOptions = { } end
    if not PawnMrRobotScaleProviderOptions.LastAdded then PawnMrRobotScaleProviderOptions.LastAdded = 0 end

    local _, Class = UnitClass("player")
    if PawnMrRobotScaleProviderOptions.LastClass ~= nil and Class ~= PawnMrRobotScaleProviderOptions.LastClass then
        -- If the character has changed class since last time, let's start over.
        PawnSetAllScaleProviderScalesVisible(ScaleProviderName, false)
        PawnMrRobotScaleProviderOptions.LastAdded = 0
    end
    PawnMrRobotScaleProviderOptions.LastClass = Class

    -- These scales are new, and we don't need any upgrade logic yet.
    PawnMrRobotScaleProviderOptions.LastAdded = 1

    -- After this function terminates there's no need for it anymore, so cause it to self-destruct to save memory.
    PawnMrRobotScaleProvider_AddScales = nil

end -- PawnMrRobotScaleProvider_AddScales

------------------------------------------------------------

if not VgerCore.IsClassic then
	-- These scales aren't useful on WoW retail, so skip them.
    PawnMrRobotScaleProvider_AddScales = nil
else
    PawnAddPluginScaleProvider(ScaleProviderName, 'Pawn Sniper Classic', SniperPawnScaleProvider_AddScales)
end
