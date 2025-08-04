# EXP

## Gains and Losses

Playing the game will earn EXP stats. Just play, and you'll gain in stats.

Being AFK will cause your EXP to drain.

New players EXP stats will, sometimes rise to high levels in a short time.

As you continue to play, your stats will fluctuate less and steadily increase/decrease.

Being offline for 5 days will cause a reduction of approximately 20%% every day.

___

## Stat Definitions

The idea behind the way exp is calculated is simple: Experience is measured by your overall activity over a period of time.

The command to view your exp stats is `/exp`, or of another player `/exp username`. This will show your stats:

`OT`: Every second counts. Being online in-game will increase your online time (OT)

`AP`: Action points. Doing stuff, even running in circles will increase this stat.

`Exp`: Experience gained by doing things in-game.

`Level`: Bragging rights, shown as nametag flair in public chat.

`Luck`: Chance of outcome. This number is variable, and used to determine outcome from random events (either good or bad). In other words, "whether you win or lose".

`Fortune` Outcome multiplier. Fortune is complimentary to luck, and decides "how much you win or lose".

___

## Levels

Your level is shown as part of your public chat nametag flair in round brackets.

___

## Luck and Fortune

Luck and Fortune can be used as Multipliers or Determinators for certain events.

Luck is always changing, and will never go above 1. Typically used to determine if something will happen.

Fortune will normally increase, and sometimes decrease.

___

## Bones

Dying will cause your player to drop items into a bones block.

There is no loss of EXP from dying, however using the command to return to bones *may* cost some EXP points.

To test your luck and return to bones, use `/bones` after dying.

The luck throw is this: `if (random decimal between 0.0 and 1.0) < (your current luck) then you lose exp`

If you're lucky, returning to bones will not lower your exp stats.

If not, your AP and OT stats will each be reduced using the formula: `((stat * luck) / (fortune + 3))`

Regardless of how much EXP it would cost, there is a minimum of 10 EXP to use the command.

If you die in someone else's protected area no bones are dropped, and are therefore unable to use `/bones`.

___

## Drop Bonus

For node drops, if a listed item is to be dropped into your inventory, a luck throw will be made.

The throw is: if your luck is lower than a random decimal between 0.0 and 1.0

Next you'll roll for a multiplier using your fortune stat.

The roll is simply a random number between 1 and your fortunre stat rounded up to the next integer.

The list of items which qualify for a luck/multiplier throw is:

|                |
|:--------------:|
| bone           |
| coal_lump      |
| copper_lump    |
| diamond        |
| gold_lump      |
| iron_lump      |
| mese_crystal   |
| obsidian_shard |
| ender_pearl    |
| etherium_dust  |
| mithril_lump   |
| pinkdiamond    |
| silver_lump    |
| quartz_crystal |

___

## Mob Drops

Mobs drop items, and your luck/fortune will amplify those drops.

Luck throw is successful if your luck stat is lower than a random decimal between 0.0 and 1.0

If successful, the multiplier roll from the random number between zero and your fortune stat rounded up to the next integer is added to the mob drop

In other words, if a mob drops a diamond, and your fortune rolls a 2, you'll receive 3 diamonds.

