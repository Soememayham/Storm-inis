/// Actual movement 

right_key = keyboard_check(vk_right);
left_key = keyboard_check(vk_left);
up_key = keyboard_check(vk_up);
down_key = keyboard_check(vk_down);

xspeed = (right_key - left_key) * move_speed;
yspeed = (down_key - up_key) * move_speed;


//Piss off you wanker 
//Nah fr though collisions 

if place_meeting( x + xspeed, y, OBJ_BARRIER) == true
	{
	xspeed = 0;
	}
if place_meeting( x, y + yspeed, OBJ_BARRIER) == true
	{
	yspeed = 0;
	}


x += xspeed;
y += yspeed;