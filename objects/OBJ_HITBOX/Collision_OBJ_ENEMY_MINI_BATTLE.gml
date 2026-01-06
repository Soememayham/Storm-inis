if (other != owner) {
    scr_take_damage(owner, other, damage, kb, kbdur);
    instance_destroy(); // single-hit
}
