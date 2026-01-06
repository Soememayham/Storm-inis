 /// Actual movement 

right_key = keyboard_check(vk_right) && place_free(x + collisionSpeed, y);
left_key = keyboard_check(vk_left) && place_free(x - collisionSpeed, y);
up_key = keyboard_check(vk_up) && place_free(x, y - collisionSpeed);
down_key = keyboard_check(vk_down) && place_free(x, y + collisionSpeed);

inputDirection = point_direction(0, 0, right_key-left_key, down_key-up_key);
inputMagnitude = (right_key - left_key != 0) || (down_key - up_key != 0);
_lastdir = direction;

xspeed = lengthdir_x(inputMagnitude * move_speed, inputDirection);
yspeed = lengthdir_y(inputMagnitude * move_speed, inputDirection);

x += xspeed;
y += yspeed;

//Update sprite index 
var _oldsprite = sprite_index;
if (inputMagnitude != 0)
{
	direction = inputDirection
	sprite_index = spritewalk;
	_lastdir = direction;
} else sprite_index = spriteIdle;
if(inputMagnitude = 0) direction = _lastdir;
if (_oldsprite != sprite_index) localFrame = 0;

SCRIPT_PLAYERANIM();















//OLD CODE
//Piss off you wanker 
//Nah fr though collisions 
//if place_meeting( x + xspeed, y, OBJ_BARRIER) == true
//{
	//xspeed = 0;
	//}
//if place_meeting( x, y + yspeed, OBJ_BARRIER) == true
	//{
//yspeed = 0;
//}
























//Set sprite
//mask_index = spritewalk;
//if yspeed == 0
//{
//if xspeed > 0 {spritewalk = RIGHT}
//if xspeed < 0 {spritewalk = LEFT};
//}
//if xspeed > 0 && face == LEFT {face = RIGHT};
//if xspeed < 0 && face == RIGHT {face = LEFT};

//if xspeed > 0 {face = right}
//if xspeed < 0 {face = left};
//sprite_index = sprite[face];

//xspeed = lengthdir_x(right_key - left_key) * move_speed;
//yspeed = lengthdir_y(down_key - up_key) * move_speed;