## Boss health bar UI — shows boss name, health, and phase.
extends Control
class_name BossHealthUI

@onready var boss_name_label: Label = $BossName
@onready var health_bar: ProgressBar = $HealthBar
@onready var health_label: Label = $HealthBar/HealthLabel
@onready var phase_label: Label = $PhaseLabel

var boss: BossEnemy


func _ready() -> void:
    visible = false


func show_boss(new_boss: BossEnemy) -> void:
    boss = new_boss
    visible = true

    if boss:
        boss_name_label.text = "THE GRAND KNIGHT"
        _update_health(
            boss.current_health, boss.max_health
        )
        boss.phase_changed.connect(_on_phase_changed)


func hide_boss() -> void:
    visible = false
    boss = null


func update_health(current: int, maximum: int) -> void:
    _update_health(current, maximum)


func _update_health(current: int, maximum: int) -> void:
    if health_bar:
        health_bar.max_value = maximum
        health_bar.value = current

    if health_label:
        health_label.text = "%d / %d" % [current, maximum]


func _on_phase_changed(phase: int) -> void:
    if not phase_label:
        return

    match phase:
        1:
            phase_label.text = "PHASE 1"
        2:
            phase_label.text = "ENRAGED!"
            phase_label.modulate = Color.RED
        3:
            phase_label.text = "FINAL PHASE"
            phase_label.modulate = Color.DARK_RED