#!/usr/bin/env bash
set -euo pipefail

# Usage: place original files in images/ named pa-large-1.jpg and pa-large-2.jpg
# then run: ./scripts/optimize-images.sh

IMAGES_DIR="images"
SIZES=(800 1600)
QUALITY_JPG=85
QUALITY_WEBP=80

command -v magick >/dev/null 2>&1 || { echo "ImageMagick (magick) not found. Install it and retry."; exit 1; }
command -v cwebp >/dev/null 2>&1 || { echo "cwebp not found. Install libwebp and retry."; exit 1; }

FILES=("pa-large-1.jpg" "pa-large-2.jpg")

mkdir -p "$IMAGES_DIR"

for f in "${FILES[@]}"; do
  src="$IMAGES_DIR/$f"
  [ -f "$src" ] || { echo "Source not found: $src — überspringe"; continue; }
  base="${f%.*}"
  for s in "${SIZES[@]}"; do
    out_jpg="$IMAGES_DIR/${base}-${s}.jpg"
    out_webp="$IMAGES_DIR/${base}-${s}.webp"
    echo "Erzeuge $out_jpg (Breite $s)"
    magick "$src" -resize ${s}x -quality $QUALITY_JPG "$out_jpg"
    echo "Erzeuge $out_webp"
    cwebp -q $QUALITY_WEBP "$out_jpg" -o "$out_webp" >/dev/null 2>&1 || echo "cwebp fehlgeschlagen für $out_jpg"
  done
  echo "Fertig für $src"
done

echo "Alle verfügbaren Bilder wurden verarbeitet. Bitte prüfe images/ für -800/-1600 Varianten und .webp-Ausgaben."
