/// @function SCRIPT_ENEMY_HIT_PLAYER(attacker, target, dir)
/// @desc Enemy single-strike: apply damage + medium knockback to player
function SCRIPT_ENEMY_HIT_PLAYER(_attacker, _target, _dir)
{
    if (!instance_exists(_attacker) || !instance_exists(_target)) return;

    // Damage calc
    var raw = (variable_instance_exists(_attacker, "stats") && variable_struct_exists(_attacker.stats, "atk"))
              ? _attacker.stats.atk : 4;
    var def = (variable_instance_exists(_target, "stats") && variable_struct_exists(_target.stats, "def"))
              ? _target.stats.def : 0;
    var dmg = max(1, raw - def);

    // Apply damage
    if (variable_instance_exists(_target, "stats")) {
        _target.stats.hp = max(0, _target.stats.hp - dmg);
    }
    _target.just_hit = true;

    // Medium knockback impulse (directly add to player's velocity)
    var kb_spd = 6.0; // "medium" feel; tweak if needed
    _target.vx += lengthdir_x(kb_spd, _dir);
    _target.vy += lengthdir_y(kb_spd, _dir);

    // Show damage number
    if (is_undefined(SCRIPT_SHOW_DAMAGE) == false) {
        SCRIPT_SHOW_DAMAGE(dmg, _target.x, _target.y - 16, c_yellow);
    }
}
