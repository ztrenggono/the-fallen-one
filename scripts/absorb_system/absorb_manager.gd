## Manages enemy ability absorption for the player.
## Tracks absorbed abilities and applies stat bonuses.
extends Node
class_name AbsorbManager

signal ability_absorbed(ability: AbilityData)

@export var max_abilities: int = 6

var absorbed_abilities: Array[AbilityData] = []

@onready var player: Player = owner


## Absorb an enemy ability, applying its stat bonuses.
## Rejects if max capacity is reached.
func absorb_ability(ability: AbilityData) -> void:
    if absorbed_abilities.size() >= max_abilities:
        print("Cannot absorb more abilities")
        return

    absorbed_abilities.append(ability)
    _apply_single_bonus(ability)
    ability_absorbed.emit(ability)

    print("Absorbed: %s (+%d dmg, +%.1f speed, +%d hp)" % [
        ability.ability_name,
        ability.damage_bonus,
        ability.speed_bonus,
        ability.health_bonus,
    ])


## Apply bonuses from a single newly absorbed ability.
## Only applies the delta for THIS ability — not cumulative totals.
func _apply_single_bonus(ability: AbilityData) -> void:
    player.move_speed += ability.speed_bonus
    player.max_health += ability.health_bonus

    # Heal the player by the health bonus amount
    if ability.health_bonus > 0:
        player.heal(ability.health_bonus)


## Calculate total power level from all absorbed abilities.
func get_total_power() -> int:
    var total: int = 0
    for ability in absorbed_abilities:
        total += ability.damage_bonus
        total += int(ability.speed_bonus * 10)
        total += ability.health_bonus
    return total


## Get total accumulated damage bonus from all abilities.
func get_damage_bonus() -> int:
    var total: int = 0
    for ability in absorbed_abilities:
        total += ability.damage_bonus
    return total