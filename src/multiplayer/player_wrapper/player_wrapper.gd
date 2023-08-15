extends Node2D
class_name PlayerWrapper


func _ready() -> void:
	var camera: Camera2D
	var enabled := false
	match get_child(0).name:
		"Mech":
			camera = get_child(0).get_node("Camera2D")
			enabled = Server.player_info["role"] == Server.PlayerRole.MECH
		"Virus":
			camera = get_child(0)
			enabled = Server.player_info["role"] == Server.PlayerRole.VIRUS
	if camera:
		camera.enabled = enabled


@rpc("authority", "call_local", "reliable")
func change_authority(id: int) -> void:
	set_multiplayer_authority(id)
	var is_auth := is_multiplayer_authority()
	get_child(0).set_process(is_auth)
	get_child(0).set_process_input(is_auth)
	get_child(0).set_process_shortcut_input(is_auth)
	get_child(0).set_process_unhandled_input(is_auth)
	get_child(0).set_process_unhandled_key_input(is_auth)
