#include "raylib.h"

void newRect(Rectangle *rec, float x, float y, float width, float height)
{
	rec->x = x;
	rec->y = y;
	rec->width = width;
	rec->height = height;
}

void sh_DrawRectangleRec(Rectangle *rec, Color color)
{
	//printf("%f %f %f %f\n", rec->x, rec->y, rec->width, rec->height);
	DrawRectangleRec(*rec, color);
}

void sh_DrawRectangleLines(int x, int y, int width, int height, float thick, Color tint)
{
	DrawRectangleLinesEx((Rectangle){x, y, width, height}, thick, tint);
}

int sh_CheckCollisionPointRec(int x, int y, int recX, int recY, int width, int height)
{
	return CheckCollisionPointRec((Vector2){x, y}, (Rectangle){recX, recY, width, height}) ? 1 : 0;
}