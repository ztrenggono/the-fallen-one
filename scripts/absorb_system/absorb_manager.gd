extends Node
class_name AbsorbManager

signal ability_absorbed(ability: AbilityData)

@export var max_abilities: int = 6

var absorbed_abilities: Array[AbilityData] = []
var total_damage_bonus: int = 0
var total_speed_bonus: float = 0.0
var total_health_bonus: int = 0

@onready var player: Player = owner

func absorb_ability(ability: AbilityData) -> bool:
    if absorbed_abilities.size() >= max_abilities:
        print("Cannot absorb more abilities")
        return false
    
    absorbed_abilities.append(ability)
    
    total_damage_bonus += ability.damage_bonus
    total_speed_bonus += ability.speed_bonus
    total_health_bonus += ability.health_bonus
    
    _apply_bonuses()
    ability_absorbed.emit(ability)
    
    print("Absorbed: %s (+%d dmg, +%.1f speed, +%d hp)" % [
        ability.ability_name,
        ability.damage_bonus,
        ability.speed_bonus,
        ability.health_bonus
    ])
    
    return true

func _apply_bonuses() -> void:
    pass

func get_total_power() -> int:
    return total_damage_bonus + int(total_speed_bonus * 10) + total_health_bonus