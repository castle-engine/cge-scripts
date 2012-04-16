#!/bin/bash
set -eu

#DEBUG='echo'
DEBUG=''

#find ../ -iname *.png -exec $DEBUG svn propset svn:mime-type image/png '{}' ';'
#find ../ -iname *.jpg -exec $DEBUG svn propset svn:mime-type image/jpeg '{}' ';'

find ../ '(' -iname *.pas -or \
             -iname *.inc -or \
             -iname *.lpr \
         ')' -exec $DEBUG svn propset svn:eol-style native '{}' ';' \
             -exec $DEBUG svn propset svn:mime-type text/pascal '{}' ';'
