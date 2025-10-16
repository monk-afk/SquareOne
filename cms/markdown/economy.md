# Economy

There are 6 denominations:

|     |      |     |      |
|----:|:----:|----:|:----:|
| **$1**   | ![SQ1 Note 1](/images/textures/money/money_note_1.png)     | **$5**   | ![SQ1 Note 5](/images/textures/money/money_note_5.png) |
| **$10**  | ![SQ1 Note 10](/images/textures/money/money_note_10.png)   | **$50**  | ![SQ1 Note 50](/images/textures/money/money_note_50.png) |
| **$100** | ![SQ1 Note 100](/images/textures/money/money_note_100.png) | **$500** | ![SQ1 Note 500](/images/textures/money/money_note_500.png) |

___

### Market

Most of the server's economy is driven by sales from Shop signs.

Players may choose to sell items for cash or trade with another item.

```/market``` view the real-time market-price averages.

Every cash sale contributes to the moving average.

___

### Money Drops

Every 30 minutes, players receive a base amount of $10 deposited into their inventory wallet.

The inventory wallet can hold up to 99 notes.

___

### Profit Sharing Tax

Shop signs (aka. smartshop) contribute a 10%% tax towards the server half-hour money drops.

Only cash sales are taxed. Any bartering, or item-for-item sales are not taxed.

For the pending amount to be paid, there must be at least enough to give each online player at minimum an additional $10 on top of the regular $10 half-hour money drop.

Any surplus is also distributed up to a maximum of $90 + regular drop.

For example, if there are 10 players online, there must be at least $100 pending payout to give everyone $10 at the next money drop.

```/profit-share``` show the amount of collected taxes pending next payout.

Shop owners can expect to receive $9 for every $10 sale.

___

### Tax Brackets

Below is a table showing the amounts deducted from cash sales in their respective brackets. To elaborate; any item being sold between $1 and $3 will incur no deduction. Sales between $4 and $10 will contribute $1 from the sale to profit share.

|    |    |    |    |
|:--:|:--:|---:|---:|
| ![SQ1 Note 1](/images/textures/money/money_note_1.png) | Range From | Range To | Shared Profit |
|  | x  1 ($    1) | x  3 ($    3) | $   0 |
|  | x  4 ($    4) | x 10 ($   10) | $   1 |
|  | x 11 ($   11) | x 20 ($   20) | $   2 |
|  | x 21 ($   21) | x 30 ($   30) | $   3 |
|  | x 31 ($   31) | x 40 ($   40) | $   4 |
|  | x 41 ($   41) | x 50 ($   50) | $   5 |
|  | x 51 ($   51) | x 60 ($   60) | $   6 |
|  | x 61 ($   61) | x 70 ($   70) | $   7 |
|  | x 71 ($   71) | x 80 ($   80) | $   8 |
|  | x 81 ($   81) | x 90 ($   90) | $   9 |
|  | x 91 ($   91) | x 99 ($   99) | $  10 |
| ![SQ1 Note 5](/images/textures/money/money_note_5.png) | Range From | Range To | Shared Profit |
|  | x  1 ($    5) | x  2 ($   10) | $   1 |
|  | x  3 ($   15) | x  3 ($   15) | $   2 |
|  | x  4 ($   20) | x 10 ($   50) | $   5 |
|  | x 11 ($   55) | x 20 ($  100) | $  10 |
|  | x 21 ($  105) | x 30 ($  150) | $  15 |
|  | x 31 ($  155) | x 40 ($  200) | $  20 |
|  | x 41 ($  205) | x 50 ($  250) | $  25 |
|  | x 51 ($  255) | x 60 ($  300) | $  30 |
|  | x 61 ($  305) | x 70 ($  350) | $  35 |
|  | x 71 ($  355) | x 80 ($  400) | $  40 |
|  | x 81 ($  405) | x 90 ($  450) | $  45 |
|  | x 91 ($  455) | x 99 ($  495) | $  50 |
| ![SQ1 Note 10](/images/textures/money/money_note_10.png) | Range From | Range To | Shared Profit |
|  | x  1 ($   10) | x  1 ($   10) | $   1 |
|  | x  2 ($   20) | x  2 ($   20) | $   2 |
|  | x  3 ($   30) | x  3 ($   30) | $   3 |
|  | x  4 ($   40) | x 10 ($  100) | $  10 |
|  | x 11 ($  110) | x 20 ($  200) | $  20 |
|  | x 21 ($  210) | x 30 ($  300) | $  30 |
|  | x 31 ($  310) | x 40 ($  400) | $  40 |
|  | x 41 ($  410) | x 50 ($  500) | $  50 |
|  | x 51 ($  510) | x 60 ($  600) | $  60 |
|  | x 61 ($  610) | x 70 ($  700) | $  70 |
|  | x 71 ($  710) | x 80 ($  800) | $  80 |
|  | x 81 ($  810) | x 90 ($  900) | $  90 |
|  | x 91 ($  910) | x 99 ($  990) | $ 100 |
| ![SQ1 Note 50](/images/textures/money/money_note_50.png) | Range From | Range To | Shared Profit |
|  | x  1 ($   50) | x  2 ($  100) | $  10 |
|  | x  3 ($  150) | x  3 ($  150) | $  20 |
|  | x  4 ($  200) | x 10 ($  500) | $  50 |
|  | x 11 ($  550) | x 20 ($ 1000) | $ 100 |
|  | x 21 ($ 1050) | x 30 ($ 1500) | $ 150 |
|  | x 31 ($ 1550) | x 40 ($ 2000) | $ 200 |
|  | x 41 ($ 2050) | x 50 ($ 2500) | $ 250 |
|  | x 51 ($ 2550) | x 60 ($ 3000) | $ 300 |
|  | x 61 ($ 3050) | x 70 ($ 3500) | $ 350 |
|  | x 71 ($ 3550) | x 80 ($ 4000) | $ 400 |
|  | x 81 ($ 4050) | x 90 ($ 4500) | $ 450 |
|  | x 91 ($ 4550) | x 99 ($ 4950) | $ 500 |
| ![SQ1 Note 100](/images/textures/money/money_note_100.png) | Range From | Range To | Shared Profit |
|  | x  1 ($  100) | x  1 ($  100) | $  10 |
|  | x  2 ($  200) | x  2 ($  200) | $  20 |
|  | x  3 ($  300) | x  3 ($  300) | $  30 |
|  | x  4 ($  400) | x 10 ($ 1000) | $ 100 |
|  | x 11 ($ 1100) | x 20 ($ 2000) | $ 200 |
|  | x 21 ($ 2100) | x 30 ($ 3000) | $ 300 |
|  | x 31 ($ 3100) | x 40 ($ 4000) | $ 400 |
|  | x 41 ($ 4100) | x 50 ($ 5000) | $ 500 |
|  | x 51 ($ 5100) | x 60 ($ 6000) | $ 600 |
|  | x 61 ($ 6100) | x 70 ($ 7000) | $ 700 |
|  | x 71 ($ 7100) | x 80 ($ 8000) | $ 800 |
|  | x 81 ($ 8100) | x 90 ($ 9000) | $ 900 |
|  | x 91 ($ 9100) | x 99 ($ 9900) | $1000 |
| ![SQ1 Note 500](/images/textures/money/money_note_500.png) | Range From | Range To | Shared Profit |
|  | x  1 ($  500) | x  2 ($ 1000) | $ 100 |
|  | x  3 ($ 1500) | x  3 ($ 1500) | $ 200 |
|  | x  4 ($ 2000) | x 10 ($ 5000) | $ 500 |
|  | x 11 ($ 5500) | x 20 ($10000) | $1000 |
|  | x 21 ($10500) | x 30 ($15000) | $1500 |
|  | x 31 ($15500) | x 40 ($20000) | $2000 |
|  | x 41 ($20500) | x 50 ($25000) | $2500 |
|  | x 51 ($25500) | x 60 ($30000) | $3000 |
|  | x 61 ($30500) | x 70 ($35000) | $3500 |
|  | x 71 ($35500) | x 80 ($40000) | $4000 |
|  | x 81 ($40500) | x 90 ($45000) | $4500 |
|  | x 91 ($45500) | x 99 ($49500) | $5000 |
