## Fast enemy type — agile with burst attacks and dodge chance.
## Inherits gravity and movement from Enemy base.
extends Enemy
class_name FastEnemy

@export var burst_attack_count: int = 3
@export var burst_damage: int = 8
@export var dodge_chance: float = 0.3

var current_burst_count: int = 0


## Returns true if the enemy successfully dodges.
func try_dodge() -> bool:
    return randf() < dodge_chance