## Chase state — pursues the player toward attack range.
## Returns to Idle if player is lost or out of range.
extends EnemyState
class_name EnemyChase


func enter() -> void:
    pass


func physics_update(delta: float) -> void:
    if not enemy.player_ref:
        state_machine.change_state("Idle")
        return

    var dist: float = enemy.global_position.distance_to(
        enemy.player_ref.global_position
    )

    if dist <= enemy.attack_range:
        state_machine.change_state("Attack")
        return

    if dist > enemy.detection_range * 1.5:
        state_machine.change_state("Idle")
        return

    var dir: Vector3 = (
        enemy.player_ref.global_position
        - enemy.global_position
    ).normalized()
    dir.y = 0.0

    enemy.velocity.x = dir.x * enemy.move_speed
    enemy.velocity.z = dir.z * enemy.move_speed

    enemy.rotation.y = lerp_angle(
        enemy.rotation.y,
        atan2(dir.x, dir.z),
        10.0 * delta
    )