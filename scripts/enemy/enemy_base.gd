extends CharacterBody3D
class_name Enemy

@export var max_health: int = 50
@export var move_speed: float = 3.0
@export var attack_range: float = 1.5
@export var detection_range: float = 10.0
@export var absorb_ability: AbilityData

var current_health: int
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var player_ref: Player = null

@onready var detection_area: Area3D = $DetectionArea
@onready var hitbox: Area3D = $Hitbox
@onready var hurtbox: Area3D = $Hurtbox

func _ready() -> void:
    current_health = max_health
    
    detection_area.body_entered.connect(_on_detection_area_body_entered)
    detection_area.body_exited.connect(_on_detection_area_body_exited)

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y -= gravity * delta
    
    if player_ref:
        var direction: Vector3 = (player_ref.global_position - global_position).normalized()
        direction.y = 0.0
        
        var distance: float = global_position.distance_to(player_ref.global_position)
        
        if distance > attack_range:
            velocity.x = direction.x * move_speed
            velocity.z = direction.z * move_speed
        else:
            velocity.x = 0.0
            velocity.z = 0.0
    else:
        velocity.x = 0.0
        velocity.z = 0.0
    
    move_and_slide()

func take_damage(amount: int) -> void:
    current_health -= amount
    print("Enemy took %d damage, health: %d/%d" % [amount, current_health, max_health])
    
    if current_health <= 0:
        die()

func die() -> void:
    if absorb_ability and player_ref:
        var absorb_manager: AbsorbManager = player_ref.get_node_or_null("AbsorbManager")
        if absorb_manager:
            absorb_manager.absorb_ability(absorb_ability)
    queue_free()

func _on_detection_area_body_entered(body: Node3D) -> void:
    if body is Player:
        player_ref = body

func _on_detection_area_body_exited(body: Node3D) -> void:
    if body == player_ref:
        player_ref = null