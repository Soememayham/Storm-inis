/// OBJ_OVERWORLD_SPAWN -> Room Start

// Ensure the manager exists
if (!variable_global_exists("Game") || !instance_exists(global.Game)) {
    global.Game = instance_create_layer(0, 0, "Instances", OBJ_Game);
}
var G = global.Game;

// Pull saved position (fallback 0,0)
var px = is_undefined(G.player.ow_x) ? 0 : G.player.ow_x;
var py = is_undefined(G.player.ow_y) ? 0 : G.player.ow_y;

// Spawn or move the overworld player
var pl;
if (!instance_exists(OBJ_CHAR_OVERWORLD)) {
    pl = instance_create_layer(px, py, "Instances", OBJ_CHAR_OVERWORLD);
} else {
    pl = instance_find(OBJ_CHAR_OVERWORLD, 0);
    pl.x = px; pl.y = py;
}

// (Optional) nudge to nearest free spot so we never spawn inside walls
function _find_free(_x, _y, _r_max, _step) {
    if (place_free(_x, _y)) return [_x, _y];
    var r = _step, a, ax, ay;
    while (r <= _r_max) {
        a = 0;
        while (a < 360) {
            ax = _x + lengthdir_x(r, a);
            ay = _y + lengthdir_y(r, a);
            if (place_free(ax, ay)) return [ax, ay];
            a += 15;
        }
        r += _step;
    }
    return [_x, _y];
}
var pos = _find_free(pl.x, pl.y, 64, 8);
pl.x = pos[0]; pl.y = pos[1];

// Point the camera at this player (if your camera reads follow_id)
G.follow_id = pl;
