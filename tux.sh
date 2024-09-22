function load_tux_assets() {
  struct -m tux_texture_ptr Texture tux_texture
  dlcall sh_LoadTexture $tux_texture_ptr "assets/graphics/tux.png"
  unpack $tux_texture_ptr tux_texture

  struct -m bash_texture_ptr Texture bash_texture
  dlcall sh_LoadTexture $bash_texture_ptr "assets/graphics/bash_logo.png"
  unpack $bash_texture_ptr bash_texture

  struct -m tux_rec_origin_ptr Rectangle tux_rec_origin
  set_rect_values tux_rec_origin float:0.0 float:0.0 float:32.0 float:32.0
  pack $tux_rec_origin_ptr tux_rec_origin

  struct -m tux_vec_origin_ptr Vector2 tux_vec_origin
  tux_vec_origin[x]=float:16.0
  tux_vec_origin[y]=float:16.0
  pack $tux_vec_origin_ptr tux_vec_origin

  struct -m tux_rec_dest_ptr Rectangle tux_rec_dest
  set_rect_values tux_rec_dest float:100$dec_pt0 float:100$dec_pt0 float:64$dec_pt0 float:64$dec_pt0
  pack $tux_rec_dest_ptr tux_rec_dest

  struct -m tux_bullet_rect_ptr Rectangle tux_bullet_rect
  set_rect_values tux_bullet_rect float:0.0 float:0.0 float:24.0 float:24.0
  pack $tux_bullet_rect_ptr tux_bullet_rect

  struct -m tux_box_ptr Rectangle tux_box
  set_rect_values tux_box float:110.0 float:110.0 float:16.0 float:32.0
  pack $tux_box_ptr tux_box
}

function init_tux() {
  # -- Tux animation --
  tux_origin_x=0
  tux_origin_y=0
  tux_current_x=0
  tux_frame_width=32
  tux_frame_height=32
  tux_frame_delay=(40 40)
  tux_current_delay=30
  tux_delay_index=0
  tux_current_frame=0
  # -- End Tux animation --

  # -- Tux bullets --
  tux_bullet_max_delay=10
  tux_bullet_delay=0
  tux_bullets_x=()
  tux_bullets_y=()
  # -- End Tux bullets --

  tux_speed=float:200.0
  tux_bullet_speed=float:400.0
}

function set_tux_game_over() {
  tux_delay_index=0
  tux_rec_origin[x]=float:0.0
  tux_rec_origin[y]=float:64.0
  pack $tux_rec_origin_ptr tux_rec_origin
  tux_frame_delay=(40)
}

function tux_game_over_update() {
  dlcall -n screen_height -r int GetScreenHeight
  local y_pos=${tux_rec_dest[y]##*:}
  local y=${y_pos%%$dec_pt*}
  if [[ $y -lt ${screen_height##*:}+50 ]]; then
    tux_rec_dest[y]=float:$(($y + 3))
    pack $tux_rec_dest_ptr tux_rec_dest
  fi
}

function restart_tux() {
  tux_bullets_x=()
  tux_bullets_y=()
  tux_rec_origin[y]=float:0.0
  pack $tux_rec_origin_ptr tux_rec_origin
  tux_rec_dest[x]=float:100$dec_pt0
  tux_rec_dest[y]=float:100$dec_pt0
  pack $tux_rec_dest_ptr tux_rec_dest
  tux_frame_delay=(40 40)
}

function update_tux_anim() {
  tux_current_delay=$((tux_current_delay - 1))
  if [[ $tux_current_delay -le 0 ]]; then
    tux_delay_index=$((tux_delay_index + 1))
    if [[ $tux_delay_index+1 -gt ${#tux_frame_delay[@]} ]]; then
      tux_delay_index=0
    fi
    tux_current_delay=${tux_frame_delay[$tux_delay_index]}
  fi
}

function tux_movement() {
  dlcall -n dt -r float GetFrameTime
  dlcall -n screen_width -r int GetScreenWidth
  dlcall -n screen_height -r int GetScreenHeight

  dlcall -n shift_down -r int sh_IsKeyDown int:340

  if [[ $shift_down == int:1 ]]; then
    tux_speed=float:100.0
  else
    tux_speed=float:200.0    
  fi

  tux_frame_delay=(40 40)
  local pos_x=${tux_rec_dest[x]%%$dec_pt*}
  local pos_y=${tux_rec_dest[y]%%$dec_pt*}

  dlcall -n is_left_down -r int sh_IsKeyDown int:65
  if [[ $is_left_down == int:1 && ${pos_x##*:} -gt 0 ]]; then
    dlcall -n pos_x -r float sub_position ${tux_rec_dest[x]} $tux_speed $dt
    tux_rec_dest[x]=$pos_x
    pos_x=${pos_x%%$dec_pt*}
    tux_frame_delay=(15 15)
  fi

  dlcall -n is_right_down -r int sh_IsKeyDown int:68
  if [[ $is_right_down == int:1 && ${pos_x##*:} -lt $viewport_width-32 ]]; then
    dlcall -n pos_x -r float add_position ${tux_rec_dest[x]} $tux_speed $dt 
    tux_rec_dest[x]=$pos_x
    pos_x=${pos_x%%$dec_pt*}
    tux_frame_delay=(15 15)
  fi

  dlcall -n is_up_down -r int sh_IsKeyDown int:87
  if [[ $is_up_down == int:1 && ${pos_y##*:} -gt 0 ]]; then
    #pos_y=$((${pos_y##*:} - 3))
    dlcall -n pos_y -r float sub_position ${tux_rec_dest[y]} $tux_speed $dt 
    tux_rec_dest[y]=$pos_y
    pos_y=${pos_y%%$dec_pt*}
    tux_frame_delay=(15 15)
  fi

  dlcall -n is_down_down -r int sh_IsKeyDown int:83
  if [[ $is_down_down == int:1 && ${pos_y##*:} -lt $viewport_height-44 ]]; then
    #pos_y=$((${pos_y##*:} + 3))
    dlcall -n pos_y -r float add_position ${tux_rec_dest[y]} $tux_speed $dt 
    tux_rec_dest[y]=$pos_y
    pos_y=${pos_y%%$dec_pt*}
    tux_frame_delay=(15 15)
  fi
  pack $tux_rec_dest_ptr tux_rec_dest

  tux_box[x]=float:$((${pos_x##*:} + 10))
  tux_box[y]=float:$((${pos_y##*:} + 10))
  pack $tux_box_ptr tux_box
}

function tux_bullet_update() {
  dlcall -n dt -r float GetFrameTime

  if [[ $tux_bullet_delay -gt 0 ]]; then
    tux_bullet_delay=$((tux_bullet_delay - 1))
  fi

  dlcall -n is_space_down -r int sh_IsKeyDown int:32

  if [[ $is_space_down == int:1 ]]; then
    tux_rec_origin[y]=float:32.0
    pack $tux_rec_origin_ptr tux_rec_origin
  elif [[ ${tux_rec_origin[y]} == float:32.0 ]]; then
    tux_rec_origin[y]=float:0.0
    pack $tux_rec_origin_ptr tux_rec_origin
  fi

  if [[ $is_space_down == int:1 && $tux_bullet_delay == 0 ]]; then
    tux_bullet_delay=$tux_bullet_max_delay
    local pos_x=${tux_rec_dest[x]%%$dec_pt*}
    local pos_y=${tux_rec_dest[y]%%$dec_pt*}
    tux_bullets_x+=( $((${pos_x##*:} + 30)) )
    tux_bullets_y+=( $((${pos_y##*:} + 10)) )
    #struct -m bullet_pos_ptr Vector2 bullet_pos
    #bullet_pos[x]=${tux_rec_dest_ptr[x]}
    #bullet_pos[y]=${tux_rec_dest_ptr[y]}
    #pack $bullet_pos_ptr bullet_pos
    #local current_bullets=${#tux_bullets[@]}
    #tux_bullets[current_bullets]=$bullet_pos
  fi

  if [[ ${#tux_bullets_x[@]} -gt 0 ]]; then
    for ((i=0; i < ${#tux_bullets_x[@]}; i++)); do
      dlcall -n screen_width -r int GetScreenWidth
      #tux_bullets_x[i]=$((${tux_bullets_x[i]} + 5))
      dlcall -n new_pos -r int add_position_i ${tux_bullets_x[i]} $tux_bullet_speed $dt
      tux_bullets_x[i]=${new_pos##*:}
      if [[ ${new_pos##*:} -gt ${screen_width##*:} ]]; then
        unset tux_bullets_x[$i]
        unset tux_bullets_y[$i]
        tux_bullets_x=("${tux_bullets_x[@]}")
        tux_bullets_y=("${tux_bullets_y[@]}")
      fi
    done
  fi
}

function update_tux() {
  update_tux_anim
  tux_movement
  tux_bullet_update
}

function draw_tux() {
  for ((i=0; i<${#tux_bullets_x[@]}; i++)); do
    dlcall sh_DrawTexture $bash_texture_ptr int:${tux_bullets_x[i]} int:${tux_bullets_y[i]} int:4294967295
    #tux_bullet_rect[x]=float:${tux_bullets_x[$i]}
    #tux_bullet_rect[y]=float:${tux_bullets_y[$i]}
    #pack $tux_bullet_rect_ptr tux_bullet_rect
    #dlcall sh_DrawRectangleRec $tux_bullet_rect_ptr int64:4278190335
  done
  tux_rec_origin[x]=float:$((tux_delay_index * tux_frame_width))
  pack $tux_rec_origin_ptr tux_rec_origin
  dlcall sh_DrawTexturePro $tux_texture_ptr $tux_rec_origin_ptr $tux_rec_dest_ptr $tux_vec_origin_ptr float:0.0 int64:4294967295

  #dlcall sh_DrawRectangleRec $tux_box_ptr int64:4294967295
}