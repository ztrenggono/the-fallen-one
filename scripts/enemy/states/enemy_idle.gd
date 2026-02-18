## Idle state — alternates between standing and simple patrol.
## Detects player and transitions to Chase.
extends EnemyState
class_name EnemyIdle

@export var idle_duration: float = 2.0
@export var patrol_distance: float = 3.0

var idle_timer: float = 0.0
var is_patrolling: bool = false


func enter() -> void:
    idle_timer = idle_duration
    is_patrolling = false
    enemy.velocity.x = 0.0
    enemy.velocity.z = 0.0


func physics_update(delta: float) -> void:
    # Check for player detection
    if enemy.player_ref:
        var dist: float = enemy.global_position.distance_to(
            enemy.player_ref.global_position
        )
        if dist <= enemy.detection_range:
            state_machine.change_state("Chase")
            return

    idle_timer -= delta

    if idle_timer <= 0.0:
        if is_patrolling:
            _start_patrol()
        else:
            _stop_patrol()


## Pick a random patrol target and move toward it.
func _start_patrol() -> void:
    var offset: Vector3 = Vector3(
        randf_range(-patrol_distance, patrol_distance),
        0,
        randf_range(-patrol_distance, patrol_distance)
    )
    var target: Vector3 = enemy.global_position + offset
    var dir: Vector3 = (
        target - enemy.global_position
    ).normalized()

    enemy.velocity.x = dir.x * enemy.move_speed * 0.5
    enemy.velocity.z = dir.z * enemy.move_speed * 0.5
    is_patrolling = false
    idle_timer = idle_duration * 0.5


## Stop moving and wait before next patrol.
func _stop_patrol() -> void:
    enemy.velocity.x = 0.0
    enemy.velocity.z = 0.0
    is_patrolling = true
    idle_timer = idle_duration