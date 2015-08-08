#!/bin/bash
set -eu

# Trivial script to test compilation of all programs inside.
#
# Requires environment variable $CASTLE_ENGINE_PATH to be set
# to a directory containing castle_game_engine and other projects
# (required by this script itself, and also some of it's child scripts).
#
# To cross-compile (when you want to get e.g. Windows binaries from Linux),
# make sure your compiler is set up Ok (see e.g.
# http://wiki.lazarus.freepascal.org/Cross_compiling) and then do
#   export CASTLE_FPC_OPTIONS=-Twin32
#   export CASTLE_ENGINE_TOOL_OPTIONS=--os=win32
# before calling this. 
# (Some scripts use direct FPC calls with CASTLE_FPC_OPTIONS,
# some scripts use new castle-engine build tool with $CASTLE_ENGINE_TOOL_OPTIONS).
#
# Pass $1 = 'lazarus' to tests compiling using Lazarus lazbuild.
# This tests that our .lpi and package files for Lazarus are Ok.

LAZARUS="${1:-}"

echo "Castle Game Engine path detected: ${CASTLE_ENGINE_PATH}"
cd "${CASTLE_ENGINE_PATH}"
# On Cygwin, convert pwd output to something understandable for Windows programs.
if which cygpath > /dev/null; then
  CASTLE_ENGINE_PATH="`cygpath --mixed \"$CASTLE_ENGINE_PATH\"`"
fi

set -x

if [ "$LAZARUS" = 'lazarus' ]; then
  # Note that Lazarus must know about our packages.
  lazbuild castle_game_engine/packages/castle_base.lpk
  lazbuild castle_game_engine/packages/castle_window.lpk
  lazbuild castle_game_engine/packages/castle_components.lpk
fi

cd bezier_curves/
if [ "$LAZARUS" = 'lazarus' ]; then lazbuild bezier_curves.lpi; else make; fi
cd ..

cd castle/
if [ "$LAZARUS" = 'lazarus' ]; then lazbuild source/castle.lpi; else make; fi
cd ..

cd darkest_before_dawn/
if [ "$LAZARUS" = 'lazarus' ]; then lazbuild code/darkest_before_dawn_standalone.lpi; else make; fi
cd ..

cd demo_models/shadow_maps/sunny_street/
if [ "$LAZARUS" = 'lazarus' ]; then lazbuild sunny_street_process.lpi; else ./sunny_street_process_compile.sh; fi
cd ../../../

cd glinformation/
if [ "$LAZARUS" = 'lazarus' ]; then lazbuild glinformation_glut.lpi; lazbuild glinformation.lpi; else ./compile.sh; fi
cd ..

cd glplotter/
if [ "$LAZARUS" = 'lazarus' ]; then lazbuild glplotter.lpi; lazbuild gen_function.lpi; else ./compile.sh; fi
cd ..

cd glviewimage/
if [ "$LAZARUS" = 'lazarus' ]; then lazbuild glViewImage.lpi; else ./compile.sh; fi
cd ..

cd hotel_nuclear/
if [ "$LAZARUS" = 'lazarus' ]; then lazbuild code/hotel_nuclear.lpi; else make; fi
cd ..

cd kambi_lines/
if [ "$LAZARUS" = 'lazarus' ]; then lazbuild kambi_lines.lpi; else make; fi
cd ..

cd little_things/
if [ "$LAZARUS" = 'lazarus' ]; then lazbuild code/little_things.lpi; else make; fi
cd ..

cd malfunction/
if [ "$LAZARUS" = 'lazarus' ]; then lazbuild malfunction.lpi; else make; fi
cd ..

cd mountains_of_fire/
if [ "$LAZARUS" = 'lazarus' ]; then lazbuild code/mountains_of_fire.lpi; else make; fi
cd ..

cd rayhunter/
if [ "$LAZARUS" = 'lazarus' ]; then lazbuild rayhunter.lpi; else make; fi
cd ..

cd view3dscene/
if [ "$LAZARUS" = 'lazarus' ]; then lazbuild view3dscene.lpi; lazbuild tovrmlx3d.lpi; else ./compile.sh; fi
cd ..
