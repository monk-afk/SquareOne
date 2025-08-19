# EXP

## Gains and Losses

Playing the game will earn EXP stats. Just play, and you'll gain in stats.

As you continue to play, your stats curve will dampen and steadily increase/decrease.

Dying won't reduce your EXP, but using /bones has a chance of costing EXP.

Being offline for 5 days will cause a reduction of approximately 20%% every day.

___

## Metrics and Stats

Experience is measured by your overall activity over a period of time.

To calculate this, we use two metric points:

- `Online Time`: Measured in seconds from the time you join until you leave.
- `Stamina Exhaust`: Your activity: building, digging, fighting, crafting, running.

From these we measure your `Exp` and `level`, `Luck` and `Fortune`.

View the Leaderboard, and your stats or another player, with game command: `/exp player_name`

___

## Exp and Levels

Your **level** is shown as part of your public chat nametag flair in round brackets.

___

## Luck and Fortune

Luck is a **determinator**: whether something *will or will not* happen.

Fortune is a **Multipliers**: how much of a reward or punishment to receive.

::: {.notices .yellow}
Luck and Fortune are always changing, especially for new players.
:::

They typically work together to give a sense of fateful outcome.

___

## The Odds {#odds}

A player's luck will always drift between 0.5 and 1.0.

When luck is to be tested, like when using `/bones`, a random decimal between 0.0 and 1.0 is compared against the player's luck.

Having a high or low luck stat doesn't mean having good or bad luck.

Whether 'good' luck means having a stat higher or lower than the random is determined by the mod calling for a luck throw.

[![Thumbnail Snapshot of Luck and Fortune at Levels 20 to 25](/images/other/published/thumbnails/exp_simulation-lvl_20-25.jpg)](#img)

[![Full Snapshot of Luck and Fortune at Levels 20 to 25](/images/other/published/full/exp_simulation-lvl_20-25.png)](#odds){#img .lightbox}

^Snapshot of Luck (blue) and Fortune (magenta) from at Levels 20 to 25^

If a mod function asks for a win to be determined with `random() > luck`, the win probability is around 20%%.

Conversely, if the win condition is `luck > random()` the win probability is closer to 80%%.

___

## Bones

Dying players drop their items into a bones block.

There is no loss of EXP from dying.

There is a minimum of 50 EXP to use the command.

You can use command `/bones` to return to bones, but it *may* cost some EXP points.

The luck throw is this, random() is between 0.0 and 1.0:

  > if `luck > random()`: free bones!

  > if `lua < random()`: not free! rip exp.

Exp is reduced by applying the formula `(metric * luck) / (fortune * math.pi)` to both metric points, your Stamina Exhaust, and Online Seconds, then recalculate the exp from the new metric values.

If you die in someone else's protected area no bones are dropped, and are therefore unable to use `/bones`.

___

## Drop Bonus

For node drops, you dig something from the list below, a luck throw is made.

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

The throw is: `if luck < random()`: you win a fortune multiplier!

The multiplier is used with Fortune rounded up: `digged_item x random(1, Fortune)`

In other words, if your fortune is 3.45 and you dig a diamond, you could get between 1 and 4 diamonds!

___

## Mob Drops

Similar to node drops, killing mobs has a chance multiplier.

Luck throw is successful if: `luck > rand`: successful luck

The multiplier is the same as digging, except Fortune is *added on to the mob drops*.

Meaning, if a killing a mob drops two diamonds, and your multiplier adds 2, you get 4 diamonds!

___

# Money

The less fortunate don't get money drops every 30 minutes.

The minimum amount of fortune to receive money drops is `0.5`

