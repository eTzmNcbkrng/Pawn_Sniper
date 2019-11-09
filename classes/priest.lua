local AddonName, AddonTable = ...

local PriestIntellect=16
local PriestSpirit=4
local PriestMp5=8
local PriestHealing=32
local PriestArmor=0.01
local PriestStamina=1
local PriestSpellCritRating=4

AddonTable.priest = {
  ["colour"] = 'ffffff',
  ["Discipline"] = {
    Armor=PriestArmor,
    SpellCritRating=PriestSpellCritRating,
    Stamina=PriestStamina,
    Spirit=PriestSpirit,
    Intellect=PriestIntellect,
    Mp5=PriestMp5,
    Healing=PriestHealing
  },
  ["Holy"] = {
    Armor=PriestArmor,
    SpellCritRating=PriestSpellCritRating,
    Stamina=PriestStamina,
    Spirit=PriestSpirit,
    Intellect=PriestIntellect,
    Mp5=PriestMp5,
    Healing=PriestHealing
  },
  ["Shadow"] = {
    Armor=PriestArmor,
    SpellCritRating=PriestSpellCritRating,
    Stamina=PriestStamina,
    Spirit=PriestSpirit,
    Intellect=PriestIntellect,
    Mp5=PriestMp5
  }
}
