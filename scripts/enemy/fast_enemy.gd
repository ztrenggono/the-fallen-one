extends Enemy
class_name FastEnemy

@export var burst_attack_count: int = 3
@export var burst_damage: int = 8
@export var dodge_chance: float = 0.3

var current_burst_count: int = 0

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y -= gravity * delta
    
    move_and_slide()

func try_dodge() -> bool:
    return randf() < dodge_chance