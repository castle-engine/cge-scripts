#!/bin/bash
set -eu

# Extract information about unit dependencies,
# including implementation dependencies.
# Good script to keep track of dependencies between many CGE units.
#
# This can only check units it can compile.
# For now it assumes that it runs on a desktop Unix (like a Linux),
# so it omits stuff specific to Windows, Android, it also omits stuff
# that requires Lazarus LCL.

CHECK_DIR=`pwd`
castle-engine simple-compile check_one_unit_dependencies.lpr

# Enter correct engine src dir.
# Work with $CASTLE_ENGINE_PATH either pointing to top-level CGE SVN dir,
# or to the actual CGE engine dir.
if [ -d "${CASTLE_ENGINE_PATH}"/castle_game_engine/src/ ]; then
  cd "${CASTLE_ENGINE_PATH}"/castle_game_engine/src/
else
  cd "${CASTLE_ENGINE_PATH}"/src/
fi

# Clean ppu/o files.
# Work regardless if dircleaner is installed.
if which dircleaner > /dev/null; then
  dircleaner . clean
else
  find . -type f '(' -iname '*.ow'  -or -iname '*.ppw' -or \
                     -iname '*.o'   -or -iname '*.ppu' ')' \
    -print \
    | xargs rm -f
fi

# Calculate temp file location.
# Work regardless if $HOME/tmp is created.
if [ -d "$HOME/tmp" ]; then
  TMP_PAS_LIST="$HOME/tmp/test-cge-units-dependencies_all_units.txt"
else
  TMP_PAS_LIST="/tmp/test-cge-units-dependencies_all_units.txt"
fi

echo "All units list in ${TMP_PAS_LIST}"
find . \
  '(' -type d -iname android -prune ')' -or \
  '(' -type d -iname windows -prune ')' -or \
  '(' -type d -iname components -prune ')' -or \
  '(' -type f -iname '*.pas' -print ')' > "${TMP_PAS_LIST}"

for F in `cat "${TMP_PAS_LIST}"`; do
  echo "----------------------------------------------------------------------"
  echo "Checking dependencies of $F"
  castle-engine simple-compile "$F"
  # Like `stringoper ChangeFileExt %F .ppu`
  PPU="${F%.*}.ppu"

  # Strip directory name,
  # and add castle-engine-output/compilation/<arch-cpu>/,
  # because that's where "castle-engine simple-compile" places ppu now.
  PPU="`basename \"${PPU}\"`"
  PPU='castle-engine-output/compilation/'`fpc -iTP`-`fpc -iTO`"/${PPU}"

  DEPENDENCIES_TO_CHECK=`ppudump "$PPU" | grep 'Uses unit' | awk '{ print $3 }' | sort -u`
  # echo 'Got dependencies:'
  # echo "$DEPENDENCIES_TO_CHECK"
  "${CHECK_DIR}"/check_one_unit_dependencies "${TMP_PAS_LIST}" "$F" "$DEPENDENCIES_TO_CHECK"
done
