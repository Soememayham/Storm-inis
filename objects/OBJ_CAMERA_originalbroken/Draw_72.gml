/// OBJ_CAMERA_original -> Draw Begin

// 1) Resolve a target OR a safe fallback (room center)
var tx = room_width * 0.5;
var ty = room_height * 0.5;

if (variable_global_exists("Game") && instance_exists(global.Game) && instance_exists(global.Game.follow_id)) {
    var f = global.Game.follow_id;
    if (instance_exists(f)) { tx = f.x; ty = f.y; }
} else if (instance_exists(OBJ_CHAR_OVERWORLD)) {
    var ow = instance_find(OBJ_CHAR_OVERWORLD, 0); tx = ow.x; ty = ow.y;
} else if (instance_exists(OBJ_PL_MINI_BATTLE)) {
    var pl = instance_find(OBJ_PL_MINI_BATTLE, 0); tx = pl.x; ty = pl.y;
}

// 2) Smooth follow (optional)
if (cx == 0 && cy == 0) { cx = tx; cy = ty; }
var k = 0.15;
cx += (tx - cx) * k;
cy += (ty - cy) * k;

// 3) Build view/projection (IMPORTANT: POSITIVE FOV & aspect)
var xto = cx, yto = cy, zto = 0;
var xfrom = cx, yfrom = cy + 150, zfrom = 75;

var cam = camera_get_active();
camera_set_view_mat(cam, matrix_build_lookat(xfrom, yfrom, zfrom, xto, yto, zto, 0, 0, 1));
camera_set_proj_mat(cam, matrix_build_projection_perspective_fov(
    60, // POSITIVE FOV
    window_get_width() / window_get_height(), // POSITIVE aspect
    1, 4000
));
camera_apply(cam);

// 4) Prep 3D state for diorama draws
draw_clear(c_black);
gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);



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

