extends State
class_name PlayerState

@export var animation_name: StringName

var player: Player

func _ready() -> void:
    await owner.ready
    player = owner as Player