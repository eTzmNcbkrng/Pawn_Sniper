local AddonName, AddonTable = ...

AddonTable.paladin = {
  ["colour"] = 'f58cba', -- TODO: Correct the colour
  -- Tanking
  ["Protection"] = {
    Armor=0.1,
    Agility=1,
    CritRating=1,
    AttackPower=2,
    Hit=10,
    Stamina=6,
    Strength=4,
    Defense=2,
    Dodge=1,
    Parry=1,
    Hp5=4
  },
  -- Healing
  ["Holy"] = {
    Armor=0.01,
    SpellCritRating=4,
    Stamina=1,
    Spirit=4,
    Intellect=16,
    Mp5=8,
    Healing=32
  },
  -- DPS
  ["Retribution"] = {
    Armor=0.01,
    Agility=1,
    CritRating=1,
    AttackPower=2,
    Hit=10,
    Stamina=6,
    Strength=4,
    Defense=2,
    Dodge=1,
    Parry=1,
    Hp5=4
  }
}
