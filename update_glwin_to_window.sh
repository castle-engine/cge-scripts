#!/bin/bash
set -u

# Don't "set -e", we want to ignore all sed exit status.

doit ()
{
sed --separate --in-place -e 's/\bglwin:/Window:/ig' "$@"
sed --separate --in-place -e 's/\bglwin\./Window\./ig' "$@"
sed --separate --in-place -e 's/\bglwin,/Window,/ig' "$@"
sed --separate --in-place -e 's/\bglwin;/Window;/ig' "$@"
sed --separate --in-place -e 's/\bglwin)/Window)/ig' "$@"
sed --separate --in-place -e 's/\bglwin(/Window(/ig' "$@"

sed --separate --in-place -e 's/\bglw:/Window:/ig' "$@"
sed --separate --in-place -e 's/\bglw\./Window\./ig' "$@"
sed --separate --in-place -e 's/\bglw,/Window,/ig' "$@"
sed --separate --in-place -e 's/\bglw;/Window;/ig' "$@"
sed --separate --in-place -e 's/\bglw)/Window)/ig' "$@"
sed --separate --in-place -e 's/\bopenglw(/OpenWindow(/ig' "$@"
sed --separate --in-place -e 's/\bcloseglw(/CloseWindow(/ig' "$@"
sed --separate --in-place -e 's/\bopenglw)/OpenWindow)/ig' "$@"
sed --separate --in-place -e 's/\bcloseglw)/CloseWindow)/ig' "$@"

sed --separate --in-place -e 's/\bglw :=/Window :=/ig' "$@"
}

doit *.pas *.inc *.lpr *.patch
