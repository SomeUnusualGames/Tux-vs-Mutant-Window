function init_background() {
  n_stars=$1
  stars_x=()
  stars_y=()
  dlcall -n screen_width -r int GetScreenWidth
  dlcall -n screen_height -r int GetScreenHeight
  for ((i=0; i < $n_stars; i++)); do
    stars_x+=( $(random 0 $viewport_width) )
    stars_y+=( $(random 0 $viewport_height) )
  done
}

function draw_background() {
  for ((i=0; i < $n_stars; i++)); do
    dlcall DrawPixel ${stars_x[$i]} ${stars_y[$i]} int64:4294967295
  done
}