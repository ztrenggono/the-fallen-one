## Fast burst attack — rapid multi-hit combo.
## Uses FastEnemy.burst_damage if available.
extends EnemyState
class_name FastBurstAttack

@export var attack_damage: int = 8
@export var attack_interval: float = 0.15
@export var burst_count: int = 3
@export var recovery_duration: float = 0.8

var current_attack: int = 0
var attack_timer: float = 0.0
var is_recovering: bool = false


func enter() -> void:
    current_attack = 0
    is_recovering = false
    attack_timer = 0.0
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
    if is_recovering:
        attack_timer -= delta
        if attack_timer <= 0.0:
            state_machine.change_state("Idle")
        return

    attack_timer -= delta

    if attack_timer <= 0.0:
        _do_attack()
        current_attack += 1
        attack_timer = attack_interval

        if current_attack >= burst_count:
            is_recovering = true
            attack_timer = recovery_duration


## Check range and deal damage for one burst hit.
func _do_attack() -> void:
    if not enemy.player_ref:
        return

    var dist: float = enemy.global_position.distance_to(
        enemy.player_ref.global_position
    )

    if dist <= enemy.attack_range:
        var target: Player = enemy.player_ref
        if target.hurtbox.monitoring:
            var fast: FastEnemy = enemy as FastEnemy
            var dmg: int = fast.burst_damage if fast else attack_damage
            target.take_damage(dmg)
            print(
                "Fast enemy burst %d for %d damage"
                % [current_attack + 1, dmg]
            )