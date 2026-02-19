## Main player controller — handles stats, physics,
## and integrates with the state machine.
## Extends CharacterBody3D for built-in movement.
extends CharacterBody3D
class_name Player

# --- Stats ---
@export var max_health: int = 100
@export var max_stamina: float = 100.0
@export var stamina_regen: float = 25.0
@export var stamina_regen_delay: float = 0.5
@export var move_speed: float = 5.0
@export var sprint_speed: float = 8.0
@export var jump_velocity: float = 4.5

# --- Runtime State ---
var current_health: int
var current_stamina: float
var stamina_regen_timer: float = 0.0
var is_dead: bool = false
var gravity: float = ProjectSettings.get_setting(
    "physics/3d/default_gravity"
)

# --- Signals ---
signal health_changed(current: int, maximum: int)
signal stamina_changed(current: float, maximum: float)
signal player_died

# --- Node References ---
@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera: Camera3D = $CameraPivot/Camera3D
@onready var hitbox: Area3D = $Hitbox
@onready var hurtbox: Area3D = $Hurtbox
@onready var state_machine: Node = $StateMachine
@onready var animation_player: AnimationPlayer = (
    $AnimationPlayer
)


func _ready() -> void:
    current_health = max_health
    current_stamina = max_stamina
    add_to_group("player")


func _physics_process(delta: float) -> void:
    if is_dead:
        return
    _update_stamina(delta)
    move_and_slide()


func _update_stamina(delta: float) -> void:
    if stamina_regen_timer > 0.0:
        stamina_regen_timer -= delta
    elif current_stamina < max_stamina:
        current_stamina = min(
            current_stamina + stamina_regen * delta,
            max_stamina
        )
        stamina_changed.emit(
            current_stamina, max_stamina
        )


func use_stamina(amount: float) -> bool:
    if current_stamina < amount:
        return false
    current_stamina -= amount
    stamina_regen_timer = stamina_regen_delay
    stamina_changed.emit(current_stamina, max_stamina)
    return true


func take_damage(amount: int) -> void:
    if is_dead:
        return

    current_health -= amount
    health_changed.emit(current_health, max_health)

    if current_health <= 0:
        die()
    else:
        print("Player took %d damage, HP: %d/%d" % [
            amount, current_health, max_health
        ])


func heal(amount: int) -> void:
    current_health = min(
        current_health + amount, max_health
    )
    health_changed.emit(current_health, max_health)


func die() -> void:
    if is_dead:
        return
    is_dead = true
    velocity = Vector3.ZERO
    # Disable collision so player falls through
    hurtbox.monitoring = false
    hurtbox.monitorable = false
    player_died.emit()
    print("Player died")

    # Play death animation if available
    if animation_player and animation_player.has_animation("death"):
        animation_player.play("death")


## Play an animation if the AnimationPlayer exists.
func play_animation(anim_name: StringName) -> void:
    if not animation_player:
        return
    if animation_player.has_animation(anim_name):
        animation_player.play(anim_name)


## Smoothly rotate the player toward a movement direction.
func rotate_toward_movement(
    direction: Vector3, delta: float
) -> void:
    var target_rot: float = atan2(
        direction.x, direction.z
    )
    rotation.y = lerp_angle(
        rotation.y, target_rot, 10.0 * delta
    )