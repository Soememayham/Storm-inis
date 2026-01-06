/// Step Event
y += vspeed;
x += hspeed;

// fade out
image_alpha -= fade_speed;
if (image_alpha <= 0) instance_destroy();
