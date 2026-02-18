## Base state class for all state machine states.
## Provides virtual methods for state lifecycle and input handling.
extends Node
class_name State

var state_machine: StateMachine

## Called when this state becomes active.
func enter() -> void:
    pass

## Called when this state is exited.
func exit() -> void:
    pass

## Called every physics frame while this state is active.
func physics_update(_delta: float) -> void:
    pass

## Called for input events while this state is active.
func handle_input(_event: InputEvent) -> void:
    pass