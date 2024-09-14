function init_title() {
  title_message_max=60
  title_message_timer=$blink_message_max
  title_message_show=false
  struct -m title_ptr Texture title
  dlcall sh_LoadTexture $title_ptr "assets/graphics/title2.png"
  unpack $title_ptr title

  struct -m title_music_ptr Music title_music
  dlcall sh_LoadMusicStream $title_music_ptr "assets/music/Speedier_Than_Photons.mp3" int:1
  #unpack $title_music_ptr title_music # segfaults?
  dlcall sh_PlayMusicStream $title_music_ptr
}

function update_title() {
  dlcall sh_UpdateMusicStream $title_music_ptr

  title_message_timer=$((title_message_timer - 1))
  if [[ $title_message_timer -le 0 ]]; then
    title_message_timer=$title_message_max
    $title_message_show && title_message_show=false || title_message_show=true
  fi

  dlcall -n key_pressed -r int GetKeyPressed
  if [[ $key_pressed != int:0 ]]; then
    dlcall sh_StopMusicStream $title_music_ptr
    dlcall sh_PlayMusicStream $music_intro1_ptr
    in_title=false
  fi
}

function draw_title() {
  dlcall sh_DrawTexture $title_ptr int:0 int:0 int64:4294967295
  if $title_message_show; then
    dlcall DrawText "Bash any key to begin!" int:400 int:600 int:40 int64:4294967295
  fi
}