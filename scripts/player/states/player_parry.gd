## Parry state — timed block window.
## If an enemy attacks during the parry window, the
## enemy is stunned. Otherwise, player recovers.
extends PlayerState

@export var parry_window: float = 0.25
@export var recovery_time: float = 0.3
@export var stamina_cost: float = 15.0

var parry_timer: float = 0.0
var is_parry_active: bool = false
var parry_successful: bool = false


func enter() -> void:
    if not player.use_stamina(stamina_cost):
        state_machine.change_state("Idle")
        return

    player.play_animation(&"parry")
    parry_timer = parry_window
    is_parry_active = true
    parry_successful = false

    # Enable monitoring on hurtbox to detect incoming
    player.hurtbox.area_entered.connect(
        _on_parry_hit
    )


func exit() -> void:
    is_parry_active = false
    if player.hurtbox.area_entered.is_connected(
        _on_parry_hit
    ):
        player.hurtbox.area_entered.disconnect(
            _on_parry_hit
        )


func physics_update(delta: float) -> void:
    parry_timer -= delta
    player.velocity.x = 0.0
    player.velocity.z = 0.0

    if is_parry_active and parry_timer <= 0.0:
        # Parry window expired, go to recovery
        is_parry_active = false
        parry_timer = recovery_time

    if not is_parry_active and parry_timer <= 0.0:
        state_machine.change_state("Idle")


func _on_parry_hit(area: Area3D) -> void:
    if not is_parry_active:
        return

    parry_successful = true
    is_parry_active = false

    # Try to stun the attacker
    var attacker: Node = area.get_parent()
    if attacker.has_method("stun"):
        attacker.stun(1.0)

    player.play_animation(&"parry_success")
    print("Parry successful!")

    # Restore some stamina as reward
    player.current_stamina = min(
        player.current_stamina + 10.0,
        player.max_stamina
    )

    parry_timer = recovery_time * 0.5
