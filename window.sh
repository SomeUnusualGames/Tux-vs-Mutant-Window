function load_window_assets() {
  # -- Tentacle texture --
  struct -m win_bullet_texture_ptr Texture win_bullet_texture
  dlcall sh_LoadTexture $win_bullet_texture_ptr "assets/graphics/sad.png"
  unpack $win_bullet_texture_ptr win_bullet_texture

  struct -m win_bullet_rec_ptr Rectangle win_bullet_rec
  set_rect_values win_bullet_rec float:0.0 float:0.0 float:12.0 float:21.0
  pack $win_bullet_rec_ptr win_bullet_rec

  struct -m window_texture_ptr Texture window_texture
  dlcall sh_LoadTexture $window_texture_ptr "assets/graphics/window1.png"
  unpack $window_texture_ptr window_texture

  struct -m tentacle_texture_ptr Texture tentacle_texture
  dlcall sh_LoadTexture $tentacle_texture_ptr "assets/graphics/tentacle4.png"
  unpack $tentacle_texture_ptr tentacle_texture

  struct -m tentacle_rec_origin_ptr Rectangle tentacle_rec_origin
  set_rect_values tentacle_rec_origin float:0.0 float:0.0 float:120.0 float:96.0
  pack $tentacle_rec_origin_ptr tentacle_rec_origin

  struct -m tentacle_vec_origin_ptr Vector2 tentacle_vec_origin
  tentacle_vec_origin[x]=float:60.0
  tentacle_vec_origin[y]=float:48.0
  pack $tentacle_vec_origin_ptr tentacle_vec_origin

  struct -m tentacle_rec_dest_ptr1 Rectangle tentacle_rec_dest1
  set_rect_values tentacle_rec_dest1 float:525.0 float:255.0 float:120.0 float:96.0
  pack $tentacle_rec_dest_ptr1 tentacle_rec_dest1

  struct -m tentacle_rec_dest_ptr2 Rectangle tentacle_rec_dest2
  set_rect_values tentacle_rec_dest2 float:525.0 float:394.0 float:120.0 float:96.0
  pack $tentacle_rec_dest_ptr2 tentacle_rec_dest2

  struct -m tentacle_rec_dest_ptr3 Rectangle tentacle_rec_dest3
  set_rect_values tentacle_rec_dest3 float:455.0 float:328.0 float:120.0 float:96.0
  pack $tentacle_rec_dest_ptr3 tentacle_rec_dest3

  struct -m tentacle_rec_dest_ptr4 Rectangle tentacle_rec_dest4
  set_rect_values tentacle_rec_dest4 float:595.0 float:328.0 float:120.0 float:96.0
  pack $tentacle_rec_dest_ptr4 tentacle_rec_dest4
  # -- End Tentacle texture --

  # -- Tentacle hitbox --
  struct -m tentacle_box_ptr1 Rectangle tentacle_box1
  set_rect_values tentacle_box1 float:515.0 float:205.0 float:30.0 float:96.0
  pack $tentacle_box_ptr1 tentacle_box1

  struct -m tentacle_box_ptr2 Rectangle tentacle_box2
  set_rect_values tentacle_box2 float:500.0 float:344.0 float:30.0 float:96.0
  pack $tentacle_box_ptr2 tentacle_box2

  struct -m tentacle_box_ptr3 Rectangle tentacle_box3
  set_rect_values tentacle_box3 float:425.0 float:305.0 float:76.0 float:40.0
  pack $tentacle_box_ptr3 tentacle_box3

  struct -m tentacle_box_ptr4 Rectangle tentacle_box4
  set_rect_values tentacle_box4 float:545.0 float:315.0 float:96.0 float:40.0
  pack $tentacle_box_ptr4 tentacle_box4
  # -- End Tentacle hitbox --

  # -- Background --
  struct -m big_sad_ptr Texture big_sad
  dlcall sh_LoadTexture $big_sad_ptr "assets/graphics/big_sad.png"
  unpack $big_sad_ptr big_sad

  struct -m big_happy_ptr Texture big_happy
  dlcall sh_LoadTexture $big_happy_ptr "assets/graphics/big_happy.png"
  unpack $big_happy_ptr big_happy

  struct -m message_1_ptr Texture message_1
  dlcall sh_LoadTexture $message_1_ptr "assets/graphics/message1.png"
  unpack $message_1_ptr message_1

  struct -m message_2_ptr Texture message_2
  dlcall sh_LoadTexture $message_2_ptr "assets/graphics/message2.png"
  unpack $message_2_ptr message_2

  struct -m message_footer_ptr Texture message_footer
  dlcall sh_LoadTexture $message_footer_ptr "assets/graphics/message_footer.png"
  unpack $message_footer_ptr message_footer
  # -- Background end --

  # etc
  struct -m win_hp_ptr Rectangle win_hp
  set_rect_values win_hp float:0.0 float:710.0 float:400.0 float:10.0
  pack $win_hp_ptr win_hp

  struct -m music_intro1_ptr Music music_intro1
  dlcall sh_LoadMusicStream $music_intro1_ptr "assets/music/Oldschool_Action_Theme_Intro.mp3" int:0
  struct -m music_loop1_ptr Music music_loop1
  dlcall sh_LoadMusicStream $music_loop1_ptr "assets/music/Oldschool_Action_Theme_Main.mp3" int:1

  struct -m music_intro2_ptr Music music_intro2
  dlcall sh_LoadMusicStream $music_intro2_ptr "assets/music/Porkymon_Battle_Theme_Intro.mp3" int:0
  struct -m music_loop2_ptr Music music_loop2
  dlcall sh_LoadMusicStream $music_loop2_ptr "assets/music/Porkymon_Battle_Theme_Main.mp3" int:1

  struct -m music_game_over_ptr Music music_game_over
  dlcall sh_LoadMusicStream $music_game_over_ptr "assets/music/game_over_bad_chest.wav" int:0

  struct -m music_victory_ptr Music music_victory
  dlcall sh_LoadMusicStream $music_victory_ptr "assets/music/winneris_0.ogg" int:0
}

function init_window_boss() {
  tentacle_delay=(40 30 10 30 40)
  #tentacle_delay_fast=(5 5 5 5 5)
  tentacle_health=(100 100 100 100)
  tentacle_hp=400
  tentacle_current_delay=30
  tentacle_mov=1
  tentacle_index=0

  struct -m win_pos_ptr Vector2 win_pos
  win_pos[x]=float:700$dec_pt0
  win_pos[y]=float:300$dec_pt0
  pack $win_pos_ptr win_pos  

  win_max_movement_delay=600
  win_movement_delay=$win_max_movement_delay
  win_moving=false
  win_target_x=float:0.0
  win_target_y=float:0.0

  win_hard_mode=false
  win_current_angle=-90
  win_angle_change=10
  win_max_wave_delay=800
  win_wave_delay=$win_max_wave_delay
  win_current_wave=0
  win_bullet_max_delay=60
  win_bullet_delay=$win_bullet_max_delay
  win_bullet_speed=float:200.0
  win_bullet_x=()
  win_bullet_y=()
  win_bullet_angle=()
}

function restart_win() {
  tentacle_delay=(40 30 10 30 40)
  win_bullet_x=()
  win_bullet_y=()
  win_bullet_angle=()
  tentacle_health=(100 100 100 100)
  win_hard_mode=false
  win_current_wave=0
  win_wave_delay=$win_max_wave_delay
  tentacle_hp=400
  win_bullet_speed=float:200.0
  win_bullet_max_delay=60
  
  dlcall sh_StopMusicStream $music_game_over_ptr
  #dlcall -n screen_width -r int GetScreenWidth
  #win_pos[x]=float:$((${screen_width##*:} - 400))
  win_pos[x]=float:700$dec_pt0
  win_pos[y]=float:300$dec_pt0
  pack $win_pos_ptr win_pos
}

function check_collision_player_bullet() {
  if [[ ${#tux_bullets_x[@]} -gt 0 ]]; then
    for ((i=0; i < ${#tux_bullets_x[@]}; i++)); do
      tux_bullet_rect[x]=float:${tux_bullets_x[$i]}
      tux_bullet_rect[y]=float:${tux_bullets_y[$i]}
      pack $tux_bullet_rect_ptr tux_bullet_rect
      for ((j=1; j < 5; j++)); do
        if [[ ${tentacle_health[$j-1]} -le 0 ]]; then
          continue
        fi
        local box="tentacle_box_ptr$j"
        dlcall -n collides -r bool check_collision $tux_bullet_rect_ptr ${!box}
        if [[ $collides == bool:1 ]]; then
          unset tux_bullets_x[$i]
          unset tux_bullets_y[$i]
          tux_bullets_x=("${tux_bullets_x[@]}")
          tux_bullets_y=("${tux_bullets_y[@]}")
          tentacle_hp=$((tentacle_hp - 1))
          tentacle_health[$j-1]=$((tentacle_health[j-1] - 1))
          if [[ $tentacle_hp -le 0 ]]; then
            player_won=true
            victories=$((victories + 1))
            dlcall sh_PlayMusicStream $music_victory_ptr
          fi
        fi
      done
    done
  fi
}

function check_collision_win_bullet() {
  win_bullet_rec[x]=$1
  win_bullet_rec[y]=$2
  pack $win_bullet_rec_ptr win_bullet_rec
  dlcall -n collides -r bool check_collision $win_bullet_rec_ptr $tux_box_ptr
  if [[ $collides == bool:1 && $game_over == false ]]; then
    game_over=true
    defeats=$((defeats + 1))
    if $player_won; then
      player_won=false
      victories=$((victories - 1))
      dlcall sh_StopMusicStream $music_victory_ptr
    fi
    tentacle_delay=(5 5 5 5 5)
    dlcall sh_PlayMusicStream $music_game_over_ptr
    dlcall sh_StopMusicStream $music_intro1_ptr
    dlcall sh_StopMusicStream $music_loop1_ptr
    dlcall sh_StopMusicStream $music_intro2_ptr
    dlcall sh_StopMusicStream $music_loop2_ptr
    set_tux_game_over
  fi
}

function win_game_over_update() {
  dlcall -n screen_height -r int GetScreenHeight
  local y_pos=${win_pos[y]##*:}
  local y=${y_pos%%$dec_pt*}
  if [[ $y -lt ${screen_height##*:}+50 ]]; then
    win_pos[y]=float:$(($y + 3))
    pack $win_pos_ptr win_pos
  fi
  if [[ ${#win_bullet_x[@]} -gt 0 ]]; then
    update_window_wave_$win_current_wave
  fi
}

function update_window_anim() {
  tentacle_current_delay=$(($tentacle_current_delay - 1))
  if [[ $tentacle_current_delay -le 0 ]]; then
    tentacle_index=$(($tentacle_index + $tentacle_mov))
    tentacle_current_delay=${tentacle_delay[$tentacle_index]}
    if [[ $tentacle_index == 4 ]]; then
      tentacle_mov=-1
    elif [[ $tentacle_index == 0 ]]; then
      tentacle_mov=1
    fi
  fi
}

function update_window_movement() {
  dlcall -n dt -r float GetFrameTime
  win_movement_delay=$((win_movement_delay - 1))
  if [[ $win_movement_delay -le 0 ]]; then
    dlcall -n screen_width -r int GetScreenWidth
    dlcall -n screen_height -r int GetScreenHeight
    win_movement_delay=$win_max_movement_delay
    win_moving=true
    win_target_x=$(random 600 650)
    win_target_y=$(random 100 400)
    #win_target_x=$((800 + $(od -An -N1 -d /dev/urandom) % (${screen_width##*:} - 250)))
    #win_target_y=$((100 + $(od -An -N1 -d /dev/urandom) % (${screen_height##*:} - 50)))
  fi

  if $win_moving; then
    dlcall -n pos_x -r float lerp ${win_pos[x]} float:${win_target_x##*:} float:2.0 $dt
    dlcall -n pos_y -r float lerp ${win_pos[y]} float:${win_target_y##*:} float:2.0 $dt
    win_pos[x]=$pos_x
    win_pos[y]=$pos_y
    pack $win_pos_ptr win_pos
  fi
}

function update_window_wave_0() {
  dlcall -n dt -r float GetFrameTime
  win_bullet_delay=$((win_bullet_delay - 1))
  if [[ win_bullet_delay -le 0 ]]; then
    win_bullet_delay=$win_bullet_max_delay
    $win_hard_mode && local ang_change=15 || local ang_change=20
    #for ((i=120; i>-120; i-=10)); do # -> fast
    for ((i=120; i>-120; i-=ang_change)); do
      win_bullet_x+=(${win_pos[x]})
      win_bullet_y+=(${win_pos[y]})
      dlcall -n angle_rad -r float deg2rad float:$i
      win_bullet_angle+=($angle_rad)
    done
  fi

  dlcall -n screen_width -r int GetScreenWidth
  dlcall -n screen_height -r int GetScreenHeight

  for ((i=0; i<${#win_bullet_x[@]}; i++)); do
    dlcall -n new_pos_x -r float sub_position_cos_angle ${win_bullet_x[$i]} ${win_bullet_angle[$i]} $win_bullet_speed $dt
    dlcall -n new_pos_y -r float sub_position_sin_angle ${win_bullet_y[$i]} ${win_bullet_angle[$i]} $win_bullet_speed $dt
    local rand_angle=float:$(($RANDOM % 2))
    dlcall -n new_angle -r float add_position ${win_bullet_angle[$i]} $rand_angle $dt
    win_bullet_angle[$i]=$new_angle
    local pos_x=${win_bullet_x[$i]##*:}
    local pos_y=${win_bullet_y[$i]##*:}
    local pos_x_num=${pos_x%%$dec_pt*}
    local pos_y_num=${pos_y%%$dec_pt*}
    if [[ $pos_y_num -le 0 || $pos_y_num -ge ${screen_height##*:} || $pos_x_num -le 0 ]]; then
      unset win_bullet_x[$i]
      unset win_bullet_y[$i]
      unset win_bullet_angle[$i]
      win_bullet_x=("${win_bullet_x[@]}")
      win_bullet_y=("${win_bullet_y[@]}")
      win_bullet_angle=("${win_bullet_angle[@]}")
    else
      win_bullet_x[$i]=$new_pos_x
      win_bullet_y[$i]=$new_pos_y
    fi
  done
}

function update_window_wave_1() {
  dlcall -n dt -r float GetFrameTime
  win_bullet_delay=$((win_bullet_delay - 1))
  if [[ win_bullet_delay -le 0 ]]; then
    win_bullet_delay=$win_bullet_max_delay
    dlcall -n win_tux_angle -r float angle_points ${win_pos[x]} ${win_pos[y]} ${tux_rec_dest[x]} ${tux_rec_dest[y]}
    win_bullet_x+=(${win_pos[x]})
    win_bullet_y+=(${win_pos[y]})
    win_bullet_angle+=($win_tux_angle)
  fi

  dlcall -n screen_width -r int GetScreenWidth
  dlcall -n screen_height -r int GetScreenHeight

  for ((i=0; i<${#win_bullet_x[@]}; i++)); do
    dlcall -n new_pos_x -r float sub_position_cos_angle ${win_bullet_x[$i]} ${win_bullet_angle[$i]} $win_bullet_speed $dt
    dlcall -n new_pos_y -r float sub_position_sin_angle ${win_bullet_y[$i]} ${win_bullet_angle[$i]} $win_bullet_speed $dt
    local pos_x=${win_bullet_x[$i]##*:}
    local pos_y=${win_bullet_y[$i]##*:}
    local pos_x_num=${pos_x%%$dec_pt*}
    local pos_y_num=${pos_y%%$dec_pt*}
    if [[ $pos_y_num -le 0 || $pos_y_num -ge ${screen_height##*:} || $pos_x_num -le 0 ]]; then
      unset win_bullet_x[$i]
      unset win_bullet_y[$i]
      unset win_bullet_angle[$i]
      win_bullet_x=("${win_bullet_x[@]}")
      win_bullet_y=("${win_bullet_y[@]}")
      win_bullet_angle=("${win_bullet_angle[@]}")
    else
      win_bullet_x[$i]=$new_pos_x
      win_bullet_y[$i]=$new_pos_y
    fi
  done
}

function update_window_wave_2() {
  dlcall -n dt -r float GetFrameTime
  win_bullet_delay=$((win_bullet_delay - 1))
  if [[ win_bullet_delay -le 0 ]]; then
    win_bullet_delay=$win_bullet_max_delay
    win_bullet_x+=(${win_pos[x]})
    win_bullet_y+=(${win_pos[y]})
    dlcall -n angle_rad -r float deg2rad float:$win_current_angle
    win_bullet_angle+=($angle_rad)
    win_bullet_x+=(${win_pos[x]})
    win_bullet_y+=(${win_pos[y]})
    dlcall -n angle_rad2 -r float deg2rad float:$((-win_current_angle))
    win_bullet_angle+=($angle_rad2)

    if [[ $win_hard_mode && ${win_current_angle#-} -gt 45 ]]; then
      dlcall -n win_tux_angle -r float angle_points ${win_pos[x]} ${win_pos[y]} ${tux_rec_dest[x]} ${tux_rec_dest[y]}
      win_bullet_x+=(${win_pos[x]})
      win_bullet_y+=(${win_pos[y]})
      win_bullet_angle+=($win_tux_angle)
    fi

    win_current_angle=$((win_current_angle + win_angle_change))
    if [[ $win_current_angle == 90 || $win_current_angle == -90 ]]; then
      win_angle_change=$((-win_angle_change))
    fi
  fi

  dlcall -n screen_width -r int GetScreenWidth
  dlcall -n screen_height -r int GetScreenHeight

  for ((i=0; i<${#win_bullet_x[@]}; i++)); do
    dlcall -n new_pos_x -r float sub_position_cos_angle ${win_bullet_x[$i]} ${win_bullet_angle[$i]} $win_bullet_speed $dt
    dlcall -n new_pos_y -r float sub_position_sin_angle ${win_bullet_y[$i]} ${win_bullet_angle[$i]} $win_bullet_speed $dt
    local pos_x=${win_bullet_x[$i]##*:}
    local pos_y=${win_bullet_y[$i]##*:}
    local pos_x_num=${pos_x%%$dec_pt*}
    local pos_y_num=${pos_y%%$dec_pt*}
    if [[ $pos_y_num -le 0 || $pos_y_num -ge ${screen_height##*:} || $pos_x_num -le 0 ]]; then
      unset win_bullet_x[$i]
      unset win_bullet_y[$i]
      unset win_bullet_angle[$i]
      win_bullet_x=("${win_bullet_x[@]}")
      win_bullet_y=("${win_bullet_y[@]}")
      win_bullet_angle=("${win_bullet_angle[@]}")
    else
      win_bullet_x[$i]=$new_pos_x
      win_bullet_y[$i]=$new_pos_y
    fi
  done
}

function update_music() {
  local music_intro=$1
  local music_loop=$2
  dlcall -n is_intro_playing -r int sh_IsMusicStreamPlaying $music_intro

  if $game_over; then
    dlcall sh_UpdateMusicStream $music_game_over_ptr
  elif $player_won; then
    dlcall sh_UpdateMusicStream $music_victory_ptr
  elif [[ $is_intro_playing == int:1 ]]; then
    dlcall sh_UpdateMusicStream $music_intro
  else
    dlcall -n is_loop_playing -r int sh_IsMusicStreamPlaying $music_loop
    if [[ $is_loop_playing == int:0 ]]; then
      dlcall sh_StopMusicStream $music_intro
      dlcall sh_PlayMusicStream $music_loop
    fi
    dlcall sh_UpdateMusicStream $music_loop
  fi
}

function update_window() {
  if $win_hard_mode; then
    update_music $music_intro2_ptr $music_loop2_ptr
  else
    update_music $music_intro1_ptr $music_loop1_ptr
  fi

  if [[ $tentacle_hp == 100 && $win_wave_delay -gt 0 ]]; then
    win_hard_mode=true
    win_wave_delay=0
    tentacle_delay=(5 5 5 5 5)
    dlcall sh_StopMusicStream $music_loop1_ptr
    dlcall sh_PlayMusicStream $music_intro2_ptr
  fi

  win_wave_delay=$((win_wave_delay - 1))
  if [[ $win_wave_delay -le 0 ]]; then
    win_wave_delay=$win_max_wave_delay
    win_current_wave=$((win_current_wave + 1))
    case $win_current_wave in
      1)
        if $win_hard_mode; then
          win_bullet_max_delay=15
          win_bullet_speed=float:500.0
        else
          win_bullet_max_delay=20
          win_bullet_speed=float:400.0
        fi ;;
      2)
        if $win_hard_mode; then
          win_bullet_max_delay=5
          win_bullet_speed=float:400.0
        else
          win_bullet_max_delay=10
          win_bullet_speed=float:250.0
        fi ;;
      3)
        win_current_wave=0
        if $win_hard_mode; then
          win_bullet_speed=float:150.0
          win_bullet_max_delay=40
        else
          win_bullet_speed=float:200.0
          win_bullet_max_delay=60
        fi ;;
    esac
  fi

  check_collision_player_bullet

  update_window_anim
  update_window_movement
  update_window_wave_$win_current_wave
}

function draw_hard_mode_background() {
  if $player_won; then
    dlcall sh_DrawTexture $big_happy_ptr int:150 int:100 int64:4294967295
  else
    dlcall sh_DrawTexture $big_sad_ptr int:150 int:100 int64:4294967295
  fi
  dlcall sh_DrawTexture $message_2_ptr int:150 int:250 int64:4294967295
  dlcall sh_DrawTexture $message_footer_ptr int:150 int:390 int64:4294967295
}
function draw_tentacles() {
  local pos_x=${win_pos[x]##*:}
  local pos_y=${win_pos[y]##*:}

  if [[ ${tentacle_health[0]} -gt 0 ]]; then
    tentacle_rec_dest1[x]=float:$((${pos_x%%$dec_pt*} + 25))
    tentacle_rec_dest1[y]=float:$((${pos_y%%$dec_pt*} - 45))
    pack $tentacle_rec_dest_ptr1 tentacle_rec_dest1
    tentacle_box1[x]=float:$((${pos_x%%$dec_pt*} + 15))
    tentacle_box1[y]=float:$((${pos_y%%$dec_pt*} - 95))
    pack $tentacle_box_ptr1 tentacle_box1
    dlcall sh_DrawTexturePro $tentacle_texture_ptr $tentacle_rec_origin_ptr $tentacle_rec_dest_ptr1 $tentacle_vec_origin_ptr float:0.0 int64:4294967295
    #dlcall sh_DrawRectangleRec $tentacle_box_ptr1 int64:4294967295
  fi
  
  if [[ ${tentacle_health[1]} -gt 0 ]]; then
    tentacle_rec_dest2[x]=float:$((${pos_x%%$dec_pt*} + 25))
    tentacle_rec_dest2[y]=float:$((${pos_y%%$dec_pt*} + 94))
    pack $tentacle_rec_dest_ptr2 tentacle_rec_dest2
    tentacle_box2[x]=float:$pos_x
    tentacle_box2[y]=float:$((${pos_y%%$dec_pt*} + 44))
    pack $tentacle_box_ptr2 tentacle_box2
    dlcall sh_DrawTexturePro $tentacle_texture_ptr $tentacle_rec_origin_ptr $tentacle_rec_dest_ptr2 $tentacle_vec_origin_ptr float:180.0 int64:4294967295
    #dlcall sh_DrawRectangleRec $tentacle_box_ptr2 int64:4294967295
  fi

  if [[ ${tentacle_health[2]} -gt 0 ]]; then
    tentacle_rec_dest3[x]=float:$((${pos_x%%$dec_pt*} - 45))
    tentacle_rec_dest3[y]=float:$((${pos_y%%$dec_pt*} + 28))
    pack $tentacle_rec_dest_ptr3 tentacle_rec_dest3
    tentacle_box3[x]=float:$((${pos_x%%$dec_pt*} - 75))
    tentacle_box3[y]=float:$((${pos_y%%$dec_pt*} + 5))
    pack $tentacle_box_ptr3 tentacle_box3
    dlcall sh_DrawTexturePro $tentacle_texture_ptr $tentacle_rec_origin_ptr $tentacle_rec_dest_ptr3 $tentacle_vec_origin_ptr float:270.0 int64:4294967295
    #dlcall sh_DrawRectangleRec $tentacle_box_ptr3 int64:4294967295
  fi

  if [[ ${tentacle_health[3]} -gt 0 ]]; then
    tentacle_rec_dest4[x]=float:$((${pos_x%%$dec_pt*} + 95))
    tentacle_rec_dest4[y]=float:$((${pos_y%%$dec_pt*} + 28))
    pack $tentacle_rec_dest_ptr4 tentacle_rec_dest4
    tentacle_box4[x]=float:$((${pos_x%%$dec_pt*} + 45))
    tentacle_box4[y]=float:$((${pos_y%%$dec_pt*} + 15))
    pack $tentacle_box_ptr4 tentacle_box4
    dlcall sh_DrawTexturePro $tentacle_texture_ptr $tentacle_rec_origin_ptr $tentacle_rec_dest_ptr4 $tentacle_vec_origin_ptr float:90.0 int64:4294967295
    #dlcall sh_DrawRectangleRec $tentacle_box_ptr4 int64:4294967295
  fi
}

function draw_window() {
  tentacle_rec_origin[x]=float:$(($tentacle_index * 120))
  pack $tentacle_rec_origin_ptr tentacle_rec_origin

  draw_tentacles

  dlcall sh_DrawTextureV $window_texture_ptr $win_pos_ptr int64:4294967295

  for ((i=0; i<${#win_bullet_x[@]}; i++)); do
    check_collision_win_bullet ${win_bullet_x[$i]} ${win_bullet_y[$i]}
    if $win_hard_mode; then
      dlcall sh_DrawTexturef $win_bullet_texture_ptr ${win_bullet_x[$i]} ${win_bullet_y[$i]} int64:4278190080
    else
      dlcall sh_DrawTexturef $win_bullet_texture_ptr ${win_bullet_x[$i]} ${win_bullet_y[$i]} int64:4294967295
    fi
    #win_bullet_rec[x]=${win_bullet_x[$i]}
    #win_bullet_rec[y]=${win_bullet_y[$i]}
    #pack $win_bullet_rec_ptr win_bullet_rec
    #dlcall sh_DrawRectangleRec $win_bullet_rec_ptr int64:4294967295
  done
  
  win_hp[width]=float:$tentacle_hp
  pack $win_hp_ptr win_hp
  dlcall sh_DrawRectangleRec $win_hp_ptr int64:4278255360
  dlcall DrawText string:"$tentacle_hp" int:9 int:709 int:10 int64:4278190080
  dlcall DrawText string:"$tentacle_hp" int:11 int:711 int:10 int64:4278190080
  dlcall DrawText string:"$tentacle_hp" int:10 int:710 int:10 int64:4294967295
}