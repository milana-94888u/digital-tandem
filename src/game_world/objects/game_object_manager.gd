extends Node


var current_selected_object: GameObject


func select_object(object: GameObject) -> void:
	if current_selected_object != null:
		current_selected_object.deselect_game_object()
	current_selected_object = object
	current_selected_object.select_game_object()


func deselect_object(object: GameObject) -> void:
	if current_selected_object == object:
		current_selected_object = null
	object.deselect_game_object()
