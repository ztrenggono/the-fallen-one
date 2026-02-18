## End screen — shown on victory or player death.
extends Control

@onready var title_label: Label = $VBoxContainer/Title
@onready var message_label: Label = $VBoxContainer/Message
@onready var continue_button: Button = $VBoxContainer/Continue


func _ready() -> void:
    continue_button.pressed.connect(_on_continue)


func show_victory() -> void:
    title_label.text = "VICTORY"
    message_label.text = (
        "You have defeated The Sovereign.\n"
        + "The caste system crumbles.\n"
        + "The oppressed are free at last."
    )
    visible = true


func show_death() -> void:
    title_label.text = "YOU DIED"
    message_label.text = (
        "But your vengeance remains unfulfilled..."
    )
    continue_button.text = "Try Again"
    visible = true


func _on_continue() -> void:
    GameManager.save_manager.delete_save()
    get_tree().change_scene_to_file(
        "res://scenes/ui/main_menu.tscn"
    )