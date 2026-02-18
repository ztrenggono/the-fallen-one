## Move state — player is walking on the ground.
## Handles camera-relative movement with smooth rotation.
extends PlayerState
class_name PlayerMove


func physics_update(delta: float) -> void:
    if not player.is_on_floor():
        state_machine.change_state("Air")
        return

    if Input.is_action_just_pressed("dodge"):
        state_machine.change_state("Dodge")
        return

    if Input.is_action_just_pressed("attack"):
        state_machine.change_state("Attack")
        return

    var input_dir: Vector2 = Input.get_vector(
        "move_left", "move_right",
        "move_forward", "move_backward"
    )

    if input_dir == Vector2.ZERO:
        state_machine.change_state("Idle")
        return

    var cam_basis: Basis = player.camera_pivot.global_transform.basis
    var direction: Vector3 = (
        cam_basis * Vector3(input_dir.x, 0.0, input_dir.y)
    ).normalized()

    player.velocity.x = direction.x * player.move_speed
    player.velocity.z = direction.z * player.move_speed

    player.rotate_toward_movement(direction, delta)


func handle_input(_event: InputEvent) -> void:
    if Input.is_action_just_pressed("jump") and player.is_on_floor():
        player.velocity.y = player.jump_velocity
        state_machine.change_state("Air")