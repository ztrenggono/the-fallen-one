## Ranged attack — windup → fire projectile → recovery.
## Retreats from player during recovery if too close.
extends EnemyState
class_name RangedAttack

@export var windup_duration: float = 0.6
@export var recovery_duration: float = 1.2

enum AttackPhase { WINDUP, RECOVERY }
var current_phase: AttackPhase = AttackPhase.WINDUP
var phase_timer: float = 0.0


func enter() -> void:
    current_phase = AttackPhase.WINDUP
    phase_timer = windup_duration
    enemy.velocity.x = 0.0
    enemy.velocity.z = 0.0

    # Face the player
    if enemy.player_ref:
        var dir: Vector3 = (
            enemy.player_ref.global_position
            - enemy.global_position
        ).normalized()
        enemy.rotation.y = atan2(dir.x, dir.z)


func physics_update(delta: float) -> void:
    phase_timer -= delta

    match current_phase:
        AttackPhase.WINDUP:
            if phase_timer <= 0.0:
                _fire_projectile()
                current_phase = AttackPhase.RECOVERY
                phase_timer = recovery_duration

        AttackPhase.RECOVERY:
            _handle_retreat()

            if phase_timer <= 0.0:
                if enemy.player_ref:
                    state_machine.change_state("Chase")
                else:
                    state_machine.change_state("Idle")


## Retreat from player if they are too close.
func _handle_retreat() -> void:
    if not enemy.player_ref:
        return

    var ranged: RangedEnemy = enemy as RangedEnemy
    if not ranged:
        return

    var dist: float = enemy.global_position.distance_to(
        enemy.player_ref.global_position
    )

    if dist < ranged.retreat_distance:
        var dir: Vector3 = (
            enemy.global_position
            - enemy.player_ref.global_position
        ).normalized()
        enemy.velocity.x = dir.x * enemy.move_speed
        enemy.velocity.z = dir.z * enemy.move_speed
    else:
        enemy.velocity.x = 0.0
        enemy.velocity.z = 0.0


func _fire_projectile() -> void:
    var ranged: RangedEnemy = enemy as RangedEnemy
    if ranged:
        ranged.fire_projectile()