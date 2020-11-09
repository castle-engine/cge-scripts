#!/bin/bash
set -eu

# Utilities for creating xxx.app directory, which is a macOS "bundle"
# (magic directory that behaves like a clickable application under macOS).
# Include ("source") this script to have some useful functions,
# first of all the create_bundle function.

# ----------------------------------------------------------------------------

# Internal in this script.
# Helper function for convert_to_icns.
convert_to_icns_one_size ()
{
  local INPUT_FILE_NAME="$1"
  local SIZE="$2"
  shift 2

  local INPUT_EXTENSION=".${INPUT_FILE_NAME##*.}"
  if [ "${INPUT_EXTENSION}" = '.svg' ]; then
    inkscape \
      --export-width="${SIZE}" \
      --export-height="${SIZE}" \
      "${INPUT_FILE_NAME}" \
      --export-png=convert_to_icns-temp-"${SIZE}".png
  else
    convert "${INPUT_FILE_NAME}" -geometry "${SIZE}x${SIZE}!" \
      convert_to_icns-temp-"${SIZE}".png
  fi
}

# Internal in this script.
# Convert svg, png or other image format (known to ImageMagick)
# to Mac OS X icns (icons) format.
#
# We use inkscape to convert svg to various sizes,
# or ImageMagick "convert" to resize to various sizes,
# then we use png2icns (http://icns.sourceforge.net/)
# to convert a set of png images to final icns.
#
# $1 is input image file name, $2 is output icns file name.
convert_to_icns ()
{
  local INPUT_FILE_NAME="$1"
  local OUTPUT_FILE_NAME="$2"
  shift 2

  convert_to_icns_one_size "${INPUT_FILE_NAME}" 16
  convert_to_icns_one_size "${INPUT_FILE_NAME}" 32
  convert_to_icns_one_size "${INPUT_FILE_NAME}" 48
  convert_to_icns_one_size "${INPUT_FILE_NAME}" 128
  convert_to_icns_one_size "${INPUT_FILE_NAME}" 256
  convert_to_icns_one_size "${INPUT_FILE_NAME}" 512

  png2icns "$OUTPUT_FILE_NAME" \
    convert_to_icns-temp-16.png \
    convert_to_icns-temp-32.png \
    convert_to_icns-temp-48.png \
    convert_to_icns-temp-128.png \
    convert_to_icns-temp-256.png \
    convert_to_icns-temp-512.png

  rm -f \
    convert_to_icns-temp-16.png \
    convert_to_icns-temp-32.png \
    convert_to_icns-temp-48.png \
    convert_to_icns-temp-128.png \
    convert_to_icns-temp-256.png \
    convert_to_icns-temp-512.png
}

# Create a Mac OS X bundle.
# This is based on createbundle.sh script from Lazarus examples/trayicon/,
# improved and generalized by Kambi.
#
# $1 is the nice application name. Used as a folder basename.
# This is traditionally in CamelCase.
# This determines the look of the final bundle file,
# and may be completely unrelated to the executable name,
# or application name specified in CastleEngineManifest.xml .
#
# $2 is the binary (executable) filename, relative to the current dir.
# This file must actually exist, we will copy it into the bundle,
# we will also run it (with --version) to get the version number.
#
# $3 is the icon filename, relative to the current dir.
# If it's not already in macOS .icns format,
# it will be internally converted into it, using various tools
# like png2icns, ImageMagick, inkscape (in case input is svg).
#
# $4 are handled document types, encoded in XML. Just leave empty if you
# don't handle any file format.
create_bundle ()
{
  local appname="$1"
  local appfolder=$appname.app
  local macosfolder=$appfolder/Contents/MacOS
  local plistfile=$appfolder/Contents/Info.plist
  local appfile="$2"
  local ICON_FILE="$3"
  local appversion="`./$appfile --version | cut -d" " -f2`"
  local appDocumentTypes="${4:-}"

  echo '--------------------- Creating app bundle  --------------------'

  if ! [ -e $appfile ]; then
    echo "$appfile binary does not exist."
    echo "Run something like \"./compile.sh\" or \"make\" first"
    exit 1
  fi

  if [ -e $appfolder ]; then
    echo "$appfolder already exists, removing"
    rm -Rf $appfolder
  fi

  echo "Creating $appfolder..."
  mkdir $appfolder
  mkdir $appfolder/Contents
  mkdir $appfolder/Contents/MacOS
  mkdir $appfolder/Contents/Resources

  cp $appfile $macosfolder/$appname
  strip $macosfolder/$appname

  # Make sure $ICON_FILE is in .icns format,
  # and place the icon file in the correct place
  local ICON_EXTENSION=".${ICON_FILE##*.}"
  if [ "${ICON_EXTENSION}" != '.icns' ]; then
    local NEW_ICON_FILE="${appname}.icns"
    echo "Converting the icon to ICNS format in ${NEW_ICON_FILE}..."
    convert_to_icns "${ICON_FILE}" "${NEW_ICON_FILE}"
    mv "$NEW_ICON_FILE" $appfolder/Contents/Resources/"${appname}.icns"
  else
    cp "$ICON_FILE" $appfolder/Contents/Resources/"${appname}.icns"
  fi

  # Create PkgInfo file.
  echo "APPL????" >$appfolder/Contents/PkgInfo

  # Create information property list file (Info.plist).
  cat >$plistfile <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleDevelopmentRegion</key>
  <string>English</string>
  <key>CFBundleExecutable</key>
  <string>$appname</string>
  <key>CFBundleName</key>
  <string>$appname</string>
  <key>CFBundleIdentifier</key>
  <string>net.sourceforge.castle-engine.$appname</string>
  <key>CFBundleInfoDictionaryVersion</key>
  <string>6.0</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleSignature</key>
  <string>view</string>
  <key>CFBundleShortVersionString</key>
  <string>$appversion</string>
  <key>CFBundleVersion</key>
  <string>$appversion</string>
  <key>CSResourcesFileMapped</key>
  <true/>
  <key>CFBundleIconFile</key>
  <string>${appname}</string>
  <key>CFBundleDocumentTypes</key>
  <array>
    <dict>
      <key>CFBundleTypeRole</key>
      <string>Viewer</string>
      <key>CFBundleTypeExtensions</key>
      <array>
        <string>*</string>
      </array>
      <key>CFBundleTypeOSTypes</key>
      <array>
        <string>fold</string>
        <string>disk</string>
        <string>****</string>
      </array>
    </dict>
    $appDocumentTypes
  </array>
  <key>NSHighResolutionCapable</key>
  <true/>
</dict>
</plist>
EOF

  echo "Done."
}

# Create the dmg file.
#
# $1 and $2 are the same as for create_bundle:
# $1 is the nice application name and folder basename. This is traditionally
# in CamelCase.
# $2 is the binary name, must be relative to current dir.
# We will actually run it, with --version, to get the version number.
create_dmg ()
{
  local appname="$1"
  local appfolder=$appname.app
  local appfile="$2"

  # We remove lines
  #   TCarbonClipboard.Create Error: PasteboardCreate primary selection failed with result -4960
  #   TCarbonClipboard.Create Error: PasteboardCreate secondary selection failed with result -4960
  #   TCarbonClipboard.Create Error: PasteboardCreate clipboard failed with result -4960
  # generated on stdout when macOS application
  # using TCastleWindow backend LCL widgetset Carbon is run
  # under ssh (like Jenkins), not GUI.

  local appversion="`./$appfile --version | grep --invert-match 'TCarbonClipboard.Create Error: PasteboardCreate' | cut -d" " -f2`"

  echo "Creating dmg for application ${appname} version ${appversion}"

  make -f "${CGE_SCRIPTS_PATH:-../../../castle-engine/cge-scripts/}"macosx_dmg.makefile \
    NAME="${appname}" VERSION="${appversion}"
}

# Copy fink lib $1, and adjust it's -id (how the library identifies itself,
# may be important if another lib depends on it -- although tests show it's not really
# important?).
cp_fink_lib ()
{
  cp /sw/lib/"$1" .
  install_name_tool -id @executable_path/"$1" "$1"
}

# Check are all libs (and additional executables given as $@) do not depend on fink.
check_libs_not_depending_on_fink ()
{
  echo 'Checking that libraries do not depend on fink (/sw/lib) existence.'
  echo 'Message below that nothing matches *.dylib is OK, not a problem.'
  if otool -L *.dylib "$@" | grep /sw/lib/; then
    echo 'Error: Some references to /sw/lib/ remain inside the bundle, application possibly will not run without fink installed. Check install_name_tool commands in create_macosx_bundle.sh script.'
    exit 1
  fi
}

# Run sed "in place", changing "$1". All other params are passed to sed verbatim.
sed_in_place ()
{
  FILE_NAME="$1"
  shift 1

  local TEMP=/tmp/create_macosx_bundle-sed_in_place-$$.txt
  sed "$@" "$FILE_NAME" > "$TEMP"
  mv -f "$TEMP" "$FILE_NAME"
}

revert_change_lpi_to_alternative_castle_window_based_on_lcl ()
{
  sed_in_place "$CREATE_MACOSX_BUNDLE_LPI" -e 's|<PackageName Value="alternative_castle_window_based_on_lcl"/>|<PackageName Value="castle_window"/>|'

  if grep 'alternative_castle_window_based_on_lcl' "$CREATE_MACOSX_BUNDLE_LPI" > /dev/null; then
    echo "Can still find alternative_castle_window_based_on_lcl in $CREATE_MACOSX_BUNDLE_LPI, not good - revert_change_lpi_to_alternative_castle_window_based_on_lcl failed"
    exit 1
  fi

  if ! grep '<PackageName Value="castle_window"/>' "$CREATE_MACOSX_BUNDLE_LPI" > /dev/null; then
    echo "Cannot find castle_window in $CREATE_MACOSX_BUNDLE_LPI, not good - revert_change_lpi_to_alternative_castle_window_based_on_lcl failed"
    exit 1
  fi

  echo "Reverted $CREATE_MACOSX_BUNDLE_LPI to use alternative_castle_window_based_on_lcl: OK"
}

# Change lpi ($1) to use alternative_castle_window_based_on_lcl, not castle_window.
# Sets up "bash trap" http://redsymbol.net/articles/bash-exit-traps/
# to revert this at script exit.
temporary_change_lpi_to_alternative_castle_window_based_on_lcl ()
{
  local LPI="$1"

  CREATE_MACOSX_BUNDLE_LPI="$LPI"
  trap revert_change_lpi_to_alternative_castle_window_based_on_lcl EXIT

  sed_in_place "$LPI" -e 's|<PackageName Value="castle_window"/>|<PackageName Value="alternative_castle_window_based_on_lcl"/>|'

  if grep '"castle_window"' "$LPI" > /dev/null; then
    echo "Can still find \"castle_window\" in $LPI, not good - temporary_change_lpi_to_alternative_castle_window_based_on_lcl failed"
    exit 1
  fi

  if ! grep '<PackageName Value="alternative_castle_window_based_on_lcl"/>' "$LPI" > /dev/null; then
    echo "Cannot find alternative_castle_window_based_on_lcl in $LPI, not good - temporary_change_lpi_to_alternative_castle_window_based_on_lcl failed"
    exit 1
  fi

  echo "Changed $LPI to use alternative_castle_window_based_on_lcl: OK"
}

finish_macosx_pack ()
{
  rm -Rf *.app/ template.dmg wc.dmg
  # Note: do not delete template.dmg.bz2, as it was possibly prepared specifically for this app
  echo 'EVERYTHING DONE OK. Release the dmg file created by this script.'
}
