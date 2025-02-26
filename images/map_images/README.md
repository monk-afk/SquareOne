<img src="../logos_icons/squareone_logo_v2_notext_256px.png" alt="SquareOne pixel text." width="64"/> <img src="../logos_icons/squareone_text_256px.png" alt="SquareOne pixel text." width="160"/> <img src="../logos_icons/squareone_logo_v1_notext_64px.png" alt="SquareOne pixel text." width="64"/>

<hr>

# Map Images
- [View on Fandom](https://squareone.fandom.com/wiki/Special:AllMaps)
  - Each image is 4096x4096 pixels, each pixel represents one node.
  - Coordinates Cardinal Directions are: z(North), z-(South), x(East), x-(West)


|               | **Z+12288**                             | **Z+8192**                              | **Z+4096**                              | **Z 0**                                | **Z-4096**                              | **Z-8192**                              | **Z-12288**                             |
|-------------|--------------------------------------|--------------------------------------|--------------------------------------|--------------------------------------|--------------------------------------|--------------------------------------|--------------------------------------|
| **X-12288** | [x-12288, z12288](squareone_x-12288_z12288.png) | [x-12288, z8192](squareone_x-12288_z8192.png) | [x-12288, z4096](squareone_x-12288_z4096.png) | [x-12288, z0](squareone_x-12288_z0.png) | [x-12288, z-4096](squareone_x-12288_z-4096.png) | [x-12288, z-8192](squareone_x-12288_z-8192.png) | [x-12288, z-12288](squareone_x-12288_z-12288.png) |
| **X-8192**  | [x-8192, z12288](squareone_x-8192_z12288.png)  | [x-8192, z8192](squareone_x-8192_z8192.png)  | [x-8192, z4096](squareone_x-8192_z4096.png)  | [x-8192, z0](squareone_x-8192_z0.png)  | [x-8192, z-4096](squareone_x-8192_z-4096.png)  | [x-8192, z-8192](squareone_x-8192_z-8192.png)  | [x-8192, z-12288](squareone_x-8192_z-12288.png)  |
| **X-4096**  | [x-4096, z12288](squareone_x-4096_z12288.png)  | [x-4096, z8192](squareone_x-4096_z8192.png)  | [x-4096, z4096](squareone_x-4096_z4096.png)  | [x-4096, z0](squareone_x-4096_z0.png)  | [x-4096, z-4096](squareone_x-4096_z-4096.png)  | [x-4096, z-8192](squareone_x-4096_z-8192.png)  | [x-4096, z-12288](squareone_x-4096_z-12288.png)  |
| **X 0**     | [x0, z12288](squareone_x0_z12288.png)     | [x0, z8192](squareone_x0_z8192.png)     | [x0, z4096](squareone_x0_z4096.png)     | [x0, z0](squareone_x0_z0.png)     | [x0, z-4096](squareone_x0_z-4096.png)     | [x0, z-8192](squareone_x0_z-8192.png)     | [x0, z-12288](squareone_x0_z-12288.png)     |
| **X 4096**  | [x4096, z12288](squareone_x4096_z12288.png)  | [x4096, z8192](squareone_x4096_z8192.png)  | [x4096, z4096](squareone_x4096_z4096.png)  | [x4096, z0](squareone_x4096_z0.png)  | [x4096, z-4096](squareone_x4096_z-4096.png)  | [x4096, z-8192](squareone_x4096_z-8192.png)  | [x4096, z-12288](squareone_x4096_z-12288.png)  |
| **X 8192**  | [x8192, z12288](squareone_x8192_z12288.png)  | [x8192, z8192](squareone_x8192_z8192.png)  | [x8192, z4096](squareone_x8192_z4096.png)  | [x8192, z0](squareone_x8192_z0.png)  | [x8192, z-4096](squareone_x8192_z-4096.png)  | [x8192, z-8192](squareone_x8192_z-8192.png)  | [x8192, z-12288](squareone_x8192_z-12288.png)  |
| **X 12288** | [x12288, z12288](squareone_x12288_z12288.png) | [x12288, z8192](squareone_x12288_z8192.png) | [x12288, z4096](squareone_x12288_z4096.png) | [x12288, z0](squareone_x12288_z0.png) | [x12288, z-4096](squareone_x12288_z-4096.png) | [x12288, z-8192](squareone_x12288_z-8192.png) | [x12288, z-12288](squareone_x12288_z-12288.png) |

___
___

- > GIMP script-fu for indexing color of map images, because it takes too long to use optipng
  - Indexes with max of 128 color pallet
  - cd into path of image files to be indexed, then run.
  - images will be copied and prefixed with `-indexed.png`

```sh
find * -maxdepth 0 -type f -name "*.png" -exec sh -c 'gimp -i -b "(let* ((img (car (gimp-file-load RUN-NONINTERACTIVE \"{}\" \"{}\")))) (gimp-image-convert-indexed img 0 0 128 FALSE TRUE \"\") (gimp-file-save RUN-NONINTERACTIVE img (car (gimp-image-get-active-layer img)) \"{}_indexed.png\" \"{}_indexed.png\") (gimp-image-delete img))" -b "(gimp-quit 0)"' \;
```

- [make_map_images.lua](make_map_images.lua)

___

<sub>[Home](README.md)</sub>

___