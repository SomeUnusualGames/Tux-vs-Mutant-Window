#include "raylib.h"

#define MAX(a, b) ((a)>(b)? (a) : (b))
#define MIN(a, b) ((a)<(b)? (a) : (b))

void sh_LoadRenderTexture(struct RenderTexture *texture, int width, int height)
{
  //texture = malloc(sizeof(Texture2D));
  *texture = LoadRenderTexture(width, height);
  //return texture;
}

void sh_BeginTextureMode(struct RenderTexture *texture)
{
  BeginTextureMode(*texture);
}

void sh_SetTextureFilter(struct RenderTexture *target)
{
  SetTextureFilter(target->texture, TEXTURE_FILTER_BILINEAR);
}

void sh_DrawRenderTexture(struct RenderTexture *target, int gameScreenWidth, int gameScreenHeight)
{
  float scale = MIN((float)GetScreenWidth()/gameScreenWidth, (float)GetScreenHeight()/gameScreenHeight);
  DrawTexturePro(
    target->texture,
    (Rectangle){ 0.0f, 0.0f, (float)target->texture.width, (float)-target->texture.height },
    (Rectangle){
      (GetScreenWidth() - ((float)gameScreenWidth*scale))*0.5f,
      (GetScreenHeight() - ((float)gameScreenHeight*scale))*0.5f,
      (float)gameScreenWidth*scale, (float)gameScreenHeight*scale
    },
    (Vector2){ 0, 0 },
    0.0f, WHITE
  );
}