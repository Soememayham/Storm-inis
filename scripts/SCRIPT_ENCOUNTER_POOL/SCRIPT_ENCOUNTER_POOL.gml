/// SCRIPT_ENCOUNTER_POOL(_encID)
function SCRIPT_ENCOUNTER_POOL(_encID)
{
    // === SAFETY CHECK ===
    if (argument_count < 1 || is_undefined(_encID)) {
        show_debug_message("!! WARNING: SCRIPT_ENCOUNTER_POOL called without valid encounter_id");
        _encID = 1; // default fallback encounter
    }

    switch (_encID) {
        case 1:
            return [ OBJ_ENEMY_MINI_BATTLE ];

        case 2:
            return [ OBJ_ENEMY_MINI_BATTLE ];

        case 3:
            return [ OBJ_ENEMY_MINI_BATTLE ];

        case 4: // 👾 MULTI-TINI PACK
            return [
                OBJ_ENEMY_TINI,
                OBJ_ENEMY_TINI,
                OBJ_ENEMY_TINI
            ];

        default:
            return [ OBJ_ENEMY_MINI_BATTLE ];
    }
}
