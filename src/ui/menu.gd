extends Control


func _on_mecha_button_pressed() -> void:
	Server.player_info["role"] = Server.PlayerRole.MECH
	get_tree().change_scene_to_file("res://src/world/world.tscn")
	Server.join_game()


func _on_virus_button_pressed() -> void:
	Server.player_info["role"] = Server.PlayerRole.VIRUS
	get_tree().change_scene_to_file("res://src/world/world.tscn")
	Server.join_game()


func _on_host_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/world/world.tscn")
	Server.create_game()
