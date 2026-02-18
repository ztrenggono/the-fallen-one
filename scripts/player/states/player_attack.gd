## Attack state — 3-hit combo system with stamina costs.
## Uses raycast for hit detection during the attack window.
extends PlayerState
class_name PlayerAttack

@export var combo_window: float = 0.5

var attack_index: int = 0
var attack_timer: float = 0.0
var can_combo: bool = false
var combo_requested: bool = false
var has_hit: bool = false

## Each entry defines: duration, damage, range, stamina_cost.
var attack_data: Array[Dictionary] = [
    {
        "duration": 0.4, "damage": 10,
        "range": 1.5, "stamina_cost": 10.0,
    },
    {
        "duration": 0.35, "damage": 15,
        "range": 1.8, "stamina_cost": 15.0,
    },
    {
        "duration": 0.5, "damage": 25,
        "range": 2.0, "stamina_cost": 20.0,
    },
]


func enter() -> void:
    attack_index = 0
    _start_attack()


func _start_attack() -> void:
    var current: Dictionary = attack_data[attack_index]
    var stamina_cost: float = current.get("stamina_cost", 10.0)

    if not player.use_stamina(stamina_cost):
        state_machine.change_state("Idle")
        return

    attack_timer = current["duration"]
    can_combo = false
    combo_requested = false
    has_hit = false

    # Rotate toward input direction if moving
    var input_dir: Vector2 = Input.get_vector(
        "move_left", "move_right",
        "move_forward", "move_backward"
    )
    if input_dir != Vector2.ZERO:
        var cam_basis: Basis = (
            player.camera_pivot.global_transform.basis
        )
        var direction: Vector3 = (
            cam_basis * Vector3(input_dir.x, 0.0, input_dir.y)
        ).normalized()
        player.rotate_toward_movement(direction, 0.1)

    # Stop horizontal movement during attack
    player.velocity.x = 0.0
    player.velocity.z = 0.0


func physics_update(delta: float) -> void:
    attack_timer -= delta
    var current: Dictionary = attack_data[attack_index]
    var duration: float = current["duration"]

    # Hit detection at 50% through the attack
    if attack_timer <= duration * 0.5 and not has_hit:
        _check_hit()

    # Combo window opens at 70% through the attack
    if attack_timer <= duration * 0.3:
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


## Raycast forward to detect enemies in attack range.
func _check_hit() -> void:
    has_hit = true
    var current: Dictionary = attack_data[attack_index]
    var atk_range: float = current["range"]
    var atk_damage: int = current["damage"]

    var origin: Vector3 = player.global_position + Vector3.UP
    var forward: Vector3 = -player.global_transform.basis.z
    var target: Vector3 = origin + forward * atk_range

    var space: PhysicsDirectSpaceState3D = (
        player.get_world_3d().direct_space_state
    )
    var query: PhysicsRayQueryParameters3D = (
        PhysicsRayQueryParameters3D.create(origin, target)
    )
    query.collision_mask = 7

    var result: Dictionary = space.intersect_ray(query)

    if result and result.collider.has_method("take_damage"):
        result.collider.take_damage(atk_damage)
        print("Hit enemy for %d damage" % atk_damage)


func _next_attack() -> void:
    attack_index += 1

    if attack_index >= attack_data.size():
        attack_index = 0

    _start_attack()