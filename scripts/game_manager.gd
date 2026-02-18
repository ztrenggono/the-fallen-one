extends Node

var quest_manager: QuestManager
var save_manager: SaveManager

func _ready() -> void:
    quest_manager = QuestManager.new()
    save_manager = SaveManager.new()
    
    add_child(quest_manager)
    add_child(save_manager)
    
    quest_manager.name = "QuestManager"
    save_manager.name = "SaveManager"

func start_new_game() -> void:
    save_manager.delete_save()
    quest_manager.start_quest("quest_001")

func continue_game() -> bool:
    if not save_manager.has_save():
        return false
    
    var save_data: Dictionary = save_manager.load_game()
    return not save_data.is_empty()

func save_current_game() -> bool:
    return save_manager.save_game()