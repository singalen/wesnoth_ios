#!/bin/bash
set -euo pipefail

# https://developer.apple.com/ios/human-interface-guidelines/graphics/app-icon/
#ICON_SIZES="1024 180 167 152 120 87 80 76 60 58 40"

OUT_ICONS=$(cat <<EOF
Icon-App-20x20@1x.png
Icon-App-20x20@2x.png
Icon-App-20x20@3x.png
Icon-App-29x29@1x.png
Icon-App-29x29@2x.png
Icon-App-29x29@3x.png
Icon-App-40x40@1x.png
Icon-App-40x40@2x.png
Icon-App-40x40@3x.png
Icon-App-57x57@1x.png
Icon-App-57x57@2x.png
Icon-App-60x60@1x.png
Icon-App-60x60@2x.png
Icon-App-60x60@3x.png
Icon-App-72x72@1x.png
Icon-App-72x72@2x.png
Icon-App-76x76@1x.png
Icon-App-76x76@2x.png
Icon-App-83.5x83.5@2x.png
Icon-Small-50x50@1x.png
Icon-Small-50x50@2x.png
EOF
)
#  Icon-512.png iTunesArtwork@1x.png
# Icon-1024.png iTunesArtwork@2x.png
# Icon-1024.png iTunesArtwork@2x.png

BG_COLOR='#101623'

make_icon() {
  ICON_NAME=$1
  ICON_SIZE=$2

  echo "Making ${ICON_NAME} of size ${ICON_SIZE}"
#  convert \
#	-background "${BG_COLOR}" \
#	-density 1200 \
#	-resize ${ICON_SIZE}x${ICON_SIZE} \
#	wesnoth-logo.svg \
#	${ICON_NAME}
  rsvg-convert \
	--background-color="${BG_COLOR}" \
	--width=${ICON_SIZE} --height=${ICON_SIZE} \
	-o ${ICON_NAME} \
	wesnoth-logo.svg
}

calc() { awk "BEGIN{print $*}"; }

for icon in ${OUT_ICONS}; do
  ICON_SIZE=$(echo "${icon}" | egrep -o 'x.+?@?x' | tr -d x| tr '@' '*')
  ICON_SIZE=$(calc "${ICON_SIZE}")
  make_icon ${icon} ${ICON_SIZE}
done

make_icon iTunesArtwork@1x.png 512
make_icon iTunesArtwork@2x.png 1024
make_icon iTunesArtwork@3x.png 1576
