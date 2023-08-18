extends Node2D
class_name GameObject


signal object_chosen(object: Node2D)


func _ready() -> void:
	$StaticBody2D.input_pickable = Server.player_info["role"] == Server.PlayerRole.VIRUS


func select_game_object() -> void:
	pass


func _on_static_body_2d_mouse_entered() -> void:
	modulate = Color.RED


func deselect_game_object() -> void:
	pass


func _on_static_body_2d_mouse_exited() -> void:
	modulate = Color.WHITE


func _on_static_body_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		object_chosen.emit(self)


func change_object() -> void:
	pass


@rpc("any_peer", "call_local", "reliable")
func complete_object() -> void:
	change_object()
	remove_child($StaticBody2D)


