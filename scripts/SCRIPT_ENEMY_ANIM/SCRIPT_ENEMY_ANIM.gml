/// @desc Simple enemy animation handler
/// @param state      (0=idle, 1=walk, 2=attack, 3=hurt, 4=dead)
/// @param obj        (enemy instance itself)

function SCRIPT_ENEMY_ANIM(_state, _obj) {

    switch (_state) {

        // 🟦 Idle
        case 0:
            _obj.sprite_index = _obj.spr_idle;
            _obj.image_speed = 0.15;
            break;

        // 🟩 Walk
        case 1:
            _obj.sprite_index = _obj.spr_walk;
            _obj.image_speed = 0.20;
            break;

        // 🟥 Attack
        case 2:
            _obj.sprite_index = _obj.spr_attack;
            _obj.image_speed = 0.40;
            break;

        // 🟨 Hurt (no sprite yet — just flash red)
        case 3:
            _obj.image_blend = c_red;
            break;

        // 🟫 Dead (no sprite yet — destroy)
        case 4:
            instance_destroy(_obj.id);
            break;
    }
}
