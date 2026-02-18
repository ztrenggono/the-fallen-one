extends Node3D
class_name CameraController

@export var rotation_speed: float = 0.002
@export var min_pitch: float = -0.5
@export var max_pitch: float = 0.75
@export var camera_distance: float = 5.0

var pitch: float = 0.3
var yaw: float = 0.0

@onready var camera: Camera3D = $Camera3D

func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    camera.position = Vector3(0, 0, camera_distance)

func _input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        _handle_mouse_motion(event)

func _handle_mouse_motion(event: InputEventMouseMotion) -> void:
    yaw -= event.relative.x * rotation_speed
    pitch -= event.relative.y * rotation_speed
    pitch = clamp(pitch, min_pitch, max_pitch)
    
    rotation = Vector3(pitch, yaw, 0.0)