extends Resource
class_name QuestReward

enum RewardType { ABILITY, HEALTH, STAMINA, STAT_BOOST }

@export var reward_type: RewardType = RewardType.ABILITY
@export var reward_value: int = 0
@export var ability: AbilityData