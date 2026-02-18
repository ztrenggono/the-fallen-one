extends RigidBody3D
class_name Projectile

@export var lifetime: float = 5.0
@export var hit_effect_scene: PackedScene

var damage: int = 10
var velocity: Vector3 = Vector3.FORWARD
var owner_entity: Node3D

@onready var hitbox: Area3D = $Hitbox

func _ready() -> void:
    hitbox.body_entered.connect(_on_hitbox_body_entered)
    hitbox.area_entered.connect(_on_hitbox_area_entered)
    
    get_tree().create_timer(lifetime).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
    position += velocity * delta

func launch(direction: Vector3, speed: float, dmg: int) -> void:
    velocity = direction * speed
    damage = dmg
    look_at(global_position + direction)

func _on_hitbox_body_entered(body: Node3D) -> void:
    if body == owner_entity:
        return
    
    if body.has_method("take_damage"):
        body.take_damage(damage)
    
    _spawn_hit_effect()
    queue_free()

func _on_hitbox_area_entered(area: Area3D) -> void:
    var body: Node3D = area.get_parent()
    
    if body == owner_entity:
        return
    
    if body.has_method("take_damage"):
        body.take_damage(damage)
    
    _spawn_hit_effect()
    queue_free()

func _spawn_hit_effect() -> void:
    if hit_effect_scene:
        var effect: Node3D = hit_effect_scene.instantiate()
        get_tree().current_scene.add_child(effect)
        effect.global_position = global_position