/// @desc Creates a floating damage number
/// @param value
/// @param x
/// @param y
/// @param color
function SCRIPT_SHOW_DAMAGE(_val, _x, _y, _color) {
    var dmg = instance_create_layer(_x, _y, "Effects", OBJ_DAMAGE_NUMBER);
    dmg.text  = string(_val);
    dmg.color = _color;
//    dmg.font  = fnt_damage;  // optional
    return dmg;
}
