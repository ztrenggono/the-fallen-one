## Air state — applies gravity and limited air control.
## Returns to Idle on landing.
extends PlayerState


func enter() -> void:
    player.play_animation(&"jump")


func physics_update(delta: float) -> void:
    player.velocity.y -= player.gravity * delta

    # Limited air control
    var input_dir: Vector2 = Input.get_vector(
        "move_left", "move_right",
        "move_forward", "move_backward"
    )

    if input_dir.length() > 0.1:
        var cam_basis: Basis = (
            player.camera_pivot.global_transform.basis
        )
        var direction: Vector3 = (
            cam_basis
            * Vector3(input_dir.x, 0, input_dir.y)
        ).normalized()
        direction.y = 0.0

        # Air control is weaker than ground
        player.velocity.x = lerp(
            player.velocity.x,
            direction.x * player.move_speed,
            0.05
        )
        player.velocity.z = lerp(
            player.velocity.z,
            direction.z * player.move_speed,
            0.05
        )

    if player.is_on_floor():
        state_machine.change_state("Idle")