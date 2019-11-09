local AddonName, AddonTable = ...

local MageArmor=0.01
local MageSpellCritRating=4
local MageStamina=1
local MageSpirit=2
local MageIntellect=16
local MageMp5=8
local MageWeaponDamage=0.1

AddonTable.mage = {
  ["colour"] = '69ccf0',
  ["Arcane"] = {
    Armor=MageArmor,
    SpellCritRating=MageSpellCritRating,
    Stamina=MageStamina,
    Spirit=MageSpirit,
    Intellect=MageIntellect,
    Mp5=MageMp5,
    Dps=MageWeaponDamage,
    RangedDps=MageWeaponDamage
  },
  ["Fire"] = {
    Armor=MageArmor,
    SpellCritRating=MageSpellCritRating,
    Stamina=MageStamina,
    Spirit=MageSpirit,
    Intellect=MageIntellect,
    Mp5=MageMp5,
    Dps=MageWeaponDamage,
    RangedDps=MageWeaponDamage
  },
  ["Frost"] = {
    Armor=MageArmor,
    SpellCritRating=MageSpellCritRating,
    Stamina=MageStamina,
    Spirit=MageSpirit,
    Intellect=MageIntellect,
    Mp5=MageMp5,
    Dps=MageWeaponDamage,
    RangedDps=MageWeaponDamage
  }
}
