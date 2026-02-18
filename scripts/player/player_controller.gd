extends CharacterBody3D
class_name Player

@export var move_speed: float = 5.0
@export var sprint_speed: float = 8.0
@export var jump_velocity: float = 4.5
@export var dodge_speed: float = 12.0
@export var dodge_duration: float = 0.4

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var is_dodging: bool = false
var dodge_timer: float = 0.0
var dodge_direction: Vector3 = Vector3.ZERO

@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera: Camera3D = $CameraPivot/Camera3D
@onready var hitbox: Area3D = $Hitbox
@onready var hurtbox: Area3D = $Hurtbox

func _physics_process(delta: float) -> void:
    if is_dodging:
        _handle_dodge(delta)
    else:
        _handle_movement(delta)
    
    move_and_slide()

func _handle_movement(delta: float) -> void:
    if not is_on_floor():
        velocity.y -= gravity * delta
    
    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = jump_velocity
    
    if Input.is_action_just_pressed("dodge") and is_on_floor():
        _start_dodge()
        return
    
    var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
    var direction: Vector3 = (camera_pivot.global_transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
    
    if direction:
        velocity.x = direction.x * move_speed
        velocity.z = direction.z * move_speed
        _rotate_toward_movement(direction, delta)
    else:
        velocity.x = move_toward(velocity.x, 0.0, move_speed)
        velocity.z = move_toward(velocity.z, 0.0, move_speed)

func _start_dodge() -> void:
    var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
    
    if input_dir == Vector2.ZERO:
        dodge_direction = -camera_pivot.global_transform.basis.z
    else:
        dodge_direction = (camera_pivot.global_transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
    
    is_dodging = true
    dodge_timer = dodge_duration
    velocity.y = 0.0

func _handle_dodge(delta: float) -> void:
    dodge_timer -= delta
    
    velocity.x = dodge_direction.x * dodge_speed
    velocity.z = dodge_direction.z * dodge_speed
    
    if dodge_timer <= 0.0:
        is_dodging = false

func _rotate_toward_movement(direction: Vector3, delta: float) -> void:
    var target_rotation: float = atan2(direction.x, direction.z)
    rotation.y = lerp_angle(rotation.y, target_rotation, 10.0 * delta)

func take_damage(amount: int) -> void:
    print("Player took %d damage" % amount)