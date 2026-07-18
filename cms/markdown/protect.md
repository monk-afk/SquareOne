# Protectors

### About Protector nodes

Players can protect their area from griefing with protector nodes, aka: pblocks or pbs.

A protector node covers an area of 15x15x15.

Tap on your own protector, or tap on the ground with a protector in hand to momentarily show the area's protected borders.

___

### Protector Placer Tool

![Protector Tool](/images/textures/tools/protector_tool.png){width=32 height=32}

To get perfect area coverage, use a placer tool to place a pblock without overlapping or leaving a gap.

::: {.notices .blue}
  You will need at least one protector in your inventory to use the placer!
:::

Stand next to an existing protecto., While holding the placer tool, aim at any of the six parallel directions (straight ahead, up, down, etc.). Then click or tap like you're using a sword, the protector from your inventory will shoot 15 blocks away in line with the one you're standing next to.

___

### PvP in protected area

When a player is within the borders of a protected area, they are only able to inflict PvP damage on another player *if they own* the protected area. Otherwise, PvP is not enabled for players who stand in protected areas not owned by themselves.

|   | inside pB zone? | is pB owner? | Can cause damage? | Can receive damage? | Will drop bones? |
|:-:|:---------------:|:------------:|:-----------------:|:-------------------:|:----------------:|
|   | No              | No           | Yes               | Yes                 | Yes              |
|   | Yes             | No           | No                | Yes - From pB owner | No               |
|   | Yes             | Yes          | Yes!              | No                  | No               |

___

### Chat command: /protect_view

There is now a command to change the protector: `/protector_view`, or for short: `/pb`. This command accepts three different options, and will change nearby protectors into that type:

  - `/pb block`
  - `/pb logo`
  - `/pb hide`

___
