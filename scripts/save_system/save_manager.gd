## Save manager — handles saving/loading game state to JSON.
extends Node
class_name SaveManager

const SAVE_PATH: String = "user://savegame.save"

signal game_saved()
signal game_loaded(data: Dictionary)

var current_save: Dictionary = {}


func save_game() -> bool:
    var save_data: Dictionary = _collect_save_data()

    var file: FileAccess = FileAccess.open(
        SAVE_PATH, FileAccess.WRITE
    )
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

    var file: FileAccess = FileAccess.open(
        SAVE_PATH, FileAccess.READ
    )
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


## Collect all game state into a save dictionary.
func _collect_save_data() -> Dictionary:
    var save_data: Dictionary = {
        "timestamp": Time.get_unix_time_from_system(),
        "version": "1.0",
        "player": {},
        "quests": {},
        "world": {},
    }

    _save_player_data(save_data)
    _save_quest_data(save_data)
    _save_world_data(save_data)

    return save_data


func _save_player_data(save_data: Dictionary) -> void:
    var players: Array[Node] = (
        get_tree().get_nodes_in_group("player")
    )
    if players.size() == 0:
        return

    var p: Player = players[0] as Player
    save_data["player"] = {
        "position": {
            "x": p.global_position.x,
            "y": p.global_position.y,
            "z": p.global_position.z,
        },
        "health": p.current_health,
        "stamina": p.current_stamina,
        "max_health": p.max_health,
        "max_stamina": p.max_stamina,
    }


func _save_quest_data(save_data: Dictionary) -> void:
    # QuestManager is a child of the GameManager autoload
    if not GameManager or not GameManager.quest_manager:
        return

    var qm: QuestManager = GameManager.quest_manager
    save_data["quests"] = {
        "completed": qm.completed_quests.map(
            func(q: QuestData) -> String: return q.quest_id
        ),
        "active": [],
    }


func _save_world_data(save_data: Dictionary) -> void:
    save_data["world"] = {
        "scene": get_tree().current_scene.scene_file_path,
    }


## Apply loaded save data to the current game state.
func apply_save_data(data: Dictionary) -> void:
    if data.is_empty():
        return

    var players: Array[Node] = (
        get_tree().get_nodes_in_group("player")
    )
    if players.size() == 0 or not data.has("player"):
        return

    var p: Player = players[0] as Player
    var pd: Dictionary = data["player"]

    p.global_position = Vector3(
        pd["position"]["x"],
        pd["position"]["y"],
        pd["position"]["z"],
    )
    p.current_health = pd.get("health", p.max_health)
    p.current_stamina = pd.get("stamina", p.max_stamina)