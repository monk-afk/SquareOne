<img src="./images/squareone_logo_v2_notext_256px.png" alt="SquareOne pixel text." width="64"/><img src="./images/squareone_text_256px.png" alt="SquareOne pixel text." width="160"/><img src="./images/squareone_logo_v1_notext_64px.png" alt="SquareOne pixel text." width="64"/>
<hr>

Update Tracker
---

Updates to mods which are planned or in-progress. Not comprehensive, possibly not up to date. Refer also to bug tracker: https://github.com/monk-afk/SquareOne/issues

___

> Planned Development

- SquareOne Website
  - Set up SSL
  - website development

- Filter tags api: onjoin callbacks

- 3d_armor/armor_pinkdiamond_augmented -- textures + ability

- 3d_armor -- merging armors from separate mods into 3d_armor
  - modify falling feather so it is a craft item for etherium armor
  - add icons to inventory for other stat effects, gravity etc.

- make falling speed damage player

___

> PENDING REBOOT

```diff
++ Fix day and night stones recipies
```

___

> DONE

```diff
++ shopsigns are reverted back to original mod (aka smartshop)
++ all the money has been reset due to duplication glitch
++ Safe is now in-game but untested
```

```diff
++ bugfix shopsign
++ add itemshelfs back to game
```

```diff
++ re-add hopper functionality
++ re-add auto-crafting workbench
++ re-add shopsign functionality
```

```diff
++ updated mobs_api to fix evil bunny crashing server
++ fixed the server guide showing incorrect server age
++ fix missing texture for white granite
++ optimized table initialization for bob_ross command
++ fix diggable abandonned protector
++ update the infographic from the /invhelp command
-- temporarily disabled shopsigns until the duplication issue is confirmed or debunked
```

```diff
++ Increased logging for shopsign events
++ changed recipies for bags for easier crafting
```

```diff
++ restore faction name in player on-screen nametag, also new players names are random colors
++ Changed recipes for Obsidian tools to make them more affordable
++ Update Discord webhook script to send batch messages to stop hitting the rate-limit. It is now one single script, as opposed to three
++ Reduced item drops from ores and common nodes to sane amount
++ Balance armor ratings
-- Water is no longer Jell-o. Placing water will cause runoff. <restored to normal jello-water>
++ Staff of light creates "glowing stone" which extinguishes after 2 minutes
```

``` diff
++ anvil -- clean up code
++ basic_materials -- fix bad group types
++ exp2 -- fix error division, add variable gains
++ filterplus -- clean code
++ homedecor_modpack/homedecor_lighting -- fix broken recipes
++ mobs_monster -- lowered dig time
++ money -- minimum requirement for drops, no afk farming
++ motd -- rewritten
++ online_players -- prep code future change
++ protector -- correct grouping
++ teleport_potion -- fatal error from throwing tp potion and logout
++ squareone_items -- fix notice cmd, remove invalid block detection
++ stamina -- tweak exhaustion values
++ teleport-request -- add bank to tpp places
++ bones -- the cost is no longer optional, but the command is free
```

```diff
++ squareone_items -- add staff command functional reporting
++ homedecor_modpack/homedecor_office/init.lua -- fix invalid inventory size on desk
++ exp update change gain method
++ filterplus -- minor code improvements to filter load order
++ squareone_ores -- add drop items, see: issue #11
++ invisibility/init.lua -- increase time from 30 to 300 seconds
++ irrigation -- cleaned up code, fix reservoir and add recipe
++ squareone_guide -- update to guide text
++ shopsign -- bugfix and texturing
++ exp -- removed garbage noclip detection
++ squareone_items -- silence reporting
++ building_blocks_marble.png -- more visible texture detail
```