extends Control


func _ready() -> void:
	for arg in OS.get_cmdline_args():
		if arg == "--server":
			_on_host_button_pressed()


func _on_mecha_button_pressed() -> void:
	Server.player_info["role"] = Server.PlayerRole.MECH
	Server.join_game()
	await Server.multiplayer.connected_to_server
	get_tree().change_scene_to_file("res://src/multiplayer/world_wrapper/world_wrapper.tscn")


func _on_virus_button_pressed() -> void:
	Server.player_info["role"] = Server.PlayerRole.VIRUS
	Server.join_game()
	await Server.multiplayer.connected_to_server
	get_tree().change_scene_to_file("res://src/multiplayer/world_wrapper/world_wrapper.tscn")


func _on_host_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/multiplayer/world_wrapper/world_wrapper.tscn")
	Server.create_game()
