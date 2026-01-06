/// @function SCRIPT_HIT_ENEMY(attacker, dir, frame_local)
/// @desc Per-frame multi-hit with weakened knockback
/// @param attacker    instance id of player
/// @param dir         attack direction in degrees
/// @param frame_local local frame 0..17 within facing half
function SCRIPT_HIT_ENEMY(_attacker, _dir, _frame_local)
{
    if (!instance_exists(_attacker)) return;

    // Tunables
    var reach   = 22;     // hit origin distance in front of attacker
    var arc_w   = 12;     // hit radius
    var kb_base = 220;    // base knockback (first hit)
    var dmg_min = 1;

    // Hit origin
    var hx = _attacker.x + lengthdir_x(reach, _dir);
    var hy = _attacker.y + lengthdir_y(reach, _dir);

    // Gather targets
    var list = ds_list_create();
    collision_circle_list(hx, hy, arc_w, OBJ_ENEMY_MINI_BATTLE, false, true, list, true);

    // Per-frame stamp avoids duplicate hits on the same enemy within the same frame
    var stamp = string(_attacker.id) + "_" + string(_frame_local);

    // Knockback weakening with hits in THIS attack
    if (!variable_instance_exists(_attacker, "attack_hits")) _attacker.attack_hits = 0;
    var hits_so_far = _attacker.attack_hits;
    var kb_mult = max(0.25, 1 - (0.25 * hits_so_far)); // 100%, 75%, 50%, 25%...

    for (var i = 0; i < ds_list_size(list); i++)
    {
        var e = list[| i];
        if (!instance_exists(e)) continue;

        if (variable_instance_exists(e, "last_hit_stamp") && e.last_hit_stamp == stamp) continue;

        // Ensure stats
        if (!variable_instance_exists(e, "stats")) e.stats = { hp:10, hp_max:10, atk:2, def:0, spd:100 };
        if (!variable_struct_exists(e.stats, "hp"))  e.stats.hp = 10;
        if (!variable_struct_exists(e.stats, "def")) e.stats.def = 0;

        // Damage basic calc
        var raw = (variable_instance_exists(_attacker, "stats") && variable_struct_exists(_attacker.stats, "atk"))
                  ? _attacker.stats.atk : 3;
        var dmg = max(dmg_min, raw - e.stats.def);

        // Apply damage
        e.stats.hp = max(0, e.stats.hp - dmg);
        e.just_hit = true;

        // Knockback to enemy (consumed in enemy Step if you implemented it)
        if (!variable_instance_exists(e, "kb_t"))   e.kb_t = 0;
        if (!variable_instance_exists(e, "kb_spd")) e.kb_spd = 0;
        if (!variable_instance_exists(e, "kb_dir")) e.kb_dir = 0;

        e.kb_t   = 0.12;
        e.kb_spd = kb_base * kb_mult;
        e.kb_dir = _dir;

        // Damage numbers (optional)
        if (is_undefined(SCRIPT_SHOW_DAMAGE) == false) {
            SCRIPT_SHOW_DAMAGE(dmg, e.x, e.y - 16, c_red);
        }

        e.last_hit_stamp = stamp;
        _attacker.attack_hits += 1;
    }

    ds_list_destroy(list);
}
