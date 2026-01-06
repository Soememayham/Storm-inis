var dt = clamp(delta_time * 0.000001, 0, 0.05);
timer += dt;

// Every interval, top up population
if (timer >= spawn_check_interval) {
    timer = 0;

    var count = instance_number(OBJ_ENEMY);
    if (count < max_enemies) {
        // Random position away from player
        var tries = 0;
        while (tries < 15) {
            var rx = irandom(room_width - 1);
            var ry = irandom(room_height - 1);

            var pl = (is_undefined(global.player) || !instance_exists(global.player)) ? noone : global.player;
            var ok = true;

            if (pl != noone) {
                if (point_distance(rx, ry, pl.x, pl.y) < 220) ok = false; // don't spawn on top of player
            }

            // Optional: prevent solid tiles / walls, etc.
            if (ok /* && position_is_okay(rx,ry) */) {
                var e = instance_create_layer(rx, ry, "Instances", OBJ_ENEMY);
                // Seed encounter settings (region by room or global)
                e.region       = is_undefined(global.overworld_region) ? "plains" : string(global.overworld_region);
                e.encounter_id = choose(1,2,3); // or weight per region
                e.min_group    = 1;
                e.max_group    = choose(2,3);   // small groups
                break;
            }
            tries++;
        }
    }
}
