extends Node
class_name SaveManager

const SAVE_PATH: String = "user://savegame.save"

signal game_saved()
signal game_loaded(data: Dictionary)

var current_save: Dictionary = {}

func save_game() -> bool:
    var save_data: Dictionary = _collect_save_data()
    
    var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    if not file:
        push_error("Failed to open save file")
        return false
    
    var json_string: String = JSON.stringify(save_data)
    file.store_string(json_string)
    file.close()
    
    current_save = save_data
    game_saved.emit()
    print("Game saved successfully")
    return true

func load_game() -> Dictionary:
    if not FileAccess.file_exists(SAVE_PATH):
        push_warning("No save file found")
        return {}
    
    var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
    if not file:
        push_error("Failed to open save file")
        return {}
    
    var json_string: String = file.get_as_text()
    file.close()
    
    var json: JSON = JSON.new()
    var parse_result: int = json.parse(json_string)
    
    if parse_result != OK:
        push_error("Failed to parse save file")
        return {}
    
    current_save = json.data
    game_loaded.emit(current_save)
    print("Game loaded successfully")
    return current_save

func has_save() -> bool:
    return FileAccess.file_exists(SAVE_PATH)

func delete_save() -> void:
    if FileAccess.file_exists(SAVE_PATH):
        DirAccess.remove_absolute(SAVE_PATH)
    current_save = {}
    print("Save deleted")

func _collect_save_data() -> Dictionary:
    var save_data: Dictionary = {
        "timestamp": Time.get_unix_time_from_system(),
        "version": "1.0",
        "player": {},
        "quests": {},
        "world": {}
    }
    
    var players: Array[Node] = get_tree().get_nodes_in_group("player")
    if players.size() > 0:
        var player: Player = players[0] as Player
        save_data["player"] = {
            "position": {
                "x": player.global_position.x,
                "y": player.global_position.y,
                "z": player.global_position.z
            },
            "health": player.current_health,
            "stamina": player.current_stamina,
            "max_health": player.max_health,
            "max_stamina": player.max_stamina
        }
    
    if get_tree().current_scene.has_node("QuestManager"):
        var quest_manager: QuestManager = get_tree().current_scene.get_node("QuestManager")
        save_data["quests"] = {
            "completed": quest_manager.completed_quests.map(func(q): return q.quest_id),
            "active": []
        }
    
    save_data["world"] = {
        "scene": get_tree().current_scene.scene_file_path
    }
    
    return save_data

func apply_save_data(data: Dictionary) -> void:
    if data.is_empty():
        return
    
    var players: Array[Node] = get_tree().get_nodes_in_group("player")
    if players.size() > 0 and data.has("player"):
        var player: Player = players[0] as Player
        var player_data: Dictionary = data["player"]
        
        player.global_position = Vector3(
            player_data["position"]["x"],
            player_data["position"]["y"],
            player_data["position"]["z"]
        )
        player.current_health = player_data.get("health", player.max_health)
        player.current_stamina = player_data.get("stamina", player.max_stamina)