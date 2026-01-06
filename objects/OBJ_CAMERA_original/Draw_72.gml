/// OBJ_CAMERA_original -> Draw

// Pick a valid follow target (overworld first, then battle pawn)
var targ = noone;
if (instance_exists(OBJ_CHAR_OVERWORLD)) {
    targ = instance_find(OBJ_CHAR_OVERWORLD, 0);
} else if (instance_exists(OBJ_PL_MINI_BATTLE)) {
    targ = instance_find(OBJ_PL_MINI_BATTLE, 0);
}

// If no target, skip drawing camera stuff this frame
if (targ == noone) exit;

// Use targ.* from here on (do NOT reference OBJ_CHAR_OVERWORLD.* directly)
var xto = targ.x;
var yto = targ.y;
var zto = 0;

var xfrom = targ.x;
var yfrom = targ.y + 150;
var zfrom = 75;

// --- your existing camera code below ---
var camera = camera_get_active();
camera_set_view_mat(camera, matrix_build_lookat(xfrom, yfrom, zfrom, xto, yto, zto, 0, 0, 1));
camera_set_proj_mat(camera, matrix_build_projection_perspective_fov(-60, -window_get_width() / window_get_height(), 1, 1000));
camera_apply(camera);

// whatever you already do after this (clear, shaders, drawing, etc.)

draw_clear(c_black);
gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);
gpu_set_alphatestenable(true);
gpu_set_alphatestenable(254);




/*

var xto = OBJ_CHAR_OVERWORLD.x;
var yto = OBJ_CHAR_OVERWORLD.y;
var zto = 0;



var xfrom = OBJ_CHAR_OVERWORLD.x;
var yfrom = OBJ_CHAR_OVERWORLD.y + 150;
var zfrom = 75;

var camera = camera_get_active();
camera_set_view_mat(camera, matrix_build_lookat(xfrom, yfrom, zfrom, xto ,yto, zto, 0, 0, 1));
camera_set_proj_mat(camera, matrix_build_projection_perspective_fov(-60, -window_get_width() / window_get_height(), 1, 1000));
camera_apply(camera);

