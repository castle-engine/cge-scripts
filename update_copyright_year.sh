#!/bin/bash
set -eu

cd ../

make -C kambi_vrml_game_engine/ cleanmore

# dircleaner from http://michalis.ii.uni.wroc.pl/wsvn/michalis/dircleaner/
dircleaner . clean

find kambi_vrml_game_engine/src/ '(' -type d -name .svn -prune ')' -or \
       '(' -type d -name .git -prune ')' -or \
       '(' -type f -exec emacs --batch \
         -l scripts/update_copyright_year.el '{}' \
         -f kam-update-copyright-year ';' ')'
