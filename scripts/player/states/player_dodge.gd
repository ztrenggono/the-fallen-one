extends PlayerState
class_name PlayerDodge

@export var dodge_speed: float = 12.0
@export var dodge_duration: float = 0.4

var dodge_timer: float = 0.0
var dodge_direction: Vector3 = Vector3.FORWARD

func enter() -> void:
    var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
    
    if input_dir == Vector2.ZERO:
        dodge_direction = -player.camera_pivot.global_transform.basis.z
    else:
        dodge_direction = (player.camera_pivot.global_transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
    
    dodge_timer = dodge_duration
    player.velocity.y = 0.0
    
    player.hurtbox.set_deferred("monitoring", false)

func exit() -> void:
    player.hurtbox.set_deferred("monitoring", true)

func physics_update(delta: float) -> void:
    dodge_timer -= delta
    
    player.velocity.x = dodge_direction.x * dodge_speed
    player.velocity.z = dodge_direction.z * dodge_speed
    
    if dodge_timer <= 0.0:
        state_machine.change_state("Idle")