## Heavy enemy type — armored with charge attack capability.
## Reduces incoming damage by the armor value.
extends Enemy
class_name HeavyEnemy

@export var charge_speed: float = 8.0
@export var charge_damage: int = 30
@export var armor: int = 5


func take_damage(amount: int) -> void:
    if is_dead:
        return

    var reduced: int = max(1, amount - armor)
    current_health -= reduced
    print(
        "Heavy enemy took %d damage (reduced from %d), "
        + "health: %d/%d" % [
            reduced, amount, current_health, max_health
        ]
    )

    if current_health <= 0:
        is_dead = true
        state_machine.change_state("Death")
    else:
        state_machine.change_state("Hurt")