// --- delta-time (seconds) for stable speed across FPS
// --- delta-time (seconds)
var dt = clamp(delta_time * 0.000001, 0, 0.05);

// --- raw input (intent first; collisions later)
var ix = keyboard_check(vk_right) - keyboard_check(vk_left);
var iy = keyboard_check(vk_down)  - keyboard_check(vk_up);

// normalize diagonal so diagonals aren’t faster
var len = sqrt(ix*ix + iy*iy);
var inputMagnitude = (len > 0);
if (len > 0) { ix /= len; iy /= len; }

// target velocity
var tx = inputMagnitude ? ix * move_speed : 0;
var ty = inputMagnitude ? iy * move_speed : 0;

// accelerate/decelerate toward target
var ax = (abs(tx) > abs(vx)) ? accel_rate : decel_rate;
var ay = (abs(ty) > abs(vy)) ? accel_rate : decel_rate;

var step_x = ax * dt;
var diff_x = tx - vx;
vx = (abs(diff_x) <= step_x) ? tx : (vx + sign(diff_x) * step_x);

var step_y = ay * dt;
var diff_y = ty - vy;
vy = (abs(diff_y) <= step_y) ? ty : (vy + sign(diff_y) * step_y);

// proposed motion
var mx = vx * dt;
var my = vy * dt;

// --- move & collide with place_free (no solid object needed)
x += mx;
if (!place_free(x, y)) {
    var sx = sign(mx);
    while (!place_free(x - sx, y)) x -= sx;
    vx = 0;
}

y += my;
if (!place_free(x, y)) {
    var sy = sign(my);
    while (!place_free(x, y - sy)) y -= sy;
    vy = 0;
}

// --- facing / sprite logic
var _oldsprite = sprite_index;
if (inputMagnitude) {
    var inputDirection = point_direction(0, 0, ix, iy);
    direction   = inputDirection;
    sprite_index = spr_walk;
    _lastdir    = direction;
} else {
    sprite_index = spr_idle;
    direction    = _lastdir; // safe: _lastdir is initialized in Create
}

if (_oldsprite != sprite_index) localFrame = 0;

// optional: tiny idle friction so it settles fully when no input
if (!inputMagnitude) {
    var idle_friction = 60 * dt;
    vx = (abs(vx) < idle_friction) ? 0 : (vx - sign(vx) * idle_friction);
    vy = (abs(vy) < idle_friction) ? 0 : (vy - sign(vy) * idle_friction);
}

// your animation script
SCRIPT_PLAYERANIM();


//if (keyboard_check_pressed(ord("B"))) {
//    var estats = { name:"Mimic", hp:12, hp_max:12, atk:4, def:1, spd:140 };
//    OBJ_Game.start_battle(estats);
//}
















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