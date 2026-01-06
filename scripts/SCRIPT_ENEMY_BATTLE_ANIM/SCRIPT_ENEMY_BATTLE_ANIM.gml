/// @desc Directional enemy animation (right & left sheet)
/// @param spr       (sprite to use)
/// @param state     (0=idle,1=walk,2=attack)
/// @param dir_deg   (direction in degrees)

function SCRIPT_ENEMY_BATTLE_ANIM(_spr, _state, _dir_deg)
{
    sprite_index = _spr;

    // === Image speed per state ===
    switch (_state) {
        case 0: image_speed = 0.15; break; // idle
        case 1: image_speed = 1; break; // walk
        case 2: image_speed = 0.5; break; // attack
    }

    // === Direction slicing (right half / left half) ===
    var total_frames = sprite_get_number(_spr);
    var half = total_frames div 2;

    // Right-facing (0 to 180)
    if (_dir_deg <= 90 || _dir_deg >= 270) {
        image_index = image_index mod half;
    }
    // Left-facing (180-360)
    else {
        image_index = (image_index mod half) + half;
    }
}
