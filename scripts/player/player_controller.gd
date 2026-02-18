extends CharacterBody3D
class_name Player

@export var move_speed: float = 5.0
@export var sprint_speed: float = 8.0
@export var jump_velocity: float = 4.5

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera: Camera3D = $CameraPivot/Camera3D
@onready var hitbox: Area3D = $Hitbox
@onready var hurtbox: Area3D = $Hurtbox
@onready var state_machine: Node = $StateMachine

func _physics_process(_delta: float) -> void:
    move_and_slide()

func _rotate_toward_movement(direction: Vector3, delta: float) -> void:
    var target_rotation: float = atan2(direction.x, direction.z)
    rotation.y = lerp_angle(rotation.y, target_rotation, 10.0 * delta)  