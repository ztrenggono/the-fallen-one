## Quest data resource — defines objectives, prerequisites,
## and rewards for a single quest.
extends Resource
class_name QuestData

@export var quest_id: String = ""
@export var quest_name: String = ""
@export var description: String = ""
@export var prerequisite_quest: String = ""

@export var objectives: Array[QuestObjective] = []
@export var rewards: Array[QuestReward] = []

var current_objective_index: int = 0


func reset() -> void:
    current_objective_index = 0
    for objective in objectives:
        objective.current_amount = 0


## Advance the current objective if the type matches.
## Returns true if progress was made.
func update_objective(
    objective_type: QuestObjective.ObjectiveType,
    amount: int = 1
) -> bool:
    if current_objective_index >= objectives.size():
        return false

    var current: QuestObjective = (
        objectives[current_objective_index]
    )

    if current.objective_type != objective_type:
        return false

    current.current_amount = min(
        current.current_amount + amount,
        current.required_amount
    )

    if current.is_complete():
        current_objective_index += 1

    return true


func is_complete() -> bool:
    for objective in objectives:
        if not objective.is_complete():
            return false
    return true


func get_progress_text() -> String:
    if current_objective_index >= objectives.size():
        return "Complete"

    var current: QuestObjective = (
        objectives[current_objective_index]
    )
    return "%s: %d/%d" % [
        current.description,
        current.current_amount,
        current.required_amount,
    ]
