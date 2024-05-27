<img src="./images/squareone_logo_v2_notext_256px.png" alt="SquareOne pixel text." width="64"/> <img src="./images/squareone_text_256px.png" alt="SquareOne pixel text." width="160"/> <img src="./images/squareone_logo_v1_notext_64px.png" alt="SquareOne pixel text." width="64"/>
<hr>

The new exp system: *exp2*
===

#### Calculated Chaos

The previous exp system used a simple luck draw with a chance of 1 in 2000 to gain one exp with every block digged or placed by a player.

The new exp2 system is totally different, and does not rely on luck for exp gains.

Playing the game will earn exp points, basically anything besides being AFK or dying will earn you exp. 

New players with low overall stats will have stats with high fluctuation. Over time, your stats will fluctuate less, and earning exp will be slower.

Gaining exp is not linear, there is no way to know when or how much exp is needed for a level up. Pretty much every stat in the exp mod is unpredictable.

Exp doesn't last forever! Every 24 hours of being offline will cause a reduction of your exp stats. Worry not, it is not very much, and losing all exp will take a long time even for players with low stats.

___

### Metrics

There are four main stats which affect your game. The command to view your exp stats is `/exp`, or of another player is `/exp username`. The popup shows:

`Exp` Experience, is your exp. 

`Level` Is your level of exp.

`Luck` Variable which will be used to determine outcome from random events.

`Fortune` Used to determine the output of your luck.

The two stats which are not player-facing are top secret ;) *wink* Don't even worry about it.

___

### Dying sucks

Dying used to come with a choice of returning to bones at a cost of %10 exp, and players needed at least 1 exp to use `/bones`

The new system doesn't give the dying player a choice of losing exp, and now using `/bones` is free, and can be used anytime.

Only one death position is saved. If the player dies again and hasn't returned to bones position, the new death overwrites the old death.

Bones will drop anywhere, and if you are killed by another player inside their protected area, you cannot return to bones by command.

___

### I do feel lucky

Having a higher Luck or Fortune stat doesn't mean you'll have better results, and being lucky doesn't always mean being fortunate.

These two stats are best explained by example.

When a player dies, a draw between 0 and 1 is compared against their Luck. If the draw is lower than their Luck, exp is lost.

The average win over loss for this draw is about 36%.

Next is a Fortune check to get the amount of exp lost. In this case, having a high Fortune stat results in lower exp lost. 

Luck determines the 'if' an outcome will occur, and fortune guages 'how much' the outcome will produce.

- - -  > <sup>**I won the lottery!** <sub>*But I only won $5*...</sub></sup>

___

### Level Up!

The Level stat does absolutely nothing.

A player's level is the number in (brackets) shown in the chat.