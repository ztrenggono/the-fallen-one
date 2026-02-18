extends Node
class_name EnemyStateMachine

@export var initial_state: EnemyState

var current_state: EnemyState
var states: Dictionary = {}

func _ready() -> void:
    await owner.ready
    
    for child in get_children():
        if child is EnemyState:
            states[child.name.to_lower()] = child
            child.state_machine = self
            child.enemy = owner
    
    if initial_state:
        initial_state.enter()
        current_state = initial_state

func _physics_process(delta: float) -> void:
    if current_state:
        current_state.physics_update(delta)

func change_state(state_name: String) -> void:
    var new_state: EnemyState = states.get(state_name.to_lower())
    
    if not new_state or new_state == current_state:
        return
    
    if current_state:
        current_state.exit()
    
    new_state.enter()
    current_state = new_state