## Idle state — player is stationary on the ground.
## Listens for movement, dodge, attack, and jump inputs.
extends PlayerState
class_name PlayerIdle


func enter() -> void:
    player.velocity.x = 0.0
    player.velocity.z = 0.0


func physics_update(_delta: float) -> void:
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

    if input_dir != Vector2.ZERO:
        state_machine.change_state("Move")


func handle_input(_event: InputEvent) -> void:
    if Input.is_action_just_pressed("jump") and player.is_on_floor():
        player.velocity.y = player.jump_velocity
        state_machine.change_state("Air")