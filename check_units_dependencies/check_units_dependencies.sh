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

if [ -d "${CASTLE_ENGINE_PATH}"/castle_game_engine/src/ ]; then
  cd "${CASTLE_ENGINE_PATH}"/castle_game_engine/src/
else
  cd "${CASTLE_ENGINE_PATH}"/src/
fi

dircleaner . clean

TMP_PAS_LIST="$HOME/tmp/test-cge-units-dependencies_all_units.txt"
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
  PPU="`stringoper ChangeFileExt \"$F\" .ppu`"
  DEPENDENCIES_TO_CHECK=`ppudump "$PPU" | grep 'Uses unit' | awk '{ print $3 }' | sort -u`
  # echo 'Got dependencies:'
  # echo "$DEPENDENCIES_TO_CHECK"
  "${CHECK_DIR}"/check_one_unit_dependencies "${TMP_PAS_LIST}" "$F" "$DEPENDENCIES_TO_CHECK"
done
