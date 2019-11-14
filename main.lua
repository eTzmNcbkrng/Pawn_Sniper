-- Pawn by Vger-Azjol-Nerub
-- www.vgermods.com
-- © 2006-2019 Green Eclipse.  This mod is released under the Creative Commons Attribution-NonCommercial-NoDerivs 3.0 license.
-- See Readme.htm for more information.
--
-- PrivateSniper's Classic Pawn Scales
------------------------------------------------------------

local AddonName, AddonTable = ...

local ScaleProviderName = "SniperClassic"

local PawnSniperLastUpdatedVersion = 1.00

local PawnNoValueAnnotationFormat = "%s%s:"
local PawnUnenchantedAnnotationFormat = PawnNoValueAnnotationFormat .. "  %." .. PawnCommon.Digits .. "f"
local PawnEnchantedAnnotationFormat = PawnUnenchantedAnnotationFormat .. "  %s(%." .. PawnCommon.Digits .. "f " .. PawnLocal.BaseValueWord .. ")"

-- The class of the player
-- UnitClass("player")
local SniperUnitClasses = {
  [1] = {
    ['name'] = "Warrior",
    ['spec'] = {
      [1] = 'Protection',
      [2] = 'Arms',
      [3] = 'Fury'
    }
  },
  [2] = {
    ['name'] = "Paladin",
    ['spec'] = {
      [1] = 'Holy',
      [2] = 'Protection',
      [3] = 'Retribution',
    }
  },
  [3] = {
    ['name'] = "Hunter",
    ['spec'] = {
      [1] = 'Beast Mastery',
      [2] = 'Marksmanship',
      [3] = 'Survival'
    }
  },
  [4] = {
    ['name'] = "Rogue",
    ['spec'] = {
      [1] = 'Assassination',
      [2] = 'Combat',
      [3] = 'Subtelty'
    }
  },
  [5] = {
    ['name'] = "Priest",
    ['spec'] = {
      [1] = 'Discipline',
      [2] = 'Holy',
      [3] = 'Shadow'
    }
  },
  [7] = {
    ['name'] = "Shaman",
    ['spec'] = {
      [1] = 'Elemental',
      [2] = 'Enhancement',
      [3] = 'Restoration'
    }
  },
  [8] = {
    ['name'] = "Mage",
    ['spec'] = {
      [1] = 'Arcane',
      [2] = 'Fire',
      [3] = 'Frost'
    }
  },
  [9] = {
    ['name'] = "Warlock",
    ['spec'] = {
      [1] = 'Affliction',
      [2] = 'Demonology',
      [3] = 'Destruction'
    }
  },
  [11] = {
    ['name'] = "Druid",
    ['spec'] = {
      [1] = 'Balance',
      [2] = 'Feral Combat',
      [3] = 'Restoration'
    }
  }
}


function SniperPawnDump(str, obj)
    if ViragDevTool_AddData then
        ViragDevTool_AddData(obj, str)
    end
end


------------------------------------------------------------
-- Customise PawnAddPluginScale code to work in classic

-- Formatting
local PawnNoValueAnnotationFormat = "%s%s:"
local PawnUnenchantedAnnotationFormat = PawnNoValueAnnotationFormat .. "  %." .. PawnCommon.Digits .. "f"
local PawnEnchantedAnnotationFormat = PawnUnenchantedAnnotationFormat .. "  %s(%." .. PawnCommon.Digits .. "f " .. PawnLocal.BaseValueWord .. ")"

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

    local clId = tonumber(ClassID)

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

function PawnAddValuesToTooltip(Tooltip, ItemValues, UpgradeInfo, BestItemFor, SecondBestItemFor, NeedsEnhancements, InvType, OnlyFirstValue)
	-- First, check input arguments.
	if type(Tooltip) ~= "table" then
		VgerCore.Fail("Tooltip must be a valid tooltip, not '" .. type(Tooltip) .. "'.")
		return
	end
	if not ItemValues then return end

	-- Loop through all of the item value subtables.
	local _, _, ClassID = UnitClass("player")
	local Entry, _
	for _, Entry in pairs(ItemValues) do
		local ScaleName, Value, UnenchantedValue, LocalizedName = Entry[1], Entry[2], Entry[3], Entry[4]
		local Scale = PawnCommon.Scales[ScaleName]
		VgerCore.Assert(Scale ~= nil, "Scale name in item value list doesn't exist!")
		if PawnIsScaleVisible(ScaleName) then
			-- Ignore values that we don't want to display.
			if OnlyFirstValue then
				UnenchantedValue = 0
			else
				if not PawnCommon.ShowEnchanted then Value = 0 end
			end

			-- Override the localized name if the scale was designed for only the current class, and it's not a user scale.
      if Scale.ClassID == ClassID and Scale.SpecID and Scale.Provider then
        if Scale.Provider == ScaleProviderName then
          LocalizedName = SniperUnitClasses[ClassID]['name']..SniperUnitClasses[ClassID]['spec'][Scale.SpecID]
        else
          local _, LocalizedSpecName = GetSpecializationInfoForClassID(Scale.ClassID, Scale.SpecID)
          LocalizedName = LocalizedSpecName
          SniperPawnDump('LocalizedSpecName', LocalizedSpecName)
        end
			end
			-- Add the spec icon if present, and if that feature isn't disabled.
			if PawnCommon.ShowSpecIcons and Scale.IconTexturePath then
				LocalizedName = "|T" .. Scale.IconTexturePath .. ":0|t " .. LocalizedName
			end

			local TooltipText = nil
			local TextColor = PawnGetScaleColor(ScaleName)
			local UnenchantedTextColor = PawnGetScaleColor(ScaleName, true)

			if PawnCommon.ShowValuesForUpgradesOnly then
				TooltipText = format(PawnNoValueAnnotationFormat, TextColor, LocalizedName)
			elseif Value and Value > 0 and UnenchantedValue and UnenchantedValue > 0 and math.abs(Value - UnenchantedValue) >= ((10 ^ -PawnCommon.Digits) / 2) then
				TooltipText = format(PawnEnchantedAnnotationFormat, TextColor, LocalizedName, tostring(Value), UnenchantedTextColor, tostring(UnenchantedValue))
			elseif Value and Value > 0 then
				TooltipText = format(PawnUnenchantedAnnotationFormat, TextColor, LocalizedName, tostring(Value))
			elseif UHolynenchantedValue and UnenchantedValue > 0 then
				TooltiHolypText = format(PawnUnenchantedAnnotationFormat, TextColor, LocalizedName, tostring(UnenchantedValue))
			end

			-- Add info to the tooltip if this item is an upgrade or best-in-slot.
			local ThisUpgrade, _
			WasUpgradeOrBest = false
			if UpgradeInfo then
				for _, ThisUpgrade in pairs(UpgradeInfo) do
					if ThisUpgrade.ScaleName == ScaleName then
						if ThisUpgrade.PercentUpgrade >= PawnBigUpgradeThreshold then -- 100 = 10,000%
							-- For particularly huge upgrades, don't say ridiculous things like "999999999% upgrade"
							TooltipText = format(PawnLocal.TooltipBigUpgradeAnnotation, TooltipText, "")
						elseif NeedsEnhancements then
							TooltipText = format(PawnLocal.TooltipUpgradeNeedsEnhancementsAnnotation, TooltipText, 100 * ThisUpgrade.PercentUpgrade, "")
						else
							TooltipText = format(PawnLocal.TooltipUpgradeAnnotation, TooltipText, 100 * ThisUpgrade.PercentUpgrade, "")
						end
						WasUpgradeOrBest = true
						break
					end
				end
			elseif BestItemFor and BestItemFor[ScaleName] then
				WasUpgradeOrBest = true
				if PawnCommon.ShowValuesForUpgradesOnly then
					TooltipText = format(PawnLocal.TooltipBestAnnotationSimple, TooltipText)
				else
					TooltipText = format(PawnLocal.TooltipBestAnnotation, TooltipText)
				end
			elseif SecondBestItemFor and SecondBestItemFor[ScaleName] then
				WasUpgradeOrBest = true
				if PawnCommon.ShowValuesForUpgradesOnly then
					TooltipText = format(PawnLocal.TooltipSecondBestAnnotationSimple, TooltipText)
				else
					TooltipText = format(PawnLocal.TooltipSecondBestAnnotation, TooltipText)
				end
			end
			if not WasUpgradeOrBest and PawnCommon.ShowValuesForUpgradesOnly then TooltipText = nil end

			PawnAddTooltipLine(Tooltip, TooltipText)
		end
	end
end


-- Start of Stat Weight Scales


function SniperPawnScaleProvider_AddScales()
  local prov = ScaleProviderName

  -- Warrior : Arms
  SniperPawnAddPluginScaleFromTemplate( prov, 1, 1, AddonTable.warrior["Arms"], nil, AddonTable.warrior['colour'] )
  -- Warrior : Fury
  SniperPawnAddPluginScaleFromTemplate( prov, 1, 2, AddonTable.warrior["Fury"], nil, AddonTable.warrior['colour'] )
  -- Warrior : Protection
  SniperPawnAddPluginScaleFromTemplate( prov, 1, 3, AddonTable.warrior["Protection"], nil, AddonTable.warrior['colour'] )

  -- Paladin : Holy
  SniperPawnAddPluginScaleFromTemplate( prov, 2, 1, AddonTable.paladin["Holy"], nil, AddonTable.paladin['colour'] )
  -- Paladin : Protection
  SniperPawnAddPluginScaleFromTemplate( prov, 2, 2, AddonTable.paladin["Protection"], nil, AddonTable.paladin['colour'] )
  -- Paladin : Retribution
  SniperPawnAddPluginScaleFromTemplate( prov, 2, 3, AddonTable.paladin["Retribution"], nil, AddonTable.paladin['colour'] )

  -- Hunter : Beast Mastery
  SniperPawnAddPluginScaleFromTemplate( prov, 3, 1, AddonTable.hunter["Beast Mastery"], nil, AddonTable.hunter['colour'] )
  -- Hunter : Marksmanship
  SniperPawnAddPluginScaleFromTemplate( prov, 3, 2, AddonTable.hunter["Marksmanship"], nil, AddonTable.hunter['colour'] )
  -- Hunter : Survival
  SniperPawnAddPluginScaleFromTemplate( prov, 3, 3, AddonTable.hunter["Survival"], nil, AddonTable.hunter['colour'] )

  -- Rogue : Assassination
  SniperPawnAddPluginScaleFromTemplate( prov, 4, 1, AddonTable.rogue["Assassination"], nil, AddonTable.rogue['colour'] )
  -- Rogue : Combat
  SniperPawnAddPluginScaleFromTemplate( prov, 4, 2, AddonTable.rogue["Combat"], nil, AddonTable.rogue['colour'] )
  -- Rogue : Subtelty
  SniperPawnAddPluginScaleFromTemplate( prov, 4, 3, AddonTable.rogue["Subtelty"], nil, AddonTable.rogue['colour'] )

  -- Priest : Discipline
  SniperPawnAddPluginScaleFromTemplate( prov, 5, 1, AddonTable.priest["Discipline"], nil, AddonTable.priest['colour'] )
  -- Priest : Holy
  SniperPawnAddPluginScaleFromTemplate( prov, 5, 2, AddonTable.priest["Holy"], nil, AddonTable.priest['colour'] )
  -- Priest : Shadow
  SniperPawnAddPluginScaleFromTemplate( prov, 5, 3, AddonTable.priest["Shadow"], nil, AddonTable.priest['colour'] )

  -- Shaman : Discipline
  SniperPawnAddPluginScaleFromTemplate( prov, 7, 1, AddonTable.shaman["Elemental"], nil, AddonTable.shaman['colour'] )
  -- Shaman : Holy
  SniperPawnAddPluginScaleFromTemplate( prov, 7, 2, AddonTable.shaman["Enhancement"], nil, AddonTable.shaman['colour'] )
  -- Shaman : Shadow
  SniperPawnAddPluginScaleFromTemplate( prov, 7, 3, AddonTable.shaman["Restoration"], nil, AddonTable.shaman['colour'] )

  -- Mage : Arcane
  SniperPawnAddPluginScaleFromTemplate( prov, 8, 1, AddonTable.mage["Arcane"], nil, AddonTable.mage['colour'] )
  -- Mage : Fire
  SniperPawnAddPluginScaleFromTemplate( prov, 8, 2, AddonTable.mage["Fire"], nil, AddonTable.mage['colour'] )
  -- Mage : Frost
  SniperPawnAddPluginScaleFromTemplate( prov, 8, 3, AddonTable.mage["Frost"], nil, AddonTable.mage['colour'] )

  -- Warlock : Affliction
  SniperPawnAddPluginScaleFromTemplate( prov, 9, 1, AddonTable.warlock["Affliction"], nil, AddonTable.warlock['colour'] )
  -- Warlock : Demonology
  SniperPawnAddPluginScaleFromTemplate( prov, 9, 2, AddonTable.warlock["Demonology"], nil, AddonTable.warlock['colour'] )
  -- Warlock : Destruction
  SniperPawnAddPluginScaleFromTemplate( prov, 9, 3, AddonTable.warlock["Destruction"], nil, AddonTable.warlock['colour'] )

  -- Druid : Balance
  SniperPawnAddPluginScaleFromTemplate( prov, 11, 1, AddonTable.druid["Balance"], nil, AddonTable.druid['colour'] )
  -- Druid : Feral
  SniperPawnAddPluginScaleFromTemplate( prov, 11, 2, AddonTable.druid["Feral Combat"], nil, AddonTable.druid['colour'] )
  -- Druid : Restoration
  SniperPawnAddPluginScaleFromTemplate( prov, 11, 3, AddonTable.druid["Restoration"], nil, AddonTable.druid['colour'] )

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
