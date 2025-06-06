# Recent Updates

### May 27 | Celebrating SquareOne Year Two! {.header-separator}

- ***New Posters***

In recognition of the server's second year anniversary, four new posters are available for purchase in the spawn willow shop (the potions shop). This year's themes are 'mosaic' and 'cascading text'.

![SquareOne Poster Anniversary 2025](/images/other/logos_icons/squareone_poster_anniversary_2025.png){width=64 height=64} ![SquareOne Poster Are One](/images/other/logos_icons/squareone_poster_are_one.png){width=64 height=64}

![SquareOne Poster Logo Mosaic 1](/images/other/logos_icons/squareone_poster_logo_mosaic_1.png){width=64 height=64} ![SquareOne Poster Logo Mosaic 2](/images/other/logos_icons/squareone_poster_logo_mosaic_2.png){width=64 height=64}

Limited Edition, Only 2025 of each will be distributed!

### May 13 | Chat and Filter Update {.header-separator}

- ***Useless chat filter***

The old one sucked, this one sucks a little less. You still can't use caps, but you can say '100000000' without it turning into '100'. Thie updated version was completely re-written, which means there could be some bugs.

- ***Proximity Chat***

A new command for players, `/xm` is another way to group chat. This one will only send to players within 100 nodes, and will show as cyan-colored text with.

- ***Toggle Chat***

Ignore everyone while staying available with `/chat`. This command will silence the public channel, while allowing private and faction and proximity chat.

- ***Useless EXP***

Not anymore! Your Level stat will now show as your nametag flair.

- ***Simplified /block***

Just use `/block player_name` to pretend like player_name doesn't even exist. Do it yourself before staff does it for you.

To see who you've blocked, just type `/block`. Staff can also now see your block list with the same command.

- ***Outgoing Private Messages***

Private messages will show as blue when you send it, and green when you receive. The notification of being unable to send due to 'active block-list' has also been removed. Now, you'll never know why player_name doesn't answer you.


### May 2 | EXP and Bones Update {.header-separator}

- ***Balanced gains/losses***

Adjusted the formula used to calculate your EXP and Levels. This should better reflect established players Level, while also giving noobs a lot of chances to die without suffering too many losses.

- ***Dying is more risky***

Using `/bones` now has a minimum of 100 exp. This sounds like a lot, but it isn't anymore.

When you use `/bones`, there is still a chance of not losing EXP based on your Luck.

Your Luck decides if you pay, and Fortune determines the amount of EXP lost. Check the [EXP Page](/pages/exp.html) for full details.

- ***Dropping bones in someone else's protected area***

If you die in someone else's protected area (in other words, not your own protected area, or not in a unprotected), don't worry about your bones because you won't drop them. You also won't be able to use `/bones` to return to your death position, so tread carefully in a stranger's property.

- ***Spawn: 3***

The Bank is now open. The Library is now Open. The Potions Shop (Willow Tree Shop) is now Open. The Clothing Store is now Open. The Post Office is finally open.

To apply for a mailbox in the Post Office: *Read and follow the instructions in the book at front entrance*!

![Spawn Image](/images/squareone_spawn.png)

There's probably more but I'm done with typing.

### April 28 2025 | Mods Update {.header-separator}

- ***Abandoned Protector Patch***

Nodes which are now affected by the abandoned protector mechanic:

- Mailbox (Red Cube)
- Inbox (White Round)
- Shopsign

The items in an abandoned shop can only be removed from the shop. Items cannot be moved within the shop, neither can items be moved into the shop.

Patched a bug caused by placing protector blocks on an abandoned protector too quickly; [see issue #46](https://github.com/monk-afk/SquareOne/issues/46).

- ***Clearobjects caused the removal of some animals***

Unfortunately, the command was not able to clear the objects from the entire world; some animals were removed while others were not.

- ***Old spawn demolished!***

The spawn build was an impressive structure. I loved telling people that it was built using mathematics and explain how spawn was a [Menger Cube twisted by a Fibonacci Spiral](/scripts/spawn_build.lua)

However, building inside the spawn building was becoming increasingly frustrating. There was no place to build, despite being 6 stories high; and it was oddly shaped, having almost no symmetry.

Now, I have room to build stuff.

### April 14 2025 | Announcement {.header-separator}

(Ammended May 5 2025)

- ***A new regulation implemented in relation to the abandoned protector mechanic.***

::: {.notices .red}
Do not protect abandonned builds, unless you will live in it
:::

If there are disputes over abandoned builds, or if multiple players chaotically protect an abandoned area into a state where it cannot be built upon, we will demolish the area.

### April 8 2025 | Mods Update {.header-separator}

- ***Abandonned Protectors has been re-enabled***
    - Still gotta wait 9 months for a protector to become abandonned.
    - If you place your own pblock where it would overlap the abandoned pblock, the ownership of the abandoned pblock is automatically changed to your name.
    - To discourage vulture-like behaviour, the /when or /last-login command has been limited to show the player's login within the last 30 days, or simply "more than 30 days".
    - Additionally, the 'Last Seen' display when standing in a protected area will not show the player's last login. Only *after* the protector is abandoned will it show the last login.

- ***Bones Protecting***
    - Due to the amount of protecting bones happening, pblocks are no longer able to be placed where there are fresh bones.

- ***Faction-Shared Protectors***
    - Has been reinstated.
    - Click the checkbox to share your area.
    - PVP will be enabled for faction members of the shared protector
    - The owner is not immune to damage when attacked from a faction member inside a faction shared protector area.

- ***Farming Limitation***
    - Players will no longer be able to place seeds within 700 blocks from Spawn.
        - Previously, it was possible to place seed, but nothing would grow.
    - Hopefully that fixes the issue of crystal grass not growing anywhere

### April 5 2025 | Mods Update {.header-separator}

- ***Obsidian Block*** (crafted from obs. ingots)
    - renamed to `Obsidian Ingot Block` and has a new texture to make it easier to distinguish from `Obsidian Block`

- ***Profit Sharing***
    - Some shops located near public areas are being added to the profit share list
        - Spawn, 10k-East, 18k-East, and Public Mines 1 and 2.
    - If your shop is added to the list, be prepared to have 10%% of cash sales contribute to the server money drops.

- ***New Mod***
    - `Lumber` Adds several wood-derived blocks: `Panel`, `Panel Link`, `Cross Planks`, `Braced Panel`, `Tile`
    - Several Tree-related textures, including wood/plank blocks, are updated.

