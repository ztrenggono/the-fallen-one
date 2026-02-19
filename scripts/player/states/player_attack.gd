## Attack state — 3-hit combo with raycast hit detection.
## Each hit has configurable duration, damage, range, stamina.
extends PlayerState

# Combo data: [duration, damage, range, stamina_cost]
var attack_data: Array = [
    [0.5, 15, 2.0, 10.0],
    [0.4, 20, 2.2, 12.0],
    [0.6, 30, 2.5, 15.0],
]

var attack_index: int = 0
var attack_timer: float = 0.0
var can_combo: bool = false
var has_hit: bool = false


func enter() -> void:
    var data: Array = attack_data[attack_index]
    var stamina_cost: float = data[3]

    if not player.use_stamina(stamina_cost):
        state_machine.change_state("Idle")
        return

    attack_timer = data[0]
    can_combo = false
    has_hit = false

    # Play combo animation
    var anim_name: StringName = (
        &"attack_0" + str(attack_index + 1)
    )
    player.play_animation(anim_name)

    player.velocity.x = 0.0
    player.velocity.z = 0.0


func physics_update(delta: float) -> void:
    attack_timer -= delta

    # Hit check at 40% through the attack
    var data: Array = attack_data[attack_index]
    var hit_window: float = data[0] * 0.4
    if not has_hit and attack_timer <= hit_window:
        _check_hit()

    # Allow combo input in second half
    if attack_timer <= data[0] * 0.5:
        can_combo = true
        if Input.is_action_just_pressed("attack"):
            var next: int = attack_index + 1
            if next < attack_data.size():
                attack_index = next
                enter()
                return

    if attack_timer <= 0.0:
        attack_index = 0
        state_machine.change_state("Idle")


func exit() -> void:
    pass


func _check_hit() -> void:
    has_hit = true
    var data: Array = attack_data[attack_index]
    var damage: int = data[1]
    var atk_range: float = data[2]

    # Add absorb damage bonus
    var absorb_mgr: AbsorbManager = (
        player.get_node_or_null("AbsorbManager")
    )
    if absorb_mgr:
        damage += absorb_mgr.get_damage_bonus()

    # Raycast forward to detect enemies
    var origin: Vector3 = (
        player.global_position + Vector3.UP * 1.0
    )
    var forward: Vector3 = (
        -player.global_transform.basis.z * atk_range
    )

    var space: PhysicsDirectSpaceState3D = (
        player.get_world_3d().direct_space_state
    )
    var query: PhysicsRayQueryParameters3D = (
        PhysicsRayQueryParameters3D.create(
            origin, origin + forward
        )
    )
    query.collision_mask = 4  # enemy hitbox layer
    query.exclude = [player.get_rid()]

    var result: Dictionary = space.intersect_ray(query)

    if result and result.has("collider"):
        var target: Node3D = result["collider"]
        var enemy: Node3D = target.get_parent()
        if enemy.has_method("take_damage"):
            enemy.take_damage(damage)
            _spawn_hit_feedback(result["position"])


func _spawn_hit_feedback(hit_pos: Vector3) -> void:
    # Screen shake
    var tween: Tween = player.create_tween()
    var cam: Camera3D = player.camera
    var orig_offset: Vector3 = cam.position
    tween.tween_property(
        cam, "position",
        orig_offset + Vector3(
            randf_range(-0.1, 0.1),
            randf_range(-0.05, 0.05),
            0
        ),
        0.05
    )
    tween.tween_property(
        cam, "position", orig_offset, 0.05
    )

    # Spawn hit effect if available
    var hit_scene: PackedScene = preload(
        "res://scenes/vfx/hit_effect.tscn"
    ) if ResourceLoader.exists(
        "res://scenes/vfx/hit_effect.tscn"
    ) else null

    if hit_scene:
        var effect: Node3D = hit_scene.instantiate()
        player.get_tree().current_scene.add_child(effect)
        effect.global_position = hit_pos