## Ranged enemy type — fires projectiles and retreats.
## Extended detection range and retreat behavior.
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


## Spawn and launch a projectile toward the player.
## Falls back to direct damage if no projectile scene.
func fire_projectile() -> void:
    if not player_ref or not projectile_spawn:
        return

    var direction: Vector3 = (
        player_ref.global_position
        - projectile_spawn.global_position
    ).normalized()

    if projectile_scene:
        var proj: Node3D = projectile_scene.instantiate()
        get_tree().current_scene.add_child(proj)
        proj.global_position = projectile_spawn.global_position

        if proj.has_method("launch"):
            proj.launch(
                direction,
                projectile_speed,
                projectile_damage
            )
        else:
            proj.look_at(player_ref.global_position)
    else:
        # Fallback: direct damage if no projectile scene
        if player_ref:
            player_ref.take_damage(projectile_damage)