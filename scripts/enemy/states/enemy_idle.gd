extends EnemyState
class_name EnemyIdle

@export var idle_duration: float = 2.0
@export var patrol_distance: float = 3.0

var idle_timer: float = 0.0
var patrol_target: Vector3 = Vector3.ZERO
var is_patrolling: bool = false

func enter() -> void:
    idle_timer = idle_duration
    is_patrolling = false
    enemy.velocity.x = 0.0
    enemy.velocity.z = 0.0

func physics_update(delta: float) -> void:
    if enemy.player_ref:
        var distance: float = enemy.global_position.distance_to(enemy.player_ref.global_position)
        if distance <= enemy.detection_range:
            state_machine.change_state("Chase")
            return
    
    idle_timer -= delta
    
    if idle_timer <= 0.0:
        if is_patrolling:
            patrol_target = enemy.global_position + Vector3(randf_range(-patrol_distance, patrol_distance), 0, randf_range(-patrol_distance, patrol_distance))
            enemy.velocity.x = (patrol_target - enemy.global_position).normalized().x * enemy.move_speed * 0.5
            enemy.velocity.z = (patrol_target - enemy.global_position).normalized().z * enemy.move_speed * 0.5
            is_patrolling = false
            idle_timer = idle_duration * 0.5
        else:
            enemy.velocity.x = 0.0
            enemy.velocity.z = 0.0
            is_patrolling = true
            idle_timer = idle_duration