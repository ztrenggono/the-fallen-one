extends Enemy
class_name RangedEnemy

@export var projectile_scene: PackedScene
@export var attack_range: float = 12.0
@export var retreat_distance: float = 5.0
@export var projectile_speed: float = 15.0
@export var projectile_damage: int = 10

@onready var projectile_spawn: Marker3D = $ProjectileSpawn

func _ready() -> void:
    super._ready()
    detection_range = 20.0

func fire_projectile() -> void:
    if not player_ref or not projectile_spawn:
        return
    
    var direction: Vector3 = (player_ref.global_position - projectile_spawn.global_position).normalized()
    
    if projectile_scene:
        var projectile: Node3D = projectile_scene.instantiate()
        get_tree().current_scene.add_child(projectile)
        projectile.global_position = projectile_spawn.global_position
        
        if projectile.has_method("launch"):
            projectile.launch(direction, projectile_speed, projectile_damage)
        else:
            projectile.look_at(player_ref.global_position)
    else:
        if player_ref:
            player_ref.take_damage(projectile_damage)