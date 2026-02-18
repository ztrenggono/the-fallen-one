## Base state for all player-specific states.
## Provides access to the Player node and animation name export.
extends State
class_name PlayerState

@export var animation_name: StringName

var player: Player

func _ready() -> void:
    await owner.ready
    player = owner as Player