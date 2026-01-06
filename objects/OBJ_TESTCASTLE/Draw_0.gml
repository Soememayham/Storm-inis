matrix_set(matrix_world, matrix_build(x, y, 0, 80, 0, 0, 1, 1, 1));
draw_sprite(sprite_index, direction, 0, 0);
matrix_set(matrix_world, matrix_build_identity());