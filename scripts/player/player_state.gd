## Base state for all player-specific states.
## Provides access to the Player node.
## If `animation_name` is set, auto-plays on enter.
extends State
class_name PlayerState

@export var animation_name: StringName

var player: Player


func _ready() -> void:
    await owner.ready
    player = owner as Player


## Override in subclasses. Calls play_animation
## automatically if animation_name is set.
func enter() -> void:
    if animation_name:
        player.play_animation(animation_name)