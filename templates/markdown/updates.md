# Recent Updates

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

- ***A new regulation implemented in relation to the abandoned protector mechanic.***

::: {.notices .red}
8.1 Do not hoard abandoned builds: Players should only use protectors to protect areas they actively use and contribute to.
:::

- Protecting abandoned areas is permitted under certain conditions:
    - they are keeping the area for personal use
    - they are demolishing the build and will remove the protectors when finished
    - they are currently looting the area and don't intend to return

- For the last two cases, long-term protection is not permitted.

- This also includes squatting an area to resell the property.

- If there are disputes over abandoned builds, or if multiple players chaotically protect an abandoned area into a state where it cannot be built upon, we will dismantle the area.

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

