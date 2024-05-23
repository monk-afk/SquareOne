<img src="./images/squareone_logo_v2_notext_256px.png" alt="SquareOne pixel text." width="64"/><img src="./images/squareone_text_256px.png" alt="SquareOne pixel text." width="160"/><img src="./images/squareone_logo_v1_notext_64px.png" alt="SquareOne pixel text." width="64"/>
<hr>

Update Tracker
---

Updates to mods which are planned or in-progress. Not comprehensive.

___

> NOT UPLOADED, NOT READY
- [ ] 3d_armor/armor_pinkdiamond_augmented -- textures
- [ ] money/ -- add safety deposit box
- [ ] ...

___

> IN PROGRESS
- [X] Integrate exp2 into current modset (bones, money, etc)
  - [X] exp2 - localize functions which use exp2, if possible
  - [X] bones - remove minumum cost to use bones, bones is free but death is costly

___

> NOT UPLOADED, NEEDS TESTING

- [ ] homedecor_modpack/homedecor_common/inventory.lua -- increase debug verbosity
- [ ] ...

___

> TO BE UPLOADED
``` diff
+++ anvil -- clean up code
+++ basic_materials -- fix bad group types
+++ exp2 -- fix error division, add variable gains
+++ filterplus -- clean code
+++ homedecor_modpack/homedecor_lighting -- fix broken recipes
+++ mobs_monster -- lowered dig time
+++ money -- minimum requirement for drops, no afk farming
+++ motd -- rewritten
+++ online_players -- prep code future change
+++ protector -- correct grouping
+++ teleport_potion -- fatal error from throwing tp potion and logout
+++ squareone_items -- fix notice cmd, remove invalid block detection
+++ stamina -- tweak exhaustion values
+++ teleport-request -- add bank to tpp places
+++ bones -- the cost is no longer optional, but the command is free
```
___
> UPLOADED, PENDING REBOOT

___

> DONE, ADDED TO SERVER

```diff
+++ squareone_items -- add staff command functional reporting
+++ homedecor_modpack/homedecor_office/init.lua -- fix invalid inventory size on desk
+++ exp update change gain method
+++ filterplus -- minor code improvements to filter load order
+++ squareone_ores -- add drop items, see: issue #11
+++ invisibility/init.lua -- increase time from 30 to 300 seconds
+++ irrigation -- cleaned up code, fix reservoir and add recipe
+++ squareone_guide -- update to guide text
+++ shopsign -- bugfix and texturing
+++ exp -- removed garbage noclip detection
+++ squareone_items -- silence reporting
+++ building_blocks_marble.png -- more visible texture detail
```