## Boss attack — variable attack patterns based on boss phase.
## Supports BASIC, HEAVY, AOE attacks with combo chains.
extends EnemyState
class_name BossAttack

@export var basic_attack_damage: int = 20
@export var heavy_attack_damage: int = 35
@export var aoe_attack_damage: int = 25

enum AttackType { BASIC, HEAVY, AOE, COMBO }
var current_attack: AttackType = AttackType.BASIC

var attack_timer: float = 0.0
var has_dealt_damage: bool = false
var combo_count: int = 0

## Attack pattern data: windup, attack, recovery, damage, range.
var attack_patterns: Dictionary = {
    AttackType.BASIC: {
        "windup": 0.4, "attack": 0.2,
        "recovery": 0.6, "damage": 20, "range": 2.0,
    },
    AttackType.HEAVY: {
        "windup": 0.8, "attack": 0.3,
        "recovery": 1.0, "damage": 35, "range": 2.5,
    },
    AttackType.AOE: {
        "windup": 1.0, "attack": 0.5,
        "recovery": 1.5, "damage": 25, "range": 4.0,
    },
}

enum AttackPhase { WINDUP, ATTACK, RECOVERY }
var current_phase: AttackPhase = AttackPhase.WINDUP


func enter() -> void:
    _choose_attack()
    _start_attack()


## Choose attack type based on boss phase and RNG.
func _choose_attack() -> void:
    var boss: BossEnemy = enemy as BossEnemy
    var phase: int = boss.current_phase if boss else 0

    var roll: float = randf()

    if phase >= 2 and roll < 0.2:
        current_attack = AttackType.AOE
    elif phase >= 1 and roll < 0.4:
        current_attack = AttackType.HEAVY
    else:
        current_attack = AttackType.BASIC

    if phase >= 2 and combo_count < 2:
        combo_count += 1
    else:
        combo_count = 0


func _start_attack() -> void:
    var pattern: Dictionary = attack_patterns[current_attack]
    attack_timer = pattern["windup"]
    current_phase = AttackPhase.WINDUP
    has_dealt_damage = false

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
    attack_timer -= delta
    var pattern: Dictionary = attack_patterns[current_attack]

    match current_phase:
        AttackPhase.WINDUP:
            if attack_timer <= 0.0:
                current_phase = AttackPhase.ATTACK
                attack_timer = pattern["attack"]

        AttackPhase.ATTACK:
            if not has_dealt_damage:
                _try_deal_damage()

            if attack_timer <= 0.0:
                current_phase = AttackPhase.RECOVERY
                attack_timer = pattern["recovery"]

        AttackPhase.RECOVERY:
            if attack_timer <= 0.0:
                _transition_after_recovery()


func _transition_after_recovery() -> void:
    if combo_count > 0:
        _choose_attack()
        _start_attack()
        return

    if not enemy.player_ref:
        state_machine.change_state("Idle")
        return

    var dist: float = enemy.global_position.distance_to(
        enemy.player_ref.global_position
    )
    if dist <= enemy.attack_range:
        state_machine.change_state("Attack")
    else:
        state_machine.change_state("Chase")


func _try_deal_damage() -> void:
    has_dealt_damage = true

    if not enemy.player_ref:
        return

    var pattern: Dictionary = attack_patterns[current_attack]
    var dist: float = enemy.global_position.distance_to(
        enemy.player_ref.global_position
    )

    if dist > pattern["range"]:
        return

    var dmg: int = pattern["damage"]
    var boss: BossEnemy = enemy as BossEnemy

    # Apply rage mode damage multiplier
    if boss and boss.is_enraged:
        dmg = int(dmg * boss.rage_mode_damage_multiplier)

    var target: Player = enemy.player_ref
    if target.hurtbox.monitoring:
        target.take_damage(dmg)
        var atk_name: String = (
            AttackType.keys()[current_attack]
        )
        print("Boss dealt %d damage with %s" % [
            dmg, atk_name
        ])