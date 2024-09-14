set -e

function init_window() {
  # FLAG_VSYNC_HINT | FLAG_WINDOW_RESIZABLE
  dlcall SetConfigFlags int:68
  dlcall InitWindow int:$1 int:$2 string:$3
  dlcall SetTargetFPS int:60
  dlcall SetWindowMinSize int:320 int:240
}

function begin_drawing() {
  dlcall BeginDrawing
  dlcall ClearBackground $1
}

function end_drawing() {
  dlcall EndDrawing
}