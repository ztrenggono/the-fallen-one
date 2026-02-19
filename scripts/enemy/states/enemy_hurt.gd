## Hurt state — knockback away from player.
## Transitions to Chase or Idle after recovery.
extends EnemyState
class_name EnemyHurt

@export var hurt_duration: float = 0.5
@export var knockback_force: float = 3.0

var hurt_timer: float = 0.0
var knockback_dir: Vector3 = Vector3.BACK


func enter() -> void:
    hurt_timer = hurt_duration
    enemy.play_animation(&"hurt")

    if enemy.player_ref:
        knockback_dir = (
            enemy.global_position
            - enemy.player_ref.global_position
        ).normalized()
        knockback_dir.y = 0.0
    else:
        knockback_dir = Vector3.BACK


func physics_update(delta: float) -> void:
    hurt_timer -= delta

    # Knockback decays linearly
    var strength: float = knockback_force * (
        hurt_timer / hurt_duration
    )
    enemy.velocity.x = knockback_dir.x * strength
    enemy.velocity.z = knockback_dir.z * strength

    if hurt_timer <= 0.0:
        _transition_after_hurt()


func _transition_after_hurt() -> void:
    if not enemy.player_ref:
        state_machine.change_state("Idle")
        return

    var dist: float = (
        enemy.global_position.distance_to(
            enemy.player_ref.global_position
        )
    )
    if dist <= enemy.detection_range:
        state_machine.change_state("Chase")
    else:
        state_machine.change_state("Idle")