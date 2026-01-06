/// SCRIPT_BATTLE_REGION_ROOM(region_name) -> room asset
function SCRIPT_BATTLE_REGION_ROOM(_region) {
    switch (string_lower(_region)) {
        case "forest":  return Room_Battle;
//        case "plains":  return rm_battle_plains;
//        case "castle":  return rm_battle_castle;
//        case "desert":  return rm_battle_desert;
        default:        return Room_Battle;
    }
}
