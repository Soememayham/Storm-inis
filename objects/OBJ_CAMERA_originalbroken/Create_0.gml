/// OBJ_CAMERA_original : Create

// Window / application surface (keep these if you want a fixed 1600x900 game view)
window_set_size(1600, 900);
surface_resize(application_surface, 1600, 900);
window_center();

// Optional: force classic depth sorting for legacy layers (fine to keep or remove)
layer_force_draw_depth(true, 0);

// Draw the camera FIRST each frame so everyone renders with a valid projection
depth = -100000;

// Smooth-follow accumulators
cx = 0;
cy = 0;


//cam_x = OBJ_CHAR_OVERWORLD;
//cam_y = OBJ_CHAR_OVERWORLD + 150;
//cam_z = 75;