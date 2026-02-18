extends Resource
class_name QuestObjective

enum ObjectiveType { KILL_ENEMY, COLLECT_ITEM, REACH_LOCATION, TALK_TO_NPC, DEFEAT_BOSS }

@export var objective_type: ObjectiveType = ObjectiveType.KILL_ENEMY
@export var description: String = ""
@export var required_amount: int = 1
@export var target_id: String = ""

var current_amount: int = 0

func is_complete() -> bool:
    return current_amount >= required_amount