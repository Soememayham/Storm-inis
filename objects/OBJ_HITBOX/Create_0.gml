if (is_undefined(life_s)) life_s = 0.10;
alarm[0] = max(1, round(life_s * room_speed));
image_alpha = 0; // invisible collider (use a sprite if you want)
