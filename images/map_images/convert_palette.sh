#!/bin/bash
# - > GIMP script-fu for indexing color of map images, because it takes too long to use optipng
#   - Indexes with max of 128 color pallet
#   - make temporary folder with images for conversion
#   - copy this file script into same temporary folder
#   - run it, images will be moved to the parent folder
PALLET=128

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
        gimpy $arg &> /dev/null
        mv "${arg}_indexed.png" "../${arg}"
        
    done
}
imgparser `ls *.png`

echo "Done"

exit 0