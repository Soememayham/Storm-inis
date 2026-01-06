var c_bottom = make_color_rgb(0, 0, 0);
var c_top = make_color_rgb(sprite_height, 0, 0);
draw_sprite_general(sprite_index, 0, 0, 0, sprite_width, sprite_height, x, y, 1, 1, 0, c_top, c_top, c_bottom, c_bottom, 1);


//New Code 
/*
/// PAR_OBJ -> Draw  (animated + diorama-safe + gradient)

// define gradient/tint colors (locals)
var c_top    = c_white;   // e.g., make_color_rgb(255,230,230)
var c_bottom = c_white;   // e.g., make_color_rgb(255,255,255)

// save world matrix, add tiny z-bias so we sit above the floor
var __mw_prev = matrix_get(matrix_world);
var __mw      = matrix_build(x, y, 0.02, 0, 0, 0, 1, 1, 1); // 2 cm above ground
matrix_set(matrix_world, __mw);

// draw the CURRENT frame with CURRENT transform
draw_sprite_general(
    sprite_index, image_index,
    0, 0, sprite_width, sprite_height,
    0, 0,
    image_xscale, image_yscale, image_angle,
    c_top, c_top, c_bottom, c_bottom,
    image_alpha
);

// restore world matrix
matrix_set(matrix_world, __mw_prev);

var c_bottom = make_color_rgb(0, 0, 0);
var c_top = make_color_rgb(sprite_height, 0, 0);
draw_sprite_general(sprite_index, 0, 0, 0, sprite_width, sprite_height, x, y, 1, 1, 0, c_top, c_top, c_bottom, c_bottom, 1);




