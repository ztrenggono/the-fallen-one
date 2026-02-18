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
    
    if enemy.player_ref:
        var direction: Vector3 = (enemy.player_ref.global_position - enemy.global_position).normalized()
        enemy.rotation.y = atan2(direction.x, direction.z)

func physics_update(delta: float) -> void:
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
                current_phase = AttackPhase.RECOVERY
                phase_timer = recovery_duration
        
        AttackPhase.RECOVERY:
            if phase_timer <= 0.0:
                if enemy.player_ref and enemy.global_position.distance_to(enemy.player_ref.global_position) <= enemy.attack_range:
                    state_machine.change_state("Attack")
                else:
                    state_machine.change_state("Chase")

func _try_deal_damage() -> void:
    has_dealt_damage = true
    
    if not enemy.player_ref:
        return
    
    var distance: float = enemy.global_position.distance_to(enemy.player_ref.global_position)
    
    if distance <= enemy.attack_range * 1.2:
        var player: Player = enemy.player_ref
        if player.hurtbox.monitoring:
            player.take_damage(attack_damage)