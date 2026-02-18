## Boss enemy with phase system and rage mode.
## Phases trigger at configurable health thresholds.
extends Enemy
class_name BossEnemy

@export var phase_health_thresholds: Array[int] = [75, 50, 25]
@export var rage_mode_damage_multiplier: float = 1.5
@export var rage_mode_speed_multiplier: float = 1.3

var current_phase: int = 0
var is_enraged: bool = false
var _base_move_speed: float

signal phase_changed(phase: int)
signal boss_died


func _ready() -> void:
    super._ready()
    current_health = max_health
    _base_move_speed = move_speed


func take_damage(amount: int) -> void:
    if is_dead:
        return

    current_health -= amount
    print("Boss took %d damage, health: %d/%d" % [
        amount, current_health, max_health
    ])

    _check_phase_change()

    if current_health <= 0:
        is_dead = true
        state_machine.change_state("Death")
    else:
        state_machine.change_state("Hurt")


## Check if health dropped below a phase threshold.
func _check_phase_change() -> void:
    var health_pct: float = (
        float(current_health) / float(max_health) * 100.0
    )

    for i in range(phase_health_thresholds.size()):
        var threshold: int = phase_health_thresholds[i]
        if health_pct <= threshold and current_phase <= i:
            current_phase = i + 1
            phase_changed.emit(current_phase)
            _enter_phase(current_phase)
            break


## Apply phase-specific modifiers.
## Speed multiplier is always relative to base speed
## to prevent compounding.
func _enter_phase(phase: int) -> void:
    print("Boss entering phase %d" % phase)

    match phase:
        2:
            is_enraged = true
            move_speed = _base_move_speed * rage_mode_speed_multiplier
        3:
            is_enraged = true
            move_speed = (
                _base_move_speed
                * rage_mode_speed_multiplier
                * 1.2
            )


func die() -> void:
    boss_died.emit()

    if absorb_ability and player_ref:
        var absorb_mgr: AbsorbManager = (
            player_ref.get_node_or_null("AbsorbManager")
        )
        if absorb_mgr:
            absorb_mgr.absorb_ability(absorb_ability)

    queue_free()