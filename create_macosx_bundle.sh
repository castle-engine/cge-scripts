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
#
# $3 is the icons (icns) filename, relative to current dir.
# http://icns.sourceforge.net/ and svg_to_icns.sh may be useful
# to create such icon.

appname="$1"
appfolder=$appname.app
macosfolder=$appfolder/Contents/MacOS
plistfile=$appfolder/Contents/Info.plist
appfile="$2"

if ! [ -e $appfile ]; then
  echo "$appfile binary does not exist."
  echo "Run something like  ./compile.sh or ./compile_unix.sh or make build-unix first"
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

# Copy the resource files to the correct place
cp "$3" $appfolder/Contents/Resources

# Create PkgInfo file.
echo "APPL????" >$appfolder/Contents/PkgInfo

# Create information property list file (Info.plist).
echo '<?xml version="1.0" encoding="UTF-8"?>' >$plistfile
echo '<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' >>$plistfile
echo '<plist version="1.0">' >>$plistfile
echo '<dict>' >>$plistfile
echo '  <key>CFBundleDevelopmentRegion</key>' >>$plistfile
echo '  <string>English</string>' >>$plistfile
echo '  <key>CFBundleExecutable</key>' >>$plistfile
echo '  <string>'$appname'</string>' >>$plistfile
echo '  <key>CFBundleInfoDictionaryVersion</key>' >>$plistfile
echo '  <string>6.0</string>' >>$plistfile
echo '  <key>CFBundlePackageType</key>' >>$plistfile
echo '  <string>APPL</string>' >>$plistfile
echo '  <key>CFBundleSignature</key>' >>$plistfile
echo '  <string>????</string>' >>$plistfile
echo '  <key>CFBundleVersion</key>' >>$plistfile
echo '  <string>1.0</string>' >>$plistfile
echo '  <key>CSResourcesFileMapped</key>' >>$plistfile
echo '  <true/>' >>$plistfile
echo '</dict>' >>$plistfile
echo '</plist>' >>$plistfile

echo "Done."