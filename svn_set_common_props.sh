#!/bin/bash
set -eu

#DEBUG='echo'
DEBUG=''

# find ../ -iname *.png -exec $DEBUG svn propset svn:mime-type image/png '{}' ';'
# find ../ -iname *.jpg -exec $DEBUG svn propset svn:mime-type image/jpeg '{}' ';'

# find ../ '(' -iname *.pas -or \
#              -iname *.inc -or \
#              -iname *.lpr \
#          ')' -exec $DEBUG svn propset svn:eol-style native '{}' ';' \
#              -exec $DEBUG svn propset svn:mime-type text/pascal '{}' ';'

# find ../ -iname *.x3d -exec $DEBUG svn propset svn:mime-type model/x3d+xml '{}' ';'
# find ../ -iname *.x3dv -exec $DEBUG svn propset svn:mime-type model/x3d+vrml '{}' ';'
# find ../ -iname *.wrl -exec $DEBUG svn propset svn:mime-type model/vrml '{}' ';'

# Unfortunately, using the proper model/* MIME types doesn't play nicely with
# SVN, that will then consider these files binary (and not show diffs).
# See http://subversion.apache.org/faq.html#binary-files

find ../ -iname *.x3d -exec $DEBUG svn propset svn:mime-type text/plain '{}' ';'
find ../ -iname *.x3dv -exec $DEBUG svn propset svn:mime-type text/plain '{}' ';'
find ../ -iname *.wrl -exec $DEBUG svn propset svn:mime-type text/plain '{}' ';'
