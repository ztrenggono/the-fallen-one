extends Node3D

@onready var boss: BossEnemy = $Entities/Boss
@onready var boss_ui: BossHealthUI = $UI/BossHealthUI
@onready var player: Player = $Entities/Player

func _ready() -> void:
    if boss and boss_ui:
        boss_ui.show_boss(boss)
        
        var health_check_timer: Timer = Timer.new()
        health_check_timer.wait_time = 0.1
        health_check_timer.autostart = true
        add_child(health_check_timer)
        health_check_timer.timeout.connect(_update_boss_health)
        
        boss.boss_died.connect(_on_boss_died)

func _update_boss_health() -> void:
    if boss and not boss.is_dead:
        boss_ui.update_health(boss.current_health, boss.max_health)

func _on_boss_died() -> void:
    boss_ui.hide_boss()
    print("BOSS DEFEATED!")