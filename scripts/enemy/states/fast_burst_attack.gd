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
    
    if enemy.player_ref:
        var direction: Vector3 = (enemy.player_ref.global_position - enemy.global_position).normalized()
        enemy.rotation.y = atan2(direction.x, direction.z)

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

func _do_attack() -> void:
    if not enemy.player_ref:
        return
    
    var distance: float = enemy.global_position.distance_to(enemy.player_ref.global_position)
    
    if distance <= enemy.attack_range:
        var player: Player = enemy.player_ref
        if player.hurtbox.monitoring:
            var fast_enemy: FastEnemy = enemy as FastEnemy
            var damage: int = fast_enemy.burst_damage if fast_enemy else attack_damage
            player.take_damage(damage)
            print("Fast enemy burst attack %d for %d damage" % [current_attack + 1, damage])