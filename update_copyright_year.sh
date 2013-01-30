#!/bin/bash
set -eu

# Update copyright year in all the sources.
# Edit update_copyright_year.el first, to set last year
# in kam-update-copyright-year.
#
# Note: you should also update by hand ../vrml_engine_doc/vrml_engine.xml

find ../ \
  '(' -type d -name .svn -prune ')' -or \
  '(' -type d -name .git -prune ')' -or \
  '(' -type f \
    '(' -iname '*.pas' -or \
        -iname '*.inc' -or \
        -iname '*.txt' -or \
        -iname '*.lpr' -or \
        -iname '*.el'  -or \
        -iname '*.php' ')' \
    -exec emacs --batch \
    -l update_copyright_year.el '{}' \
    -f kam-update-copyright-year ';' ')'
