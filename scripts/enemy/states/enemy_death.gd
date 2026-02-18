## Death state — freezes movement, disables collision,
## then calls enemy.die() after the death duration.
extends EnemyState
class_name EnemyDeath

@export var death_duration: float = 1.0

var death_timer: float = 0.0


func enter() -> void:
    death_timer = death_duration
    enemy.velocity.x = 0.0
    enemy.velocity.z = 0.0
    enemy.collision_layer = 0
    enemy.collision_mask = 0


func physics_update(delta: float) -> void:
    death_timer -= delta

    if death_timer <= 0.0:
        enemy.die()