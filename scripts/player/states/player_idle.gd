## Idle state — waits for input, transitions to
## Move, Dodge, Attack, or Air.
extends PlayerState


func enter() -> void:
    player.velocity.x = 0.0
    player.velocity.z = 0.0
    player.play_animation(&"idle")


func physics_update(delta: float) -> void:
    # Gravity
    if not player.is_on_floor():
        player.velocity.y -= player.gravity * delta
        state_machine.change_state("Air")
        return

    # Dodge
    if Input.is_action_just_pressed("dodge"):
        state_machine.change_state("Dodge")
        return

    # Attack
    if Input.is_action_just_pressed("attack"):
        state_machine.change_state("Attack")
        return

    # Parry
    if Input.is_action_just_pressed("parry"):
        state_machine.change_state("Parry")
        return

    # Movement check
    var input_dir: Vector2 = Input.get_vector(
        "move_left", "move_right",
        "move_forward", "move_backward"
    )

    if input_dir.length() > 0.1:
        state_machine.change_state("Move")
        return

    # Jump
    if Input.is_action_just_pressed("jump"):
        player.velocity.y = player.jump_velocity
        state_machine.change_state("Air")