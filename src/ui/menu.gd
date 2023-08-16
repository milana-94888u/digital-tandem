extends Control


func _ready() -> void:
	if "--server" in OS.get_cmdline_args():
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
	Server.player_info["role"] = Server.PlayerRole.UNSET
	get_tree().change_scene_to_file("res://src/multiplayer/world_wrapper/world_wrapper.tscn")
	Server.create_game()
