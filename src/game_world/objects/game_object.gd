extends Node2D
class_name GameObject


signal object_chosen(object: Node2D)


func _ready() -> void:
	set_process_input(true)
	$StaticBody2D.input_pickable = Server.player_info["role"] == Server.PlayerRole.VIRUS


func _on_static_body_2d_mouse_entered() -> void:
	GameObjectManager.select_object(self)


func _on_static_body_2d_mouse_exited() -> void:
	GameObjectManager.deselect_object(self)


func _on_static_body_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		object_chosen.emit(self)


func select_game_object() -> void:
	pass


func deselect_game_object() -> void:
	pass


func change_object() -> void:
	pass


@rpc("any_peer", "call_local", "reliable")
func complete_object() -> void:
	change_object()
	_on_static_body_2d_mouse_exited()


