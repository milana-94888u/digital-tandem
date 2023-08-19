extends GameObject
class_name FrontDoor


signal virus_door_entered(teleport_position: Vector2)


@export var opposite_door: FrontDoor
var is_open := false


func select_game_object() -> void:
	modulate = Color.RED


func deselect_game_object() -> void:
	modulate = Color.WHITE


func change_object() -> void:
	if is_open:
		return
	is_open = true
	$AnimatedSprite2D.play("open")
	$AudioStreamPlayer2D.play()
	opposite_door.change_object()
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if Server.player_info["role"] != Server.PlayerRole.MECH:
		return
	if body is Mech:
		body.set_active_door(self)
		$Label.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if Server.player_info["role"] != Server.PlayerRole.MECH:
		return
	if body is Mech:
		body.remove_active_door(self)
		$Label.hide()


func teleport() -> Vector2:
	return opposite_door.position


func _on_area_2d_mouse_entered() -> void:
	GameObjectManager.select_object(self)


func _on_area_2d_mouse_exited() -> void:
	GameObjectManager.deselect_object(self)


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		virus_door_entered.emit(opposite_door.position)


func _on_animated_sprite_2d_animation_finished() -> void:
	remove_child($StaticBody2D)
	$Area2D/CollisionShape2D.disabled = false
	$Area2D.input_pickable = Server.player_info["role"] == Server.PlayerRole.VIRUS










