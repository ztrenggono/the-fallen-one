## Dodge state — directional dash with i-frames.
## Consumes stamina and briefly disables hurtbox.
extends PlayerState

@export var dodge_speed: float = 10.0
@export var dodge_duration: float = 0.4
@export var stamina_cost: float = 20.0

var dodge_timer: float = 0.0
var dodge_direction: Vector3 = Vector3.FORWARD


func enter() -> void:
    if not player.use_stamina(stamina_cost):
        state_machine.change_state("Idle")
        return

    player.play_animation(&"roll")
    dodge_timer = dodge_duration

    # Calculate dodge direction from input or forward
    var input_dir: Vector2 = Input.get_vector(
        "move_left", "move_right",
        "move_forward", "move_backward"
    )

    if input_dir.length() > 0.1:
        var cam_basis: Basis = (
            player.camera_pivot.global_transform.basis
        )
        dodge_direction = (
            cam_basis
            * Vector3(input_dir.x, 0, input_dir.y)
        ).normalized()
        dodge_direction.y = 0.0
    else:
        dodge_direction = (
            -player.global_transform.basis.z
        )

    # Enable i-frames
    player.hurtbox.monitoring = false
    player.hurtbox.monitorable = false


func exit() -> void:
    # Disable i-frames
    player.hurtbox.monitoring = true
    player.hurtbox.monitorable = true


func physics_update(delta: float) -> void:
    dodge_timer -= delta

    player.velocity.x = dodge_direction.x * dodge_speed
    player.velocity.z = dodge_direction.z * dodge_speed

    if dodge_timer <= 0.0:
        state_machine.change_state("Idle")