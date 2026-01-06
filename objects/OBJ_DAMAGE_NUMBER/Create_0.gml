/// Create Event
life = 0.8;                  // seconds before disappearing
move_speed = 0.5;            // upward speed
fade_speed = 1.0 / (room_speed * life);
image_alpha = 1;             // start fully visible
gravity = 0;                 // optional, can be used for arc motion
hspeed = random_range(-0.2, 0.2); // small horizontal drift
vspeed = -move_speed;        // float up

text = "";                   // damage value (set when created)
color = c_white;             // default color (can be red for damage, green for heal)
//font = fnt_damage;           // optional, assign your damage font BUILD A FONT ASAP MF
