#!/bin/bash
set -eu

# Get various project repositories (git clone or git pull).
# Useful for some Jenkins jobs.
#
# We cannot anymore configure Jenkins to just get multiple git repos.
# We could try the "Pipeline" plugin:
# http://stackoverflow.com/questions/40224272/using-a-jenkins-pipeline-to-checkout-multiple-git-repos-into-same-job
# ... but for now, just clone multiple repos with a script below.

get_repo_custom_name ()
{
  REPO="$1"
  DIR="$2"

  if [ -d "$DIR" ]; then
    echo 'Updating '"$DIR"
    cd "$DIR"
    git pull --rebase
    cd ../
  else
    echo 'Cloning '"$DIR"
    git clone https://github.com/castle-engine/"$REPO".git "$DIR"
  fi
}

get_repo ()
{
  get_repo_custom_name "$1" "$1"
}

get_repo_custom_name cge-blender blender
get_repo_custom_name castle-game castle
get_repo_custom_name darkest-before-dawn darkest_before_dawn
get_repo_custom_name demo-models demo_models
get_repo             glinformation
get_repo             glplotter
get_repo             glviewimage
get_repo_custom_name hotel-nuclear hotel_nuclear
get_repo_custom_name kambi-lines kambi_lines
get_repo_custom_name little-things little_things
get_repo             malfunction
get_repo_custom_name mountains-of-fire mountains_of_fire
get_repo             rayhunter
get_repo_custom_name cge-scripts scripts
get_repo             view3dscene
get_repo_custom_name cge-www www
