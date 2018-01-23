#!/bin/bash
set -eu

# Update copyright year in all the sources.
# Edit update_copyright_year.el first, to set last year
# in kam-update-copyright-year.
#
# Note: you should also update by hand ../vrml_engine_doc/vrml_engine.xml
#
# ----------------------------------------------------------------------------
# Should we do this?
#
#   Not necessarily. Having the *initial* year is most important:
#   - https://www.quora.com/Should-I-update-my-copyright-statement-to-the-current-year
#   - https://stackoverflow.com/questions/2390230/do-copyright-dates-need-to-be-updated
#
#   But GNU suggests to extend it, and do it automatically if the package is updated:
#   https://www.gnu.org/prep/maintain/html_node/Copyright-Notices.html
#   """When you add the new year, it is not required to keep track of which files
#      have seen significant changes in the new year and which have not.
#      It is recommended and simpler to add the new year to all files in the package,
#      and be done with it for the rest of the year.
#   """

find ../view3dscene/ ../castle-engine/ ../cge-www/htdocs/kambi-php-lib/ . \
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
