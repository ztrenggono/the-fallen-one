extends Control

@onready var resume_button: Button = $VBoxContainer/Resume
@onready var save_button: Button = $VBoxContainer/Save
@onready var quit_button: Button = $VBoxContainer/Quit

var is_paused: bool = false

func _ready() -> void:
    visible = false
    process_mode = Node.PROCESS_MODE_WHEN_PAUSED
    resume_button.pressed.connect(_on_resume)
    save_button.pressed.connect(_on_save)
    quit_button.pressed.connect(_on_quit)

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):
        toggle_pause()

func toggle_pause() -> void:
    is_paused = !is_paused
    get_tree().paused = is_paused
    visible = is_paused

func _on_resume() -> void:
    toggle_pause()

func _on_save() -> void:
    GameManager.save_current_game()
    print("Game saved")

func _on_quit() -> void:
    get_tree().paused = false
    get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")