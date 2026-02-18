extends CharacterBody3D
class_name Player

@export var max_health: int = 100
@export var max_stamina: float = 100.0
@export var stamina_regen: float = 20.0
@export var move_speed: float = 5.0
@export var sprint_speed: float = 8.0
@export var jump_velocity: float = 4.5

var current_health: int
var current_stamina: float
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

signal health_changed(current: int, maximum: int)
signal stamina_changed(current: float, maximum: float)
signal player_died

@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera: Camera3D = $CameraPivot/Camera3D
@onready var hitbox: Area3D = $Hitbox
@onready var hurtbox: Area3D = $Hurtbox
@onready var state_machine: Node = $StateMachine

func _ready() -> void:
    current_health = max_health
    current_stamina = max_stamina
    add_to_group("player")

func _physics_process(delta: float) -> void:
    _regenerate_stamina(delta)
    move_and_slide()

func _regenerate_stamina(delta: float) -> void:
    if current_stamina < max_stamina:
        current_stamina = min(current_stamina + stamina_regen * delta, max_stamina)
        stamina_changed.emit(current_stamina, max_stamina)

func use_stamina(amount: float) -> bool:
    if current_stamina < amount:
        return false
    current_stamina -= amount
    stamina_changed.emit(current_stamina, max_stamina)
    return true

func take_damage(amount: int) -> void:
    current_health -= amount
    health_changed.emit(current_health, max_health)
    
    if current_health <= 0:
        die()
    else:
        print("Player took %d damage, HP: %d/%d" % [amount, current_health, max_health])

func heal(amount: int) -> void:
    current_health = min(current_health + amount, max_health)
    health_changed.emit(current_health, max_health)

func die() -> void:
    player_died.emit()
    print("Player died")

func _rotate_toward_movement(direction: Vector3, delta: float) -> void:
    var target_rotation: float = atan2(direction.x, direction.z)
    rotation.y = lerp_angle(rotation.y, target_rotation, 10.0 * delta)