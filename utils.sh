function include_files() {
  local files=(
    libraylib.so.5.0.0
    #libraylib.so.5.5.0
    music_fun.so
    utils.so
    rectangle_fun.so
    texture_fun.so
    rendertexture_fun.so
  )
  for file in "${files[@]}"; do
    if ! dlopen ./raylib/$file; then
      echo $file could not be loaded
      exit 1
    fi
  done
}

function set_rect_values() {
  eval "$1[x]=$2 && $1[y]=$3 && $1[width]=$4 && $1[height]=$5";
}

function random() {
  echo $(($1 + $(od -An -N2 -d /dev/urandom) % $2))
}

function execute_awk_uah() {
  awk 'BEGIN{ printf('"$1"') }'
}