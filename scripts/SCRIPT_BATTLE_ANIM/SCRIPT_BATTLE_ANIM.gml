/// SCRIPT_BATTLE_ANIM(anim)
function SCRIPT_BATTLE_ANIM(anim)
{
    // === Helper Functions ===
    function _has(_s, _k)     { return is_struct(_s) && variable_struct_exists(_s, _k); }
    function _get(_s, _k, _d) { return _has(_s, _k) ? variable_struct_get(_s, _k) : _d; }

    // === Force reset from attack (Player Unfreeze) ===
    if (_get(anim, "anim_force_reset", false)) {
        anim.anim_force_reset = false;
        image_index = 0;
        return;
    }

    function _set(_spr, _spd)
    {
        if (_spr != -1 && sprite_index != _spr) {
            sprite_index = _spr;
            image_index  = 0;
        }
        image_speed = _spd;
    }

    // === Read Animation Context ===
    var st         = _get(anim, "state", 0);
    var facing     = _get(anim, "facing", 0);
    var dead       = _get(anim, "dead", false);
    var just_hit   = _get(anim, "just_hit", false);
    var speed_norm = clamp(_get(anim, "speed_norm", 0), 0, 1);
    var phase      = _get(anim, "attack_phase", 0);

    var sIdle   = _get(anim, "spr_idle",   sprite_index);
    var sRun    = _get(anim, "spr_run",    sIdle);
    var sAttack = _get(anim, "spr_attack", sRun);
    var sHurt   = _get(anim, "spr_hurt",   sIdle);
    var sDie    = _get(anim, "spr_die",    sHurt);

    // === No xscale flipping; we manually slice left/right frames ===
    image_xscale = 1;

    // === PRIORITY CHECKS ===
    if (dead)     { _set(sDie, 1); return; }
    if (just_hit) { _set(sHurt, 1); return; }

    // === STATE MACHINE ===
    switch (st)
    {
        case 1: _set(sRun, 0.35 + 0.65 * speed_norm); break;
        case 2:
            var spd = 0.8;
            if (phase == 1) spd = 1.0;
            if (phase == 2) spd = 0.9;
            if (phase == 3) spd = 0.5;
            _set(sAttack, spd);
            break;
        case 3: _set(sHurt, 1); break;
        case 4: _set(sDie, 1);  break;
        default: _set(sIdle, 0.8); break;
    }

    // === DIRECTIONAL FRAME SLICING ===
    var total_frames = sprite_get_number(sprite_index);
    var half_frames  = total_frames div 2;
    if (half_frames > 0)
    {
        var dir_is_left = (facing > 90 && facing < 270);
        if (dir_is_left) {
            image_index = (image_index mod half_frames) + half_frames;
        } else {
            image_index = image_index mod half_frames;
        }
    }
}
