extends PlayerState
class_name PlayerAir

func enter() -> void:
    pass

func physics_update(delta: float) -> void:
    player.velocity.y -= player.gravity * delta
    
    var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
    var direction: Vector3 = (player.camera_pivot.global_transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
    
    var air_control: float = 0.5
    player.velocity.x = direction.x * player.move_speed * air_control
    player.velocity.z = direction.z * player.move_speed * air_control
    
    if player.is_on_floor():
        state_machine.change_state("Idle")