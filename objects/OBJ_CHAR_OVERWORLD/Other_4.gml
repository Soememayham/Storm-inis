/// OBJ_CHAR_OVERWORLD -> Room Start
// Make sure the manager exists
if (!variable_global_exists("Game") || !instance_exists(global.Game)) {
    global.Game = instance_create_layer(0, 0, "Instances", OBJ_Game);
}
var G = global.Game;

// Pull saved position; provide smart fallbacks
var px = G.player.ow_x;
var py = G.player.ow_y;

// Optional default spawn marker:
// drop an instance of OBJ_SPAWN_POINT in your overworld room where you want the first spawn.
// If there’s no saved pos yet (0,0), use the marker; else use room center.
if ((px == 0 && py == 0) || is_undefined(px) || is_undefined(py)) {
    if (instance_exists(OBJ_SPAWN_POINT)) {
        var sp = instance_find(OBJ_SPAWN_POINT, 0);
        px = sp.x; py = sp.y;
    } else {
        px = room_width * 0.5;
        py = room_height * 0.5;
    }
}

// Move this instance to the target spot
x = px; 
y = py;

// Nudge to nearest free spot so we never spawn inside walls
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
var pos = _find_free(x, y, 64, 8);
x = pos[0]; 
y = pos[1];

// Point the camera at this player if you use follow_id
G.follow_id = id;

// Debug so we can verify what’s happening
show_debug_message("[OVERWORLD] placed at (" + string(x) + "," + string(y) + 
                   "), saved=(" + string(G.player.ow_x) + "," + string(G.player.ow_y) + ")");
