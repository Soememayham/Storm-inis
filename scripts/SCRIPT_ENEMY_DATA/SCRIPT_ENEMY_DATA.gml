
function scr_enemy_data(kind) {
    switch (kind) {
        case OBJ_ENEMY:
            return { name:"Mimic", hp:12, hp_max:12, atk:4, def:1, spd:3, reward_exp:3, sprite:spr_slime };
        case ENEMY_WOLF:
            return { name:"Wolf",  hp:20, hp_max:20, atk:7, def:2, spd:6, reward_exp:6, sprite:spr_wolf  };
    }
    return { name:"???", hp:8, hp_max:8, atk:3, def:0, spd:3, reward_exp:1, sprite:spr_unknown };
}