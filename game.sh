function init_everything() {
  init_window $1 $2 $3
  dlcall InitAudioDevice

  init_background 50
  init_tux
  load_tux_assets
  init_window_boss
  load_window_assets
  init_title

  struct -m render_texture_ptr RenderTexture render_texture
  dlcall sh_LoadRenderTexture $render_texture_ptr int:1280 int:720
  dlcall sh_SetTextureFilter $render_texture_ptr
}

function update_game() {
  if $in_title; then
    update_title
  else
    if ! $game_over && ! $player_won ; then
      update_tux
      update_window
    else
      update_music
      if $game_over; then
        tux_game_over_update
        update_window_anim
      elif $player_won; then
        win_game_over_update
        update_tux
      fi
      dlcall -n key_pressed -r bool IsKeyPressed int:82
      if [[ $key_pressed == bool:1 ]]; then
        restart_win
        restart_tux
        game_over=false
        player_won=false
        dlcall sh_PlayMusicStream $music_intro1_ptr
      fi
    fi
  fi
}

function draw_game() {
  dlcall sh_BeginTextureMode $render_texture_ptr
  if $win_hard_mode; then
    #begin_drawing int64:4292311040
    dlcall ClearBackground int64:4292311040
    draw_hard_mode_background
  else
    dlcall ClearBackground int64:4278190080
    draw_background
  fi

  if $in_title; then
    draw_title
  else
    draw_window
    draw_tux
    if $game_over; then
      dlcall DrawText string:"Loser! Press R to reset" int:300 int:300 int:60 int64:4278190335
    elif $player_won; then
      dlcall DrawText string:"You won! Press R to reset" int:300 int:300 int:60 int64:4278255360
    fi
    dlcall DrawFPS int:0 int:0
    dlcall DrawText string:"Victories: $victories Defeats: $defeats" int:1100 int:0 int:10 int64:4294967295
  fi
  dlcall EndTextureMode

  begin_drawing int64:4278190080
  dlcall sh_DrawRenderTexture $render_texture_ptr int:1280 int:720
  end_drawing
}

#function unload_everything() {
  # TODO: Unload stuff here
#}

