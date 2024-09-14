#include "raylib.h"
#include <math.h>

// For some reason this function returns garbage even though IsKeyPressed works fine,
// so as a workaround use int instead of bool
int sh_IsKeyDown(int key)
{
  return IsKeyDown(key) ? 1 : 0;
}

// Framerate independent lerp function, yoink'd from Freya Holmér
// https://youtu.be/LSNQuFEDOyQ
float lerp(float a, float b, float decay, float dt)
{
  return b+(a-b)*expf(-decay*dt);
}

float add_position(float pos, float speed, float dt)
{
  return pos + speed*dt;
}

int add_position_i(int pos, float speed, float dt)
{
  return (int)add_position((float)pos, speed, dt);
}

float sub_position(float pos, float speed, float dt)
{
  return pos - speed*dt;
}

float sub_position_cos_angle(float pos, float angle, float speed, float dt)
{
  return pos - cosf(angle)*speed*dt;
}

float sub_position_sin_angle(float pos, float angle, float speed, float dt)
{
  return pos - sinf(angle)*speed*dt;
}


int sub_position_i(int pos, float speed, float dt)
{
  return (int)sub_position((float)pos, speed, dt);
}

float deg2rad(float degrees)
{
  return degrees*DEG2RAD;
}

float angle_points(float x1, float y1, float x2, float y2)
{
  return atan2(y1-y2, x1-x2);
}

int check_collision(Rectangle *rec1, Rectangle *rec2)
{
  return CheckCollisionRecs(*rec1, *rec2) ? 1 : 0;
}