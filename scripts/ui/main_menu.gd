extends Control

@onready var new_game_button: Button = $VBoxContainer/NewGame
@onready var continue_button: Button = $VBoxContainer/Continue
@onready var quit_button: Button = $VBoxContainer/Quit

func _ready() -> void:
    continue_button.visible = GameManager.save_manager.has_save()
    new_game_button.pressed.connect(_on_new_game)
    continue_button.pressed.connect(_on_continue)
    quit_button.pressed.connect(_on_quit)

func _on_new_game() -> void:
    GameManager.start_new_game()
    get_tree().change_scene_to_file("res://scenes/worlds/test_level.tscn")

func _on_continue() -> void:
    var save_data: Dictionary = GameManager.save_manager.load_game()
    if save_data.is_empty():
        return
    
    var scene_path: String = save_data.get("world", {}).get("scene", "res://scenes/worlds/test_level.tscn")
    get_tree().change_scene_to_file(scene_path)

func _on_quit() -> void:
    get_tree().quit()