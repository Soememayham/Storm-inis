/// OBJ_OVERWORLD_CTRL — Room Start
/// Restore Player if returning from battle

if (variable_global_exists("return_after_battle")) {
    var d = global.return_after_battle;

    // Spawn or reuse overworld player object
    var pl_inst;
    if (instance_exists(OBJ_CHAR_OVERWORLD)) {
        pl_inst = instance_find(OBJ_CHAR_OVERWORLD, 0);
    } else {
        pl_inst = instance_create_layer(d.x, d.y, "Instances", OBJ_CHAR_OVERWORLD);
    }

    // Set exact return position
    pl_inst.x = d.x;
    pl_inst.y = d.y;

    // Restore HP values (raw HP system)
    if (!variable_instance_exists(pl_inst, "hp_max")) pl_inst.hp_max = 30;
    pl_inst.hp_max = d.hp_max;
    pl_inst.hp     = clamp(d.hp, 0, pl_inst.hp_max);

    // RESET Facing → Right (0 degrees)
    if (variable_instance_exists(pl_inst, "facing")) {
        pl_inst.facing = 0;
    }
    pl_inst.image_xscale = 1;

    // Hand global control back to overworld player
    global.player = pl_inst;
    global.in_battle = false;

    // Clear payload after use
    global.return_after_battle = undefined;
}
