<img src="../logos_icons/squareone_logo_v2_notext_256px.png" alt="SquareOne pixel text." width="64"/> <img src="../logos_icons/squareone_text_256px.png" alt="SquareOne pixel text." width="160"/> <img src="../logos_icons/squareone_logo_v1_notext_64px.png" alt="SquareOne pixel text." width="64"/>

___

# Map Images
  - Each image is 4096x4096 pixels, each pixel represents one node.
  - Cardinal Directions are: z:(North), -z:(South), x:(East), -x:(West)
  - Areas of white haven't been generated yet

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

Lua script for generating the images using minetestmapper
  - [make_map_images.lua](make_map_images.lua)
Bash script for converting the images to 128 color palette using GIMP
- [convert_palette.sh](convert_palette.sh)

___

<sub>[Home](README.md)</sub>

___