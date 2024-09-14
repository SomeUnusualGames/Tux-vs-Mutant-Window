#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# NOTE: The decimal point could be either a dot or a comma
# Save it to remove it from float variables
dec_pt=$(locale decimal_point)

if ! source ctypes.sh; then
  echo "ctypes.sh not found, please install it: https://github.com/taviso/ctypes.sh/"
  exit 1
fi

source raylib.sh
source utils.sh
source space_background.sh
source tux.sh
source window.sh
source title.sh
source game.sh

include_files
init_everything 1280 720 Tux-Vs-Mutant-Window

in_title=true
game_over=false
player_won=false
victories=0
defeats=0

while true; do
  update_game
  draw_game
  dlcall -n should_close -r bool WindowShouldClose 
  if [[ $should_close == bool:1 ]]; then
  	break
  fi
done

dlcall CloseAudioDevice
dlcall CloseWindow