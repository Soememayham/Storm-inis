/// SCRIPT_TINI_BATTLE_ANIM(anim)
/// TINI-only animator for full sheets; uses xscale to face left/right.
function SCRIPT_TINI_BATTLE_ANIM(anim)
{
    var st       = anim.state;      // 0 idle, 1 walk, 2 attack, 3 hurt, 4 dead
    var just_hit = anim.just_hit;
    var dead     = anim.dead;

    var sIdle    = anim.spr_idle;
    var sWalk    = anim.spr_walk;
    var sAttack  = anim.spr_attack;

    // Death/Hurt fallback (no special sprites yet)
    if (dead)     { sprite_index = sIdle;  image_speed = 0; return; }
    if (just_hit) { sprite_index = sIdle;  image_speed = 0; return; }

    // Nervous bounce idle; regular walk; faster attack
    switch (st) {
        case 1:  sprite_index = sWalk;   image_speed = 0.22; break; // walk
        case 2:  sprite_index = sAttack; image_speed = 0.35; break; // attack
        default: sprite_index = sIdle;   image_speed = 0.14; break; // idle bounce
    }

}
