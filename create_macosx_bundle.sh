#!/bin/bash
set -eu

# Create a xxx.app directory being a Mac OS X "bundle" (magic directory
# that behaves like a clickable application under Mac OS X).
# This is based on createbundle.sh script from Lazarus examples/trayicon/,
# improved and generalized by Kambi.
#
# $1 is the nice application name and folder basename. This is traditionally
# in CamelCase.
#
# $2 is the binary name, must be in current dir.
# We will actually run it, with --version, to get the version number.
#
# $3 is the icons (icns) filename, relative to current dir.
# http://icns.sourceforge.net/ and svg_to_icns.sh may be useful
# to create such icon.
#
# $4 are handled document types, encoded in XML. Just leave empty if you
# don't handle any file format.

appname="$1"
appfolder=$appname.app
macosfolder=$appfolder/Contents/MacOS
plistfile=$appfolder/Contents/Info.plist
appfile="$2"
iconfile="$3"
iconfile_basename=`basename "$iconfile"`
appversion="`./$appfile --version`"
appDocumentTypes="$4"

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

# Copy the resource files to the correct place
cp "$iconfile" $appfolder/Contents/Resources

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
  <string>${iconfile_basename}</string>
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
