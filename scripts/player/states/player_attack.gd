extends PlayerState
class_name PlayerAttack

@export var attack_damage: int = 10
@export var combo_window: float = 0.5

var attack_index: int = 0
var attack_timer: float = 0.0
var can_combo: bool = false
var combo_requested: bool = false
var has_hit: bool = false

var attack_data: Array[Dictionary] = [
    {"duration": 0.4, "damage": 10, "range": 1.5},
    {"duration": 0.35, "damage": 15, "range": 1.8},
    {"duration": 0.5, "damage": 25, "range": 2.0},
]

func enter() -> void:
    attack_index = 0
    _start_attack()

func _start_attack() -> void:
    attack_timer = attack_data[attack_index]["duration"]
    can_combo = false
    combo_requested = false
    has_hit = false
    
    var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
    if input_dir != Vector2.ZERO:
        var direction: Vector3 = (player.camera_pivot.global_transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
        player._rotate_toward_movement(direction, 0.1)
    
    player.velocity.x = 0.0
    player.velocity.z = 0.0

func physics_update(delta: float) -> void:
    attack_timer -= delta
    
    if attack_timer <= attack_data[attack_index]["duration"] * 0.5 and not has_hit:
        _check_hit()
    
    if attack_timer <= attack_data[attack_index]["duration"] * 0.3:
        can_combo = true
        if combo_requested:
            _next_attack()
            return
    
    if attack_timer <= 0.0:
        if combo_requested:
            _next_attack()
        else:
            state_machine.change_state("Idle")

func handle_input(_event: InputEvent) -> void:
    if Input.is_action_just_pressed("attack") and can_combo:
        combo_requested = true

func _check_hit() -> void:
    has_hit = true
    
    var attack_range: float = attack_data[attack_index]["range"]
    var attack_damage: int = attack_data[attack_index]["damage"]
    
    var space_state: PhysicsDirectSpaceState3D = player.get_world_3d().direct_space_state
    var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(
        player.global_position + Vector3(0, 1, 0),
        player.global_position + Vector3(0, 1, 0) + (-player.global_transform.basis.z * attack_range)
    )
    query.collision_mask = 7
    
    var result: Dictionary = space_state.intersect_ray(query)
    
    if result and result.collider.has_method("take_damage"):
        result.collider.take_damage(attack_damage)
        print("Hit enemy for %d damage" % attack_damage)

func _next_attack() -> void:
    attack_index += 1
    
    if attack_index >= attack_data.size():
        attack_index = 0
    
    _start_attack()