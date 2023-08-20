extends Node2D
class_name PlayerWrapper


func _ready() -> void:
	var camera: Camera2D
	var audio_listener := get_child(0).get_node("AudioListener2D") as AudioListener2D
	var enabled := false
	match get_child(0).name:
		"Mech":
			camera = get_child(0).get_node("Camera2D")
			enabled = Server.player_info["role"] == Server.PlayerRole.MECH
			(get_child(0) as CharacterBody2D).input_pickable = Server.player_info["role"] == Server.PlayerRole.VIRUS
		"Virus":
			camera = get_child(0).get_node("Camera2D")
			enabled = Server.player_info["role"] == Server.PlayerRole.VIRUS
	if camera:
		camera.enabled = enabled
		if enabled:
			audio_listener.make_current()
			camera.make_current()
		else:
			audio_listener.clear_current()


@rpc("any_peer", "call_local", "reliable")
func change_authority(id: int) -> void:
	get_multiplayer_authority()
	set_multiplayer_authority(id)
	var is_auth := is_multiplayer_authority()
	get_child(0).set_process(is_auth)
	get_child(0).set_process_input(is_auth)
	get_child(0).set_process_shortcut_input(is_auth)
	get_child(0).set_process_unhandled_input(is_auth)
	get_child(0).set_process_unhandled_key_input(is_auth)
	(get_child(0).get_node("UICanvas") as CanvasLayer).visible = is_auth
