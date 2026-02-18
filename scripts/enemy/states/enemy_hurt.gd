extends EnemyState
class_name EnemyHurt

@export var hurt_duration: float = 0.5
@export var knockback_force: float = 3.0

var hurt_timer: float = 0.0
var knockback_direction: Vector3 = Vector3.BACK

func enter() -> void:
    hurt_timer = hurt_duration
    
    if enemy.player_ref:
        knockback_direction = (enemy.global_position - enemy.player_ref.global_position).normalized()
        knockback_direction.y = 0.0
    else:
        knockback_direction = Vector3.BACK

func physics_update(delta: float) -> void:
    hurt_timer -= delta
    
    var knockback_strength: float = knockback_force * (hurt_timer / hurt_duration)
    enemy.velocity.x = knockback_direction.x * knockback_strength
    enemy.velocity.z = knockback_direction.z * knockback_strength
    
    if hurt_timer <= 0.0:
        if enemy.player_ref and enemy.global_position.distance_to(enemy.player_ref.global_position) <= enemy.detection_range:
            state_machine.change_state("Chase")
        else:
            state_machine.change_state("Idle")