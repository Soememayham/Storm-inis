
shader_set(SHD_Diorama);
with (PAR_OBJ) {
	event_perform(ev_draw, 0);
}
shader_reset();

/* Pick a valid target (overworld first, then battle pawn)
var targ = noone;
if (instance_exists(OBJ_CHAR_OVERWORLD)) {
    targ = instance_find(OBJ_CHAR_OVERWORLD, 0);
} else if (instance_exists(OBJ_PL_MINI_BATTLE)) {
    targ = instance_find(OBJ_PL_MINI_BATTLE, 0);
}

// If no target, bail out of Draw to avoid errors
if (targ == noone) exit;

// Use targ.* instead of OBJ_CHAR_OVERWORLD.*
var xto = targ.x;
var yto = targ.y;
var zto = 0;

// if you also use "from" position:
var xfrom = targ.x;
var yfrom = targ.y + 150;
var zfrom = 75;

// ...rest of your camera code (view/proj matrices, etc.)
