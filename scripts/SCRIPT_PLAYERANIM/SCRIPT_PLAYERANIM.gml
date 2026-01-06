// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function SCRIPT_PLAYERANIM(){
var _cardinalDirection = round(direction / 180) % 2;
var _totalFrames = sprite_get_number(sprite_index)/2;
image_index = localFrame + (_cardinalDirection * _totalFrames);
localFrame += sprite_get_speed(sprite_index) / FRAME_RATE;

// Animation loop on next game step
if (localFrame >= _totalFrames)
{
	animationEnd = true;
	localFrame = 0;
	//localFrame -= _totalFrames;
} else animationEnd = false;
}