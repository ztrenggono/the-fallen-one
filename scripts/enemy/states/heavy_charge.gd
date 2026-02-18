extends EnemyState
class_name HeavyCharge

@export var charge_speed: float = 10.0
@export var charge_duration: float = 0.8
@export var charge_damage: int = 35
@export var windup_duration: float = 1.0
@export var recovery_duration: float = 1.5

enum ChargePhase { WINDUP, CHARGE, RECOVERY }
var current_phase: ChargePhase = ChargePhase.WINDUP
var phase_timer: float = 0.0
var charge_direction: Vector3 = Vector3.FORWARD
var has_hit: bool = false

func enter() -> void:
    current_phase = ChargePhase.WINDUP
    phase_timer = windup_duration
    has_hit = false
    enemy.velocity.x = 0.0
    enemy.velocity.z = 0.0
    
    if enemy.player_ref:
        charge_direction = (enemy.player_ref.global_position - enemy.global_position).normalized()
        charge_direction.y = 0.0
        enemy.rotation.y = atan2(charge_direction.x, charge_direction.z)

func physics_update(delta: float) -> void:
    phase_timer -= delta
    
    match current_phase:
        ChargePhase.WINDUP:
            if phase_timer <= 0.0:
                current_phase = ChargePhase.CHARGE
                phase_timer = charge_duration
                has_hit = false
        
        ChargePhase.CHARGE:
            var heavy_enemy: HeavyEnemy = enemy as HeavyEnemy
            var speed: float = heavy_enemy.charge_speed if heavy_enemy else charge_speed
            
            enemy.velocity.x = charge_direction.x * speed
            enemy.velocity.z = charge_direction.z * speed
            
            if not has_hit:
                _check_collision()
            
            if phase_timer <= 0.0:
                current_phase = ChargePhase.RECOVERY
                phase_timer = recovery_duration
                enemy.velocity.x = 0.0
                enemy.velocity.z = 0.0
        
        ChargePhase.RECOVERY:
            if phase_timer <= 0.0:
                state_machine.change_state("Idle")

func _check_collision() -> void:
    if not enemy.player_ref:
        return
    
    var distance: float = enemy.global_position.distance_to(enemy.player_ref.global_position)
    
    if distance <= enemy.attack_range:
        has_hit = true
        var player: Player = enemy.player_ref
        if player.hurtbox.monitoring:
            var heavy_enemy: HeavyEnemy = enemy as HeavyEnemy
            var damage: int = heavy_enemy.charge_damage if heavy_enemy else charge_damage
            player.take_damage(damage)
            print("Heavy enemy charge hit for %d damage" % damage)