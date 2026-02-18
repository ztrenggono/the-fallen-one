## Quest manager — loads quests from resources and tracks
## active/completed status.
extends Node
class_name QuestManager

signal quest_started(quest: QuestData)
signal quest_updated(quest: QuestData)
signal quest_completed(quest: QuestData)

var active_quests: Array[QuestData] = []
var completed_quests: Array[QuestData] = []
var quest_database: Dictionary = {}


func _ready() -> void:
    _load_quests()


## Scan the quests directory and load all .tres resources.
func _load_quests() -> void:
    var quest_dir: DirAccess = DirAccess.open(
        "res://resources/quests/"
    )
    if not quest_dir:
        return

    quest_dir.list_dir_begin()
    var file_name: String = quest_dir.get_next()
    while file_name != "":
        if (
            not quest_dir.current_is_dir()
            and file_name.ends_with(".tres")
        ):
            var path: String = (
                "res://resources/quests/" + file_name
            )
            var quest: QuestData = load(path)
            if quest:
                quest_database[quest.quest_id] = quest
        file_name = quest_dir.get_next()


## Start a quest by ID. Returns false if not found,
## already active/completed, or prerequisites not met.
func start_quest(quest_id: String) -> bool:
    var quest: QuestData = quest_database.get(quest_id)

    if not quest:
        push_error("Quest not found: " + quest_id)
        return false

    if quest in active_quests or quest in completed_quests:
        return false

    if (
        quest.prerequisite_quest != ""
        and not is_quest_completed(quest.prerequisite_quest)
    ):
        return false

    quest.reset()
    active_quests.append(quest)
    quest_started.emit(quest)
    print("Quest started: " + quest.quest_name)
    return true


## Update all active quests matching the objective type.
func update_quest(
    objective_type: QuestObjective.ObjectiveType,
    amount: int = 1
) -> void:
    for quest in active_quests:
        if quest.update_objective(objective_type, amount):
            quest_updated.emit(quest)

            if quest.is_complete():
                complete_quest(quest)


func complete_quest(quest: QuestData) -> void:
    active_quests.erase(quest)
    completed_quests.append(quest)
    quest_completed.emit(quest)
    print("Quest completed: " + quest.quest_name)


func is_quest_active(quest_id: String) -> bool:
    var quest: QuestData = quest_database.get(quest_id)
    return quest in active_quests if quest else false


func is_quest_completed(quest_id: String) -> bool:
    var quest: QuestData = quest_database.get(quest_id)
    return quest in completed_quests if quest else false


func get_active_quest() -> QuestData:
    if active_quests.size() > 0:
        return active_quests[0]
    return null
