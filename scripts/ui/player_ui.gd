extends Control
class_name PlayerUI

@onready var health_bar: ProgressBar = $HealthBar
@onready var health_label: Label = $HealthBar/HealthLabel
@onready var stamina_bar: ProgressBar = $StaminaBar
@onready var stamina_label: Label = $StaminaBar/StaminaLabel
@onready var absorb_container: HBoxContainer = $AbsorbContainer

var player: Player

func _ready() -> void:
    await get_tree().process_frame
    _find_player()

func _find_player() -> void:
    var players: Array[Node] = get_tree().get_nodes_in_group("player")
    if players.size() > 0:
        player = players[0] as Player
        _connect_signals()
        _init_bars()

func _connect_signals() -> void:
    if player:
        player.health_changed.connect(_on_health_changed)
        player.stamina_changed.connect(_on_stamina_changed)
        
        if player.has_node("AbsorbManager"):
            var absorb_manager: AbsorbManager = player.get_node("AbsorbManager")
            absorb_manager.ability_absorbed.connect(_on_ability_absorbed)

func _init_bars() -> void:
    if player:
        _on_health_changed(player.current_health, player.max_health)
        _on_stamina_changed(player.current_stamina, player.max_stamina)

func _on_health_changed(current: int, maximum: int) -> void:
    if health_bar:
        health_bar.max_value = maximum
        health_bar.value = current
    
    if health_label:
        health_label.text = "HP: %d/%d" % [current, maximum]

func _on_stamina_changed(current: float, maximum: float) -> void:
    if stamina_bar:
        stamina_bar.max_value = maximum
        stamina_bar.value = current
    
    if stamina_label:
        stamina_label.text = "Stamina: %d" % [int(current)]

func _on_ability_absorbed(ability: AbilityData) -> void:
    _add_absorb_icon(ability)

func _add_absorb_icon(ability: AbilityData) -> void:
    if not absorb_container:
        return
    
    var icon: TextureRect = TextureRect.new()
    icon.custom_minimum_size = Vector2(32, 32)
    icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    
    if ability.icon:
        icon.texture = ability.icon
    else:
        icon.modulate = Color(0.5, 0.5, 0.5)
    
    var panel: Panel = Panel.new()
    panel.custom_minimum_size = Vector2(36, 36)
    icon.position = Vector2(2, 2)
    panel.add_child(icon)
    
    panel.tooltip_text = "%s\n%s" % [ability.ability_name, ability.description]
    
    absorb_container.add_child(panel)