## Main menu — New Game, Continue, Quit.
extends Control

@onready var new_game_btn: Button = $VBoxContainer/NewGame
@onready var continue_btn: Button = $VBoxContainer/Continue
@onready var quit_btn: Button = $VBoxContainer/Quit

const FIRST_LEVEL: String = "res://scenes/worlds/test_level.tscn"


func _ready() -> void:
    continue_btn.visible = GameManager.save_manager.has_save()
    new_game_btn.pressed.connect(_on_new_game)
    continue_btn.pressed.connect(_on_continue)
    quit_btn.pressed.connect(_on_quit)


func _on_new_game() -> void:
    GameManager.start_new_game()
    get_tree().change_scene_to_file(FIRST_LEVEL)


func _on_continue() -> void:
    var save_data: Dictionary = (
        GameManager.save_manager.load_game()
    )
    if save_data.is_empty():
        return

    var scene_path: String = save_data.get(
        "world", {}
    ).get("scene", FIRST_LEVEL)
    get_tree().change_scene_to_file(scene_path)


func _on_quit() -> void:
    get_tree().quit()