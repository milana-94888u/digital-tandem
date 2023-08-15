extends Node2D
class_name WorldWrapper


@rpc("any_peer", "call_local", "reliable")
func pause_game() -> void:
	get_tree().paused = true


@rpc("any_peer", "call_local", "reliable")
func resume_game() -> void:
	get_tree().paused = false


func _ready() -> void:
	pause_game()
