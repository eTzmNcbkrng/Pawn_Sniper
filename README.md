# Pawn (Classic) Sniper's Weights

[Pawn](https://www.curseforge.com/wow/addons/pawn)

## Important Notes

1) The weights are just my own made up values but good enough for my own use (although I don't play all classes I have based most weights off what feels right)
2) Feel absolutely free to make your own fork, rename the addon to whatever you want and play around with your own weights, if you do push to curse please credit my own work here on github, but the purpose of most of my addons is to make stuff I like to use and to help others get things they like to use.
3) Hit is a weird stat in classic, you need exact amounts of it, so I have weighted it high, but once you hit a cap you should bear in mind that adding more will be useless, so the weights should always be taken with a pinch of salt.

## Installation

Git clone this repo into your addons folder, as well as it's dependency which is [Shim](https://github.com/ps-wow/_shim)

## Known Issues

Errors currently in pawn:

    Pawn\PawnUI.lua:246: attempt to call global 'GetSpecializationInfoForClassID' (a nil value)
    Pawn\PawnUI.lua:246: in function `PawnUIFrame_ScaleSelector_UpdateAuto'
    Pawn\PawnUI.lua:299: in function `PawnUI_SelectScale'
    Pawn\PawnUI.lua:285: in function <Pawn\PawnUI.lua:278>
    
None of the above prevent the addon from working if encountered, I have Pawn_Sniper working in my own wow classic.

## Stats

Below is a list of some of the stats used by my weights and their internal names in Pawn.

- `HitRating`
- `CritRating`
- `Ap` - Attack Power
- `Agility`
- `Rap` - Ranged Attack Power
