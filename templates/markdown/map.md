# Map Images
  - Each image is 4096x4096 pixels, each pixel represents one node.
  - Cardinal Directions are: z:(North), -z:(South), x:(East), -x:(West)
  - Areas of white haven't been generated yet

$hitmark

  - Lua script for generating the images using minetestmapper
      - [make\\_map_images.lua](/scripts/make_map_images.lua)

  - Bash script for converting the images to 128 color palette using GIMP
      - [convert_palette.sh](/scripts/convert_palette.sh)
