#include "raylib.h"

void sh_LoadTexture(struct Texture *texture, char *filename)
{
  *texture = LoadTexture(filename);
}

void sh_DrawTexture(Texture2D *texture, int x, int y, Color color)
{
  DrawTexture(*texture, x, y, color);
}

void sh_DrawTexturef(Texture2D *texture, float x, float y, Color color)
{
  DrawTexture(*texture, (int)x, (int)y, color);
}

void sh_DrawTexturePro(Texture2D *texture, Rectangle *source, Rectangle *dest, Vector2 *origin, float rotation, Color tint)
{
  DrawTexturePro(*texture, *source, *dest, *origin, rotation, tint);
}

void sh_DrawTextureV(Texture2D *texture, Vector2 *position, Color tint)
{
  DrawTextureV(*texture, *position, tint);
}