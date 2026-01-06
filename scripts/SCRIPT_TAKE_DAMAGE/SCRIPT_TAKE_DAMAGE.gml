/// SCRIPT_TAKE_DAMAGE(attacker, target, dmg, kb_speed, kb_dur)
function SCRIPT_TAKE_DAMAGE(attacker, target, dmg, kb_speed, kb_dur) {
    if (!instance_exists(target)) return;

    // i-frames guard
    if (variable_instance_exists(target, "ifr_time") && target.ifr_time > 0) return;

    // DEF
    var t_def = 0;
    if (variable_instance_exists(target, "stats") && is_struct(target.stats) && variable_struct_exists(target.stats, "def")) {
        t_def = max(0, target.stats.def);
    }

    var base  = max(1, dmg);
    var roll  = irandom_range(0, max(1, t_def));
    var final = max(1, base - roll);

    // ensure hp fields
    if (!variable_instance_exists(target, "stats")) target.stats = {};
    if (!variable_struct_exists(target.stats, "hp"))     target.stats.hp = 1;
    if (!variable_struct_exists(target.stats, "hp_max")) target.stats.hp_max = target.stats.hp;

    target.stats.hp = max(0, target.stats.hp - final);

    // knockback
    if (kb_speed > 0) {
        var dir = instance_exists(attacker) ? point_direction(attacker.x, attacker.y, target.x, target.y) : 0;
        target.kb_dir = dir;
        target.kb_spd = kb_speed;
        target.kb_t   = kb_dur;
    }

    // i-frames start
    target.ifr_time = variable_instance_exists(target, "ifr_max") ? target.ifr_max : 0.2;
}
