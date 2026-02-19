## Base enemy controller with health, detection,
## animation, and absorb drops.
## Extended by specific enemy types (Fast, Heavy,
## Ranged, Boss).
extends CharacterBody3D
class_name Enemy

# --- Stats ---
@export var max_health: int = 50
@export var move_speed: float = 3.0
@export var attack_range: float = 1.5
@export var detection_range: float = 10.0
@export var absorb_ability: AbilityData

# --- Runtime State ---
var current_health: int
var gravity: float = ProjectSettings.get_setting(
    "physics/3d/default_gravity"
)
var player_ref: Player = null
var is_dead: bool = false
var is_stunned: bool = false
var stun_timer: float = 0.0

# --- Node References ---
@onready var detection_area: Area3D = $DetectionArea
@onready var hitbox: Area3D = $Hitbox
@onready var hurtbox: Area3D = $Hurtbox
@onready var state_machine: Node = $StateMachine
@onready var animation_player: AnimationPlayer = (
    get_node_or_null("AnimationPlayer")
)


func _ready() -> void:
    current_health = max_health
    detection_area.body_entered.connect(
        _on_detection_area_body_entered
    )
    detection_area.body_exited.connect(
        _on_detection_area_body_exited
    )


func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y -= gravity * delta

    # Handle stun timer
    if is_stunned:
        stun_timer -= delta
        if stun_timer <= 0.0:
            is_stunned = false
        else:
            velocity.x = 0.0
            velocity.z = 0.0

    move_and_slide()


## Apply damage; transitions to Hurt or Death state.
func take_damage(amount: int) -> void:
    if is_dead:
        return

    current_health -= amount
    print("Enemy took %d damage, health: %d/%d" % [
        amount, current_health, max_health
    ])

    if current_health <= 0:
        is_dead = true
        state_machine.change_state("Death")
    else:
        state_machine.change_state("Hurt")


## Stun the enemy for a duration (e.g. parry).
func stun(duration: float) -> void:
    is_stunned = true
    stun_timer = duration
    velocity.x = 0.0
    velocity.z = 0.0


## Play an animation if AnimationPlayer exists.
func play_animation(anim_name: StringName) -> void:
    if not animation_player:
        return
    if animation_player.has_animation(anim_name):
        animation_player.play(anim_name)


## Called when death animation finishes.
## Grants absorb ability to the player if available.
func die() -> void:
    if absorb_ability and player_ref:
        var absorb_mgr: AbsorbManager = (
            player_ref.get_node_or_null(
                "AbsorbManager"
            )
        )
        if absorb_mgr:
            absorb_mgr.absorb_ability(absorb_ability)
    queue_free()


func _on_detection_area_body_entered(
    body: Node3D
) -> void:
    if body is Player:
        player_ref = body


func _on_detection_area_body_exited(
    body: Node3D
) -> void:
    if body == player_ref:
        player_ref = null