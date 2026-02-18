## Base state for all enemy-specific states.
## Provides access to the Enemy node and the state machine.
extends Node
class_name EnemyState

var state_machine: EnemyStateMachine
var enemy: Enemy

## Called when this state becomes active.
func enter() -> void:
    pass

## Called when this state is exited.
func exit() -> void:
    pass

## Called every physics frame while this state is active.
func physics_update(_delta: float) -> void:
    pass