extends Label
class_name TooltipLabel

func _ready() -> void:
    mouse_filter = Control.MOUSE_FILTER_PASS
    mouse_default_cursor_shape = Control.CURSOR_HELP

func _make_custom_tooltip(for_text: String) -> Object:
    var label: Label = Label.new()
    label.text = for_text
    label.add_theme_font_size_override("font_size", 14)
    label.add_theme_color_override("font_color", Color.WHITE)
    label.add_theme_color_override("font_outline_color", Color.BLACK)
    label.add_theme_constant_override("outline_size", 2)
    return label