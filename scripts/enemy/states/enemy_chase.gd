extends EnemyState
class_name EnemyChase

func enter() -> void:
    pass

func physics_update(delta: float) -> void:
    if not enemy.player_ref:
        state_machine.change_state("Idle")
        return
    
    var distance: float = enemy.global_position.distance_to(enemy.player_ref.global_position)
    
    if distance <= enemy.attack_range:
        state_machine.change_state("Attack")
        return
    
    if distance > enemy.detection_range * 1.5:
        state_machine.change_state("Idle")
        return
    
    var direction: Vector3 = (enemy.player_ref.global_position - enemy.global_position).normalized()
    direction.y = 0.0
    
    enemy.velocity.x = direction.x * enemy.move_speed
    enemy.velocity.z = direction.z * enemy.move_speed
    
    enemy.rotation.y = lerp_angle(enemy.rotation.y, atan2(direction.x, direction.z), 10.0 * delta)