extends EnemyState
class_name RangedAttack

@export var windup_duration: float = 0.6
@export var recovery_duration: float = 1.2

enum AttackPhase { WINDUP, ATTACK, RECOVERY }
var current_phase: AttackPhase = AttackPhase.WINDUP
var phase_timer: float = 0.0

func enter() -> void:
    current_phase = AttackPhase.WINDUP
    phase_timer = windup_duration
    enemy.velocity.x = 0.0
    enemy.velocity.z = 0.0
    
    if enemy.player_ref:
        var direction: Vector3 = (enemy.player_ref.global_position - enemy.global_position).normalized()
        enemy.rotation.y = atan2(direction.x, direction.z)

func physics_update(delta: float) -> void:
    phase_timer -= delta
    
    match current_phase:
        AttackPhase.WINDUP:
            if phase_timer <= 0.0:
                current_phase = AttackPhase.ATTACK
                _fire_projectile()
                current_phase = AttackPhase.RECOVERY
                phase_timer = recovery_duration
        
        AttackPhase.RECOVERY:
            if enemy.player_ref:
                var distance: float = enemy.global_position.distance_to(enemy.player_ref.global_position)
                
                if distance < enemy.retreat_distance:
                    var direction: Vector3 = (enemy.global_position - enemy.player_ref.global_position).normalized()
                    enemy.velocity.x = direction.x * enemy.move_speed
                    enemy.velocity.z = direction.z * enemy.move_speed
                else:
                    enemy.velocity.x = 0.0
                    enemy.velocity.z = 0.0
            
            if phase_timer <= 0.0:
                if enemy.player_ref:
                    state_machine.change_state("Chase")
                else:
                    state_machine.change_state("Idle")

func _fire_projectile() -> void:
    var ranged_enemy: RangedEnemy = enemy as RangedEnemy
    if ranged_enemy:
        ranged_enemy.fire_projectile()