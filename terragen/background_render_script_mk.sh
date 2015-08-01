#!/bin/bash
set -eu

# This script generates to the standard output Terragen script
# that can be used to make 6 textures for skycube.
#
# Parameters: $1 = camera position z
# If present, $2 = camera position x and $3 = camera position y.
# (default camera pos x,y = 128,128)

CAMERA_POS_Z=$1
CAMERA_POS_X=${2:-128}
CAMERA_POS_Y=${3:-128}

# Filter through eoldos --- Terragen requires DOS line endings
cat <<EOFTGS | eoldos -
; -*- buffer-read-only: t -*-
; Do not edit, this is automatically generated file.
; Edit background_render_script_mk.sh instead.

InitAnim "rendered_background" 1

; Zero CloudVelo, so that clouds will not move (to keep clouds position the same
; on each rendered image).
; I'm not sure whether setting CloudPos 0 0 is really needed, Terragen will
; probably use the same cloud setting anyway (and this is all I want) if I will
; not call CloudPos at any place.
CloudPos 0 0
CloudVel 0 0

CamPos $CAMERA_POS_X $CAMERA_POS_Y $CAMERA_POS_Z
CamB 0

; Zoom 1 = field of view 90 degrees
Zoom 1

; render 6 views now

TarPos $CAMERA_POS_X  1000 $CAMERA_POS_Z
FRend
TarPos -1000 $CAMERA_POS_Y $CAMERA_POS_Z
FRend
TarPos $CAMERA_POS_X -1000 $CAMERA_POS_Z
FRend
TarPos  1000 $CAMERA_POS_Y $CAMERA_POS_Z
FRend

TarPos $CAMERA_POS_X $CAMERA_POS_Y -1000
CamB 90
FRend

TarPos $CAMERA_POS_X $CAMERA_POS_Y  1000
CamB -90
FRend

EOFTGS
