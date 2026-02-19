## Enemy attack — windup → attack → recovery.
## Deals damage via proximity in the attack phase.
extends EnemyState
class_name EnemyAttack

@export var windup_duration: float = 0.5
@export var attack_duration: float = 0.3
@export var recovery_duration: float = 0.8
@export var attack_damage: int = 15

enum AttackPhase { WINDUP, ATTACK, RECOVERY }
var current_phase: AttackPhase
var phase_timer: float = 0.0
var has_dealt_damage: bool = false


func enter() -> void:
    current_phase = AttackPhase.WINDUP
    phase_timer = windup_duration
    has_dealt_damage = false
    enemy.velocity.x = 0.0
    enemy.velocity.z = 0.0
    enemy.play_animation(&"attack")

    # Face the player before attacking
    if enemy.player_ref:
        var dir: Vector3 = (
            enemy.player_ref.global_position
            - enemy.global_position
        ).normalized()
        enemy.rotation.y = atan2(dir.x, dir.z)


func physics_update(delta: float) -> void:
    if enemy.is_stunned:
        state_machine.change_state("Idle")
        return

    phase_timer -= delta

    match current_phase:
        AttackPhase.WINDUP:
            if phase_timer <= 0.0:
                current_phase = AttackPhase.ATTACK
                phase_timer = attack_duration

        AttackPhase.ATTACK:
            if not has_dealt_damage:
                _try_deal_damage()

            if phase_timer <= 0.0:
                current_phase = (
                    AttackPhase.RECOVERY
                )
                phase_timer = recovery_duration

        AttackPhase.RECOVERY:
            if phase_timer <= 0.0:
                _transition_after_recovery()


func _transition_after_recovery() -> void:
    if not enemy.player_ref:
        state_machine.change_state("Idle")
        return

    var dist: float = (
        enemy.global_position.distance_to(
            enemy.player_ref.global_position
        )
    )
    if dist <= enemy.attack_range:
        state_machine.change_state("Attack")
    else:
        state_machine.change_state("Chase")


func _try_deal_damage() -> void:
    has_dealt_damage = true

    if not enemy.player_ref:
        return

    var dist: float = (
        enemy.global_position.distance_to(
            enemy.player_ref.global_position
        )
    )

    if dist <= enemy.attack_range * 1.2:
        var target: Player = enemy.player_ref
        if target.hurtbox.monitorable:
            target.take_damage(attack_damage)