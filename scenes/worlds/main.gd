extends Node3D

@onready var player: Player = $Entities/Player

func _ready() -> void:
    print("Level initialized")
    _connect_player_signals()

func _connect_player_signals() -> void:
    if player:
        player.player_died.connect(_on_player_died)

func _on_player_died() -> void:
    get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")