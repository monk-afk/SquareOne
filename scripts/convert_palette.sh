#!/bin/bash
# - > GIMP script-fu for indexing color of map images, because it takes too long to use optipng
#   - indexes with max of 128 color pallet
#   - make temporary folder with images for conversion
#   - copy this file script into same temporary folder
#   - run it, images will be moved to the parent folder
PALLET=128
THUMB_WIDTH=200
THUMB_HEIGHT=200
mkdir -p "../GIMP_converted"
mkdir -p "../GIMP_thumbnails"

gimpy () {
  gimp -i -b "(let* (
    (img (car (gimp-file-load RUN-NONINTERACTIVE \"$1\" \"$1\"))))
    (gimp-image-convert-indexed img 0 0 $PALLET FALSE TRUE \"\")
    (gimp-file-save RUN-NONINTERACTIVE img (
      car (gimp-image-get-active-layer img)) \"$1\_indexed.png\" \"$1\_indexed.png\") 
      (gimp-image-delete img))" -b "(gimp-quit 0)"
}

imgparser () {
  for arg in "$@"; do
    echo "Converting <$arg>"
    gimpy "$arg" &> /dev/null
    mv "${arg}_indexed.png" "../GIMP_converted/${arg}"
    convert "$arg" -resize ${THUMB_WIDTH}x${THUMB_HEIGHT}^ -gravity center -extent ${THUMB_WIDTH}x${THUMB_HEIGHT} "../GIMP_thumbnails/${arg%.png}.jpg"
  done
}

imgparser *.png

echo "Done"

exit 0