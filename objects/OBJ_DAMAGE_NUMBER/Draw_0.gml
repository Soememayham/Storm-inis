draw_set_alpha(image_alpha);
draw_set_color(color);

if (variable_instance_exists(id, "font")) {
    draw_set_font(font);
}

draw_text(x, y, string(text));

draw_set_alpha(1);
draw_set_color(c_white);
