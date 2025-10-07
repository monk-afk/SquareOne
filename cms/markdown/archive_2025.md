# Archived Updates /archive/

- [Archive Index](/pages/archive/index.html)

# {#july-21-2025}

### July 21 | Mandated Taxes and Chat Filter Update {.header-separator}

"Profit Sharing" has been an optional feature of shops for the last 9 months. It will now be mandated for all shops, and any shop selling items for cash will automatically contribute 10%% of their cash sales towards the half-hourly money drops.

What to expect:

  - If you have a shop selling items for cash, you will receive 90%% of the cash sale
    - Example: if you sell gold for $10, each sale gives you $9
  - The server 30 minute money drops will give more than $10 more frequently
  - Everyone will complain about it, but in the long run they will have more money to spend

For more details about the shop taxes, [click here](/pages/economy.html)

And yes, another chat filter update. I don't have much to say about it. It should be better than the last one, but I always say that.

# {#june-24-2025}

### June 24 | Add Lantern Slabs and Improved Textures {.header-separator}

A few nodes were missing from the available slabs, have been added:

- Obsidian Frosted Glass
- Obsidian Lantern
- Cobble Brick
- Wooden Lightbox (white and yellow)

These textures were also updated:

- White Granite (also recipe gives 4 instead of 1)
- Birch wood
- Healing wood
- Willow wood

And finally, the coloredblocks mod. Completely re-written to make it easier to add new nodes, and create individual colored textures without relying on the engine modifiers to colorize a greyscale template.

This also comes with a new block: Colored Obsidian Frosted Glass! So pretty.

![Screenshot of Colored Blocks](/images/other/game_textures/Screenshot_2025-06-24_11-09-16.png)

# {#june-14-2025}

### June 14 | Armor Buffs {.header-separator}

Mythril has long been a rare and useless item. It's harder to find than diamonds, and has a market value of roughly $5 per lump. To offset this, the armor stat for mythril has been buffed, by increasing the block chance to around 5%%.

Additionally, the Pink Crystal boots have gained the ability to "walk" over single nodes. This will be noticed primarily by PC players, since some mobile apps have had this functionality for a while. Wearing the Pink Crystal boots will let players walk and step over single blocks without having to jump.

# {#may-27-2025}

### May 27 | Celebrating SquareOne Year Two! {.header-separator}

- ***New Posters***

In recognition of the server's second year anniversary, four new posters are available for purchase in the spawn willow shop (the potions shop). This year's themes are 'mosaic' and 'cascading text'.

![SquareOne Poster Anniversary 2025](/images/other/logos_icons/squareone_poster_anniversary_2025.png){width=64 height=64} ![SquareOne Poster Are One](/images/other/logos_icons/squareone_poster_are_one.png){width=64 height=64}

![SquareOne Poster Logo Mosaic 1](/images/other/logos_icons/squareone_poster_logo_mosaic_1.png){width=64 height=64} ![SquareOne Poster Logo Mosaic 2](/images/other/logos_icons/squareone_poster_logo_mosaic_2.png){width=64 height=64}

Limited Edition, Only 2025 of each will be distributed!

# {#may-13-2025}

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

# {#may-2-2025}

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

# {#april-28-2025}

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

# {#april-14-2025}

### April 14 2025 | Announcement {.header-separator}

(Ammended May 5 2025)

- ***A new regulation implemented in relation to the abandoned protector mechanic.***

::: {.notices .red}
Do not protect abandonned builds, unless you will live in it
:::

If there are disputes over abandoned builds, or if multiple players chaotically protect an abandoned area into a state where it cannot be built upon, we will demolish the area.

# {#april-8-2025}
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

# {#april-5-2025}

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

