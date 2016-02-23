# Define bash functions to clean/generate textures in GPU-compressed formats
# suitable for Android GPUs.
#
# They use
# - PVRTexToolCLI (get it from https://community.imgtec.com/developers/powervr/tools/pvrtextool/ )
# - AMD Compressonator (get it from http://developer.amd.com/tools-and-sdks/archive/legacy-cpu-gpu-tools/the-compressonator/ )
#
# ----------------------------------------------------------------------------
# Usage:
# Create your own shell script, where you:
#
# 1. Define process_files function, like
#
# process_files ()
# {
#   find dragon/ \
#     '(' -type d -name 'compressed' -prune ')' -or \
#     '(' -type f \
#         '(' -iname *.png -or -iname *.jpg ')' \
#         "$@" \
#     ')'
# }
#
# 2. Source this script, like
#
# . "${CASTLE_ENGINE_PATH}"scripts/generate_compressed_textures_functions.sh
#
# 3. Call the targets you want, like
#
# clean_compressed
# do_pvrtc
# do_atitc
# ----------------------------------------------------------------------------

clean_compressed ()
{
  process_files \
    -execdir rm -Rf 'compressed' ';'
}

do_pvrtc ()
{
  # try the standard installation path on Linux
  PVRTexTool='/opt/Imagination/PowerVR_Graphics/PowerVR_Tools/PVRTexTool/CLI/Linux_x86_32/PVRTexToolCLI'
  if ! [ -f "$PVRTexTool" ]; then
    # otherwise, assume it's on $PATH
    PVRTexTool='PVRTexToolCLI'
  fi
  echo "Using PVRTexTool as ${PVRTexTool}"

  SUBDIR='compressed/pvrtc1_4bpp_rgba/'

  process_files \
    -execdir mkdir -p "${SUBDIR}" ';' \
    -execdir "${PVRTexTool}" -f PVRTC1_4 -q pvrtcbest -m 1 -squarecanvas '+' -flip y -i '{}' -o "${SUBDIR}"'{}'.dds ';'
}

do_atitc ()
{
  # try the standard installation path on Linux
  ATICompressonator="$HOME/.wine/drive_c/Program Files/AMD/The Compressonator 1.50/TheCompressonator.exe"
  if ! [ -f "$ATICompressonator" ]; then
    # try the standard installation path on Windows
    ATICompressonator="C:/Program Files/AMD/The Compressonator 1.50/TheCompressonator.exe"
    if ! [ -f "$ATICompressonator" ]; then
      # otherwise, assume it's on $PATH
      ATICompressonator='TheCompressonator'
    fi
  fi
  echo "Using ATI Compressonator as ${ATICompressonator}"

  CONVERT='convert'
  echo "Using ImageMagick convert as ${CONVERT}"

  SUBDIR='compressed/atitc_rgba_interpolated/'

  # Note: don't generate with -mipmaps, as
  # - not always you need them, so it would be a waste of size.
  # - using mipmaps with compressed textures is broken on some ATI GPUs on Android (testcase: escape on p phone).
  process_files \
    -execdir mkdir -p "${SUBDIR}" ';' \
    -execdir "${CONVERT}" '{}' -flip 'temporary.png' ';' \
    -execdir wine "${ATICompressonator}" -convert -overwrite 'temporary.png' "${SUBDIR}"'{}'.dds -codec ATICompressor.dll +fourCC 'ATCI' ';' \
    -execdir rm -f 'temporary.png' ';'
}
