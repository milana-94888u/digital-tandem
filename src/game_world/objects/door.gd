extends StaticBody2D


signal object_chosen(object: Node2D)


func _ready() -> void:
	input_pickable = Server.player_info["role"] == Server.PlayerRole.VIRUS


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		object_chosen.emit(self)


@rpc("any_peer", "call_local", "reliable")
func open_door() -> void:
	$DoorLocked.texture = preload("res://assets/sprites/tiles/objects/animated/door/DoorUnlocked.png")
	remove_child($CollisionShape2D)
