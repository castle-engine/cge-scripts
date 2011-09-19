#!/bin/bash
set -eu

find ../ \
  '(' -type d -name .svn -prune ')' -or \
  '(' -type d -name .git -prune ')' -or \
  '(' -type f \
    '(' -iname '*.pas' -or \
        -iname '*.inc' -or \
        -iname '*.txt' -or \
        -iname '*.lpr' -')' \
    -exec emacs --batch \
    -l update_copyright_year.el '{}' \
    -f kam-update-copyright-year ';' ')'
