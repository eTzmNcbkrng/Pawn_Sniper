-- Pawn by Vger-Azjol-Nerub
-- www.vgermods.com
-- © 2006-2019 Green Eclipse.  This mod is released under the Creative Commons Attribution-NonCommercial-NoDerivs 3.0 license.
-- See Readme.htm for more information.
--
-- Ask Mr. Robot scales
------------------------------------------------------------

local ScaleProviderName = "SniperClassic"

PawnMrRobotLastUpdatedVersion = 2.0245

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
    -- [3] = {
    -- },
    -- [4] = {
    -- },
    -- [5] = {
    -- },
    -- [6] = {
    -- },
    -- [7] = {
    -- },
    -- [8] = {
    -- },
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
function SniperPawnAddPluginScaleFromTemplate(ProviderInternalName, ClassID, SpecID, Stats, NormalizationFactor)
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
		'ffffff',
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


function PawnMrRobotScaleProvider_AddScales()

-- SniperPawnAddPluginScaleFromTemplate(
-- 	ScaleProviderName,
-- 	11, -- Druid
-- 	1, -- Balance
-- 	{ Avoidance=0.03, CritRating=1.79, HasteRating=2.20, Indestructible=0.01, Intellect=1.97, Leech=0.01, MasteryRating=2.14, MovementSpeed=0.02, Versatility=1.62 }
-- )

-- SniperPawnAddPluginScaleFromTemplate(
-- 	ScaleProviderName,
-- 	11, -- Druid
-- 	2, -- Feral
-- 	{ Agility=1.89, Avoidance=0.02, CritRating=2.15, HasteRating=1.67, Indestructible=0.01, Leech=0.01, MasteryRating=1.91, MaxDamage=1.47, MinDamage=1.47, MovementSpeed=0.03, Versatility=1.60 }
-- )

-- SniperPawnAddPluginScaleFromTemplate(
-- 	ScaleProviderName,
-- 	11, -- Druid
-- 	3, -- Guardian
-- 	{ Agility=7.85, Armor=27.72, Avoidance=5.96, CritRating=14.08, HasteRating=11.49, Indestructible=0.01, Leech=9.52, MasteryRating=17.48, MaxDamage=4.71, MinDamage=4.71, MovementSpeed=0.01, Stamina=9.83, Versatility=18.72 }
-- )

-- SniperPawnAddPluginScaleFromTemplate(
-- 	ScaleProviderName,
-- 	11, -- Druid
-- 	4, -- Restoration
-- 	{ Avoidance=0.02, CritRating=3.18, HasteRating=3.42, Indestructible=0.01, Intellect=3.45, Leech=4.31, MasteryRating=3.62, MovementSpeed=0.01, Versatility=3.44 }
-- )

-- SniperPawnAddPluginScaleFromTemplate(
-- 	ScaleProviderName,
-- 	3, -- Hunter
-- 	1, -- Beast Mastery
-- 	{ Agility=1.95, Avoidance=0.03, CritRating=1.58, HasteRating=1.62, Indestructible=0.01, Leech=0.01, MasteryRating=1.64, MaxDamage=1.06, MinDamage=1.06, MovementSpeed=0.02, Versatility=1.48 }
-- )

-- SniperPawnAddPluginScaleFromTemplate(
-- 	ScaleProviderName,
-- 	3, -- Hunter
-- 	2, -- Marksmanship
-- 	{ Agility=1.80, Avoidance=0.03, CritRating=1.53, HasteRating=1.67, Indestructible=0.01, Leech=0.01, MasteryRating=1.82, MaxDamage=1.71, MinDamage=1.71, MovementSpeed=0.02, Versatility=1.41 }
-- )

-- SniperPawnAddPluginScaleFromTemplate(
-- 	ScaleProviderName,
-- 	3, -- Hunter
-- 	3, -- Survival
-- 	{ Agility=1.89, Avoidance=0.02, CritRating=1.63, HasteRating=2.09, Indestructible=0.01, Leech=0.01, MasteryRating=1.33, MaxDamage=1.15, MinDamage=1.15, MovementSpeed=0.03, Versatility=1.53 }
-- )

-- SniperPawnAddPluginScaleFromTemplate(
-- 	ScaleProviderName,
-- 	8, -- Mage
-- 	1, -- Arcane
-- 	{ Avoidance=0.03, CritRating=1.76, HasteRating=1.68, Indestructible=0.01, Intellect=1.91, Leech=0.01, MasteryRating=1.45, MovementSpeed=0.02, Versatility=1.58 }
-- )

-- SniperPawnAddPluginScaleFromTemplate(
-- 	ScaleProviderName,
-- 	8, -- Mage
-- 	2, -- Fire
-- 	{ Avoidance=0.03, CritRating=1.68, HasteRating=1.71, Indestructible=0.01, Intellect=1.80, Leech=0.01, MasteryRating=1.50, MovementSpeed=0.02, Versatility=1.45 }
-- )

-- SniperPawnAddPluginScaleFromTemplate(
-- 	ScaleProviderName,
-- 	8, -- Mage
-- 	3, -- Frost
-- 	{ Avoidance=0.03, CritRating=1.49, HasteRating=1.69, Indestructible=0.01, Intellect=1.76, Leech=0.01, MasteryRating=1.77, MovementSpeed=0.02, Versatility=1.48 }
-- )

-- SniperPawnAddPluginScaleFromTemplate(
-- 	ScaleProviderName,
-- 	2, -- Paladin
-- 	1, -- Holy
-- 	{ Avoidance=0.02, CritRating=1.91, HasteRating=0.19, Indestructible=0.01, Intellect=2.36, Leech=1.40, MasteryRating=2.68, MovementSpeed=0.01, Versatility=2.06 }
-- )

-- SniperPawnAddPluginScaleFromTemplate(
-- 	ScaleProviderName,
-- 	2, -- Paladin
-- 	2, -- Protection
-- 	{ Armor=17.06, Avoidance=5.51, CritRating=13.12, HasteRating=7.56, Indestructible=0.01, Leech=10.00, MasteryRating=27.19, MaxDamage=11.70, MinDamage=11.70, MovementSpeed=0.01, Stamina=13.28, Strength=7.54, Versatility=19.08 }
-- )

-- SniperPawnAddPluginScaleFromTemplate(
-- 	ScaleProviderName,
-- 	2, -- Paladin
-- 	3, -- Retribution
-- 	{ Avoidance=0.02, CritRating=1.53, HasteRating=1.77, Indestructible=0.01, Leech=0.01, MasteryRating=1.60, MaxDamage=1.39, MinDamage=1.39, MovementSpeed=0.03, Strength=1.79, Versatility=1.50 }
-- )

-- SniperPawnAddPluginScaleFromTemplate(
-- 	ScaleProviderName,
-- 	5, -- Priest
-- 	1, -- Discipline
-- 	{ Avoidance=0.02, CritRating=2.16, HasteRating=2.71, Indestructible=0.01, Intellect=2.52, Leech=1.30, MasteryRating=1.72, MovementSpeed=0.01, Versatility=2.37 }
-- )

-- SniperPawnAddPluginScaleFromTemplate(
-- 	ScaleProviderName,
-- 	5, -- Priest
-- 	2, -- Holy
-- 	{ Avoidance=0.02, CritRating=3.10, HasteRating=0.26, Indestructible=0.01, Intellect=3.52, Leech=3.48, MasteryRating=3.94, MovementSpeed=0.01, Versatility=3.19 }
-- )

-- SniperPawnAddPluginScaleFromTemplate(
-- 	ScaleProviderName,
-- 	5, -- Priest
-- 	3, -- Shadow
-- 	{ Avoidance=0.03, CritRating=1.79, HasteRating=2.16, Indestructible=0.01, Intellect=1.81, Leech=0.01, MasteryRating=1.66, MovementSpeed=0.02, Versatility=1.48 }
-- )

-- SniperPawnAddPluginScaleFromTemplate(
-- 	ScaleProviderName,
-- 	4, -- Rogue
-- 	1, -- Assassination
-- 	{ Agility=1.76, Avoidance=0.02, CritRating=1.75, HasteRating=1.81, Indestructible=0.01, Leech=0.01, MasteryRating=1.65, MaxDamage=2.45, MinDamage=2.45, MovementSpeed=0.03, Versatility=1.42 }
-- )

-- SniperPawnAddPluginScaleFromTemplate(
-- 	ScaleProviderName,
-- 	4, -- Rogue
-- 	2, -- Outlaw
-- 	{ Agility=1.75, Avoidance=0.02, CritRating=1.51, HasteRating=1.47, Indestructible=0.01, Leech=0.01, MasteryRating=1.41, MaxDamage=1.63, MinDamage=1.63, MovementSpeed=0.03, Versatility=1.39 }
-- )

-- SniperPawnAddPluginScaleFromTemplate(
-- 	ScaleProviderName,
-- 	4, -- Rogue
-- 	3, -- Subtlety
-- 	{ Agility=1.79, Avoidance=0.02, CritRating=1.57, HasteRating=1.35, Indestructible=0.01, Leech=0.01, MasteryRating=1.41, MaxDamage=2.53, MinDamage=2.53, MovementSpeed=0.03, Versatility=1.43 }
-- )

-- SniperPawnAddPluginScaleFromTemplate(
-- 	ScaleProviderName,
-- 	7, -- Shaman
-- 	1, -- Elemental
-- 	{ Avoidance=0.03, CritRating=1.68, HasteRating=1.69, Indestructible=0.01, Intellect=1.80, Leech=0.01, MasteryRating=1.09, MovementSpeed=0.02, Versatility=1.50 }
-- )

-- SniperPawnAddPluginScaleFromTemplate(
-- 	ScaleProviderName,
-- 	7, -- Shaman
-- 	2, -- Enhancement
-- 	{ Agility=1.86, Avoidance=0.02, CritRating=1.66, HasteRating=2.00, Indestructible=0.01, Leech=0.01, MasteryRating=1.51, MaxDamage=1.46, MinDamage=1.46, MovementSpeed=0.03, Versatility=1.49 }
-- )

-- SniperPawnAddPluginScaleFromTemplate(
-- 	ScaleProviderName,
-- 	7, -- Shaman
-- 	3, -- Restoration
-- 	{ Avoidance=0.02, CritRating=4.28, HasteRating=0.50, Indestructible=0.01, Intellect=3.18, Leech=3.88, MasteryRating=3.27, MovementSpeed=0.01, Versatility=2.96 }
-- )

-- SniperPawnAddPluginScaleFromTemplate(
-- 	ScaleProviderName,
-- 	9, -- Warlock
-- 	1, -- Affliction
-- 	{ Avoidance=0.03, CritRating=1.53, HasteRating=1.79, Indestructible=0.01, Intellect=1.70, Leech=0.01, MasteryRating=1.82, MovementSpeed=0.02, Versatility=1.34 }
-- )

-- SniperPawnAddPluginScaleFromTemplate(
-- 	ScaleProviderName,
-- 	9, -- Warlock
-- 	2, -- Demonology
-- 	{ Avoidance=0.03, CritRating=1.83, HasteRating=2.06, Indestructible=0.01, Intellect=2.03, Leech=0.01, MasteryRating=2.00, MovementSpeed=0.02, Versatility=1.68 }
-- )

-- SniperPawnAddPluginScaleFromTemplate(
-- 	ScaleProviderName,
-- 	9, -- Warlock
-- 	3, -- Destruction
-- 	{ Avoidance=0.03, CritRating=1.73, HasteRating=1.92, Indestructible=0.01, Intellect=1.86, Leech=0.01, MasteryRating=1.80, MovementSpeed=0.02, Versatility=1.52 }
-- )

-- SniperPawnAddPluginScaleFromTemplate(
-- 	ScaleProviderName,
-- 	1, -- Warrior
-- 	1, -- Arms
-- 	{ Avoidance=0.02, CritRating=1.74, HasteRating=1.71, Indestructible=0.01, Leech=0.01, MasteryRating=1.40, MaxDamage=1.35, MinDamage=1.35, MovementSpeed=0.03, Strength=1.68, Versatility=1.37 }
-- )

-- SniperPawnAddPluginScaleFromTemplate(
-- 	ScaleProviderName,
-- 	1, -- Warrior
-- 	2, -- Fury
-- 	{ Avoidance=0.02, CritRating=1.53, HasteRating=1.89, Indestructible=0.01, Leech=0.01, MasteryRating=1.62, MaxDamage=0.86, MinDamage=0.86, MovementSpeed=0.03, Strength=1.61, Versatility=1.37 }
-- )

SniperPawnAddPluginScaleFromTemplate(
	ScaleProviderName,
	1, -- Warrior
	3, -- Protection
	{
        Armor=17.04,
        CritRating=13.47,
        HasteRating=15.18,
        MaxDamage=2.74,
        MinDamage=2.74,
        MovementSpeed=0.01,
        Stamina=15.24,
        Strength=19.32,
        Versatility=26.25
    }
)



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
    PawnAddPluginScaleProvider(ScaleProviderName, PawnLocal.UI.AskMrRobotProvider, PawnMrRobotScaleProvider_AddScales)
end
