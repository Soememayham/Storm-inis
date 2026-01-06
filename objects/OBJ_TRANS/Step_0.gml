if trans_in != ""
{
	time_in-- 
	
	if sprite_index != trans_in
	{
		
		sprite_index = trans_in
		
	}
	
	if time_in <= 0
	{
		trans_in = ""
			room_goto(Room1)
	}
	
	if fade_trans == true and image_alpha < 1
	{
		image_alpha += .01
	}
}


// Fade out logic (if needed)
if trans_in == "" and trans_out != ""
{
		time_out --
	
	if instance_exists(OBJ_CHAR_OVERWORLD)
		{
			OBJ_CHAR_OVERWORLD.x = OBJ_CHAR_OVERWORLD_x;
			OBJ_CHAR_OVERWORLD.y = OBJ_CHAR_OVERWORLD_y;
		}

	if sprite_index != trans_out
		{
			image_speed = 1;
			image_index = 0;
			sprite_index = trans_out;
		}

	if fade_trans == true and image_alpha > 0 
		{
			image_alpha-=.01
		}

	if time_out <= 0
		{
			trans_out = ""
				instance_destroy();
		}
}