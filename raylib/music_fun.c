#include "raylib.h"
#include <stdbool.h>
#include <stdlib.h>

void sh_LoadMusicStream(Music *music, char *path, int loop)
{
    *music = LoadMusicStream(path);
    music->looping = loop == 1 ? true : false;
}

void sh_PlayMusicStream(Music *music)
{
    PlayMusicStream(*music);
}

void sh_UpdateMusicStream(Music *music)
{
    UpdateMusicStream(*music);
}

void sh_StopMusicStream(Music *music)
{
    StopMusicStream(*music);
}

void sh_UnloadMusicStream(Music *music)
{
    UnloadMusicStream(*music);
    free(music);
}

int sh_IsMusicStreamPlaying(Music *music)
{
    return IsMusicStreamPlaying(*music) ? 1 : 0;
}