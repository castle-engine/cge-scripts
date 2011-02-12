#!/bin/bash
set -eu

cd ../
find view3dscene/ castle/ kambi_vrml_game_engine/ \
  '(' -type d -name .svn -prune ')' -or \
  '(' -type d -name .git -prune ')' -or \
  '(' -type f \
    '(' -iname '*.pas' -or \
        -iname '*.inc' -or \
        -iname '*.txt' -or \
        -iname '*.lpr' -')' \
    -exec emacs --batch \
    -l scripts/update_copyright_year.el '{}' \
    -f kam-update-copyright-year ';' ')'
