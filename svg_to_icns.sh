#!/bin/bash
set -eu

# Convert svg image to Mac OS X icns (icons) format.
# We use inkscape to convert svg to various sizes,
# then we use png2icns (http://icns.sourceforge.net/)
# to convert a set of png images to final icns.
#
# $1 is input svg file name, $2 is output icns file name.

INPUT_FILE_NAME="$1"
OUTPUT_FILE_NAME="$2"
shift 2

do_size ()
{
  inkscape --export-width="$1" --export-height="$1" "$INPUT_FILE_NAME" \
    --export-png=svg_to_icns-temp-"$1".png
}

do_size 16
do_size 32
do_size 48
do_size 128
do_size 256
do_size 512

png2icns "$OUTPUT_FILE_NAME" \
  svg_to_icns-temp-16.png \
  svg_to_icns-temp-32.png \
  svg_to_icns-temp-48.png \
  svg_to_icns-temp-128.png \
  svg_to_icns-temp-256.png \
  svg_to_icns-temp-512.png

rm -f \
  svg_to_icns-temp-16.png \
  svg_to_icns-temp-32.png \
  svg_to_icns-temp-48.png \
  svg_to_icns-temp-128.png \
  svg_to_icns-temp-256.png \
  svg_to_icns-temp-512.png
